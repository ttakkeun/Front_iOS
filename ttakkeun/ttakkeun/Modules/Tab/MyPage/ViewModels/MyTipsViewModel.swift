//
//  MyTipsViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 1/8/25.
//

import Foundation

class MyTipsViewModel: ObservableObject {
    let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
}
