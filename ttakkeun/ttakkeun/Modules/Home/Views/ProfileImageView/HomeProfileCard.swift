//
//  HomeProfileCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/3/24.
//

import SwiftUI

struct HomeProfileCard: View {
    
    @StateObject var viewModel: HomeProfileCardViewModel
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    @ViewBuilder
    private var homeProfileCard: some View {
        ZStack {
            if viewModel.isShowFront {
                ProfileCardFront(viewModel: viewModel)
            } else {
                ProfileCardBack(viewModel: viewModel)
            }
        }
        .animation(.bouncy(duration: 1.2), value: viewModel.isShowFront)
    }
}
