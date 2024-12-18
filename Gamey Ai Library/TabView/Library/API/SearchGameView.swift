import SwiftUI

// Modello dati per il gioco
struct Game: Identifiable {
    let id = UUID()
    let name: String
    let summary: String?
    let coverURL: String?
    let releaseYear: Int?
    let platforms: [String]?
}

// Modello per il messaggio della chat
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isSentByUser: Bool
    let game: Game? // Include le informazioni del gioco se esiste
}

// Classe per gestire il fetch dei dati dall'API
class IGDBFetcher {
// Sostituisci con il tuo token di accesso
    private let url = URL(string: "https://api.igdb.com/v4/games")!
    
    func fetchGames(searchQuery: String, completion: @escaping (Game?) -> Void) {
        let query = """
        fields name, summary, cover.url, release_dates.y, platforms.name;
        search "\(searchQuery)";
        """

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue(clientID, forHTTPHeaderField: "Client-ID")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = query.data(using: .utf8)

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Errore: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("Nessun dato ricevuto.")
                completion(nil)
                return
            }

            // Decodifica la risposta
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]],
                   let randomGameDict = json.randomElement() { // Seleziona un gioco casuale
                    guard let name = randomGameDict["name"] as? String else { return completion(nil) }
                    let summary = randomGameDict["summary"] as? String
                    let coverURL = (randomGameDict["cover"] as? [String: Any])?["url"] as? String

                    // Estrarre l'anno di uscita
                    let releaseDates = randomGameDict["release_dates"] as? [[String: Any]]
                    let releaseYear = releaseDates?.first?["y"] as? Int
                    
                    // Estrazione delle piattaforme
                    let platforms = (randomGameDict["platforms"] as? [[String: Any]])?.compactMap { $0["name"] as? String }

                    completion(Game(name: name, summary: summary, coverURL: coverURL, releaseYear: releaseYear, platforms: platforms))
                } else {
                    completion(nil)
                }
            } catch {
                print("Errore nella decodifica JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
}

// Vista principale per la ricerca e la visualizzazione del risultato
struct SearchGameView: View {
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @State private var hasSearched: Bool = false
    @State private var previousSearch: String? = nil
    @State private var chatMessages: [ChatMessage] = []
    @FocusState private var isInputFocused: Bool

    @EnvironmentObject var favouritesManager: FavouritesManager // Gestisce i giochi preferiti
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(chatMessages) { message in
                    if let game = message.game {
                        VStack(alignment: .leading) {
                            HStack {
                                if let coverURL = game.coverURL, let url = URL(string: "https:\(coverURL)") {
                                    AsyncImage(url: url) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 90)
                                    } placeholder: {
                                        Color.gray
                                            .frame(width: 60, height: 90)
                                    }
                                }
                                VStack(alignment: .leading) {
                                    Text(game.name)
                                        .font(.headline)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    if let releaseYear = game.releaseYear {
                                        Text("Anno: \(String(releaseYear))")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    if let platforms = game.platforms {
                                        Text("Piattaforme: \(platforms.joined(separator: ", "))")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                            Text(game.summary ?? "No summary available.")
                                .font(.body)
                                .foregroundColor(.gray)
                                .lineLimit(3)

                            // Pulsante "Aggiungi ai preferiti"
                            Button(action: {
                                favouritesManager.addToFavourites(game: game) // Aggiunge il gioco ai preferiti
                            }) {
                                Text("Aggiungi ai preferiti")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        .padding([.top, .horizontal])
                    } else {
                        HStack {
                            if message.isSentByUser {
                                Spacer()
                            }
                            Text(message.text)
                                .padding()
                                .background(message.isSentByUser ? Color.blue : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .frame(maxWidth: .infinity, alignment: message.isSentByUser ? .trailing : .leading)
                                .padding([.top, .horizontal])
                        }
                    }
                }

                if isSearching {
                    ProgressView("Ricerca in corso...")
                        .padding()
                } else if hasSearched && chatMessages.isEmpty {
                    Text("Nessun gioco trovato.")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.red)
                } else {
                    Spacer()
                }
            }

            Spacer()

            HStack {
                TextField("Scrivi il nome del gioco...", text: $searchText)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .focused($isInputFocused)
                    .onSubmit {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        fetchGame()
                    }

                Button(action: {
                    fetchGame()
                    searchText = ""
                    isInputFocused = false
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 20))
                        .padding(12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .disabled(searchText.isEmpty)
            }
            .padding()
        }
        .navigationTitle("Ask Gamey")
    }

    private func fetchGame() {
        guard !searchText.isEmpty else { return }

        isSearching = true
        hasSearched = true
        previousSearch = searchText

        chatMessages.append(ChatMessage(text: "\(searchText)", isSentByUser: true, game: nil))

        let fetcher = IGDBFetcher()
        fetcher.fetchGames(searchQuery: searchText) { fetchedGame in
            DispatchQueue.main.async {
                self.isSearching = false
                if let game = fetchedGame {
                    chatMessages.append(ChatMessage(text: "", isSentByUser: false, game: game))
                } else {
                    chatMessages.append(ChatMessage(text: "Nessun gioco trovato.", isSentByUser: false, game: nil))
                }
            }
        }
    }
}

// Anteprima
#Preview {
    NavigationStack {
        SearchGameView()
            .environmentObject(FavouritesManager()) // Passa FavouritesManager come EnvironmentObject
    }
}
