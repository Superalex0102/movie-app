import Foundation
import InjectPropertyWrapper
import Combine

protocol GenreSectionViewModel: ObservableObject {
    var genres: [Genre] { get }
    var moviesByGenre: [Genre: [Movie]] { get }
    func loadGenres()
    func loadMovies(genre: Genre, number: Int)
    func genresAppeared()
    func getMovies(genre: Genre) -> [Movie]
}

class GenreSectionViewModelImpl: GenreSectionViewModel, ErrorPresentable {
    @Published var genres: [Genre] = []
    @Published var moviesByGenre: [Genre: [Movie]] = [:]
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
                    return AlertModel(title: "[[Értékeld az appot]]", message: "[[Értékeld az appot]]", dismissButtonTitle: "[[Rendben]]")
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
                    self.loadMovies(genre: genre, number: 3)
                }
            }
            .store(in: &cancellables)
    }
    
    func loadMovies(genre: Genre, number: Int) {
        useCase.loadMovies(genre: genre, number: number)
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { movies in
                self.moviesByGenre[genre] = movies
            }
            .store(in: &cancellables)
    }
    
    func genresAppeared() {
        useCase.genresAppeared()
    }
    
    func getMovies(genre: Genre) -> [Movie] {
        moviesByGenre[genre] ?? []
    }
}
