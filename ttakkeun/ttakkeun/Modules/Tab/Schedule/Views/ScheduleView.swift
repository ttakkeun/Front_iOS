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
    @FocusState var isFocused: Bool
    
    // MARK: - Constants
    fileprivate enum ScheduleConstants {
        static let contentsVspacing: CGFloat = 32
        static let middleVspacing: CGFloat = 9
        static let bottomVspacing: CGFloat = 10
        static let bottomTitleHspacing: CGFloat = 2
        
        static let percentContentsPadding: EdgeInsets = .init(top: 12, leading: 16, bottom: 12, trailing: 16)
        static let cornerRadius: CGFloat = 20
        
        static let todoListText: String = "Todo List"
        static let bottomTitle: String = "일정 완수율"
        static let bottomSubTitle: String = "(현재 월 기준)"
        static let bottomProgressTitle: String = "투두 완수율 데이터를 가져오지 못했습니다."
    }
    
    // MARK: - Init
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
        self.calendarViewModel = .init(month: .now, calendar: .current, container: container)
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, content: {
            VStack(alignment: .center, spacing: ScheduleConstants.contentsVspacing, content: {
                CalendarComponent(viewModel: calendarViewModel)
                middleContents
                bottomContents
            })
        })
        .background(Color.scheduleBg)
        .contentMargins(.horizontal, UIConstants.defaultSafeHorizon, for: .scrollContent)
        .contentMargins(.bottom, UIConstants.defaultSafeBottom, for: .scrollContent)
        .safeAreaInset(edge: .top, content: {
            topStatus
        })
        .keyboardToolbar {
            isFocused = false
        }
//        .task {
//            viewModel.getCompletionData()
//        }
    }
    
    // MARK: - TopContents
    /// 상단 로고 및 옵션 바
    private var topStatus: some View {
        TopStatusBar()
            .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
    }
    
    // MARK: - MiddleContents
    /// 중간 투두 리스트
    @ViewBuilder
    private var middleContents: some View {
        VStack(alignment: .leading, spacing: ScheduleConstants.middleVspacing, content: {
            Text(ScheduleConstants.todoListText)
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            ForEach(PartItem.allCases, id: \.self) { part in
                TodoCard(partItem: part, container: container, calendarViewModel: calendarViewModel)
                    .focused($isFocused)
            }
        })
    }
    
    // MARK: - BottomContents
    /// 하단 컨텐츠
    private var bottomContents: some View {
        VStack(alignment: .leading, spacing: ScheduleConstants.bottomVspacing, content: {
            bottomTitle
            bottomPercentContents
        })
    }
    
    /// 하단 퍼센트 타이틀 부분
    private var bottomTitle: some View {
        HStack(alignment: .bottom, spacing: ScheduleConstants.bottomTitleHspacing, content: {
            Text(ScheduleConstants.bottomTitle)
                .font(.H4_bold)
            Text(ScheduleConstants.bottomSubTitle)
                .font(.Body5_medium)
        })
        .foregroundStyle(Color.gray900)
    }
    
    /// 데이터 받아오지 못했을 경우 프로그레스
    @ViewBuilder
    private var notExistBottomContents: some View {
        Spacer()
        
        ProgressView(label: {
            Text(ScheduleConstants.bottomProgressTitle)
                .font(.Body4_medium)
                .foregroundStyle(Color.gray900)
        })
        .controlSize(.mini)
        
        Spacer()
    }
    
    /// 하단 영역
    private var bottomPercentContents: some View {
        HStack(alignment: .center, content: {
            if !viewModel.isLoading {
                if let data = viewModel.completionData {
                    ForEach(PartItem.allCases, id: \.self) { part in
                        TodoCompletionRate(data: data, partItem: part)
                        
                        if part != .teeth {
                            Spacer()
                        }
                    }
                } else {
                    notExistBottomContents
                }
            }
        })
        .padding(ScheduleConstants.percentContentsPadding)
        .background {
            RoundedRectangle(cornerRadius: ScheduleConstants.cornerRadius)
                .fill(Color.white)
                .stroke(Color.gray200, style: .init())
        }
    }
}

#Preview {
    ScheduleView(container: DIContainer())
        .environmentObject(DIContainer())
}
