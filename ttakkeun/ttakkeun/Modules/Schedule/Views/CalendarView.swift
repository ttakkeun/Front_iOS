//
//  DiaryView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/20/24.
//

import SwiftUI

struct CalendarView: View {
    
    @StateObject var viewModel: CalendarViewModel
    
    init(container: DIContainer) {
        self._viewModel = StateObject(wrappedValue: .init(month: Date(), calendar: Calendar.current, container: container))
    }
    
    var body: some View {
        VStack(alignment: .leading, content: {
            diaryHeaderTitle
            diaryBody
        })
        .padding(.top, 15)
        .padding(.bottom, 10)
        .padding(.leading, 22)
        .padding(.trailing, 21)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.primarycolor500)
        }
        .sheet(isPresented: $viewModel.showDatePickerView, content: {
            DatePickerSheetView(selectedDate: $viewModel.selectedDate, showDatePickerView: $viewModel.showDatePickerView)
                .presentationDetents([.fraction(0.3)])
                .presentationCornerRadius(30)
        })
    }
    
    // MARK: - DiaryHeaderTitle
    
    private var diaryHeaderTitle: some View {
        HStack(alignment: .center, spacing: 45, content: {
            diaryController
            
            changeMonthArrow
        })
        .frame(width: 306, height: 34)
    }
    
    private var diaryController: some View {
        Button(action: {
            viewModel.showDatePickerView.toggle()
        }, label: {
            HStack(spacing: 5, content: {
                Text(viewModel.month, formatter: DataFormatter.shared.monthFormatter())
                    .font(.H4_semibold)
                    .foregroundStyle(Color.gray900)
                Icon.downArrow.image
                    .resizable()
                    .frame(width: 19, height: 19)
            })
            .frame(maxWidth: 165, alignment: .leading)
        })
    }
    
    private var changeMonthArrow: some View {
        HStack(alignment: .center, spacing: 24, content: {
            changeMonthValue(monthBy: -1, image: "chevron.left")
            changeMonthValue(monthBy: 1, image: "chevron.right")
        })
    }
    
    // MARK: - DiaryBody
    
        private var diaryBody: some View {
            let dates = viewModel.generateMonthDates()
            let weekDaySymbols = viewModel.calendar.shortStandaloneWeekdaySymbols
    
            return LazyVGrid(columns: Array(repeating: GridItem(.fixed(36)), count: 7), spacing: 3, content: {
                ForEach(weekDaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.Body3_medium)
                        .foregroundStyle(Color.gray900)
                        .padding(5)
                }
    
                ForEach(dates.indices, id: \.self) { index in
                        if let date = dates[index] {
                            let isSelectedDate = viewModel.calendar.isDate(date, inSameDayAs: viewModel.selectedDate)
                            CalendarCell(viewModel: viewModel, date: date, isSelected: isSelectedDate)
                        } else {
                            Color.clear
                                .frame(width: 36, height: 36)
                        }
                }
            })
    
            .frame(width: 306)
        }
}

extension CalendarView {
    func changeMonthValue(monthBy: Int, image: String) -> some View {
        Button(action: {
            viewModel.changeMonth(by: monthBy)
        }, label: {
            Image(systemName: image)
                .resizable()
                .frame(width: 7, height: 12)
                .padding(.vertical, 11)
                .padding(.horizontal, 13)
                .foregroundStyle(Color.gray900)
                .fontWeight(.bold)
        })
    }
}
