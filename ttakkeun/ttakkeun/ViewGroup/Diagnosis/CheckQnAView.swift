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
            VStack(alignment: .center, content: {
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
                
                if let text = data.etcString {
                    etcStringView(text: text)
                }
            })
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
        }
    
    // MARK: - bottomContents
    
    /// qna 카드 리스트
    private var qnaContents: some View {
        VStack(spacing: 32, content: {
            ForEach(data.qnaList.indices, id: \.self) { index in
                CheckQnAComponent(data: data.qnaList[index], dataIndex: index)
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

struct CheckQnAView_Preview: PreviewProvider {
    static var previews: some View {
        CheckQnAView(data: CheckJournalQnAResponseData(category: .claw, date: "2024-06-23", time: "10:23", qnaList: [QnAListData(question: "털에 윤기가 잘 나고 있나요?", answer: [AnswerDetailData(answerText: "윤기가 나요")], image: ["https://upload.wikimedia.org/wikipedia/ko/4/4a/신짱구.png", "https://i.namu.wiki/i/hiLIForWFvqDCgVJD7oN0ZqSDlnOtE3AnvfNDVb3oO86cwel7kCRuXp_4AIdrH3xMwUinnRnF4HplO_SRW76PD2Y-wY4poC2FpNhYoZ1bZI_8iBN36sYxgDVEBdTmvf7aCAiUfNZQA-nG4x2yGOFdQ.webp"]), QnAListData(question: "평소보다 털빠짐이 심한가요?", answer: [AnswerDetailData(answerText: "털빠짐이 심해요")], image: nil), QnAListData(question: "집중적으로 핥거나 긁는 부위가 있나요?", answer: [AnswerDetailData(answerText: "해당부위가 있어요")], image: nil)], etcString: "나는 정말로 재밌게 하고 있따."))
    }
}
