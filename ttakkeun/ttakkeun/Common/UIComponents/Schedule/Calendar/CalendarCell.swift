//
//  CalendarCell.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import SwiftUI

struct CalendarCell: View {
    
    @Bindable var viewModel: CalendarViewModel
    var date: Date
    var isSelected: Bool
    
    var day: Int {
        return Calendar.current.component(.day, from: date)
    }
   
    init(viewModel: CalendarViewModel, date: Date, isSelected: Bool) {
        self.viewModel = viewModel
        self.date = date
        self.isSelected = isSelected
    }
    
    var body: some View {
        Group {
            if isSelected {
                makeText(day: day)
                    .padding(6)
                    .background {
                        Circle()
                            .fill(Color.primarycolor100)
                            .frame(width: 30, height: 30)
                    }
            } else {
                makeText(day: day)
                    .padding(6)
            }
        }
        .frame(width: 36, height: 36)
        .onTapGesture {
            viewModel.changeSelectedDate(date)
        }
    }
    
    func makeText(day: Int) -> Text {
        return Text(String(day))
            .font(.Body3_regular)
            .foregroundStyle(Color.gray900)
    }
}
