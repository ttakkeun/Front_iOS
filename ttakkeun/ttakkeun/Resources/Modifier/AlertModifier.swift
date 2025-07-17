//
//  AlertModifier.swift
//  ttakkeun
//
//  Created by Apple MacBook on 7/17/25.
//

import SwiftUI

/// Alert창 띄우기 Modifier
struct AlertModifier: ViewModifier {
    @Bindable var alert: AlertStateModel
    
    func body(content: Content) -> some View {
        content
            .overlay(content: {
                if alert.showAlert {
                    if let nicknameValue = alert.nicknameValue {
                        CustomAlert(alertType: alert.alertType, showAlert: $alert.showAlert, yes: alert.yes, nickNameValue: nicknameValue)
                    } else {
                        CustomAlert(alertType: alert.alertType, showAlert: $alert.showAlert, yes: alert.yes)
                    }
                }
            })
    }
}

extension View {
    func customAlert(alert: AlertStateModel) -> some View {
        self.modifier(AlertModifier(alert: alert))
    }
}
