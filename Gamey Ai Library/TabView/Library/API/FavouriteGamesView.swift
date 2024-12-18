import SwiftUI

struct FavouriteGamesView: View {
    @EnvironmentObject var favouritesManager: FavouritesManager // Usa l'EnvironmentObject per accedere al gestore dei preferiti

    var body: some View {
        VStack {
            if favouritesManager.favouriteGames.isEmpty {
                Text("Nessun gioco nei preferiti.")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                List(favouritesManager.favouriteGames) { game in
                    Text(game.name)
                        .font(.headline)
                }
            }
        }
        .navigationTitle("Giochi Preferiti")
    }
}

#Preview {
    // Mock di FavouritesManager per la preview
    let mockManager = FavouritesManager()
    mockManager.favouriteGames = [
        Game(name: "Game 1", summary: "Summary 1", coverURL: nil, releaseYear: 2023, platforms: ["PC"]),
        Game(name: "Game 2", summary: "Summary 2", coverURL: nil, releaseYear: 2024, platforms: ["PlayStation"])
    ]

    return FavouriteGamesView()
        .environmentObject(mockManager) // Usa il mock per l'anteprima
}
