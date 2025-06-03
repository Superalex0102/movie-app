//
//  Movie.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 15..
//

import Foundation

struct MoviePage {
    let movies: [Movie]
    let totalPages: Int
    
    init(dto: MoviePageResponse) {
        self.movies = dto.results.map(Movie.init)
        self.totalPages = dto.totalPages
    }
}
