//
//  DetailViewModel.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 10..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol DetailViewModelProtocol: ObservableObject {
    
}

class DetailViewModel: DetailViewModelProtocol, ErrorPresentable {
    @Published var mediaItemDetail: MediaItemDetail = MediaItemDetail()
    @Published var alertModel: AlertModel? = nil
    
    let mediaItemIdSubject = PassthroughSubject<Int, Never>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let details = mediaItemIdSubject
            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .flatMap { [weak self] mediaItemId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailRequest(mediaId: mediaItemId)
                return self.service.fetchMovieDetail(req: request)
            }
        
        details
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlerModel(error)
                }
            } receiveValue: { [weak self] mediaItemDetail in
                self?.mediaItemDetail = mediaItemDetail
            }
            .store(in: &cancellables)
    }
}
