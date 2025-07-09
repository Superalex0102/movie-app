//
//  FetchCastMemberDetailRequest.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 06. 24..
//

struct FetchCastMemberDetailRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let castMemberId: Int
    
    func asRequestParams() -> [String: Any]{
        return languageParam
    }
}
