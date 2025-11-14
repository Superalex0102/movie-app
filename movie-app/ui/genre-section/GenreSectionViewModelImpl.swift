import Foundation
import InjectPropertyWrapper
import Combine

protocol GenreSectionViewModel: ObservableObject {
    var genres: [Genre] { get }
    var mediaItemsByGenre: [Genre: [Movie]] { get }
    var trendingMediaItem: MediaItemDetail? { get }
    
    func loadGenres()
    func loadMediaItems(genre: Genre, number: Int)
    func loadDetailMediaItem(movie: Movie)
    func loadTrendingMediaItem()
    func genresAppeared()
    func getMediaItems(genre: Genre) -> [Movie]
}

class GenreSectionViewModelImpl: GenreSectionViewModel, ErrorPresentable {
    
    @Published var genres: [Genre] = []
    @Published var mediaItemsByGenre: [Genre: [Movie]] = [:]
    @Published var trendingMediaItem: MediaItemDetail?
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var useCase: GenreSectionUseCase
    
    @Inject
    private var mediaItemRepository: MediaItemStoreProtocol
    
    init() {
        useCase.showAppearPopup
            .map { showAppearPopup -> AlertModel? in
                if showAppearPopup {
                    return AlertModel(title: "app.rate.title".localized(), message: "app.rate.message".localized(), dismissButtonTitle: "app.rate.button".localized())
                }
                return nil
            }
            .sink { [weak self]alertModel in
                self?.alertModel = alertModel
            }
            .store(in: &cancellables)
    }
    
    func loadGenres() {
        useCase.loadGenres()
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { genres in
                self.genres = genres
                
                for genre in genres {
                    self.loadMediaItems(genre: genre, number: 3)
                }
            }
            .store(in: &cancellables)
    }
    
    func loadMediaItems(genre: Genre, number: Int) {
        useCase.loadMediaItems(genre: genre, number: number)
            .delay(for: .seconds(3), scheduler: RunLoop.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { movies in
                self.mediaItemsByGenre[genre] = movies
            }
            .store(in: &cancellables)
    }
    
    func loadDetailMediaItem(movie: Movie) {
        useCase.loadDetailMediaItem(movie: movie)
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { movie in
                self.trendingMediaItem = movie
            }
            .store(in: &cancellables)
    }
    
    func loadTrendingMediaItem() {
        useCase.loadTrendingMediaItem()
            .map  { $0.first }
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { movie in
                guard let movie = movie else {
                    return
                }
                self.loadDetailMediaItem(movie: movie)
            }
            .store(in: &cancellables)
    }
    
    func genresAppeared() {
        useCase.genresAppeared()
    }
    
    func getMediaItems(genre: Genre) -> [Movie] {
        mediaItemsByGenre[genre] ?? Array(repeating: Movie(), count: 5)
    }
}
