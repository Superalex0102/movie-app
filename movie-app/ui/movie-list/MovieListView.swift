import SwiftUI
import InjectPropertyWrapper

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    let genre: Genre
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: LayoutConst.largePadding) {
                ForEach(Array(viewModel.movies.enumerated()), id: \.offset) { index, movie in
                    NavigationLink(destination: DetailView(mediaItem: movie)) {
                        return MovieCellView(movie: movie)
                            .onAppear {
                                if index == viewModel.movies.count - 1 {
                                    viewModel.genreIdSubject.send(genre.id)
                                }
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, LayoutConst.normalPadding)
            .padding(.top, LayoutConst.normalPadding)
            
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .navigationTitle(genre.name)
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.genreIdSubject.send(genre.id)
        }
        .refreshable {
            viewModel.refreshSubject.send()
        }
    }
}

#Preview {
    MovieListView(genre: Genre(id: 28, name: "Action") )
}
