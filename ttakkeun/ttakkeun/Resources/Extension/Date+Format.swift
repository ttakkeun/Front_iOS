//
//  Date+Format.swift
//  ttakkeun
//
//  Created by Apple MacBook on 7/17/25.
//

import Foundation

extension Date {
    func formattedForAPI() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        return formatter.string(from: self)
    }
}
