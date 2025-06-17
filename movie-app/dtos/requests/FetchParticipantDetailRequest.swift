//
//  FetchPersonDetailRequest.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 06. 14..
//

struct FetchParticipantDetailRequest : Encodable {
    let accessToken: String = Config.bearerToken
    let participantId : Int
    
    func asRequestParams() -> [String: String] {
        return [:]
    }
}
