//
//  ScheduleView.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/11/24.
//

import SwiftUI

struct ScheduleView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 25, content: {
                TopStatusBar()
                
                CustomDiary(viewModel: CustomDiaryViewModel(month: Date(), calendar: Calendar.current))
                
                todoList
                
                todoCompleteRate
            })
            .padding(.bottom, 80)
        }
    }
    
    ///Todo List
    private var todoList: some View {
        VStack(alignment: .leading, spacing: 9, content: {
            Text("Todo List")
                .font(.H4_bold)
                .foregroundStyle(Color.gray_900)
            
            ForEach(PartItem.allCases, id: \.self) { part in
                TodoCard(partItem: part)
            }
        })
    }
    
    ///일정 완수율
    private var todoCompleteRate: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            HStack(alignment: .bottom, spacing: 2, content: {
                Text("일정 완수율")
                    .font(.H4_bold)
                    .foregroundStyle(Color.gray_900)
                
                Text("(현재 월 기준)")
                    .font(.Body5_medium)
                    .foregroundStyle(Color.gray_900)
                    .padding(.bottom, 1)
            })
            
            HStack(alignment: .center, spacing: 4, content: {
                //TODO: currentInt(현재 완료한 투두 개수), totalInt(전체 투두 개수) 넣어줘야함
                ForEach(PartItem.allCases, id: \.self) { part in
                    TodoCompleteEach(data: TodoCompleteData(partType: part, currentInt: 5, totalInt: 10))
                }
            })
            .frame(width: 350, height: 123)
            .padding(.vertical, 5)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.clear)
                    .stroke(Color.gray_200)
            )
        })
        
    }
}

#Preview {
    ScheduleView()
}
