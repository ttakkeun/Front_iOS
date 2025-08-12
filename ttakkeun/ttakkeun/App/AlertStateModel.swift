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
    
    /// Alert를 사용하기 위해 외부 사용 함수
    /// - Parameters:
    ///   - type: Alert 타입 선택
    ///   - showAlert: Alert 등장 선택
    ///   - action: Alert 확인 버튼 액션
    ///   - nicknameValue: 닉네임 변경 시 닉네임 값 지정
    func trigger(type: AlertType, showAlert: Bool, action: @escaping () -> Void = {}, nicknameValue: Binding<String>? = nil) {
        self.alertType = type
        self.showAlert = showAlert
        self.yes = action
        self.nicknameValue = nicknameValue
    }
}
