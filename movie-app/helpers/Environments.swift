//
//  Environments.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 12..
//

struct Environment {
    enum Name {
        case prod
        case dev
    }
#if ENV_PROD
    static let name: Name = .prod
#else
    static let name: Name = .dev
#endif
}
