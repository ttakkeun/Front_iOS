//
//  CustomDiary.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/13/24.
//

import SwiftUI

struct CustomDiary: View {
    @StateObject var viewModel: CustomDiaryViewModel
    @State private var isPickerPresented = false
    
    //MARK: - 변수
    /// 년월 dateFormatter
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    ///요일 심볼(S,M,T,W,T,F,S)
    private let weekdaySymbols = Calendar.current.shortStandaloneWeekdaySymbols
    
    //MARK: - 컴포넌트
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            headerView
                .padding(.horizontal,23)
            calendarGridView
                .padding(.horizontal,23)
        }
        .frame(maxWidth: 350, maxHeight: 296)
        .background(Color.primarycolor_400)
        .clipShape(.rect(cornerRadius:20))
    }
    
    /// 헤더 -> 년월 + 화살표
    private var headerView: some View {
        HStack(spacing: 45) {
            Button(action: {
                isPickerPresented.toggle()
            }) {
                HStack {
                    Text(viewModel.month, formatter: dateFormatter)
                        .font(.suit(type: .semibold, size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                    Image("downArrow")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
                .frame(maxWidth: 160, alignment: .leading)
            }
            
            changeMonthArrow
        }
        .frame(width: 306, height: 34)
        .sheet(isPresented: $isPickerPresented) {
            DiarySelectSheet(selectedDate: $viewModel.month)
                .presentationDetents([.fraction(0.3)])
        }
    }
    
    ///화살표
    private var changeMonthArrow: some View {
        HStack(alignment: .center, spacing: 24, content: {
            changeMonthArrow(monthBy: -1, name: "chevron.left")
            changeMonthArrow(monthBy: 1, name: "chevron.right")
        })
    }
    
    ///달력 일자 표시
    private var calendarGridView: some View {
        let dates = viewModel.generateMonthDates()
        //TODO: - 주차 막대 표시하기 위해 필요한 변수, 추가 필요
//        let currentWeek = viewModel.getCurrentWeek()
        let cellWidth: CGFloat = 36
        let cellHeight: CGFloat = 36

        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 0, maximum: 36)), count: 7), spacing: 3) {
            /* Grid로 요일과 날짜 모두 출력 */
            /* 요일 출력 */
            ForEach(weekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.suit(type: .medium, size: 14))
                    .foregroundStyle(Color.gray_900)
            }
            .padding(.top, 5)
            
            
            
            /* 일자 출력 */
            ForEach(dates.indices, id: \.self) { index in
                let date = dates[index]
                Group {
                    if let date = date {
                        let day = Calendar.current.component(.day, from: date)
                        let isSelected = Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate)
                        
                        ZStack {
                            //TODO: - 주차막대 추가 필요
                            /* 주차 막대 컴포넌트(WeekBar)로 주차막대 만들어서 그 주에 표시해야 함 */
                            CellView(day: day, isSelected: isSelected)
                                .frame(width: cellWidth, height: cellHeight)
                                .onTapGesture {
                                    viewModel.toggleDate(date)
                                    printDate(date)
                                }
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(Color.clear)
                            .frame(width: cellWidth, height: cellHeight)
                    }
                }
            }
        }
        .frame(maxWidth: 307)
        
    }
    // MARK: - Function
    private func changeMonthArrow(monthBy: Int, name: String) -> some View {
        Button(action: {
            viewModel.changeMonth(by: monthBy)
        }) {
            Image(systemName: name)
                .resizable()
                .frame(width: 7, height: 12)
                .padding(.vertical, 11)
                .padding(.horizontal, 13)
                .foregroundStyle(Color.black)
        }
    }

}


// MARK: - Cell Struct

/// 달력 하나(하루)의 셀
fileprivate struct CellView: View {
    var day: Int
    var isSelected: Bool

    init(day: Int, isSelected: Bool) {
        self.day = day
        self.isSelected = isSelected
    }

    var body: some View {
        VStack {
            if isSelected {
                Circle()
                    .fill(Color.primarycolor_700)
                    .frame(width: 36, height: 36)
                    .overlay(Text(String(day))
                        .foregroundColor(Color.gray_900))
                    .font(.suit(type: .medium, size: 14))
            } else {
                Text(String(day))
                    .font(.suit(type: .medium, size: 14))
                    .background(Color.clear)
            }
        }
        .frame(width: 36, height: 36)
    }
}

//MARK: - Preview
struct CustomDiaryComponent_Previews: PreviewProvider {
    static var previews: some View {
        CustomDiary(viewModel: CustomDiaryViewModel(month: Date(), calendar: Calendar.current))
            .previewLayout(.sizeThatFits)
    }
}

//MARK: - Test
///누르면 해당 날짜 출력
private func printDate(_ date: Date) {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    let dateString = formatter.string(from: date)
    print(dateString)
}
