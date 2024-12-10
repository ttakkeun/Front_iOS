//
//  NavigatiobnRoutingView.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/4/24.
//

import Foundation
import SwiftUI

struct NavigationRoutingView: View {
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    @State var destination: NavigationDestination
    
    var body: some View {
        switch destination {
        case .signUp(let signUpRequest):
            SignUpView(singUpRequest: signUpRequest, container: container, appFlowViewModel: appFlowViewModel)
                .environmentObject(container)
        case .createProfile:
            MakeProfileView(container: container)
                .environmentObject(container)
            
        case .editPetProfile(let petInfo, let image):
            EditProfileView(container: container,
                            editPetInfo: petInfo, image: image)
                .environmentObject(container)
        case .makeJournalist:
            JournalRegistView(container: container)
                .environmentObject(container)
        case .productSearch:
            RecommendSearchView(container: container)
                .environmentObject(container)
        }
    }
}
