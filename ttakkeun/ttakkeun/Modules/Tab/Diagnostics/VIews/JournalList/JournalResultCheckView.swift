//
//  JournalResultCheckView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/18/24.
//

import SwiftUI

/// 일지 생성 시 작성한 질문과 답변 서버 전송 후, 전달 받는 뷰
struct JournalResultCheckView: View {
    
    // MARK: - Property
    let recordResultResponse: RecordResultResponse
    
    // MARK: - Constants
    fileprivate enum JournalResultConstants {
        static let textEditorHeight: CGFloat = 200
        static let etcVspacing: CGFloat = 16
        static let middleVspacing: CGFloat = 38
        static let answerBoxVspacing: CGFloat = 32
        static let topSafePadding: CGFloat = 10
        static let journalHspacing: CGFloat = 2
        
        static let maxTextCount: Int = 150
        static let titleText: String = "일지 체크리스트"
        static let etcBoxTitle: String = "4. 기타 특이사항이 있으면 알려주세요!"
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: JournalResultConstants.middleVspacing, content: {
            topTitle(data: (recordResultResponse.date, recordResultResponse.time))
            
            journalResultContents(data: journalResultResponse)
        })
        .safeAreaInset(edge: .top, spacing: UIConstants.capsuleSpacing, content: {
            Capsule()
                .modifier(CapsuleModifier())
        })
        .safeAreaPadding(.top, JournalResultConstants.topSafePadding)
    }
}

extension JournalResultCheckView {
    
    /// 상단 타이틀 시간 표시 + 날짜 표시
    /// - Parameter data: 날짜 데이터와 시간 데이터
    /// - Returns: 타이틀 뷰 반환
    func topTitle(data: (String, String)) -> some View {
        VStack(spacing: .zero, content: {
            makeTitle()
            
            makeTimeAndData(data.0, data.1)
        })
    }
    
    /// 상단 이미지 표시 타이틀
    /// - Returns: 이미지 표시 타이틀
    func makeTitle() -> some View {
        return HStack(spacing: JournalResultConstants.journalHspacing, content: {
            Image(.leftCat)
                .fixedSize()
            
            Text(JournalResultConstants.titleText)
                .font(.H2_bold)
                .foregroundStyle(Color.gray900)
            
            Image(.rightDog)
                .fixedSize()
        })
    }
    
    /// 날짜 + 시간 데이터 반환
    /// - Parameters:
    ///   - date: 날짜 데이터
    ///   - time: 시간 데이터
    /// - Returns: 뷰 반환
    func makeTimeAndData(_ date: String, _ time: String) -> some View {
        (
            Text(date.formattedDate())
                .font(.Body3_bold)
                .foregroundStyle(Color.gray400)
            
            +
            
            Text(date.formattedDate())
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
        )
    }
    
    /// 기타 특이사항 박스
    /// - Parameter text: 특이사항 내부 텍스트
    /// - Returns: 뷰 반환
    func makeJournalEtcTextBox(text: String) -> some View {
        return VStack(alignment: .leading, spacing: JournalResultConstants.etcVspacing, content: {
            Text(JournalResultConstants.etcBoxTitle)
                .font(.Body1_bold)
                .foregroundStyle(Color.gray900)
                .lineLimit(nil)
            
            TextEditor(text: .constant(text))
                .customStyleEditor(text: .constant(text), placeholder: "", maxTextCount: JournalResultConstants.maxTextCount)
                .disabled(true)
                .frame(height: JournalResultConstants.textEditorHeight)
        })
        .modifier(JournalResultBoxModifier())
        
    }
    
    func journalResultContents(data: RecordResultResponse) -> some View {
        ScrollView(.vertical, content: {
            VStack(spacing: JournalResultConstants.answerBoxVspacing, content: {
                ForEach(data.qnaList.indices, id: \.self) { index in
                    JournalAnswerResult(data: data.qnaList[index], index: index)
                }
                
                if let text = data.etcString {
                    makeJournalEtcTextBox(text: text)
                }
            })
        })
        .contentMargins(.horizontal, UIConstants.horizonScrollBottomPadding, for: .scrollContent)
    }
}
