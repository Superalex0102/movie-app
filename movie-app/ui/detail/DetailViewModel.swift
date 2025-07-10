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
    @Published var movies: [Movie] = []
    @Published var reviews: [MovieReview] = []
    @Published var isFavourite: Bool = false
    @Published var alertModel: AlertModel? = nil
    
    let mediaItemIdSubject = PassthroughSubject<Int, Never>()
    let favouriteButtonTapped = PassthroughSubject<Void, Never>()
    
    @Inject
    private var repository: MovieRepository
    
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
                let request = FetchMovieDetailRequest(mediaId: mediaItemId)
                return self.repository.fetchMovieDetail(req: request)
            }
        
        let credits = mediaItemIdSubject
            .flatMap { [weak self]mediaItemId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMovieCreditsRequest(mediaId: mediaItemId)
                return self.repository.fetchMovieCredits(req: request)
            }
        
        let movies = mediaItemIdSubject
            .flatMap { [weak self]mediaItemId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchSimilarMovieRequest(mediaItemId: mediaItemId, page: 1)
                return self.repository.fetchSimilarMovie(req: request)
            }
        
        let reviews = mediaItemIdSubject
            .flatMap { [weak self]mediaItemId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMovieReviewsRequest(mediaId: mediaItemId, page: 1)
                return self.repository.fetchMovieReviews(req: request)
            }
        
        //TODO: add pagination for similar movies loading.
        Publishers.CombineLatest4(details, credits, movies, reviews)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] details, credits, movies, reviews in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                self.mediaItemDetail = details
                self.credits = credits
                self.movies = movies
                self.reviews = reviews
                self.isFavourite = self.mediaItemStore.isMediaItemStored(withId: details.id)
            }
            .store(in: &cancellables)

        favouriteButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<(ModifyMediaResult, Bool), MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let isFavourite = !self.isFavourite
                let request = EditFavouriteRequest(movieId: self.mediaItemDetail.id, isFavourite: isFavourite)
                return repository.editFavouriteMovie(req: request)
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
