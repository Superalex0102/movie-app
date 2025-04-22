//
//  MovieListView.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 15..
//

import SwiftUI
import InjectPropertyWrapper

protocol MovieListViewModelProtocol: ObservableObject {
    
}

class MovieListViewModel: MovieListViewModelProtocol {
    @Published var movies: [Movie] = []
    
    @Inject
    private var service: MoviesServiceProtocol
    
    func loadMovies(by genreId: Int) async {
        do {
            let request = FetchMoviesRequest(genreId: genreId)
            let movies = try await service.fetchMovies(req: request)
            DispatchQueue.main.async {
                self.movies = movies
            }
        } catch {
            print("Error fetching genres: \(error)")
        }
    }
}

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    let genre: Genre
    
//    let columns = [
//        GridItem(.flexible(), spacing: 16),
//        GridItem(.flexible(), spacing: 16)
//    ]
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(viewModel.movies) { movie in
                    MovieCellView(movie: movie)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        .navigationTitle(genre.name)
        .onAppear {
            Task {
                await viewModel.loadMovies(by: genre.id)
            }
        }
    }
}



struct MovieCellView: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                HStack(alignment: .center) {
                    AsyncImage(url: movie.imageUrl) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                Color.gray.opacity(0.3)
                                ProgressView()
                            }

                        case let .success(image):
                            image
                                .resizable()
                                .scaledToFill()

                        case .failure(let error):
                            ZStack {
                                Color.red.opacity(0.3)
                                Image(systemName: "photo")
                                    .foregroundColor(.white)
                            }
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                }
                
                //TODO: Import star image and add new font
                HStack(spacing: 6) {
                    Image(.star)
                    Text(String(format: "%.1f", movie.rating))
                        .font(Fonts.labelBold)
                }
                .padding(6)
                .background(Color.main.opacity(0.5))
                .cornerRadius(12)
                .padding(6)
            }

            Text(movie.title)
                .font(Fonts.subheading)
                .lineLimit(2)

            Text("\(movie.year)")
                .font(Fonts.paragraph)

            Text("\(movie.duration)")
                .font(Fonts.caption)

            Spacer()
        }
    }
}


#Preview {
    MovieListView(genre: Genre(id: 28, name: "Action") )
}
