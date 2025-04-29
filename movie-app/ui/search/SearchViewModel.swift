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
    func searchMovies() async
}

class SearchViewModel: SearchViewModelProtocol {
    @Published var movies: [Movie] = []
    @Published var searchText: String = ""
    
    @Inject
    private var service: MoviesServiceProtocol
    
    func searchMovies() async {
        guard !searchText.isEmpty else {
            DispatchQueue.main.async {
                self.movies = []
            }
            return
        }
        
        do {
            let request = SearchMovieRequest(query: searchText)
            let movies = try await service.searchMovies(req: request)
            
            DispatchQueue.main.async {
                self.movies = movies
            }
        } catch {
            print("Error searching movies: \(error)")
        }
    }
}
