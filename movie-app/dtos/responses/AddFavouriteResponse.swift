//
//  AddFavouriteResponse.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 09..
//

struct AddFavoriteResponse : Decodable {
    let success : Bool
    let statusCode : Int
    let statusMessage : String

    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
