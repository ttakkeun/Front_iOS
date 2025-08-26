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
    
    /// 서버 시간 문자열을 현재 시간과 비교하여 "n분 전", "n시간 전" 등의 차이 문자열을 반환
    /// - Returns: 시간 차이를 나타내는 문자열
    func timeAgoFromServerTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        guard let serverDate = dateFormatter.date(from: self) else {
            return "알 수 없음"
        }
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        
        let currentDate = Date()
        let difference = calendar.dateComponents([.day, .hour, .minute], from: serverDate, to: currentDate)
        
        if let day = difference.day, day > 0 {
            if let hour = difference.hour, let minute = difference.minute {
                return "\(day)일 \(hour)시간 \(minute)분 전"
            }
            return "\(day)일 전"
        } else if let hour = difference.hour, hour > 0 {
            if let minute = difference.minute {
                return "\(hour)시간 \(minute)분 전"
            }
            return "\(hour)시간 전"
        } else if let minute = difference.minute, minute > 0 {
            return "\(minute)분 전"
        } else {
            return "방금 전"
        }
    }
    
    var formattedDateString: String {
            let inputFormatter = DateFormatter()
            inputFormatter.locale = Locale(identifier: "en_US_POSIX")
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ko_KR")
            outputFormatter.dateFormat = "yyyy.MM.dd"

            guard let date = inputFormatter.date(from: self) else {
                return self // 실패 시 원본 반환
            }

            return outputFormatter.string(from: date)
        }
}
