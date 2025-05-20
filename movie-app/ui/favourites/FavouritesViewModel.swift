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
    var mediaItems: [Movie] { get }
}

class FavouritesViewModel: FavouritesViewModelProtocol, ErrorPresentable {
    @Published var mediaItems: [Movie] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    let viewLoaded = PassthroughSubject<Void, Never>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        
        viewLoaded
            .flatMap { [weak self]_ -> AnyPublisher<[Movie], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                return self.service.fetchFavouriteMovies(req: FetchFavouriteMovieRequest(), fromLocal: false)
            }
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlertModel(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self]mediaItems in
                self?.mediaItems = mediaItems
            }
            .store(in: &cancellables)
    }
}
