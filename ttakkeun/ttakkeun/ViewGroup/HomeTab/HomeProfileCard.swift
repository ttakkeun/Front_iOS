//
//  HomeProfileCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/25/24.
//

import SwiftUI

struct HomeProfileCard: View {
    
    @ObservedObject var viewModel: HomeProfileCardViewModel
    let petId: Int
    
    // MARK: - Init
    
    init(
        viewModel: HomeProfileCardViewModel,
        petId: Int
    ) {
        self.viewModel = viewModel
        self.petId = petId
    }
    
    
    // MARK: - Components
    var body: some View {
        homeProfileCard
            .onAppear {
                Task {
                    await viewModel.getPetProfileInfo(petId: petId)
                }
            }
    }
    
    @ViewBuilder
    private var homeProfileCard: some View {
        ZStack {
            if viewModel.isShowFront {
                HomeFrontCard(viewModel: viewModel)
            } else {
                HomeBackCard(viewModel: viewModel)
            }
        }
        .animation(.easeInOut, value: viewModel.isShowFront)
    }
        
}

struct HomeProfileCard_Preview: PreviewProvider {
    static var previews: some View {
        HomeProfileCard(viewModel: HomeProfileCardViewModel(), petId: 1)
    }
}
