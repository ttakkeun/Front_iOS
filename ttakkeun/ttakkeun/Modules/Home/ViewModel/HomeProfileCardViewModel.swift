//
//  HomeProfileCardViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/3/24.
//

import Foundation

class HomeProfileCardViewModel: ObservableObject {
    @Published var isShowFront: Bool = true
    @Published var profileData: HomeProfileResponseData?
    
    let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
}
