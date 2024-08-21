//
//  HomeProfileCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/25/24.
//

import SwiftUI

struct HomeProfileCard: View {
    
    @ObservedObject var viewModel: HomeProfileCardViewModel
    @EnvironmentObject var petState: PetState
    
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
                viewModel.getPetProfileInfo(petId: petId)
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
        .animation(.bouncy(duration: 1.2), value: viewModel.isShowFront)
        .sheet(isPresented: $viewModel.isImagePickerPresented, content: {
            HomeProfilePatchImagePicker(imageHandler: viewModel)
                .environmentObject(petState)
        })
    }
        
}

struct HomeProfileCard_Preview: PreviewProvider {
    static var previews: some View {
        HomeProfileCard(viewModel: HomeProfileCardViewModel(), petId: 1)
    }
}

