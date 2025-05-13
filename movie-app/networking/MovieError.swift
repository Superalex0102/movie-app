//
//  MovieError.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 26..
//

import Foundation
 
enum MovieError: Error {
    case invalidApiKeyError(message: String)
    case clientError
    case unexpectedError
    case mappingError(message: String)
    
    var domain: String {
        switch self {
        case .invalidApiKeyError, .unexpectedError, .clientError, .mappingError:
            return "MovieError"
        }
        
    
    }
}

extension MovieError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidApiKeyError(let message):
            return message
        case .mappingError(let message):
            return message
        case .clientError:
            return "Client Error Description"
        case .unexpectedError:
            return "Unexpected error"
        }
    }
    
}
