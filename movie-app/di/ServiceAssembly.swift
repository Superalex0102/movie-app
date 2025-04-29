//
//  ServiceAssembly.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 15..
//

import Swinject
import Moya
import Foundation

class ServiceAssembly: Assembly {

    func assemble(container: Container) {
        container.register(MoyaProvider<MultiTarget>.self) { _ in
            let configuration = URLSessionConfiguration.default
            configuration.headers = .default
            
            return MoyaProvider<MultiTarget>(
                session: Session(configuration: configuration,
                                 startRequestsImmediately: false),
                plugins: [
                    NetworkLoggerPlugin(
                        configuration: NetworkLoggerPlugin.Configuration(
                            output: { _, items in
                                for item in items {
                                    print("Response \(item)")
                                }
                            },
                            logOptions: .verbose))
                ])
        }.inObjectScope(.container)
        
        container.register(MoviesServiceProtocol.self) { _ in
            return MoviesService()
//            return MockMoviesService()
        }.inObjectScope(.container)
    }
}
