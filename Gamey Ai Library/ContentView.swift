import SwiftUI

struct ContentView: View {
    @StateObject private var favouritesManager = FavouritesManager() // Usa StateObject per mantenere il manager dei preferiti
    @State private var selectedTab: Int = 1 // Imposta l'indice della tab da selezionare di default (1 per la "Discover")

    var body: some View {
        TabView(selection: $selectedTab) { // Aggiungi binding per la selezione della tab
            FavouriteGamesView()
                .environmentObject(favouritesManager) // Passa l'EnvironmentObject alla vista dei preferiti
                .tabItem {
                    Label("Library", systemImage: "book")
                }
                .tag(0) // Aggiungi tag per l'indicizzazione della tab

            SearchGameView()
                .environmentObject(favouritesManager) // Passa l'EnvironmentObject alla vista di ricerca
                .tabItem {
                    Label("Discover", systemImage: "magnifyingglass")
                }
                .tag(1) // Aggiungi tag per l'indicizzazione della tab

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(2) // Aggiungi tag per l'indicizzazione della tab
        }
        .onAppear {
            // Quando la vista appare, la tab di default è la "Discover" (indice 1)
            selectedTab = 1
        }
    }
}

#Preview {
    ContentView()
}
