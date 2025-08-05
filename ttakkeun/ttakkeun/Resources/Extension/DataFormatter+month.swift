//
//  DataFormatter+month.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/4/25.
//

import Foundation

extension DateFormatter {
    static var monthFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            return formatter
        }
}
