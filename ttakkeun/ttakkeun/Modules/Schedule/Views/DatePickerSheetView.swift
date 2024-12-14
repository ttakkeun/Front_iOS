//
//  DatePickerSheetView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/20/24.
//

import SwiftUI

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
        VStack(spacing: 10, content: {
            Capsule()
                .modifier(CapsuleModifier())
            
            DatePicker
            
            completeButton
        })
        .safeAreaPadding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
        .background(Color.white)
        .frame(height: 250)
    }
    
    private var DatePicker: some View {
        HStack {
            Group {
                Picker("Year", selection: $selectedYear, content: {
                    ForEach(years, id: \.self) { year in
                        Text(formattedYear(from: year))
                            .font(.Body4_medium)
                            .foregroundStyle(Color.gray900)
                            .tag(year)
                        
                    }
                })
                
                Picker("Month", selection: $selectedMonth, content: {
                    ForEach(month, id: \.self) { month in
                        Text("\(month)월")
                            .font(.Body4_medium)
                            .foregroundStyle(Color.gray900)
                            .tag(month)
                    }
                })
                
                Picker("Day", selection: $selectedDay, content: {
                    ForEach(generateDays(), id: \.self) { day in
                        Text("\(day)일")
                            .font(.Body4_medium)
                            .foregroundStyle(Color.gray900)
                            .tag(day)
                    }
                })
            }
            .pickerStyle(WheelPickerStyle())
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 15)
        .labelsHidden()
    }
    
    private var completeButton: some View {
        Button(action: {
            let components = DateComponents(year: selectedYear, month: selectedMonth)
            if let newDate = Calendar.current.date(from: components) {
                selectedDate = newDate
                print("새롭게 선택된 날짜 : \(newDate)")
            }
            showDatePickerView.toggle()
        }, label: {
            Text("확인")
                .font(.Body3_medium)
                .foregroundStyle(Color.gray900)
                .padding()
                .frame(width: 208, height: 39)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.mainPrimary)
                }
        })
    }
}

extension DatePickerSheetView {
    
    private func formattedYear(from year: Int) -> String {
        let formatter = DataFormatter.shared.yearFormatter()
        if let formatter = formatter.string(from: NSNumber(value: year)) {
            return "\(formatter)년"
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

struct DatePickerSheetView_Preview: PreviewProvider {
    static var previews: some View {
        DatePickerSheetView(selectedDate: .constant(Date()), showDatePickerView: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
