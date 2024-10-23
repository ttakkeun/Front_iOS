//
//  Icon.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/23/24.
//

import Foundation
import SwiftUI

enum Icon: String {
    
    // MARK: - Login
    case appleLogin = "appleLogin"
    case logoBackground = "logoBackground"
    case logo = "logo"
    
    var image: Image {
        return Image(self.rawValue)
    }
}
