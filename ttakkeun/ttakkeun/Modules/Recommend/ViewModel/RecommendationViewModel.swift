//
//  RecommendationViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/23/24.
//

import Foundation

class RecommendationViewModel: ObservableObject {
    @Published var productViewModel: RecommendationProductViewModel = .init()
    @Published var searachViewModel: SearchViewModel = .init()
}
