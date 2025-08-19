//
//  DiagnosticResultView.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 7/16/25.
//

import SwiftUI
import Charts

/// 진단 결과 화면
struct DiagnosticResultView: View {
    
    // MARK: - Property
    @Binding var showFullScreenAI: Bool
    @Bindable var viewModel: DiagnosticResultViewModel
    
    // MARK: - Constants
    fileprivate enum DiagnosingResultConstants {
        static let topHspacing: CGFloat = 10
        static let topGraphHspacing: CGFloat = 19
        static let textLineSpacing: CGFloat = 2.5
        static let contentsHorizonPadding: CGFloat = 21
        static let contentsVerticalPadding: CGFloat = 14
        static let middleContentsVspacing: CGFloat = 15
        static let middleVspacing: CGFloat = 22
        
        static let topBgHeight: CGFloat = 255
        static let topLogoWidth: CGFloat = 162
        static let topLogoHeight: CGFloat = 124
        static let graphWidth: CGFloat = 168
        static let graphHeight: CGFloat = 96
        static let btnHeight: CGFloat = 63
        static let middleTextHeight: CGFloat = 100
        
        static let topCornerRadius: CGFloat = 30
        static let cornerRadius: CGFloat = 10
        static let contentsCornerRadius: CGFloat = 20
        static let chartSize: CGFloat = 70
        
        static let spacerMin: CGFloat = 34
        static let chartInnerRadius: CGFloat = 0.7
        static let angularInset: CGFloat = 1
        static let opacity: Double = 0.5
        
        static let graphTitle: String = "총점"
        static let scoreText: String = "Score"
        static let remainingText: String = "Remaining"
        static let diagResultText: String = "진단결과"
        static let followManageText: String = "추후 관리법"
        static let recommendProduct: String = "추천 제품"
        static let btnText: String = "확인"
        static let loadingText: String = "조금만 기다려주세요! \n진단 결과를 준비하고 있어요 😊"
    }
    
    // MARK: - Init
    init (viewModel: DiagnosticResultViewModel, showFullScreenAI: Binding<Bool>, diagId: Int) {
        self.viewModel = viewModel
        self._showFullScreenAI = showFullScreenAI
        viewModel.getDiagResult(diagId: diagId)
    }
    
    // MARK: - Body
    var body: some View {
        if let data = viewModel.diagnosticResolutionData {
            ScrollView(.vertical, content: {
                VStack(content: {
                    topBackground(data: data)
                    Group {
                        middleContents(data: data)
                        Spacer(minLength: DiagnosingResultConstants.spacerMin)
                        MainButton(btnText: DiagnosingResultConstants.btnText, height: DiagnosingResultConstants.btnHeight, action: {
                            showFullScreenAI = false
                        }, color: Color.mainPrimary)
                    }
                    .safeAreaPadding(.horizontal, UIConstants.defaultSafeHorizon)
                })
            })
            .ignoresSafeArea()
        } else {
            LoadingProgress(text: DiagnosingResultConstants.loadingText)
        }
    }
    
