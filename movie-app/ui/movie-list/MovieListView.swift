import SwiftUI
import InjectPropertyWrapper

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    let genre: Genre
    
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
        .alert(item: $viewModel.alertModel) { model in
            return Alert(
                title: Text(LocalizedStringKey(model.title)),
                message: Text(LocalizedStringKey(model.message)),
                dismissButton: .default(Text(LocalizedStringKey(model.dismissButtonTitle))) {
                    viewModel.alertModel = nil
                }
            )
        }
        .onAppear {
            viewModel.genreIdSubject.send(genre.id)
        }
    }
}

#Preview {
    MovieListView(genre: Genre(id: 28, name: "Action") )
}
