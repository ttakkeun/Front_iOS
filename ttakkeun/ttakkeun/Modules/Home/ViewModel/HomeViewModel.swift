//
//  HomeViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var homeProfileCardViewModel: HomeProfileCardViewModel
    @Published var homeTodoViewModel: HomeTodoViewModel
    @Published var homeRecommendViewModel: HomeRecommendViewModel
    
    init(container: DIContainer) {
        self._homeProfileCardViewModel = .init(wrappedValue: .init(container: container))
        self._homeTodoViewModel = .init(wrappedValue: .init(container: container))
        self._homeRecommendViewModel = .init(wrappedValue: .init(container: container))
    }
}
