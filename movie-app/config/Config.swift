//
//  Config.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 12..
//

import Foundation

enum Config {
    private static let config: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) else {
            preconditionFailure("Config.plist file not found or unreadable")
        }
        return dict
    }()

    private static let apiToken: String = {
        guard let token = config["API_TOKEN"] as? String else {
            preconditionFailure("API_TOKEN not found in Config.plist")
        }
        return token
    }()

    private static let accountId: Int = {
        guard let id = config["ACCOUNT_ID"] as? Int else {
            preconditionFailure("ACCOUNT_ID not found in Config.plist")
        }
        return id
    }()

    static var bearerToken: String {
        "Bearer \(apiToken)"
    }

    static var accountID: Int {
        accountId
    }
}
