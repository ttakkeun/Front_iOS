//
//  ProfileViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var isLastedCard: Bool = false
    let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
}
