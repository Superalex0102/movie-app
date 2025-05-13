//
//  MovieListViewModel.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 26..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol MovieListViewModelProtocol: ObservableObject {
    var movies: [Movie] { get }
}

class MovieListViewModel: MovieListViewModelProtocol, ErrorPresentable {
    @Published var movies: [Movie] = []
    @Published var alertModel: AlertModel? = nil
    
    let genreIdSubject = PassthroughSubject<Int, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        
        genreIdSubject
            .flatMap { [weak self] genreId -> AnyPublisher<[Movie], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMoviesRequest(genreId: genreId, includeAdult: true)
                return Environment.name == .tv ?
                                                self.service.fetchTV(req: request) :
                                                self.service.fetchMovies(req: request)
                
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlerModel(error)
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
}
