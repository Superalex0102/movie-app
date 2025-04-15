//
//  ContentView.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 08..
//

import SwiftUI
import InjectPropertyWrapper

protocol GenreSectionViewModelProtocol: ObservableObject {
    
}

class GenreSectionViewModel: GenreSectionViewModelProtocol {
    @Published var genres: [Genre] = []
    
    @Inject
    private var movieService: MoviesServiceProtocol
    
    func fetchGenres() async {
        do {
            let request = FetchGenreRequest()
            let genres = Environment.name == .tv ?
                try await movieService.fetchGenres(req: request) :
                try await movieService.fetchTVGenres(req: request)
            DispatchQueue.main.async {
                self.genres = genres
            }
        } catch {
            print("Error fetching genres: \(error)")
        }
    }
}

struct GenreSectionView: View {
    
    @StateObject private var viewModel = GenreSectionViewModel()
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            GeometryReader { geometry in
                Image(.ellipse)
                    .resizable()
                    .frame(width: 449, height: 449)
                    .position(x: geometry.size.width - 205, y: 225)
            }
            
            NavigationView {
                List(viewModel.genres) { genre in
                    ZStack {
                        NavigationLink(destination: MovieListView(genre: genre)) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        HStack {
                            Text(genre.name)
                                .font(Fonts.title)
                                .foregroundStyle(Color.primary)
                            Spacer()
                            Image(.rightArrow)
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .background(Color.clear)
                .listStyle(.plain)
                .navigationTitle(Environment.name == .dev ? "DEV" : "PROD")
            }
            .onAppear {
                Task {
                    await viewModel.fetchGenres()
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    GenreSectionView()
}
