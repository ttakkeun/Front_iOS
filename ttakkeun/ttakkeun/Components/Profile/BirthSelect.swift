//
//  BirthSelect.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/5/24.
//

import SwiftUI

/// 프로필 생성뷰에서 생년월일 선택하는 필드 구현
struct BirthSelect: View {
    
    @State private var selectedYear: Int? = nil
    @State private var selectedMonth: Int? = nil
    @State private var selectedDay: Int? = nil
    
    @Binding var birthDate: String
    @Binding var isBirthFilled: Bool
    
    ///연도 콤마 제거 Formatter
    private let yearFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.usesGroupingSeparator = false
        return formatter
    }()
    
    //MARK: - Contents
    /// 버튼 구조
    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            ///연도 피커
            Picker(selection: Binding(
                get: { selectedYear ?? Calendar.current.component(.year, from: Date()) },
                set: {
                    selectedYear = $0
                    updateBirthDate()
                }
            ), label: Text("연도")) {
                ForEach(1900...2024, id: \.self) { year in
                    Text("\(yearFormatter.string(from: NSNumber(value: year)) ?? "\(year)")년").tag(year)
                }
            }
            .pickerStyle(.menu)
            .frame(width: 110, height: 44)
            .accentColor(Color.clear)
            .overlay(
                Text(selectedYear == nil ? "연도" : "\(yearFormatter.string(from: NSNumber(value: selectedYear!)) ?? "\(selectedYear!)")년")
                    .foregroundColor(Color.gray_400)
                    .font(.Body3_medium)
                    .frame(width: 110, height: 44)
            )
            
            Divider()
                .frame(width: 1, height: 44)
                .background(Color.gray_200)
            
            /// 월 피커
            Picker(selection: Binding(
                get: { selectedMonth ?? Calendar.current.component(.month, from: Date()) },
                set: {
                    selectedMonth = $0
                    updateBirthDate()
                }
            ), label: Text("월")) {
                ForEach(1...12, id: \.self) { month in
                    Text("\(month)월").tag(month)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 110, height: 44)
            .accentColor(.clear)
            .overlay(
                Text(selectedMonth == nil ? "월" : "\(selectedMonth!)월")
                    .foregroundColor(Color.gray_400)
                    .font(.Body3_medium)
                    .frame(width: 110, height: 44)
            )
            .onChange(of: selectedMonth) { updateBirthDate() }
            
            
            Divider()
                .frame(width: 1, height: 44)
                .background(Color.gray_200)
            
            /// 일 피커
            Picker(selection: Binding(
                get: { selectedDay ?? Calendar.current.component(.day, from: Date()) },
                set: {
                    selectedDay = $0
                    updateBirthDate()
                }
            ), label: Text("일")) {
                ForEach(1...31, id: \.self) { day in
                    Text("\(day)일").tag(day)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 110, height: 44)
            .accentColor(.clear)
            .overlay(
                Text(selectedDay == nil ? "일" : "\(selectedDay!)일")
                    .foregroundColor(Color.gray_400)
                    .font(.Body3_medium)
                    .frame(width: 110, height: 44)
            )
            .onChange(of: selectedDay) { updateBirthDate() }
            
        })
        .frame(width: 331, height: 44)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray_200, lineWidth: 1)
        )
        .onAppear {
            updateBirthDate()
        }
    }
    
    //MARK: - function
    /// 생년월일 String으로 변경
    private func updateBirthDate() {
        if let year = selectedYear, let month = selectedMonth, let day = selectedDay {
            birthDate = "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day))"
            isBirthFilled = true
        } else {
            isBirthFilled = false
        }
    }
    
}
