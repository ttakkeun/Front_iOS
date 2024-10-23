//
//  DIContainer.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/23/24.
//

import Foundation

class DIContainer: ObservableObject {
    var navigationRouter: NavigationRoutable & ObservableObjectSettable
    
    init(navigationRouter: NavigationRoutable & ObservableObjectSettable = NavigationRouter()) {
        self.navigationRouter = navigationRouter
        self.navigationRouter.setObjectWillChange(objectWillChange)
    }
}
