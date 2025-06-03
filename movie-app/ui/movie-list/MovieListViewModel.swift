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
    @Published var isLoading: Bool = false
    
    var actualPage: Int = 0
    
    let genreIdSubject = PassthroughSubject<Int, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var repository: MovieRepository
    
    init() {
        
        //TODO: check totalPage, so it doesn't throw an exception
        genreIdSubject
            .flatMap { [weak self] genreId -> AnyPublisher<MoviePage, MovieError> in
                self?.isLoading = true
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                self.actualPage += 1
                let request = FetchMoviesRequest(genreId: genreId, includeAdult: true, page: actualPage)
                return self.repository.fetchMovies(req: request)
                
            }
            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] moviePage in
                self?.movies.append(contentsOf: moviePage.movies)
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}
