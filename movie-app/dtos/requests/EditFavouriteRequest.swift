//
//  EditFavouriteRequest.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 20..
//

struct EditFavouriteBodyRequest: Encodable {
    let movieId: Int
    let isFavourite: Bool
    let mediaType = "movie"
    
    enum CodingKeys: String, CodingKey {
        case isFavourite = "favorite"
        case movieId = "media_id"
        case mediaType = "media_type"
    }
}

struct EditFavouriteRequest: Encodable {
    let accessToken: String = Config.bearerToken
    let accountId: Int = 21889570
    let movieId: Int
    let isFavourite: Bool
    
    func asRequestParams() -> [String: Any] {
        return [
            "media_type": "movie",
            "media_id": movieId,
            "favorite": isFavourite
        ]
    }
}
