//
//  CastDetail.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 06. 14..
//

import Foundation

struct CastDetail: Codable, Identifiable {
    let id: Int
    let name: String
    let biography: String?
    let popularity: Double
    let imagePath: String?
    let originPlace: String?
    let birthYear: String?
    
    init() {
        id = 0
        name = ""
        biography = ""
        popularity = 0
        imagePath = nil
        originPlace = nil
        birthYear = nil
    }
    
    init(id: Int, name: String, biography: String, popularity: Double, imagePath: String?, originPlace: String?, birthYear: String?) {
        self.id = id
        self.name = name
        self.biography = biography
        self.popularity = popularity
        self.imagePath = imagePath
        self.originPlace = originPlace
        self.birthYear = birthYear
    }
    
    init(dto: CastMemberDetailResponse) {
        id = dto.id
        name = dto.name
        biography = dto.biography
        popularity = dto.popularity
        imagePath = dto.profilePath
        originPlace = dto.placeOfBirth
        birthYear = dto.birthday
    }
    
    init(dto: CompanyDetailResponse) {
        id = dto.id
        imagePath = dto.logoPath
        name = dto.name
        biography = dto.description
        popularity = 0
        originPlace = dto.originCountry
        birthYear = nil
    }
    
    var profileImageURL: URL? {
        guard let imagePath = imagePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(imagePath)")
    }
}
