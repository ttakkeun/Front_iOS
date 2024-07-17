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
    private let weekdaySymbols = Calendar.current.veryShortWeekdaySymbols
    
    //MARK: - 컴포넌트
    var body: some View {
        VStack {
            Spacer().frame(height: 10)
            headerView
            Spacer().frame(height: 6)
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
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $viewModel.month,
                    displayedComponents: [.date]
                )
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                
                Button("Select") {
                    isPickerPresented = false
                }
                .padding()
            }
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
        let currentWeek = viewModel.getCurrentWeek()
        
        return VStack(alignment: .center, spacing: 3, content: {
            HStack {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.system(size: 11))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 5)
                }
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 2) {
                ForEach(0..<dates.count, id: \.self) { index in
                    if let date = dates[index] {
                        let day = Calendar.current.component(.day, from: date)
                        let isSelected = Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate)
                        
                        if viewModel.showCurrentWeekBar, currentWeek.contains(date) {
                            CellView(day: day, isSelected: isSelected)
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(5)
                                .onTapGesture {
                                    viewModel.toggleDate(date)
                                    printDate(date)
                                }
                        } else {
                            CellView(day: day, isSelected: isSelected)
                                .onTapGesture {
                                    viewModel.toggleDate(date)
                                    printDate(date)
                                }
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.clear)
                            .frame(height: 40)
                    }
                }
            }
        })
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
