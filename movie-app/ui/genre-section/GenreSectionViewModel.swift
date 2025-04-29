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

class GenreSectionViewModel: GenreSectionViewModelProtocol, ErrorViewModelProtocol {
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var movieService: MoviesServiceProtocol
    
//    func fetchGenres() async {
//        do {
//            let request = FetchGenreRequest()
//            let genres = Environment.name == .tv ? try await movieService.fetchTVGenres(req: request) :
//                                                    try await movieService.fetchGenres(req: request)
//            DispatchQueue.main.async {
//                self.genres = genres
//            }
//        } catch {
//            DispatchQueue.main.async {
//                self.alertModel = self.toAlerModel(error)
//            }
//        }
//    }
    
    private func toAlerModel(_ error: Error) -> AlertModel {
        guard let error = error as? MovieError else {
            return AlertModel(
                title: "unexpected.error.title",
                message: "unexpected.error.message",
                dismissButtonTitle: "button.close.text"
            )
        }
        switch error {
        case .invalidApiKeyError(let message):
            return AlertModel(
                title: "API Error",
                message: message,
                dismissButtonTitle: "button.close.text"
            )
        case .clientError:
            return AlertModel(
                title: "Client Error",
                message: error.localizedDescription,
                dismissButtonTitle: "button.close.text"
            )
        default:
            return AlertModel(
                title: "unexpected.error.title",
                message: "unexpected.error.message",
                dismissButtonTitle: "button.close.text"
            )
        }
    }
    
    init() {
            let request = FetchGenreRequest()
            
            let future = Future<[Genre], Error> { promise in
                Task {
                    do {
                        let genres = try await self.movieService.fetchGenres(req: request)
                        promise(.success(genres))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        
            let futureTV = Future<[Genre], Error> { promise in
                Task {
                    do {
                        let genres = try await self.movieService.fetchTVGenres(req: request)
                        promise(.success(genres))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            
            future
                .receive(on: RunLoop.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        self.alertModel = self.toAlerModel(error)
                    case .finished:
                        break
                    }
                } receiveValue: { genres in
                    self.genres = genres
                }
                .store(in: &cancellables)
    }
}
