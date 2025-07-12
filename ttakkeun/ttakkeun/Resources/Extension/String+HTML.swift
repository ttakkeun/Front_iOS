//
//  String + Text.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 7/12/25.
//

import Foundation
import SwiftUI

extension String {
    func removingHTMLTags() -> String {
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
    
    func customLineBreak() -> String {
        self.split(separator: "").joined(separator: "\u{200B}")
    }

    func cleanedAndLineBroken() -> String {
        self.removingHTMLTags().customLineBreak()
    }
}
