//
//  DiagnosingResultDetailView.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/19/24.
//

import SwiftUI
import Charts

struct DiagnosingResultDetailView: View {
    
    @ObservedObject var viewModel: DiagnosticResultViewModel
    
    var body: some View {
        if let data = viewModel.diagnosticResolutionData {
            ScrollView(.vertical, content: {
                VStack(content: {
                    topBackground(data: data)
                    
                    Spacer().frame(height: 24)
                    
                    makeResultDetail("진단 결과", data.detailValue)
                    
                    Spacer().frame(height: 22)
                    
                    makeResultDetail("추후 결과법", data.afterCare)
                    
                    Spacer().frame(height: 22)
                    
                    aiReferrenceProduct(data: data)
                    
                    Spacer().frame(height: 34)
                    
                    MainButton(btnText: "확인", width: 343, height: 63, action: {
                        print("데이터 해제 및 디스미스")
                    }, color: Color.mainPrimary)
                })
                .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 25, trailing: 0))
            })
            .ignoresSafeArea(.all)
        } else {
            VStack(content: {
                Spacer()
                
                ProgressView(label: {
                    LoadingDotsText(text: "조금만 기다려주세요! \n진단 결과를 준비하고 있어요 😊")
                })
                .controlSize(.large)
                
                Spacer()
                
            })
        }
    }
}

extension DiagnosingResultDetailView {
    
    func aiReferrenceProduct(data: DiagnosticResolutionResponse) -> some View {
        VStack(alignment: .leading, spacing: 15, content: {
            Text("추천 상품")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            ForEach(data.products, id: \.self) { data in
                DiagnosticAIProduct(data: data)
            }
        })
    }
    
    func makeResultDetail(_ title: String, _ detail: String) -> some View {
        VStack(alignment: .leading, spacing: 15, content: {
            Text(title)
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            Text(detail)
                .frame(width: 320, alignment: .leading)
                .font(.Body3_medium)
                .foregroundStyle(Color.gray400)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .lineSpacing(2.5)
                .padding(.vertical, 16)
                .padding(.horizontal, 23)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.clear)
                        .stroke(Color.gray200, lineWidth: 1)
                }
        })
    }
    
    
    func topBackground(data: DiagnosticResolutionResponse) -> some View {
        ZStack {
            Icon.diagnosisTopBg.image
                .resizable()
                .ignoresSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: 255)
            
            HStack(spacing: 10, content: {
                Icon.bubbleLogo.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 162, height: 124)
                
                makeResultGraph(data: data)
            })
        }
    }
    
    func makeResultGraph(data: DiagnosticResolutionResponse) -> some View {
        HStack(alignment: .center, spacing: 19, content: {
            Text("총점")
                .font(.Body2_semibold)
                .foregroundStyle(Color.gray900)
            
            ZStack(alignment: .center, content: {
                Chart {
                    SectorMark(
                        angle: .value("Score", data.score),
                        innerRadius: .ratio(0.7),
                        angularInset: 1
                    )
                    .cornerRadius(30)
                    .foregroundStyle(Color.redStar)
                    
                    SectorMark(
                        angle: .value("Remaining", 100 - data.score),
                        innerRadius: .ratio(0.7),
                        angularInset: 1
                    )
                    .cornerRadius(30)
                    .foregroundStyle(Color.gray900)
                }
                .frame(width: 70, height: 70)
                
                Text("\(data.score)")
                    .font(.Body1_semibold)
                    .foregroundStyle(Color.gray900)
            })
        })
        .frame(width: 117, height: 70)
        .padding(.vertical, 13)
        .padding(.leading, 23)
        .padding(.trailing, 28)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white).opacity(0.5)
        }
    }
}

struct DiagnosingResultDetailView_Preview: PreviewProvider {
    static var previews: some View {
        DiagnosingResultDetailView(viewModel: DiagnosticResultViewModel())
    }
}
