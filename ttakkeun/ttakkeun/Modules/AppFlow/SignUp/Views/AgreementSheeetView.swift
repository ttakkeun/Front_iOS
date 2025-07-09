//
//  AgreementSheeetView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/30/24.
//

import SwiftUI

/// 회원 가입 시 동의 항목 뷰
struct AgreementSheeetView: View {
    
    // MARK: - Property
    var agreement: AgreementData
    
    
    // MARK: - Constants
    fileprivate enum AgreementSheetConstants {
        static let sectionVspacing: CGFloat = 10
        static let contentsVspacing: CGFloat = 15
        
        static let safeTopPdding: CGFloat = 30
        static let sectionBottomPadding: CGFloat = 10
        static let sectionHorizonPadding: CGFloat = 20
    }
    
    // MARK: - Init
    init(agreement: AgreementData) {
        self.agreement = agreement
    }
    
    
    // MARK: - Body
    var body: some View {
        ScrollView(.vertical, content: {
            VStack(spacing: AgreementSheetConstants.contentsVspacing, content: {
                titleText
                contentText
            })
        })
        .contentMargins(.top, AgreementSheetConstants.safeTopPdding, for: .scrollContent)
    }
    
    private var titleText: some View {
        Text(agreement.title)
            .font(.headline)
    }
    
    private var contentText: some View {
        VStack(alignment: .leading, spacing: AgreementSheetConstants.contentsVspacing, content: {
            ForEach(agreement.detailText, id: \.section) { section in
                sectionContents(section: section)
            }
        })
        .contentMargins(.bottom, AgreementSheetConstants.sectionBottomPadding, for: .scrollContent)
    }
    
    private func sectionContents(section: SectionData) -> some View {
        VStack(alignment: .leading, spacing: AgreementSheetConstants.sectionVspacing, content: {
            Text(section.section)
                .font(.Body2_bold)
                .foregroundStyle(Color.gray900)
            
            let paragraphs = section.text.components(separatedBy: "\n")
            ForEach(paragraphs, id: \.self) { paragraph in
                Text(paragraph)
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray900)
            }
        })
        .padding(.bottom, AgreementSheetConstants.sectionBottomPadding)
        .padding(.horizontal, AgreementSheetConstants.sectionHorizonPadding)
    }
}

