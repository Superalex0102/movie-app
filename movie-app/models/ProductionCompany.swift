//
//  ProductionCompany.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 20..
//

import Foundation

struct ProductionCompany: Decodable, Identifiable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String
    
    var imageUrl: URL? {
        guard let logoPath = logoPath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500\(logoPath)")
    }
    
    init(id: Int,
         logoPath: String,
         name: String,
         originCountry: String) {
        self.id = id
        self.logoPath = logoPath
        self.name = name
        self.originCountry = originCountry
    }
    
    init(dto: ProductionCompanyResponse) {
        self.id = dto.id
        self.logoPath = dto.logoPath
        self.name = dto.name
        self.originCountry = dto.originCountry
    }
}

extension ProductionCompany: ParticipantItemProtocol {}
