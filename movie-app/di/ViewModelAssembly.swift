//
//  ViewModelAssembly.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 04. 15..
//

import Swinject
import Foundation
import Combine

class ViewModelAssembly: Assembly {

    func assemble(container: Container) {
        container.register((any MovieListViewModelProtocol).self) { _ in
            return MovieListViewModel()
        }.inObjectScope(.container)
    }
}
