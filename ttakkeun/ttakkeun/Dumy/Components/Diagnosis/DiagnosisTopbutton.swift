//
//  DiagnosisTopbutton.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/8/24.
//

import SwiftUI

/// 일지 상단 버튼 컨트롤
struct DiagnosisTopbutton: View {
    
    @ObservedObject var journalListViewModel: JournalListViewModel
    @ObservedObject var diagnosticResultViewModel: DiagnosticResultViewModel
    
    var body: some View {
        topButton
    }
    
    /// 돋보기 + 선택 버튼
    private var topButton: some View {
        HStack(spacing: 10, content: {
            
            if journalListViewModel.isSelectionMode {
                HStack(spacing: 26, content: {
                    Text("\(journalListViewModel.selectedCnt)장 선택됨")
                        .frame(minWidth: 70)
                        .font(.Body3_medium)
                        .foregroundStyle(Color.gray_900)
                    
                    Text("진단가능횟수 \(diagnosticResultViewModel.point) / 10")
                        .font(.Body3_medium)
                        .foregroundStyle(Color.gray_900)
                        .frame(width: 127)
                })
                .transition(.opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        journalListViewModel.isSelectionMode = true
                    }
                }
            } else {
                Spacer()
            }
        
            HStack(spacing: 10, content: {
                
                if !journalListViewModel.isSelectionMode {
                    Button(action: {
                        print("검색 버튼")
                    }, label: {
                        Icon.glass.image
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(Color.gray400)
                            .frame(width: 24, height: 24)
                    })
                } else {
                    Button(action: {
                        Task {
                            withAnimation(.easeIn(duration: 0.2)) {
                                Task {
                                    await journalListViewModel.deleteSelecttedJournalList()
                                }
                            }
                        }
                    }, label: {
                        Icon.trash.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                    })
                }
                
                
                Button(action: {
                    if !journalListViewModel.isSelectionMode {
                        withAnimation(.easeInOut) {
                            journalListViewModel.isSelectionMode = true
                        }
                    } else {
                        withAnimation(.easeInOut) {
                            journalListViewModel.isSelectionMode = false
                        }
                        Task {
                            await journalListViewModel.clearSelection()
                        }
                    }
                }, label: {
                    Text(journalListViewModel.isSelectionMode ? "취소" : "선택")
                        .font(.Body3_bold)
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 21)
                        .padding(.vertical, 8)
                        .background(Color.gray400)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                })
            })
        })
        .frame(maxWidth: 340)
    }
}
