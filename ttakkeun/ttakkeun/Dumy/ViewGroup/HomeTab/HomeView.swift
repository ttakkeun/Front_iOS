//
//  HomeView.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/30/24.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - Property
    @StateObject var homeProfileCardViewModel: HomeProfileCardViewModel
    @StateObject var scheduleViewModel: ScheduleViewModel
    @StateObject var productViewModel: ProductViewModel
    @EnvironmentObject var petState: PetState
    
    init() {
        self._homeProfileCardViewModel = StateObject(wrappedValue: HomeProfileCardViewModel())
        self._scheduleViewModel = StateObject(wrappedValue: ScheduleViewModel())
        self._productViewModel = StateObject(wrappedValue: ProductViewModel())
    }
    
    var body: some View {
        if homeProfileCardViewModel.profileData != nil {
            contetns
        } else {
            VStack {
                Spacer()
                
                ProgressView()
                    .frame(width: 120, height: 120)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.all)
            .onAppear {
                homeProfileCardViewModel.getPetProfileInfo(petId: petState.petId)
            }
        }
    }
    
    // MARK: Contetns
    
    private var contetns: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .center, spacing: 14, content: {
                TopStatusBar()
                HomeProfileCard(viewModel: homeProfileCardViewModel)
                    .environmentObject(petState)
                
                Spacer()
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if let type = self.homeProfileCardViewModel.profileData?.type {
                HomeDragView(scheduleViewModel: scheduleViewModel, productViewModel: productViewModel, profileType: type)
                    .environmentObject(petState)
            }
        }
    }
}
    
    // MARK: - Preview
struct HomeView_Preview: PreviewProvider {
    static let devices = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            HomeView()
                .environmentObject(PetState(petName: "유애", petId: 1))
                .background(Color.primaryColor_Main)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
