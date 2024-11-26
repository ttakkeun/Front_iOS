//
//  HomeViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var homeProfileCardViewModel = HomeProfileCardViewModel()
    @Published var homeTodoViewModel: HomeTodoViewModel = HomeTodoViewModel()
    @Published var recommendViewModel: RecommendViewModel = RecommendViewModel()
}
