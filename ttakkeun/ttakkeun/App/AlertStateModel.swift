//
//  AlertStateModel.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 7/14/25.
//

import SwiftUI

@Observable
class AlertStateModel {
    var alertType: AlertType = .aiAlert(count: 0, aiCount: 0)
    var showAlert: Bool = false
    var yes: () -> Void = {}
    var nicknameValue: Binding<String>? = nil

    func trigger(type: AlertType, showAlert: Bool, action: @escaping () -> Void = {}, nicknameValue: Binding<String>? = nil) {
        self.alertType = type
        self.showAlert = showAlert
        self.yes = action
        self.nicknameValue = nicknameValue
    }
}
