//
//  HomeProfileCard.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/25/24.
//

import SwiftUI

struct HomeProfileCard: View {
    
    @ObservedObject var viewModel: HomeProfileCardViewModel
    
    // MARK: - Init
    
    init(viewModel: HomeProfileCardViewModel) {
        self.viewModel = viewModel
    }
    
    
    // MARK: - Components
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    HomeProfileCard(viewModel: HomeProfileCardViewModel())
}
