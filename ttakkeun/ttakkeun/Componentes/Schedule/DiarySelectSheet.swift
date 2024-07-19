//
//  DiarySelectSheet.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/13/24.
//

import SwiftUI

/// 년, 월 선택 시트 뷰
struct DiarySelectSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.presentationMode) var presentationMode
    
    private let years = Array(2000...(Calendar.current.component(.year, from: Date()) + 10))
    private let months = Array(1...12)
    @State private var selectedYear: Int
    @State private var selectedMonth: Int

    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        let components = Calendar.current.dateComponents([.year, .month], from: selectedDate.wrappedValue)
        self._selectedYear = State(initialValue: components.year ?? 2024)
        self._selectedMonth = State(initialValue: components.month ?? 1)
    }
    
    private let yearFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.usesGroupingSeparator = false
        return formatter
    }()

    //MARK: - 컴포넌트
    var body: some View {
        VStack(spacing: 10) {
            
            Capsule()
                .fill(Color.gray)
                .frame(width: 30, height: 4)
            
            HStack {
                Picker("Year", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text("\(yearFormatter.string(from: NSNumber(value: year)) ?? "\(year)")년").tag(year)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity)

                Picker("Month", selection: $selectedMonth) {
                    ForEach(months, id: \.self) { month in
                        Text("\(month)월").tag(month)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 15)
            .labelsHidden()
            
            
            Button(action: {
                let components = DateComponents(year: selectedYear, month: selectedMonth)
                if let newDate = Calendar.current.date(from: components) {
                    selectedDate = newDate
                }
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("확인")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.mainTextColor_Color)
                    .padding()
                    .frame(width:208, height: 39)
                    .background(Color.primaryColor_Color)
                    .clipShape(.rect(cornerRadius:10))
            }
        }
        .background(Color.white)
        .frame(height: 210)
        .clipShape(.rect(topLeadingRadius: 10, topTrailingRadius: 10))
        .padding(.vertical, 15)
    }
}

//MARK: - Preview
struct DiarySelectSheet_Previews: PreviewProvider {
    static var previews: some View {
        DiarySelectSheet(selectedDate: .constant(Date()))
            .previewLayout(.sizeThatFits)
    }
}
