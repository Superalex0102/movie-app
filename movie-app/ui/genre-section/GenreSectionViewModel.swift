//
//  GenreSectionViewModel.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 26..
//

import Foundation
import InjectPropertyWrapper

protocol ErrorViewModelProtocol {
    var alertModel: AlertModel? { get }
}

protocol GenreSectionViewModelProtocol: ObservableObject {
    var genres: [Genre] { get }
    func fetchGenres() async
}

class GenreSectionViewModel: GenreSectionViewModelProtocol, ErrorViewModelProtocol {
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
    @Inject
    private var movieService: MoviesServiceProtocol
    
    func fetchGenres() async {
        do {
            let request = FetchGenreRequest()
            let genres = Environment.name == .tv ? try await movieService.fetchTVGenres(req: request) :
                                                    try await movieService.fetchGenres(req: request)
            DispatchQueue.main.async {
                self.genres = genres
            }
        } catch {
            DispatchQueue.main.async {
                self.alertModel = self.toAlerModel(error)
            }
        }
    }
    
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
}
