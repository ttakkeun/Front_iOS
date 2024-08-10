//
//  DiagnosisTopbutton.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/8/24.
//

import SwiftUI

/// 일지 상단 버튼
struct DiagnosisTopbutton: View {
    
    @ObservedObject var viewModel: DiagnosisViewModel
    
    var body: some View {
        topButton
    }
    
    /// 돋보기 + 선택 버튼
    private var topButton: some View {
        HStack(spacing: 10, content: {
            
            if viewModel.isSelectionMode {
                HStack(spacing: 26, content: {
                    Text("\(viewModel.selectedCnt)장 선택됨")
                        .frame(minWidth: 70)
                        .font(.Body3_medium)
                        .foregroundStyle(Color.gray_900)
                    
                    Text("진단가능횟수 \(viewModel.diagnosticAvailable) / 10")
                        .font(.Body3_medium)
                        .foregroundStyle(Color.gray_900)
                        .frame(width: 127)
                })
                .transition(.opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        viewModel.isSelectionMode = true
                    }
                }
            } else {
                Spacer()
            }
        
            HStack(spacing: 6, content: {
                Button(action: {
                    print("검색 버튼")
                }, label: {
                    Icon.glass.image
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color.gray500)
                        .frame(width: 34, height: 34)
                })
                
                Button(action: {
                    if !viewModel.isSelectionMode {
                        withAnimation(.easeInOut) {
                            viewModel.isSelectionMode = true
                        }
                    } else {
                        withAnimation(.easeInOut) {
                            viewModel.isSelectionMode = false
                        }
                        Task {
                            await viewModel.clearSelection()
                        }
                    }
                }, label: {
                    Text(viewModel.isSelectionMode ? "취소" : "선택")
                        .font(.Body3_bold)
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 21)
                        .padding(.vertical, 8)
                        .background(Color.gray500)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                })
            })
        })
        .frame(maxWidth: 340)
    }
}

struct DiagnosisTopbutton_Preview: PreviewProvider {
    static var previews: some View {
        DiagnosisTopbutton(viewModel: DiagnosisViewModel())
    }
}
