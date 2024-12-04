//
//  RecommendViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/6/24.
//

import Foundation

class HomeRecommendViewModel: ObservableObject {
    @Published var aiProduct: [ProductResponse]?
    @Published var userProduct: [ProductResponse]?
    
    let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
}