    // MARK: - TopContents
    /// 상단 백그라운드 모양
    /// - Parameter data: 진단 데이터
    /// - Returns: 백그라운드 뷰 반환
    func topBackground(data: DiagnoseDetailResponse) -> some View {
        ZStack {
            Image(.diagnosisTopBg)
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: DiagnosingResultConstants.topBgHeight)
            
            HStack(spacing: DiagnosingResultConstants.topHspacing, content: {
                Image(.bubbleLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: DiagnosingResultConstants.topLogoWidth, height: DiagnosingResultConstants.topLogoHeight)
                
                makeResultGraph(data: data)
            })
        }
        .ignoresSafeArea()
    }
    
    /// 상단 그래프
    /// - Parameter data: 진단 데이터
    /// - Returns: 진단 그래프 뷰
    func makeResultGraph(data: DiagnoseDetailResponse) -> some View {
        HStack(alignment: .center, spacing: DiagnosingResultConstants.topGraphHspacing, content: {
            graphTitle
            
            ZStack(alignment: .center, content: {
                chartView(data: data)
                
                Text("\(data.score)")
                    .font(.Body1_semibold)
                    .foregroundStyle(Color.gray900)
            })
        })
        .frame(minWidth: DiagnosingResultConstants.graphWidth)
        .frame(height: DiagnosingResultConstants.graphHeight)
        .background {
            RoundedRectangle(cornerRadius: DiagnosingResultConstants.cornerRadius)
                .fill(Color.white).opacity(DiagnosingResultConstants.opacity)
        }
    }
    
    /// 그래프 타이틀
    private var graphTitle: some View {
        Text(DiagnosingResultConstants.graphTitle)
            .font(.Body2_semibold)
            .foregroundStyle(Color.gray900)
    }
    
    /// 차트 뷰
    /// - Parameter data: 차트 내부 데이터
    /// - Returns: 차트 반환
    private func chartView(data: DiagnoseDetailResponse) -> some View {
        Chart {
            SectorMark(
                angle: .value(DiagnosingResultConstants.scoreText, data.score),
                innerRadius: .ratio(DiagnosingResultConstants.chartInnerRadius),
                angularInset: DiagnosingResultConstants.chartInnerRadius
            )
            .cornerRadius(DiagnosingResultConstants.topCornerRadius)
            .foregroundStyle(Color.redStar)
            
            SectorMark(
                angle: .value(DiagnosingResultConstants.remainingText, 100 - data.score),
                innerRadius: .ratio(DiagnosingResultConstants.chartInnerRadius),
                angularInset: DiagnosingResultConstants.angularInset
            )
            .cornerRadius(DiagnosingResultConstants.topCornerRadius)
            .foregroundStyle(Color.gray900)
        }
        .frame(width: DiagnosingResultConstants.chartSize, height: DiagnosingResultConstants.chartSize)
    }
    
    // MARK: - MiddleContents
    private func middleContents(data: DiagnoseDetailResponse) -> some View {
        VStack(alignment: .leading, spacing: DiagnosingResultConstants.middleVspacing, content: {
            diagResultSection(data: data)
            followManagement(data: data)
            recommendProducts(data: data)
        })
    }
    /// 진단 결과 섹션
    /// - Parameter data: 진단 결과 사용 데이터
    /// - Returns: 진단 결과 섹션
    private func diagResultSection(data: DiagnoseDetailResponse) -> some View {
        sectionContents(DiagnosingResultConstants.diagResultText, {
            contentsText(text: data.detailValue)
        })
    }
    
    /// 추후 관리법 섹션
    /// - Parameter data: 추후 관리법 결과 사용 데이터
    /// - Returns: 추후 결과 섹션
    private func followManagement(data: DiagnoseDetailResponse) -> some View {
        sectionContents(DiagnosingResultConstants.followManageText, {
            contentsText(text: data.afterCare)
        })
    }
    
    /// 추천 제품 섹션
    /// - Parameter data: 추천 제품 사용 섹션
    /// - Returns: 추천ㅇ 제품 섹션
    private func recommendProducts(data: DiagnoseDetailResponse) -> some View {
        sectionContents(DiagnosingResultConstants.recommendProduct, {
            ForEach(data.products, id: \.id) { data in
                DiagnosticAIProduct(data: data)
            }
        })
    }
    
    /// 컨텐츠 내부 텍스트
    /// - Parameter text: 컨텐츠 내부 설명 텍스트
    /// - Returns: 텍스트 반환
    func contentsText(text: String) -> some View {
        Text(text)
            .font(.Body3_medium)
            .foregroundStyle(Color.gray400)
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
            .lineSpacing(DiagnosingResultConstants.textLineSpacing)
            .padding(.horizontal, DiagnosingResultConstants.contentsHorizonPadding)
            .padding(.vertical, DiagnosingResultConstants.contentsVerticalPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: DiagnosingResultConstants.middleTextHeight, alignment: .top)
            .background {
                RoundedRectangle(cornerRadius: DiagnosingResultConstants.contentsCornerRadius)
                    .fill(Color.clear)
                    .stroke(Color.gray200, style: .init())
            }
    }
    
    /// 중간 컨텐츠 생성
    /// - Parameters:
    ///   - title: 섹션 타이틀
    ///   - contents: 컨텐츠 내용 기입
    /// - Returns: 뷰 반환
    func sectionContents(_ title: String, @ViewBuilder _ contents: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: DiagnosingResultConstants.middleContentsVspacing, content: {
            Text(title)
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            contents()
        })
    }
}

#Preview {
    DiagnosticResultView(viewModel: .init(container: DIContainer()), showFullScreenAI: .constant(true), diagId: 0)
}
