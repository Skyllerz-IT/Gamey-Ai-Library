//
//  FavouritesManager.swift
//  Gamey Ai Library
//
//  Created by Davide Picentino on 18/12/24.
//


import SwiftUI

class FavouritesManager: ObservableObject {
    @Published var favouriteGames: [Game] = []

    func addToFavourites(game: Game) {
        if !favouriteGames.contains(where: { $0.id == game.id }) {
            favouriteGames.append(game)
            print("Aggiunto: \(game.name)")
        } else {
            print("Il gioco è già nei preferiti: \(game.name)")
        }
    }
}