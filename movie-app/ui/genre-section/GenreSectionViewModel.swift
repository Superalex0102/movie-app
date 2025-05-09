//
//  GenreSectionViewModel.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 26..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol ErrorViewModelProtocol {
    var alertModel: AlertModel? { get }
}

protocol GenreSectionViewModelProtocol: ObservableObject {
    var genres: [Genre] { get }
}

class GenreSectionViewModel: GenreSectionViewModelProtocol, ErrorPrentable {
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        let request = FetchGenreRequest()
        
        let genres = Environment.name == .tv ?
        self.service.fetchTVGenres(req: request) :
        self.service.fetchGenres(req: request)
        
        genres
            .handleEvents(receiveOutput: { genres in
                print("Custom action before receive: genres count = \(genres.count)")
            })
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlerModel(error)
                }
            } receiveValue: { genres in
                self.genres = genres
            }
            .store(in: &cancellables)
    }
}
