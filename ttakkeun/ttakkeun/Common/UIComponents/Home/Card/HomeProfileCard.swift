//
//  HomeProfileCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/3/24.
//

import SwiftUI

struct HomeProfileCard: View {
    
    // MARK: - Property
    @Bindable var viewModel: HomeProfileCardViewModel
    
    // MARK: - Constants
    fileprivate enum HomeProfileCardConstants {
        static let duration: TimeInterval = 1.2
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            if viewModel.isShowFront {
                ProfileCardFront(viewModel: viewModel)
            } else {
                ProfileCardBack(viewModel: viewModel)
            }
        }
        .task {
            viewModel.getSpecificProfile()
        }
        .animation(.bouncy(duration: HomeProfileCardConstants.duration), value: viewModel.isShowFront)
    }
}

struct HomeProfileCard_Preview: PreviewProvider {
    static var previews: some View {
        HomeProfileCard(viewModel: HomeProfileCardViewModel(container: DIContainer()))
    }
}
