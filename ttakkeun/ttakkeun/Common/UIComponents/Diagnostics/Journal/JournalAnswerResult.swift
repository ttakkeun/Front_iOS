//
//  JournalResultComponents.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/18/24.
//

import SwiftUI
import Kingfisher

/// 일지 선택 시, 선택했던 질문 및 답변 사진
struct JournalAnswerResult: View {
    
    // MARK: - Property
    let data: QnAListData
    let index: Int
    
    // MARK: - Constants
    fileprivate enum JournalAnswerResultConstants {
        static let answerBoxVspacing: CGFloat = 16
        static let answerVspacing: CGFloat = 5
        static let imageHspacing: CGFloat = 10
        static let imageMaxCount: Int = 2
        static let imageInterval: TimeInterval = 2
        static let imageSize: CGFloat = 64
        static let cornerRadius: CGFloat = 10
    }
    
    // MARK: - Init
    init(
        data: QnAListData,
        index: Int
    ) {
        self.data = data
        self.index = index
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: JournalAnswerResultConstants.answerBoxVspacing, content: {
            selectedAnswerTitle
            selectedAnswerList
            selectedAnswerImage
        })
        .modifier(JournalResultBoxModifier())
    }
    
    /// 질문 타이틀
    private var selectedAnswerTitle: some View {
        Text("\(index + 1). \(data.question)")
            .font(.Body1_bold)
            .foregroundStyle(Color.gray900)
            .lineLimit(nil)
    }
    
    /// 질문 체크 사항
    private var selectedAnswerList: some View {
        VStack(alignment: .leading, spacing: JournalAnswerResultConstants.answerVspacing, content: {
            ForEach(data.answer, id: \.self) { answer in
                JournalAnswerButton(isSelected: .constant(true),
                                    paddingValue: [18, 17, 24, 24],
                                    data: AnswerDetailData(answerText: answer))
                .disabled(true)
            }
        })
    }
    
    /// 질문에 해당하는 사진 출력
    @ViewBuilder
    private var selectedAnswerImage: some View {
        if let images = data.image {
            if !images.isEmpty {
                imageScroll(images: images)
            } else {
                EmptyView()
            }
        }
    }
    
    /// 이미지 스크롤 뷰
    /// - Parameter images: 스크롤에 사용할 전체 이미지
    /// - Returns: 이미지 스크롤 반환
    private func imageScroll(images: [String]) -> some View {
        ScrollView(.horizontal, content: {
            LazyHStack(spacing: JournalAnswerResultConstants.imageHspacing, content: {
                ForEach(images, id: \.self) { image in
                    kingfisherImage(url: image)
                }
            })
            .fixedSize()
        })
    }
    
    /// 서버로부터 가져온 이미지
    /// - Parameter url: 이미지 URL 표시
    /// - Returns: 뷰 반황ㄴ
    @ViewBuilder
    private func kingfisherImage(url: String) -> some View {
        if let url = URL(string: url) {
            KFImage(url)
                .placeholder {
                    ProgressView()
                        .controlSize(.regular)
                }.retry(maxCount: JournalAnswerResultConstants.imageMaxCount, interval: .seconds(JournalAnswerResultConstants.imageInterval))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: JournalAnswerResultConstants.imageSize, height: JournalAnswerResultConstants.imageSize)
                .clipShape(RoundedRectangle(cornerRadius: JournalAnswerResultConstants.cornerRadius))
                .overlay(content: {
                    RoundedRectangle(cornerRadius: JournalAnswerResultConstants.cornerRadius)
                        .fill(Color.clear)
                        .stroke(Color.gray200, style: .init())
                })
        }
    }
}

struct JournalAnswerResult_Preview: PreviewProvider {
    static var previews: some View {
        JournalAnswerResult(data: QnAListData(question: "평소보다 털빠짐이 심한가요?", answer: ["털빠짐이 심해요"], image: ["https://i.namu.wiki/i/nArcxgJolP6ou78vPN9eXhPDFqioFJReyeVAhX8JqJhw__Vh-QLXuoGbKRQUlcaFU325TlwfHRw4vMtq1g2yMxzMQ5fSmvvvo3lwZ4kQlEMe5CkFTYoVf4g4gfuKqEd1K8_tLxMDdP1u07jniN1Ibw.webp", "https://i.namu.wiki/i/AAqta2XOGzlv_kLJGyKfVvL2i2nkRGngXI8Oh7a2heu9O4NQA_t9q28pPx2zAojfb_Ehc-SW57Y0xR3TZvDivXnp6KDEtI-Rkpu0aysUaX76giL1Ae9xjHUtNShGGwl9j3NyFRRpGZphzVaE6AzIZw.webp"]), index: 1)
    }
}
