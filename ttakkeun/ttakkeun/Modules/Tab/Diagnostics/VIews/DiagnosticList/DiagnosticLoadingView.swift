//
//  DiagnosingView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/19/24.
//

import SwiftUI

/// 진단 중 화면
struct DiagnosticLoadingView: View {
    
    // MARK: - Constants
    fileprivate enum DiagnosingConstants {
        static let mainVspacing: CGFloat = 24
        static let logoWidth: CGFloat = 257
        static let logoHeight: CGFloat = 168
        static let contentsSpacer: CGFloat = 120
        static let loadingText: String = "AI가 데이터를 분석 중입니다... \n잠시만 기다려주세요!"
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top, content: {
           viewBg
            mainContents
        })
    }
    
    /// 메인 백그라운드
    private var viewBg: some View {
        Image(.diagnosingBg)
            .resizable()
            .frame(maxWidth: .infinity, alignment: .top)
            .frame(height: getScreenSize().height * 0.8)
            .ignoresSafeArea()
    }
    
    /// 로딩 메인 컨텐츠
    private var mainContents: some View {
        VStack(alignment: .center, spacing: DiagnosingConstants.mainVspacing, content: {
            Spacer().frame(height: DiagnosingConstants.contentsSpacer)
            ProgressView(label: {
                LoadingDotsText(
                    text: DiagnosingConstants.loadingText,
                    color: .gray900
                )
            })
            
            Image(.bubbleLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: DiagnosingConstants.logoWidth, height: DiagnosingConstants.logoHeight)
            Spacer()
        })
    }
}

struct DiagnosingView_Preview: PreviewProvider {
    static var previews: some View {
        DiagnosticLoadingView()
    }
}
