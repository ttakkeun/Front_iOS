//
//  ScheduleView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import SwiftUI

struct ScheduleView: View {
    
    @StateObject var completionViewModel: TodoCompletionViewModel
    @StateObject var calendarViewModel: CalendarViewModel
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appflowViewModel: AppFlowViewModel
    
    init(container: DIContainer) {
        self._completionViewModel = .init(wrappedValue: .init(container: container))
        self._calendarViewModel = StateObject(wrappedValue: .init(month: Date(), calendar: Calendar.current, container: container))
    }
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            TopStatusBar()
                .environmentObject(container)
            
            ScrollView(.vertical, content: {
                VStack(alignment: .center, spacing: 24, content: {
                    
                    CalendarView(viewModel: calendarViewModel)
                    
                    Spacer().frame(height: 3)
                    
                    todoList
                    
                    todoCompletionRate
                })
                .padding(.top, 5)
                .padding(.bottom, 110)
            })
        })
        .background(Color.scheduleBg)
        .task {
            completionViewModel.getCompletionData()
        }
    }
    
    private var todoList: some View {
        VStack(alignment: .leading, spacing: 9, content: {
            Text("Todo List")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            ForEach(PartItem.allCases, id: \.self) { part in
                TodoCard(partItem: part, container: container)
                    .environmentObject(calendarViewModel)
            }
        })
    }
    
    private var todoCompletionRate: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Group {
                HStack(alignment: .bottom, spacing: 2, content: {
                    Text("일정 완수율")
                        .font(.H4_bold)
                    Text("(현재 월 기준)")
                        .font(.Body5_medium)
                        .padding(.bottom, 1)
                })
            }
            .foregroundStyle(Color.gray900)
            
            HStack(alignment: .center, spacing: 4, content: {
                if !completionViewModel.isLoading {
                    if let data = completionViewModel.completionData {
                        ForEach(PartItem.allCases, id: \.self) { part in
                            TodoCompletionRate(data: data)
                        }
                    } else {
                        Spacer()
                        
                        ProgressView(label: {
                            Text("투두 완수율 데이터를 가져오지 못했습니다.")
                                .font(.Body4_medium)
                                .foregroundStyle(Color.gray900)
                        })
                        .controlSize(.mini)
                        
                        Spacer()
                    }
                } else {
                    Spacer()
                    
                    ProgressView(label: {
                        LoadingDotsText(text: "투두 완수율 데이터를 가져오는 중입니다")
                    })
                    
                    Spacer()
                }
            })
            .frame(width: 318, height: 99)
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .stroke(Color.gray200, lineWidth: 1)
            }
        })
    }
}
