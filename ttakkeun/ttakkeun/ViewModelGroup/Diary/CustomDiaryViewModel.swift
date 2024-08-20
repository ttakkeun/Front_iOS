//
//  CustomDiaryViewModel.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/13/24.
//

import Foundation
import SwiftUI

/// 다이어리 뷰, 날짜 관련 처리 뷰모델
class CustomDiaryViewModel: ObservableObject {
    @Published var month: Date {
        didSet {
            let components = calendar.dateComponents([.year, .month], from: month)
            selectedYear = components.year ?? 0
            selectedMonth = components.month ?? 1
        }
    }
    @Published var offset: CGSize = CGSize()
    @Published var selectedDate: Date
    @Published var selectedYear: Int
    @Published var selectedMonth: Int
    @Published var showCurrentWeekBar: Bool = true
    
    private var calendar: Calendar
    
    init(month: Date, calendar: Calendar) {
        self.month = month
        self.calendar = calendar
        /*현재 날짜로 초기화!!*/
        self.selectedDate = Date()
        
        let components = calendar.dateComponents([.year, .month], from: month)
        self.selectedYear = components.year ?? 0
        self.selectedMonth = components.month ?? 1
    }
    
    // MARK: - Function
    /// 해당 월의 총 일수
    private func numberOfDays(in date: Date) -> Int {
        return calendar.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    /// 월의 첫째날 시작 요일
    private func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = calendar.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = calendar.date(from: components)!
        return calendar.component(.weekday, from: firstDayOfMonth) - 1
    }

    /// 주어진 일에 대한 Date 객체 반환
    public func getDate(for day: Int) -> Date {
        return calendar.date(byAdding: .day, value: day, to: startOfMonth())!
    }
    
    /// 월의 시작 날짜
    public func startOfMonth() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        return Calendar.current.date(from: components)!
    }
    
    /// 월 변경
    public func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
            self.month = newMonth
        }
    }

    /// 선택된 날짜 토글
    public func toggleDate(_ date: Date) {
        if Calendar.current.isDate(selectedDate, inSameDayAs: date) {
            selectedDate = Date()
            showCurrentWeekBar = true
        } else {
            selectedDate = date
            showCurrentWeekBar = false
        }
    }
    
    //TODO: - 주차 막대 표시를 위한 현재 주 해당 날짜 반환
//    /// 현재 주에 해당하는 날짜들을 반환 -> 주차 막대
//    public func getCurrentWeek() -> [Date?] {
//        var currentWeek: [Date?] = []
//        let today = Date()
//        guard let startOfWeek = calendar.dateInterval(of: .weekOfMonth, for: today)?.start else { return currentWeek }
//        
//        for i in 0..<7 {
//            if let date = calendar.date(byAdding: .day, value: i, to: startOfWeek) {
//                currentWeek.append(date)
//            }
//        }
//        
//        return currentWeek
//    }
    
    //TODO: - 주차 막대 표시를 위한 현재 주차 시작과 끝 날짜 반환 함
//    /// 주차 막대 표시를 위한 현재 주차의 시작과 끝 날짜 반환
//    public func getWeekRange(for date: Date) -> (start: Date, end: Date)? {
//        guard let startOfWeek = calendar.dateInterval(of: .weekOfMonth, for: date)?.start else { return nil }
//        guard let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) else { return nil }
//        return (start: startOfWeek, end: endOfWeek)
//    }

    /// 월별 날짜 배열 반환
    public func generateMonthDates() -> [Date?] {
        let daysInMonth = numberOfDays(in: month)
        let firstWeekday = firstWeekdayOfMonth(in: month)
        var dates: [Date?] = Array(repeating: nil, count: firstWeekday)
        
        for day in 1...daysInMonth {
            let date = getDate(for: day - 1)
            dates.append(date)
        }
        
        return dates
    }
}
