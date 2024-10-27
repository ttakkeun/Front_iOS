//
//  DIContainer.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/23/24.
//

import Foundation

class DIContainer: ObservableObject {
    let useCaseProvider: UseCaseProvider
    var navigationRouter: NavigationRoutable & ObservableObjectSettable
    
    init(
        useCaseProvider: UseCaseProvider = UseCaseProvider(),
        navigationRouter: NavigationRoutable & ObservableObjectSettable = NavigationRouter()
    ) {
        self.useCaseProvider = useCaseProvider
        self.navigationRouter = navigationRouter
        self.navigationRouter.setObjectWillChange(objectWillChange)
    }
}
