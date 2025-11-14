//
//  AddReviewRequest.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 24..
//

struct AddReviewBodyRequest: Encodable {
    let mediaId: Int
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case mediaId = "media_id"
        case rating = "value"
    }
}

struct AddReviewRequest: Encodable {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    let rating: Double
    
    func asRequestParams() -> [String: Any] {
        return [
            "mediaId": mediaId,
            "rating": rating,
        ]
    }
}
