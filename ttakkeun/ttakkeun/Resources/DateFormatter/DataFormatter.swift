//
//  DataFormatter.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import Foundation

final class DataFormatter {
    static let shared = DataFormatter()
    
    public func formattedData(from dateString: String) -> String {
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
}
