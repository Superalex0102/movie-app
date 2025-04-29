//
//  FavouritesView.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 26..
//

import SwiftUI
import InjectPropertyWrapper

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationView {
            Text("Favorites Screen")
                .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView()
} 
