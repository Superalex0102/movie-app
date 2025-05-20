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
    @Published var credits: [CastMember] = []
    @Published var isFavourite: Bool = false
    @Published var alertModel: AlertModel? = nil
    
    let mediaItemIdSubject = PassthroughSubject<Int, Never>()
    let favouriteButtonTapped = PassthroughSubject<Void, Never>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    @Inject
    private var mediaItemStore: MediaItemStoreProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        let mediaItemIdSubject = mediaItemIdSubject.share()
        
        let details = mediaItemIdSubject
            .flatMap { [weak self]mediaItemId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailRequest(mediaId: mediaItemId)
                return self.service.fetchMovieDetail(req: request)
            }
        
        let credits = mediaItemIdSubject
            .flatMap { [weak self]mediaItemId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMovieCreditsRequest(mediaId: mediaItemId)
                return self.service.fetchMovieCredits(req: request)
            }
        
        Publishers.CombineLatest(details, credits)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] details, credits in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                self.mediaItemDetail = details
                self.credits = credits
                self.isFavourite = self.mediaItemStore.isMediaItemStored(withId: details.id)
            }
            .store(in: &cancellables)

        favouriteButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<(EditFavouriteResult, Bool), MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let isFavourite = !self.isFavourite
                let request = EditFavouriteRequest(movieId: self.mediaItemDetail.id, isFavourite: isFavourite)
                return service.editFavouriteMovie(req: request)
                    .map { result in
                    (result, isFavourite)
                }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] result, isFavourite in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                if result.success {
                    self.isFavourite = isFavourite
                    if isFavourite {
                        self.mediaItemStore.saveMediaItems([Movie(detail: self.mediaItemDetail)])
                    } else {
                        self.mediaItemStore.deleteMediaItem(withId: self.mediaItemDetail.id)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
}
