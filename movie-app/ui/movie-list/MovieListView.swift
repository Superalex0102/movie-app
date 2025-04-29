import SwiftUI
import InjectPropertyWrapper

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    let genre: Genre
    
//    let columns = [
//        GridItem(.flexible(), spacing: 16),
//        GridItem(.flexible(), spacing: 16)
//    ]
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: LayoutConst.normalPadding)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: LayoutConst.largePadding) {
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

#Preview {
    MovieListView(genre: Genre(id: 28, name: "Action") )
}
