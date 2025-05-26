//
//  EditFavouriteResults.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 20..
//

struct EditFavouriteResult {
    let success: Bool
    let statusCode: Int
    let statusMessage: String
    
    init(dto: EditFavouriteResponse) {
        self.success = dto.success
        self.statusCode = dto.statusCode
        self.statusMessage = dto.statusMessage
    }
}
