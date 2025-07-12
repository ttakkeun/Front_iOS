//
//  DIContainer.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/23/24.
//

import Foundation

class DIContainer: ObservableObject {
    @Published var useCaseProvider: UseCaseProvider
    @Published var navigationRouter: NavigationRoutable
    
    init(
        useCaseProvider: UseCaseProvider = UseCaseProvider(),
        navigationRouter: NavigationRoutable = NavigationRouter()
    ) {
        self.useCaseProvider = useCaseProvider
        self.navigationRouter = navigationRouter
    }
}
