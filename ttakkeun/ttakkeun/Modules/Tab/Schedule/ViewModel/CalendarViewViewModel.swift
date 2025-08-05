//
//  DiaryViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/20/24.
//

import Foundation
import SwiftUI

@Observable
class CalendarViewModel {
    
    // MARK: - Published Properties
    var showDatePickerView: Bool = false
    
    var month: Date {
        didSet {
            updateSelectedYearAndMonth(from: month)
        }
    }
    var selectedDate: Date {
        didSet {
            syncMonthWithSelectedDate()
        }
    }
    var selectedYear: Int = 0
    var selectedMonth: Int = 0
    var showCurrentWeekBar: Bool = true
    
    // MARK: - Private Properties
    public var calendar: Calendar
    private let container: DIContainer
    
    // MARK: - Initializer
    init(month: Date, calendar: Calendar, container: DIContainer) {
        self.container = container
        self.month = month
        self.calendar = calendar
        self.selectedDate = Date()
        self.calendar.locale = Locale(identifier: "ko_KR")
        updateSelectedYearAndMonth(from: month)
    }
    
    // MARK: - Methods
    private func updateSelectedYearAndMonth(from date: Date) {
        let components = calendar.dateComponents([.year, .month], from: date)
        selectedYear = components.year ?? 0
        selectedMonth = components.month ?? 1
    }
    
    func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
            self.month = newMonth
        }
    }
    
    private func numberOfDays(in date: Date) -> Int {
        return calendar.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    private func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = calendar.dateComponents([.year, .month], from: date)
        let firstDayOfMonth = calendar.date(from: components)!
        return calendar.component(.weekday, from: firstDayOfMonth) - 1
    }
    
    
    private func getDate(for day: Int) -> Date? {
        guard let startOfMonth = startOfMonth() else {
            return nil
        }
        
        return calendar.date(byAdding: .day, value: day, to: startOfMonth)
    }
    
    /// 월의 시작 날짜
    private func startOfMonth() -> Date? {
        let components = calendar.dateComponents([.year, .month], from: month)
        
        return calendar.date(from: components)
    }
    
    public func generateMonthDates() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else { return [] }
        let daysInMonth = calendar.range(of: .day, in: .month, for: month)?.count ?? 0
        
        let firstDayOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let leadingEmptySpaces = (firstWeekday - calendar.firstWeekday + 7) % 7
        
        let dates = (0..<daysInMonth).compactMap {
            calendar.date(byAdding: .day, value: $0, to: firstDayOfMonth)
        }
        
        let trailingEmptySpaces = (7 - ((leadingEmptySpaces + daysInMonth) % 7)) % 7
        let placeholderDates: [Date?] = Array(repeating: nil, count: leadingEmptySpaces)
        let placeholderDatesAtEnd: [Date?] = Array(repeating: nil, count: trailingEmptySpaces)
        
        return placeholderDates + dates + placeholderDatesAtEnd
    }
    
    public func changeSelectedDate(_ date: Date) {
        if calendar.isDate(selectedDate, inSameDayAs: date) {
            return
        } else {
            selectedDate = date
        }
    }
    
    private func syncMonthWithSelectedDate() {
        let components = calendar.dateComponents([.year, .month], from: selectedDate)
        if let newMonth = calendar.date(from: components), newMonth != month {
            month = newMonth
        }
    }
}
