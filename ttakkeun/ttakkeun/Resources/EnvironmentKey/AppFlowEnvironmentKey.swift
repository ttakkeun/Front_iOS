//
//  AppFlowEnvironmentKey.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/13/25.
//

import Foundation
import SwiftUI

struct AppFlowEnvironmentKey: EnvironmentKey {
    static var defaultValue: AppFlowViewModel = .init()
}

extension EnvironmentValues {
    var appFlow: AppFlowViewModel {
        get { self[AppFlowEnvironmentKey.self] }
        set { self[AppFlowEnvironmentKey.self] = newValue}
    }
}
