//
//  RegistDiagnosisFlowView.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/5/24.
//

import SwiftUI

struct RegistDiagnosisFlowView: View {
    @StateObject var viewModel: RegistJournalViewModel
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var tabManager: TabBarVisibilityManager
    
    init(petId: Int) {
        self._viewModel = StateObject(wrappedValue: RegistJournalViewModel(petId: petId))
    }
    
    var body: some View {
        VStack(alignment: .center, content: {
            CustomNavigation(action: {
                container.navigationRouter.pop()
            }, title: "일지 생성", currentPage: viewModel.currentPage, naviIcon: Image("close"), width: 14, height: 14)
            
            Spacer().frame(height: 38)
            
            RegistDiagnosisPageContents(viewModel: viewModel)
                .environmentObject(container)
            
            Spacer().frame(height: 20)
        })
        .navigationBarBackButtonHidden()
        .frame(width: 355, height: 820)
        .onAppear {
            withAnimation {
                tabManager.isTabBarHidden = true
            }
        }
        
        .onDisappear {
            withAnimation(.easeInOut(duration: 0.2)) {
                tabManager.isTabBarHidden = false
            }
        }
    }
}
