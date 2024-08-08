//
//  DiagnosisHeader.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/8/24.
//

import SwiftUI

struct DiagnosisView: View {
    
    @State private var selectedSegment: DiagnosisSegment = .journalList
    @State private var selectedPartItem: PartItem = .ear
    @ObservedObject var journalViewModel: JournalViewModel
    @EnvironmentObject var petState: PetState
    @Namespace var name
    
    var body: some View {
        topSegmentGroup
    }
    
    // MARK: - Contents
    
    private var header: some View {
        VStack(alignment: .leading) {
            TopStatusBar()
            Spacer()
            selectedSegmentButton
        }
        .frame(maxWidth: .infinity, maxHeight: 100)
        .background(Color.mainBg)
        .overlay(
            Rectangle()
                .frame(width: .infinity, height: 1)
                .foregroundColor(Color.gray200),
            alignment: .bottom)
    }
    
    
    /// 세그먼트 버튼 및 하단 Divider 밑줄 그룹
    private var topSegmentGroup: some View {
        VStack(alignment: .leading, spacing: 18, content: {
            TopStatusBar()
            selectedSegmentButton
            itemsButton
        })
    }
    
    /// 일지목록 및 진단결과 세그먼트 버튼
    private var selectedSegmentButton: some View {
        HStack(spacing: 19, content: {
            
            ForEach(DiagnosisSegment.allCases, id: \.self) { segment in
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.4)) {
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
                        if selectedSegment == .journalList {
                            Task {
                                await journalViewModel.getJournalList(petID: petState.petId ?? 0, category: selectedPartItem)
                            }
                        }
                    }
                }, label: {
                    Text(item.toKorean())
                        .font(selectedPartItem == item ? .H4_semibold : .H4_medium)
                        .foregroundStyle(selectedPartItem == item ? Color.gray_900 : Color.gray_400)
                })
            }
        })
        .padding(.leading, 5)
    }
}

struct DiagnosisView_Preview: PreviewProvider {
    static let devices = ["iPhone 11", "iPhone 15"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            DiagnosisView(journalViewModel: JournalViewModel())
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(PetState())
        }
    }
}
