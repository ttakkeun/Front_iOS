//
//  JournalRegistView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/11/24.
//

import SwiftUI

struct JournalRegistView: View {
    @StateObject var viewModel: JournalRegistViewModel
    @EnvironmentObject var container: DIContainer
    
    init(container: DIContainer) {
        self._viewModel = StateObject(wrappedValue: .init(petID: UserState.shared.getPetId(), container: container))
    }
    
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 38, content: {
                CustomNavigation(action: {
                    container.navigationRouter.pop()
                }, title: nil, currentPage: viewModel.currentPage)
                
                JournalRegistContents(viewModel: viewModel)
            })
            .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .navigationBarBackButtonHidden(true)
            
            if viewModel.makeJournalsLoading {
                
                Color.white.opacity(0.8).ignoresSafeArea(.all)
                
                ProgressView(label: {
                    LoadingDotsText(text: "일지 생성 중입니다. \n잠시 기다려주세요")
                })
                .controlSize(.extraLarge)
            }
        }
        .onAppear {
            UIApplication.shared.hideKeyboard()
        }
    }
}

#Preview {
    JournalRegistView(container: DIContainer())
        .environmentObject(DIContainer())
}
