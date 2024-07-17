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
        VStack {
            Spacer().frame(height: 10)
            headerView
            Spacer().frame(height: 10)
            calendarGridView
            Spacer().frame(height: 15)
        }
        .background(Color.primaryColor_Color)
        .cornerRadius(20)
        .padding()
        .frame(width: 350, height: 319)
            
    }
    
    /// 헤더 -> 년월 + 화살표
    private var headerView: some View {
        HStack {
            Spacer().frame(width: 5)
            Button(action: {
                isPickerPresented.toggle()
            }) {
                HStack {
                    Text(viewModel.month, formatter: dateFormatter)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                    Image("downArrow")
                        .resizable()
                        .frame(width: 16, height: 16)
                }
            }
            Spacer()
            changeMonthArrow
        }
        .padding(.horizontal)
        .sheet(isPresented: $isPickerPresented) {
            DiarySelectSheet(selectedDate: $viewModel.month, isPresented: $isPickerPresented)
                .presentationDetents([.fraction(0.4)])
        }
    }
    
    ///화살표
    private var changeMonthArrow: some View {
        HStack(alignment: .center, spacing: 10, content: {
            Button(action: {
                viewModel.changeMonth(by: -1)
            }) {
                Image(systemName: "chevron.left")
                    .padding()
                    .foregroundStyle(Color.black)
            }
            
            Button(action: {
                viewModel.changeMonth(by: 1)
            }) {
                Image(systemName: "chevron.right")
                    .padding()
                    .foregroundStyle(Color.black)
            }
        })
    }
    
    ///달력 일자 표시
    private var calendarGridView: some View {
        let dates = viewModel.generateMonthDates()
        /* 주차 막대 표시하기 위해 필요한 변수, 주차막대 코드 안 넣어서 경고 뜸*/
        let currentWeek = viewModel.getCurrentWeek()
        let cellWidth: CGFloat = 41
        let cellHeight: CGFloat = 36

        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 0, maximum: 100)), count: 7), spacing: 3) {
            /* Grid로 요일과 날짜 모두 출력 */
            /* 요일 출력 */
            ForEach(weekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.suit(type: .bold, size: 12))
                    .foregroundColor(Color.black)
            }
            /* 일자 출력 */
            ForEach(dates.indices, id: \.self) { index in
                let date = dates[index]
                Group {
                    if let date = date {
                        let day = Calendar.current.component(.day, from: date)
                        let isSelected = Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate)
                        
                        ZStack {
                            CellView(day: day, isSelected: isSelected)
                                .frame(width: cellWidth, height: cellHeight)
                                .onTapGesture {
                                    viewModel.toggleDate(date)
                                    printDate(date)
                                }
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.clear)
                            .frame(width: cellWidth, height: cellHeight)
                    }
                }
            }
        }
        .padding(.horizontal)
    }

}

/// 달력 하나(하루)의 셀
private struct CellView: View {
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
                    .fill(Color.BorderColor_Color)
                    .frame(width: 36, height: 36)
                    .overlay(Text(String(day))
                                .foregroundColor(.black))
                                .font(.system(size: 11))
            } else {
                Text(String(day))
                    .font(.system(size: 11))
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
            .padding()
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
