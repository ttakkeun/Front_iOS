//
//  CheckQuestionAnswer.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/17/24.
//

import SwiftUI

/// 일지 생성 시 작성한 질문과 답변 서버 전송 후 전달 받는 뷰
struct CheckQnAView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let data: CheckJournalQnAResponseData
    
    init(
        data: CheckJournalQnAResponseData
    ) {
        self.data = data
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack(alignment: .center, spacing: 38, content: {
                CustomNavigation(
                    action: {
                        dismiss()
                    },
                    title: nil,
                    currentPage: nil,
                    naviIcon: Image("close"),
                    width: 14,
                    height: 14
                )
                topTtitle
                
                qnaContents

            })
            .padding(.bottom, 60)
        })
    }
    
    // MARK: - top Title
    
    /// 제목과 날짜 시간 타이틀 그룹
    private var topTtitle: VStack<some View> {
        return VStack(spacing: 3, content: {
            title
            
            timeAndDate
        })
    }
    
    /// 일지 체크 제목
    private var title: HStack<some View> {
        return HStack(spacing: 2, content: {
            Icon.leftCat.image
                .fixedSize()
            
            Text("일지 체크리스트")
                .font(.H2_bold)
                .foregroundStyle(Color.gray_900)
            
            
            Icon.rightDog.image
                .fixedSize()
        })
    }
    
    /// 일지 체크 상단 날짜와 시간
    private var timeAndDate: HStack<some View> {
        return HStack(spacing: 3, content: {
            Text(dateFormatted)
                .font(.Body3_bold)
                .foregroundStyle(Color.gray_400)
            
            Text(timeFormatted)
                .font(.Body4_medium)
                .foregroundStyle(Color.gray_400)
        })
    }
    
    /// 일지 체크 조회 시 기타 특이사항 텍스트 에디터 뷰
    /// - Parameter text: API로 받아온 파라미터
    /// - Returns: 기타 특이사항 텍스트 에디터 뷰
    @ViewBuilder
    private func etcStringView(text: String) -> some View {
            VStack(alignment: .leading, spacing: 16, content: {
                Text("4. 기타 특이사항이 있으면 알려주세요")
                    .font(.Body1_bold)
                    .foregroundStyle(Color.gray_900)
                TextEditor(text: .constant(text))
                    .customStyleEditor(placeholder: "", text: .constant(text))
                    .frame(width: 314, height: 124)
                    .disabled(true)
            })
            .padding(.horizontal, 15)
            .padding(.bottom, 25)
            .padding(.top, 15)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.clear)
                    .stroke(Color.gray_200, lineWidth: 1)
            )
        }
    
    // MARK: - bottomContents
    
    /// qna 카드 리스트
    private var qnaContents: some View {
        VStack(spacing: 32, content: {
            ForEach(data.qnaList.indices, id: \.self) { index in
                CheckQnAComponent(data: data.qnaList[index], dataIndex: index)
            }
            
            
            if let text = data.etcString {
                etcStringView(text: text)
            }
            
            
        })
    }
    
    /// 날짜 데이터 파싱
    private var dateFormatted: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy.MM.dd"
        
        guard let date = inputFormatter.date(from: data.date) else {
            return data.date
        }
        
        return outputFormatter.string(from: date)
    }
    
    /// 시간 데이터 파일
    private var timeFormatted: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm:ss"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"
        
        guard let date = inputFormatter.date(from: data.time) else {
            return data.time
        }
        
        return outputFormatter.string(from: date)
    }
}
