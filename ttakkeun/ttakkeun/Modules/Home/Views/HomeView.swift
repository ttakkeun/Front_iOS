//
//  HomeView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        // TODO: - 데이터 로딩 적재 대기 걸어두기
            contents
//            VStack {
//                Spacer()
//                
//                ProgressView()
//                
//                Text("\(UserState.shared.getPetName())에 대한 정보를 로딩 중입니다.")
//                    .font(.Body4_medium)
//                    .foregroundStyle(Color.gray400)
//                
//                Spacer()
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var contents: some View {
        ZStack(alignment: .bottom, content: {
            VStack(alignment: .center, spacing: 14, content: {
                TopStatusBar()
                
                HomeProfileCard(viewModel: viewModel.homeProfileCardViewModel)
                
                Spacer()
            })
            .border(Color.red)
            HomeDragView(viewModel: viewModel)
        })
        .background(Color.mainPrimary)
    }
}

#Preview {
    HomeView()
}
