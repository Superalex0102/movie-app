//
//  movie_appApp.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 08..
//

import SwiftUI

@main
struct movie_appApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
//    @State var selectedTab: TabType = TabType.search
    
    var body: some Scene {
        WindowGroup {
            MovieListView(genre: Genre(id: 28, name: "Action"))
        }
    }
}
