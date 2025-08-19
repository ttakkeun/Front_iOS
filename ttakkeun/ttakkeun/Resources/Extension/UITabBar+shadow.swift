//
//  UITabBar+shadow.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/19/25.
//

import Foundation
import SwiftUI

extension UITabBarController {
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = .init(width: 0, height: -4)
        tabBar.layer.shadowRadius = 6
        tabBar.layer.shadowOpacity =  0.2
    }
}
