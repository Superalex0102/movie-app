import Foundation
import InjectPropertyWrapper
import Combine

protocol GenreSectionViewModelProtocol: ObservableObject {
    var genres: [Genre] { get }
}

class GenreSectionViewModel: GenreSectionViewModelProtocol, ErrorPresentable {
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    @Inject
    private var mediaItemRepository: MediaItemStoreProtocol
    
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
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { genres in
                self.genres = genres
            }
            .store(in: &cancellables)
        
    }
}
