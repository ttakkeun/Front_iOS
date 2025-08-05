//
//  ScheduleView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import SwiftUI

struct ScheduleView: View {
    
    // MARK: - Property
    @State var viewModel: ScheduleViewModel
    @State var calendarViewModel: CalendarViewModel
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var appFlowViewModel: AppFlowViewModel
    
    // MARK: - Constants
//    fileprivate enum ScheduleConstants {
//        static let
//    }
    
    // MARK: - Init
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
        self.calendarViewModel = .init(month: .now, calendar: .current, container: container)
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: .zero, content: {
            TopStatusBar()
                .environmentObject(container)
                .environmentObject(appFlowViewModel)
            
            ScrollView(.vertical, content: {
                VStack(alignment: .center, spacing: 24, content: {
                    
                    CalendarComponent(viewModel: calendarViewModel)
                    
                    Spacer().frame(height: 3)
                    
                    todoList
                    
                    todoCompletionRate
                })
                .padding(.top, 5)
                .padding(.bottom, 110)
                .padding(.horizontal, 20)
            })
            .frame(maxWidth: .infinity)
            .ignoresSafeArea(.all)
        })
        .background(Color.scheduleBg)
        .task {
            viewModel.getCompletionData()
        }
    }
    
    
    private var todoList: some View {
        VStack(alignment: .leading, spacing: 9, content: {
            Text("Todo List")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            ForEach(PartItem.allCases, id: \.self) { part in
                TodoCard(partItem: part, container: container)
                    .environment(calendarViewModel)
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
                if !viewModel.isLoading {
                    if let data = viewModel.completionData {
                        ForEach(PartItem.allCases, id: \.self) { part in
                            TodoCompletionRate(data: data, partItem: part)
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
