//
//  HomeView.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/30/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeProfileCardViewModel: HomeProfileCardViewModel
    @EnvironmentObject var petState: PetState
    
    init() {
        self._homeProfileCardViewModel = StateObject(wrappedValue: HomeProfileCardViewModel())
    }
    
    var body: some View {
        contetns
    }
    
    // MARK: Contetns
    
    private var contetns: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .center, spacing: 14, content: {
                TopStatusBar()
                HomeProfileCard(viewModel: homeProfileCardViewModel, petId: petState.petId ?? 1)
                
                Spacer()
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HomeDragView()
        }
    }
}

struct HomeView_Preview: PreviewProvider {
    static let devices = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            HomeView()
                .environmentObject(PetState())
                .background(Color.primaryColor_Main)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
