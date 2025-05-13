//
//  FavouritesViewModel.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 26..
//

import Foundation
import Combine
import InjectPropertyWrapper

protocol FavouritesViewModelProtocol: ObservableObject {
    var movies: [Movie] { get }
}

class FavouritesViewModel: FavouritesViewModelProtocol, ErrorPresentable {
    @Published var movies: [Movie] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        let request = FetchFavouriteMovieRequest()
        
        service.fetchFavouriteMovies(req: request)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlerModel(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self]movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
}
