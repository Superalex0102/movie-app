//
//  AddReviewViewModel.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 24..
//

import Foundation
import InjectPropertyWrapper
import Combine

class AddReviewViewModel: ObservableObject, ErrorPresentable {
    @Published var alertModel: AlertModel? = nil
    @Published var mediaItemDetail: MediaItemDetail = MediaItemDetail()
    @Published var selectedRating: Int = -1
    @Published var success: Bool = false
    
    let mediaDetailSubject = PassthroughSubject<MediaItemDetail, Never>()
    let sendReviewSubject = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var repository: MovieRepository
    
    init() {
        mediaDetailSubject
            .sink { [weak self]detail in
                self?.mediaItemDetail = detail
            }
            .store(in: &cancellables)
        
        sendReviewSubject
            .flatMap { [weak self] _ in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = AddReviewRequest(mediaId: mediaItemDetail.id, rating: Double(selectedRating))
                return self.repository.addReview(req: request)
            }
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlertModel(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self]result in
                print(result)
                self?.success = true
            }
            .store(in: &cancellables)
    }
}
