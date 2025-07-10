//
//  AppDelegate.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 7/10/25.
//

import Foundation
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = UIColor.black
        
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        return true
    }
}
