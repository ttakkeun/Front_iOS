//
//  CustomDatePickerView.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/17/24.
//

import SwiftUI
import UIKit

/// SwiftUI에서 UIPickerView 사용할 수 있도록
struct CustomDatePickerView: UIViewRepresentable {
    @Binding var selectedDate: Date

    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var parent: CustomDatePickerView

        let years = Array(2000...2100)
        let months = Array(1...12)

        init(parent: CustomDatePickerView) {
            self.parent = parent
        }

        /// UIPickerView의 구성 요소 수(년, 월)
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2
        }

        /// 각 구성 요소의 행 수
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return component == 0 ? years.count : months.count
        }

        /// 각 행의 제목
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if component == 0 {
                return "\(years[row])년"
            } else {
                return "\(months[row])월"
            }
        }

        /// 선택된 행의 값 업데이트
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let selectedYear = years[pickerView.selectedRow(inComponent: 0)]
            let selectedMonth = months[pickerView.selectedRow(inComponent: 1)]
            let components = DateComponents(year: selectedYear, month: selectedMonth)
            if let newDate = Calendar.current.date(from: components) {
                parent.selectedDate = newDate
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    /// 초기 UIPickerView를 생성
    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.delegate = context.coordinator
        picker.dataSource = context.coordinator

        /// 선택된 날짜에 맞게 초기 값 설정
        let components = Calendar.current.dateComponents([.year, .month], from: selectedDate)
        if let yearIndex = context.coordinator.years.firstIndex(of: components.year ?? 2000),
           let monthIndex = context.coordinator.months.firstIndex(of: components.month ?? 1) {
            picker.selectRow(yearIndex, inComponent: 0, animated: false)
            picker.selectRow(monthIndex, inComponent: 1, animated: false)
        }

        return picker
    }
   
    /// 뷰 업데이트
    func updateUIView(_ uiView: UIPickerView, context: Context) {
        let components = Calendar.current.dateComponents([.year, .month], from: selectedDate)
        if let yearIndex = context.coordinator.years.firstIndex(of: components.year ?? 2000),
           let monthIndex = context.coordinator.months.firstIndex(of: components.month ?? 1) {
            uiView.selectRow(yearIndex, inComponent: 0, animated: true)
            uiView.selectRow(monthIndex, inComponent: 1, animated: true)
        }
    }
}
