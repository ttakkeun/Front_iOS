//
//  AlertStateModel.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 7/14/25.
//

import Foundation

@Observable
class AlertStateModel {
    var showAlert: Bool = false
    var alertType: AlertType = .deleteAccountAlert
    var actionYes: () -> Void = {}
    
    func trigger(type: AlertType, action: @escaping () -> Void = {}) {
        self.alertType = type
        self.alertType = type
        self.actionYes = action
        self.showAlert = true
    }
}
