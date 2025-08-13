//
//  TermsView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/16/24.
//

import SwiftUI

/// 이용 약관 및 정책 뷰
struct PrivacyDetailView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    let selectedAgreement: AgreementData
    
    // MARK: - Constants
    fileprivate enum PrivacyDetailConstants {
        static let contentsVspacing: CGFloat = 15
        static let sectionDataVspacing: CGFloat = 10
        static let naviTitle: String = "이용 약관"
        static let closeBtn: String = "chevron.left"
    }
    
    // MARK: - Init
    init(selectedAgreement: AgreementData) {
        self.selectedAgreement = selectedAgreement
    }
    
    // MARK: - Body
    var body: some View {
        Section(content: {
            contents
                .navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .safeAreaPadding(.top, UIConstants.topScrollPadding)
                .customNavigation(title: PrivacyDetailConstants.naviTitle, leadingAction: {
                    container.navigationRouter.pop()
                }, naviIcon: Image(systemName: PrivacyDetailConstants.closeBtn))
        }, header: {
            title
        })
        .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
    }
    
    // MARK: - TopContents
    /// 상단 타이틀(헤더)
    private var title: some View {
        Text(selectedAgreement.title)
            .font(.H4_bold)
            .foregroundStyle(Color.gray900)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    /// 중간 컨텐츠
    private var contents: some View {
        ScrollView(.vertical, content: {
            VStack(alignment: .leading, spacing: PrivacyDetailConstants.contentsVspacing) {
                ForEach(selectedAgreement.detailText, id: \.section) { section in
                    sectionDatas(section)
                }
            }
        })
    }
    
    /// 내부 섹션 데이터 내용
    /// - Parameter section: 섹션 부분
    /// - Returns: 섹션 별 내용 뷰 반환
    private func sectionDatas(_ section: SectionData) -> some View {
        VStack(alignment: .leading, spacing: PrivacyDetailConstants.sectionDataVspacing) {
            Text(section.section)
                .font(.Body4_semibold)
                .foregroundStyle(Color.gray900)
                .underline()
            
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
    @Previewable var data = AgreementDetailData.loadAgreements()[0]
    
    PrivacyDetailView(selectedAgreement: data)
        .environmentObject(DIContainer())
}
