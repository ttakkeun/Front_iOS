//
//  DataFormatter.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import Foundation
import SwiftUI

final class DataFormatter {
    static let shared = DataFormatter()
    
    public func formattedDate(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy.MM.dd"
            return outputFormatter.string(from: date)
        } else {
            return dateString
        }
    }
    
    public func formatDateForAPI(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
    
    public func formattedTime(from timeString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm:ss.SSSSSS"
        
        if let date = inputFormatter.date(from: timeString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm"
            return outputFormatter.string(from: date)
        } else {
            return timeString
        }
    }
    
    public func yearFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.usesGroupingSeparator = false
        return formatter
    }
    
    
    public func monthFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    public func stripHTMLTags(from htmlString: String) -> String {
        guard let data = htmlString.data(using: .utf8) else { return htmlString }
        
        do {
            let attributedString = try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
            
            return attributedString.string
        } catch {
            print("Failed to decode HTML entities: \(error)")
            return htmlString
        }
    }
    
    public func formattedPrice(from price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: price)) ?? ""
    }
}
