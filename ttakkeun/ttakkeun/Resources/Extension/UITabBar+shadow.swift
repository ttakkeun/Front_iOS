//
//  UITabBar+shadow.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/19/25.
//
import Foundation
import UIKit

extension UITabBarController {
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 6
        tabBar.layer.shadowOpacity = 0.2
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
    }

    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()

        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = UIColor.clear

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
}
