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
    
    func convertedToKoreanTimeDateString() -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        // 2. self → Date 변환
        guard let serverDate = isoFormatter.date(from: self) else {
            return "알 수 없음"
        }
        
        // 3. 한국 시간(KST)으로 변환
        let koreanTimeZone = TimeZone(identifier: "Asia/Seoul")!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.timeZone = koreanTimeZone
        
        return dateFormatter.string(from: serverDate)
    }
    
    func toHourMinuteString() -> String {
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            isoFormatter.timeZone = TimeZone(secondsFromGMT: 0) // 서버가 UTC 기준이면 이렇게 설정
            
            guard let date = isoFormatter.date(from: self) else {
                return "Invalid Time"
            }
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm"
            outputFormatter.timeZone = TimeZone(identifier: "Asia/Seoul") // KST 기준으로 보기 위해 설정
            
            return outputFormatter.string(from: date)
        }
}
