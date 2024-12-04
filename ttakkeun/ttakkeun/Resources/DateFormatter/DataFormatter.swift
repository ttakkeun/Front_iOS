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
    
    public func maskUserName(_ name: String) -> String {
        let nameParts = name.split(separator: " ")
        
        if nameParts.count == 1 {
            let firstPart = nameParts[0]
            
            if firstPart.count == 2 {
                let first = firstPart.prefix(1)
                return "\(first)*"
            } else if firstPart.count > 2 {
                let first = firstPart.prefix(1)
                let remaining = firstPart.dropFirst().dropFirst()
                return "\(first)*\(remaining)"
            } else {
                return String(firstPart)
            }
        } else if nameParts.count > 1 {
            let firstName = nameParts.first ?? ""
            let lastName = nameParts.dropFirst().joined(separator: " ")
            
            let maskedLastName = String(repeating: "*", count: lastName.count)
            return "\(firstName) \(maskedLastName)"
        }
        return name
    }

    /// 서버 시간(UTC)을 받아 현재 한국 시간(KST)과 비교하여 경과 시간을 반환
    func convertToKoreanTime(from serverTime: String) -> String {
        // 1. ISO8601DateFormatter 설정
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC 기준으로 해석

        // 2. 서버 시간 문자열 → Date 변환
        guard let serverDate = isoFormatter.date(from: serverTime) else {
            return "알 수 없음" // 형식이 잘못된 경우 처리
        }

        // 3. 한국 시간(KST)으로 변환
        let koreanTimeZone = TimeZone(identifier: "Asia/Seoul")!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm" // 원하는 포맷 설정
        dateFormatter.timeZone = koreanTimeZone

        return dateFormatter.string(from: serverDate) // 한국 시간 문자열 반환
    }}
