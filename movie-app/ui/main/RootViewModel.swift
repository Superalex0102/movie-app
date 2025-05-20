//
//  RootViewModel.swift
//  movie-app
//
//  Created by Alexander Dominik Somogyi on 2025. 05. 17..
//

import Foundation
import InjectPropertyWrapper
import Combine

class RootViewModel: ObservableObject {
    
    @Inject
    private var networkMonitor: NetworkMonitorProtocol
    
    @Published var isConnected: Bool = true
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        networkMonitor.isConnected
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self]isConnected in
                self?.isConnected = isConnected
            })
            .store(in: &cancellables)
    }
}
