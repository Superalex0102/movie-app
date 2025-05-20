//
//  FavouriteMediaStore.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 20..
//

import Combine

protocol FavouriteMediaStoreProtocol {
    
    var mediaItems: AnyPublisher<[Movie], MovieError> { get }
    
    func addFavouriteMediaItem(_ mediaItem: Movie)
    func addFavouriteMediaItems(_ mediaItems: [Movie])
    func removeFavouriteMediaItem(withId id: Int)
    
    func isFavouriteMediaItem(withId id: Int) -> Bool
    
}

class FavouriteMediaStore: FavouriteMediaStoreProtocol {
    
    private var mediaItemsSubject = CurrentValueSubject<[Movie], MovieError>([])
    
    private var favouriteItems: [Movie] = []
    
    var mediaItems: AnyPublisher<[Movie], MovieError> {
        mediaItemsSubject.eraseToAnyPublisher()
    }
    
    func addFavouriteMediaItems(_ mediaItems: [Movie]) {
        favouriteItems = mediaItems
        mediaItemsSubject.send(favouriteItems)
    }
    
    func addFavouriteMediaItem(_ mediaItem: Movie) {
        favouriteItems = [mediaItem]
        mediaItemsSubject.send(favouriteItems)
    }
    
    func removeFavouriteMediaItem(withId id: Int) {
        favouriteItems.removeAll { $0.id == id }
        mediaItemsSubject.send(favouriteItems)
    }
    
    func isFavouriteMediaItem(withId id: Int) -> Bool {
        favouriteItems.contains { item in
            item.id == id
        }
    }
}
