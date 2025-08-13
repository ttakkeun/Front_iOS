//
//  AlertEnvironmentKey.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/12/25.
//

import Foundation
import SwiftUI

struct AlertStateModelKey: EnvironmentKey {
    static let defaultValue: AlertStateModel = .init()
}

extension EnvironmentValues {
    var alert: AlertStateModel {
        get { self[AlertStateModelKey.self] }
        set { self[AlertStateModelKey.self] = newValue }
    }
}
