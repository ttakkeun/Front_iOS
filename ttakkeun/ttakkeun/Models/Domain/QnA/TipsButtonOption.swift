//
//  TipsButtonOption.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/2/25.
//

import Foundation

struct TipsButtonOption {
    let heartAction: () -> Void
    let scrapAction: () -> Void
    
    init(heartAction: @escaping () -> Void, scrapAction: @escaping () -> Void) {
        self.heartAction = heartAction
        self.scrapAction = scrapAction
    }
}
