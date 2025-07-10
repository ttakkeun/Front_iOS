//
//  String+Date.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 7/9/25.
//

import Foundation
import SwiftUI

extension String {
    func formattedDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: self) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy.MM.dd"
            return outputFormatter.string(from: date)
        } else {
            return self
        }
    }
}
