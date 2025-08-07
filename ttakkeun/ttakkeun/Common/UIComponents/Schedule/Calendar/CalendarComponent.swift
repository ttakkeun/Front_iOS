//
//  DiaryView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/20/24.
//

import SwiftUI

/// 상단 캘린더 뷰
struct CalendarComponent: View {
    
    // MARK: - Property
    @Bindable var viewModel: CalendarViewModel
    
    // MARK: - Constants
    fileprivate enum CalendarConstants {
        static let diaryControllerHspacing: CGFloat = 5
        static let changeMonthArrowHspacing: CGFloat = 24
        static let calendarTextPadding: CGFloat = 5
        static let calendarPadding: EdgeInsets = .init(top: 15, leading: 22, bottom: 10, trailing: 21)
        static let changeMonthPadding: EdgeInsets = .init(top: 11, leading: 13, bottom: 11, trailing: 13)
        
        static let calendarFrameSize: CGSize = .init(width: 306, height: 280)
        static let calendarClearSize: CGSize = .init(width: 36, height: 36)
        static let calendarArrowSize: CGSize = .init(width: 12, height: 12)
        static let topContentsSize: CGSize = .init(width: 306, height: 34)
        static let changeMonthSize: CGSize = .init(width: 7, height: 12)
        static let lazyVgridSize: CGSize = .init(width: 306, height: 280)
        
        static let chevronLeft: String = "chevron.left"
        static let chevronRight: String = "chevron.right"
        
        static let sheetFraction: CGFloat = 0.5
        static let sheetHeight: CGFloat = 300
        static let cornerRadius: CGFloat = 20
        static let columnsCount = 7
        static let lazyVgridSpacing: CGFloat = 7
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, content: {
            topContents
            middleContents
        })
        .padding(CalendarConstants.calendarPadding)
        .background {
            RoundedRectangle(cornerRadius: CalendarConstants.cornerRadius)
                .fill(Color.primarycolor500)
        }
        .sheet(isPresented: $viewModel.showDatePickerView, content: {
            DatePickerSheetView(selectedDate: $viewModel.selectedDate, showDatePickerView: $viewModel.showDatePickerView)
                .presentationDetents([.height(CalendarConstants.sheetHeight)])
                .presentationCornerRadius(UIConstants.sheetCornerRadius)
        })
    }
    
    // MARK: - TopContents
    /// 다이어리 상단 날짜 지정
    private var topContents: some View {
        HStack(alignment: .center, content: {
            diaryController
            Spacer()
            changeMonthArrow
        })
        .frame(width: CalendarConstants.topContentsSize.width, height: CalendarConstants.topContentsSize.height)
    }
    
    /// 캘린더 날짜 조정 버튼
    private var diaryController: some View {
        Button(action: {
            viewModel.showDatePickerView.toggle()
        }, label: {
            HStack(spacing: CalendarConstants.diaryControllerHspacing, content: {
                Text(viewModel.month, formatter: DateFormatter.monthFormatter)
                    .font(.H4_semibold)
                    .foregroundStyle(Color.gray900)
                
                Image(.downArrow)
                    .fixedSize()
            })
            .frame(maxWidth: .infinity, alignment: .leading)
        })
    }
    
    /// 상단 오른쪽 날짜 조정 버튼
    private var changeMonthArrow: some View {
        HStack(alignment: .center, spacing: CalendarConstants.changeMonthArrowHspacing, content: {
            changeMonthValue(monthBy: -1, image: CalendarConstants.chevronLeft)
            changeMonthValue(monthBy: 1, image: CalendarConstants.chevronRight)
        })
    }
    
    /// 상단 달 증가 감소 버튼
    /// - Parameters:
    ///   - monthBy: 증가 및 감소 값
    ///   - image: 이미지 버튼
    /// - Returns: 버튼 뷰 반환
    func changeMonthValue(monthBy: Int, image: String) -> some View {
        Button(action: {
            viewModel.changeMonth(by: monthBy)
        }, label: {
            Image(systemName: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: CalendarConstants.calendarArrowSize.width, height: CalendarConstants.calendarArrowSize.height)
                .padding(CalendarConstants.changeMonthPadding)
                .foregroundStyle(Color.gray900)
                .fontWeight(.bold)
        })
    }
    
    // MARK: - MiddleContents
    /// 달력 내부 일주일 표시 및 일 표시
    @ViewBuilder
    private var middleContents: some View {
        let dates = viewModel.generateMonthDates()
        let weekDaySymbols = viewModel.calendar.shortStandaloneWeekdaySymbols
        let columns = Array(repeating: GridItem(.flexible()), count: CalendarConstants.columnsCount)
        
        LazyVGrid(columns: columns, spacing: CalendarConstants.lazyVgridSpacing, content: {
            ForEach(weekDaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray900)
                    .padding(CalendarConstants.calendarTextPadding)
            }
            
            ForEach(dates.indices, id: \.self) { index in
                if let date = dates[index] {
                    let isSelectedDate = viewModel.calendar.isDate(date, inSameDayAs: viewModel.selectedDate)
                    CalendarCell(viewModel: viewModel, date: date, isSelected: isSelectedDate)
                } else {
                    Color.clear
                        .frame(width: CalendarConstants.calendarClearSize.width, height: CalendarConstants.calendarClearSize.height)
                }
            }
        })
        .frame(width: CalendarConstants.lazyVgridSize.width, height: CalendarConstants.lazyVgridSize.height, alignment: .top)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    CalendarComponent(viewModel: .init(month: .now, calendar: .current, container: DIContainer()))
}
