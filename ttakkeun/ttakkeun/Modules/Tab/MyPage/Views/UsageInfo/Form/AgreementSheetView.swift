//
//  AgreementSheetView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/18/24.
//

import SwiftUI

/// 문의하기 및 신고하기 작성 시 이용 약관 체크 뷰
struct AgreementSheetView: View {
    
    // MARK: - Property
    var agreement: AgreementData
    
    // MARK: - Constants
    fileprivate enum AgreementSheetConstants {
        static let contentsVspacing: CGFloat = 35
        static let middleVspacing: CGFloat = 25
        static let sectionVspacing: CGFloat = 15
        static let sectionContentsVspacing: CGFloat = 10
        static let safeTopPadding: CGFloat = 10
        static let naviTitle: String = "이용약관"
    }
    
    // MARK: - Init
    init(agreement: AgreementData = AgreementDetailData.loadEmailAgreements()) {
        self.agreement = agreement
    }

    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: AgreementSheetConstants.contentsVspacing, content: {
            topContents
            middleContents
            
            Spacer()
        })
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
        .safeAreaInset(edge: .top, spacing: UIConstants.capsuleSpacing, content: {
            Capsule()
                .modifier(CapsuleModifier())
        })
        .safeAreaPadding(.top, UIConstants.defaultSafeTop)
    }
    
    // MARK: - TopContents
    /// 상단 타이틀
    private var topContents: some View {
        Text(AgreementSheetConstants.naviTitle)
            .font(.H3_bold)
            .foregroundStyle(Color.gray900)
    }
    
    // MARK: - MiddleContents
    /// 약관 내용 + 약관 제목
    private var middleContents: some View {
        VStack(alignment: .leading, spacing: AgreementSheetConstants.middleVspacing, content: {
            middleTopTitle
            middleSection
        })
    }
    
    /// 약관 내용 타이틀
    private var middleTopTitle: some View {
        Text(agreement.title)
            .font(.H4_bold)
            .foregroundStyle(Color.gray900)
    }
    
    /// 중간 섹션 모음
    private var middleSection: some View {
        VStack(alignment: .leading, spacing: AgreementSheetConstants.sectionVspacing) {
            ForEach(agreement.detailText, id: \.section) { section in
                middleSectionContents(section: section)
            }
        }
    }
    
    private func middleSectionContents(section: SectionData) -> some View {
        VStack(alignment: .leading, spacing: AgreementSheetConstants.sectionContentsVspacing) {
            Text(section.section)
                .font(.Body4_medium)
                .foregroundStyle(Color.gray900)
            
            // \n을 기준으로 단락 나누기
            let paragraphs = section.text.components(separatedBy: "\n")
            ForEach(paragraphs, id: \.self) { paragraph in
                if !paragraph.isEmpty {
                    Text(paragraph)
                        .font(.Body4_medium)
                        .foregroundStyle(Color.gray900)
                }
            }
        }
    }
}

#Preview {
    AgreementSheetView()
}
