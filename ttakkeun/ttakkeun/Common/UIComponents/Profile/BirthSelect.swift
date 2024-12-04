//
//  BirthSelect.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/1/24.
//

import SwiftUI

struct BirthSelect: View {
    @State private var selectedYear: Int?
    @State private var selectedMonth: Int?
    @State private var selectedDay: Int?
    
    @Binding var birthDate: String
    @Binding var isBirthFilled: Bool
    
    init(selectedYear: Int? = nil, selectedMonth: Int? = nil, selectedDay: Int? = nil, birthDate: Binding<String>, isBirthFilled: Binding<Bool>) {
        self._birthDate = birthDate
        self._isBirthFilled = isBirthFilled
        
        // 초기값 설정
        let parsedDate = Self.parseBirthDate(birthDate.wrappedValue)
        self._selectedYear = State(initialValue: parsedDate.year)
        self._selectedMonth = State(initialValue: parsedDate.month)
        self._selectedDay = State(initialValue: parsedDate.day)
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            CustomPicker(selectedValue: $selectedYear, title: "연도",
                         range: Array(startYear()...currentYear()).map { $0 },
                         updateAction: { updateBirthDate() })
            
            Divider()
                .frame(width: 1, height: 44)
                .background(Color.gray200)
            
            CustomPicker(selectedValue: $selectedMonth, title: "월",
                         range: Array(1...12).map { $0 },
                         updateAction: { updateBirthDate() })
            
            Divider()
                .frame(width: 1, height: 44)
                .background(Color.gray200)
            
            CustomPicker(selectedValue: $selectedDay, title: "일",
                         range: dayRange(), updateAction: { updateBirthDate() })
        })
        .frame(width: 331, height: 44)
        .overlay(content: {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray200, lineWidth: 1)
        })
    }
}

extension BirthSelect {
    func currentYear() -> Int {
        Calendar.current.component(.year, from: Date())
    }
    
    func startYear() -> Int {
        currentYear() - 30
    }
    
    func dayRange() -> [Int] {
        guard let year = selectedYear, let month = selectedMonth else {
            return Array(1...31)
        }
        
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: month)
        if let date = calendar.date(from: dateComponents),
           let range = calendar.range(of: .day, in: .month, for: date) {
            return Array(range)
        } else {
            return Array(1...31)
        }
    }
    
    func updateBirthDate() {
        if let year = selectedYear, let month = selectedMonth, let day = selectedDay {
            birthDate = "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day))"
            isBirthFilled = true
        } else {
            isBirthFilled = false
        }
    }
    
    static func parseBirthDate(_ birthDate: String) -> (year: Int?, month: Int?, day: Int?) {
        let components = birthDate.split(separator: "-").map { Int($0) }
        guard components.count == 3 else {
            return (nil, nil, nil)
        }
        return (year: components[0], month: components[1], day: components[2])
    }
}
