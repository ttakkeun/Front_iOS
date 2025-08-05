//
//  DateComponentsPicker.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/4/25.
//
import SwiftUI

/// 날짜 선택 피커
struct DateComponentsPicker<T: Hashable>: View {
    // MARK: - Property
    let title: String
    @Binding var selection: T
    let values: [T]
    let display: (T) -> String
    
    var body: some View {
        Picker(title, selection: $selection) {
            ForEach(values, id: \.self) { value in
                Text(display(value))
                    .font(.Body4_medium)
                    .foregroundStyle(Color.gray900)
                    .tag(value)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .frame(maxWidth: .infinity)
    }
}
