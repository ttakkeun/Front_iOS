//
//  DiagnosisHeader.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/8/24.
//

import SwiftUI

/// 진단 탭 상단 헤더 뷰, 검색 버튼과 진단결과 일지 목록 세그먼트 버튼
struct DiagnosisHeader: View {
    
    @Binding var selectedSegment: DiagnosisSegment
    @Binding var selectedPartItem: PartItem
    @ObservedObject var journalListViewModel: JournalListViewModel
    
    @Namespace var name
    
    
    init(selectedSegment: Binding<DiagnosisSegment>,
         selectedPartItem: Binding<PartItem>,
         journalListViewModel: JournalListViewModel
    ) {
        self._selectedSegment = selectedSegment
        self._selectedPartItem = selectedPartItem
        self.journalListViewModel = journalListViewModel
    }
    
    var body: some View {
        header
    }
    
    // MARK: - Contents
    
    /// 화면 전환 세그먼트 전환 헤더
    private var header: some View {
        ZStack(alignment: .top) {
            
            Icon.diagnosisBackground.image
                .resizable()
                .aspectRatio(contentMode: .fit)
            
                topSegmentGroup
        }
    }
    
    
    /// 세그먼트 버튼 및 하단 Divider 밑줄 그룹
    private var topSegmentGroup: some View {
        VStack(alignment: .leading, spacing: 18, content: {
            TopStatusBar()
            
            Spacer().frame(height: 3)
            
            selectedSegmentButton
            
            itemsButton
                .padding(.leading, 7)
        })
        .frame(width: 353, height: 121)
        .background(Color.clear)
        .padding(.horizontal, 15)
        .padding(.top, 68)
    }
    
    /// 일지목록 및 진단결과 세그먼트 버튼
    private var selectedSegmentButton: some View {
        HStack(spacing: 19, content: {
            
            ForEach(DiagnosisSegment.allCases, id: \.self) { segment in
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        selectedSegment = segment
                    }
                }, label: {
                    VStack(alignment: .center, spacing: 0, content: {
                        Text(segment.rawValue)
                            .font(.Body1_semibold)
                            .foregroundStyle(selectedSegment == segment ? Color.gray_900 : Color.gray_400)
                        ZStack {
                            Capsule()
                                .fill(Color.clear)
                                .frame(width: 73, height: 2)
                            
                            if selectedSegment == segment {
                                Capsule()
                                    .fill(Color.primarycolor_700)
                                    .frame(width: 73, height: 2)
                                    .matchedGeometryEffect(id: "Tab", in: name)
                            }
                        }
                    })
                })
            }
        })
    }
    
    /// 5가지 항목 데이터 조회 버트
    private var itemsButton: some View {
        HStack(alignment: .center, spacing: 20, content: {
            
            ForEach(PartItem.allCases, id: \.self) { item in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        selectedPartItem = item
                    }
                }, label: {
                    Text(item.toKorean())
                        .font(selectedPartItem == item ? .H4_semibold : .H4_medium)
                        .foregroundStyle(selectedPartItem == item ? Color.gray_900 : Color.gray_400)
                })
            }
        })
    }
}
