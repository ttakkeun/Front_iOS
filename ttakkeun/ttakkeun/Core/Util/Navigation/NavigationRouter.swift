//
//  NavigationRoutabler.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/23/24.
//

import Foundation
import Combine

protocol NavigationRoutable {
    var destination: [NavigationDestination] { get set }
    
    func push(to view: NavigationDestination)
    func pop()
    func popToRootView()
}

class NavigationRouter: NavigationRoutable, ObservableObjectSettable {
    var destination: [NavigationDestination] = [] {
        didSet {
            objectWillChange?.send()
        }
    }
    
    func push(to view: NavigationDestination) {
        destination.append(view)
    }
    
    func pop() {
        _ = destination.popLast()
    }
    
    func popToRootView() {
        destination = []
    }
    
    var objectWillChange: ObservableObjectPublisher?
}
