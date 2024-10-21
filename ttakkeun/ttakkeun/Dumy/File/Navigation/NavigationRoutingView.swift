//
//  NavigationRoutingView.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/14/24.
//

import Foundation
import SwiftUI

struct NavigationRoutingView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var tabManager: TabBarVisibilityManager
    @State var destination: NavigationDestination
    
    var body: some View {
        switch destination {
        case .signUp(let token, let name, let email):
            SignupView(signUpData: SignUpData(token: token, email: email, name: name))
                .environmentObject(container)
        case .createProfile:
            CreateProfileView()
                .environmentObject(container)
        case .myPage:
            Text("마이페이잊")
        case .createDiagnosis(let petId):
            RegistDiagnosisFlowView(petId: petId)
                .environmentObject(container)
                .environmentObject(tabManager)
        }
    }
}
