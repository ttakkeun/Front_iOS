//
//  DiagnosisResultView.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/19/24.
//

import SwiftUI
import Charts

struct DiagnosisResultView: View {
    
    @ObservedObject var viewModel: DiagnosticResultViewModel
    @Environment(\.dismiss) var dismiss
    
    @ViewBuilder
    var body: some View {
        if let _ = viewModel.diagnosisData {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 24) {
                    self.topBackground
                    
                    self.checkDetail("진단 결과", "data.detailValue")
                    self.checkDetail("추후 결과법", "data.afterCare")
                    
                    referrenceProduct
                    
                    Spacer()
                    
                    MainButton(btnText: "확인", width: 343, height: 63, action: {
                        dismiss()
                    }, color: Color.primaryColor_Main)
                }
                .padding(.bottom, 30)
            }
            .frame(maxHeight: .infinity)
            .ignoresSafeArea(.all)
        } else {
            VStack {
                LoadingView(width: 506, height: 686)
                
                Spacer()
            }
            .ignoresSafeArea(.all)
            .onAppear {
                viewModel.objectWillChange.send()
            }
        }
    }
    
    
    // MARK: - Top ContentsView
    
    /// 상단 topBacground
    private var topBackground: some View {
        ZStack {
            Icon.diagnosisBackground.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 400, height: 255)
            
            HStack(spacing: 6, content: {
                Icon.bubbleLogo.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 162, height: 124)
                
                graphRectangle
            })
        }
    }
    
    /// 점수가 포함된 RectangleGraph
    @ViewBuilder
    private var graphRectangle: some View {
        if let data = viewModel.diagnosisData {
            HStack(alignment: .center, spacing: 19, content: {
                Text("총점")
                    .font(.Body2_semibold)
                    .foregroundStyle(Color.gray_900)
                ZStack(alignment: .center, content: {
                    Chart {
                        SectorMark(
                            angle: .value("Score", data.score),
                            innerRadius: .ratio(0.7),
                            angularInset: 1.5
                        )
                        .foregroundStyle(Color.redStarColor)
                        
                        SectorMark(
                            angle: .value("Remaining", 100 - data.score),
                            innerRadius: .ratio(0.7),
                            angularInset: 1.5
                        )
                        .foregroundStyle(Color.gray_900)
                    }
                    .frame(width: 70, height: 70)
                    
                    Text("\(data.score)")
                        .font(.suit(type: .semibold, size: 18))
                        .foregroundStyle(Color.gray_900)
                })
            })
            .padding(.vertical, 13)
            .padding(.horizontal, 23)
            .frame(width: 168, height: 96)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .background(Color.unClickedTab_Color)
        } else {
            ProgressView()
                .frame(width: 100, height: 100)
        }
    }
    
    // MARK: - Bottom ContentsView
    
    /// 진단결과 상세 내용 컨텐츠
    /// - Parameters:
    ///   - title: 컨텐츠 제목
    ///   - detail: 컨텐츠 내용
    /// - Returns: 내용을 담은 컨텐츠
    private func checkDetail(_ title: String, _ detail: String) -> some View {
        VStack(alignment: .leading, spacing: 15, content: {
            
            Text(title)
                .font(.H4_bold)
                .foregroundStyle(Color.gray_900)
            
            Text(detail)
                .frame(width: 300, alignment: .leading)
                .font(.Body3_medium)
                .foregroundStyle(Color.gray_400)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .lineSpacing(2)
                .padding(.vertical, 14)
                .padding(.horizontal, 21)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.clear)
                        .stroke(Color.gray_200, lineWidth: 1)
                )
        })
        .frame(width: 350)
    }
    
    /// 하단 추천 상품 조회
    private var referrenceProduct: some View {
        VStack(alignment: .leading, spacing: 15, content: {
            Text("추천 상품")
                .font(.H4_bold)
                .foregroundStyle(Color.gray_900)
            
            DiagnosisProduct(data: AIProducts(title: "dsad", image: "Asad", lprice: 1234, brand: "Adad"))
            DiagnosisProduct(data: AIProducts(title: "dsad", image: "Asad", lprice: 1234, brand: "Adad"))
            DiagnosisProduct(data: AIProducts(title: "dsad", image: "Asad", lprice: 1234, brand: "Adad"))
            DiagnosisProduct(data: AIProducts(title: "dsad", image: "Asad", lprice: 1234, brand: "Adad"))
            DiagnosisProduct(data: AIProducts(title: "dsad", image: "Asad", lprice: 1234, brand: "Adad"))
            
            if let data = viewModel.diagnosisData {
                VStack(spacing: 15, content: {
                    ForEach(data.products, id: \.self) { data in
                        DiagnosisProduct(data: data)
                    }
                })
            }
        })
    }
    // MARK: - LoadingView
    
    /// 로딩 중 뷰
    fileprivate struct LoadingView: View {
        
        let width: CGFloat
        let height: CGFloat
        
        init(width: CGFloat, height: CGFloat) {
            self.width = width
            self.height = height
        }
        
        var body: some View {
            ZStack(alignment: .center, content: {
                
                Icon.loadingBg.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                
                VStack(spacing: 24, content: {
                    
                    Text("진단중!! \n잠시만 기다려주세요!!")
                        .font(.H2_semibold)
                        .foregroundStyle(Color.black)
                        .multilineTextAlignment(.center)
                        .lineSpacing(1.5)
                    
                    Icon.bubbleLogo.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 257, height: 168)
                })
            })
        }
    }
}

struct DiagnosisResultView_Preview: PreviewProvider {
    static let devices = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            DiagnosisResultView(viewModel: DiagnosticResultViewModel(petId: 0))
        }
    }
}
