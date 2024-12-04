//
//  HomeProfileCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/3/24.
//

import SwiftUI

struct HomeProfileCard: View {
    
    @ObservedObject var viewModel: HomeProfileCardViewModel
    
    var body: some View {
        homeProfileCard
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

struct HomeProfileCard_Preview: PreviewProvider {
    static var previews: some View {
        HomeProfileCard(viewModel: HomeProfileCardViewModel(container: DIContainer()))
    }
}
