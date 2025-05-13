//
//  SearchViewModel.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 26..
//

import Foundation
import Combine
import InjectPropertyWrapper

protocol SearchViewModelProtocol: ObservableObject {
    var movies: [Movie] { get }
    var searchText: String { get set }
}

class SearchViewModel: SearchViewModelProtocol, ErrorPresentable {
    @Published var movies: [Movie] = []
    @Published var searchText: String = ""
    @Published var alertModel: AlertModel? = nil
    
    
    let startSearch = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        startSearch
            .print("<<< startSearch")
            .debounce(for: .seconds(2.5), scheduler: RunLoop.main)
            .flatMap { [weak self]_ ->  AnyPublisher<[Movie], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = SearchMovieRequest(query: self.searchText)
                return self.service.searchMovies(req: request)
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
