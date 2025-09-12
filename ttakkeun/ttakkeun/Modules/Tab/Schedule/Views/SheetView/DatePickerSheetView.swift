//
//  DatePickerSheetView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/20/24.
//

import SwiftUI

/// 날짜 피커 시트 뷰
struct DatePickerSheetView: View {
    
    // MARK: - Binding
    @Binding var selectedDate: Date
    @Binding var showDatePickerView: Bool
    
    // MARK: - State
    @State private var selectedYear: Int
    @State private var selectedMonth: Int
    @State private var selectedDay: Int
    
    // MARK: - Constants
    private let years: [Int]
    private let month = Array(1...12)
    
    fileprivate enum DatePickerSheetConstants {
        static let buttonHeight: CGFloat = 39
        static let cornerRadius: CGFloat = 10
        static let contentsVspacing: CGFloat = 10
        static let checkText: String = "확인"
        static let yearText: String = "Year"
        static let monthText: String = "Month"
        static let dayText: String = "Day"
    }
    
    // MARK: - Init
    init(
        selectedDate: Binding<Date>,
        showDatePickerView: Binding<Bool>
    ) {
        self._selectedDate = selectedDate
        self._showDatePickerView = showDatePickerView
        
        let calendar = Calendar.current
        let year = calendar.component(.year, from: selectedDate.wrappedValue)
        let month = calendar.component(.month, from: selectedDate.wrappedValue)
        let day = calendar.component(.day, from: selectedDate.wrappedValue)
        
        self._selectedYear = State(initialValue: year)
        self._selectedMonth = State(initialValue: month)
        self._selectedDay = State(initialValue: day)
        
        self.years = {
            let currentYear = calendar.component(.year, from: Date())
            let futureYear = calendar.date(byAdding: .year, value: 10, to: Date()).map { calendar.component(.year, from: $0) } ?? currentYear
            return Array(2000...futureYear)
        }()
    }
    
    var body: some View {
        VStack(spacing: DatePickerSheetConstants.contentsVspacing, content: {
            topContents
            bottomContents
        })
        .safeAreaInset(edge: .top, spacing: UIConstants.capsuleSpacing, content: {
            Capsule()
                .modifier(CapsuleModifier())
        })
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
        .safeAreaPadding(.top, UIConstants.capusuleTopPadding)
    }
    
    // MARK: - TopContents
    /// 상단 피커 뷰
    private var topContents: some View {
        HStack {
            DateComponentsPicker(
                title: DatePickerSheetConstants.yearText,
                selection: $selectedYear,
                values: years,
                display: { "\(formattedYear(from: $0))" }
            )
            
            DateComponentsPicker(
                title: DatePickerSheetConstants.monthText,
                selection: $selectedMonth,
                values: month,
                display: { "\($0)월" }
            )
            
            DateComponentsPicker(
                title: DatePickerSheetConstants.dayText,
                selection: $selectedDay,
                values: generateDays(),
                display: { "\($0)일" }
            )
        }
        .labelsHidden()
    }
    
    // MARK: - BottomContents
    /// 하단 날짜 선택 체크 버튼
    private var bottomContents: some View {
        Button(action: {
            changeSelectedDate()
            showDatePickerView.toggle()
        }, label: {
            checkButtonContents
        })
    }
    
    /// 버튼 액션
    private func changeSelectedDate() {
        let components = DateComponents(year: selectedYear, month: selectedMonth, day: selectedDay)
        if let newDate = Calendar.current.date(from: components) {
            selectedDate = newDate
        }
    }
    
    /// 체크 버튼 컨텐츠
    private var checkButtonContents: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DatePickerSheetConstants.cornerRadius)
                .fill(Color.mainPrimary)
                .frame(height: DatePickerSheetConstants.buttonHeight)
            
            Text(DatePickerSheetConstants.checkText)
                .font(.Body3_medium)
                .foregroundStyle(Color.gray900)
        }
    }
}

extension DatePickerSheetView {
    
    private func formattedYear(from year: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = false
        if let formatted = formatter.string(from: NSNumber(value: year)) {
            return "\(formatted)년"
        } else {
            return "\(year)년"
        }
    }
    
    private func generateDays() -> [Int] {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: selectedYear, month: selectedMonth)
        let date = calendar.date(from: dateComponents) ?? Date()
        let range = calendar.range(of: .day, in: .month, for: date) ?? (1...30).lowerBound..<31
        return Array(range)
    }
}

#Preview {
    @Previewable @State var date: Date = .init()
    
    DatePickerSheetView(selectedDate: $date, showDatePickerView: .constant(true))
}

