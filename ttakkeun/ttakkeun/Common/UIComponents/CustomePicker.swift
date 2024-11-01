//
//  CustomePicker.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/1/24.
//

import SwiftUI

struct CustomPicker: View {
    
    @Binding var selectedValue: Int?
    let title: String
    let range: [Int?]
    let updateAction: () -> Void
    
    var body: some View {
        Picker(selection: Binding(
            get: { selectedValue },
            set: {
                selectedValue = $0
                updateAction()
            }), content: {
                Text(title).tag(nil as Int?)
                ForEach(range, id: \.self) { value in
                    if let value = value {
                        let formattedValue = title == "연도" ? (DataFormatter.shared.yearFormatter().string(from: NSNumber(value: value)) ?? "\(value)") : "\(value)"
                        Text("\(formattedValue)\(title == "연도" ? "년" : title == "월" ? "월" : "일")").tag(value)
                    } else {
                        Text(title).tag(nil as Int?)
                    }
                }
            }, label: {
                Text(title)
                    .multilineTextAlignment(.center)
            })
        .pickerStyle(MenuPickerStyle())
        .frame(width: 110, height: 44)
        .tint(.clear)
        .overlay(content: {
            Text(selectedValue == nil ? title : "\(title == "연도" ? (DataFormatter.shared.yearFormatter().string(from: NSNumber(value: selectedValue!)) ?? "\(selectedValue!)") : "\(selectedValue!)")\(title == "연도" ? "년" : title == "월" ? "월" : "일")")
                .foregroundStyle(Color.gray400)
                .font(.Body3_medium)
                .frame(width: 110, height: 44)

        })
    }
}
