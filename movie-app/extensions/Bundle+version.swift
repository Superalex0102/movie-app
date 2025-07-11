//
//  Bundle+version.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 07. 11..
//

import Foundation

extension Bundle {
    
    static func getAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    static func getBuildNumber() -> String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
    
    static func getVersionAndBuild() -> String {
        return "v\(getAppVersion()) (\(getBuildNumber()))"
    }
}
