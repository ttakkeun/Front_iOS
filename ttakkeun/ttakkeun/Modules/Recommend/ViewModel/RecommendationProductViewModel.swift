//
//  RecommendationViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/22/24.
//

import Foundation

class RecommendationProductViewModel: ObservableObject {
    @Published var selectedCategory: ExtendPartItem = .all
    @Published var aiProducts: [ProductResponse]?
    @Published var recommendProducts: [ProductResponse] = []
}
