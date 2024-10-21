//
//  NavigationRouter.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/14/24.
//

import Foundation
import Combine

protocol NavigationRoutable {
    var destinations: [NavigationDestination] { get set }
    
    func push(to view: NavigationDestination)
    func pop()
    func popToRootView()
}

/// 네비게이션 지정 라우터
class NavigationRouter: NavigationRoutable, ObservableObjectSettable {
    
    var destinations: [NavigationDestination] = [] {
        didSet {
            objectWillChange?.send()
        }
    }
    
    func push(to view: NavigationDestination) {
        destinations.append(view)
    }
    
    func pop() {
        _ = destinations.popLast()
    }
    
    func popToRootView() {
        destinations = []
    }
    
    var objectWillChange: ObservableObjectPublisher?
    
    
}
