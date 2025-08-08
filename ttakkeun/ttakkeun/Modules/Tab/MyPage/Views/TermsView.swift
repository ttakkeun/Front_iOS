//
//  TermsView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/16/24.
//

import SwiftUI

/// 이용 약관 및 정책 뷰
struct TermsView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    var selectedAgreement: AgreementData
    
    // MARK: - Init
    init(selectedAgreement: AgreementData) {
        self.selectedAgreement = selectedAgreement
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 35, content: {
            
            CustomNavigation(action: { container.navigationRouter.pop() },
                             title: "이용 약관",
                             currentPage: nil)
            
            ScrollView(.vertical, content: {
                VStack(alignment: .leading, spacing: 17, content: {
                    /// 제목
                    Text(selectedAgreement.title)
                        .font(.H4_bold)
                        .foregroundStyle(Color.gray900)
                        .padding(.leading, 18)
                    
                    /// 내용
                    VStack(alignment: .leading, spacing: 15) {
                        ForEach(selectedAgreement.detailText, id: \.section) { section in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(section.section) // 섹션 제목
                                    .font(.Body4_medium)
                                    .foregroundStyle(Color.gray900)
                                
                                // \n을 기준으로 단락 나누기
                                let paragraphs = section.text.components(separatedBy: "\n")
                                ForEach(paragraphs, id: \.self) { paragraph in
                                    if !paragraph.isEmpty {
                                        Text(paragraph)
                                            .font(.Body4_medium)
                                            .foregroundStyle(Color.gray900)
                                            .padding(.bottom, 5)
                                    }
                                }
                            }
                            .padding(.horizontal, 22)
                            .padding(.bottom, 10)
                        }
                    }
                })
            })
            
        })
        .navigationBarBackButtonHidden(true)
    }
}

//MARK: - Preview
struct TermsView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            let sampleAgreement = AgreementDetailData.loadAgreements()[0]
            
            TermsView(selectedAgreement: sampleAgreement)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(DIContainer())
        }
    }
}
