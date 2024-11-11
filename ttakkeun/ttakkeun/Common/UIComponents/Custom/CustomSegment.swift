//
//  CustomSegment.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//
import SwiftUI

struct CustomSegment<T: SegmentType & CaseIterable>: View {
    
    @Binding var selectedSegment: T
    @Namespace var name
    
    var body: some View {
        HStack(spacing: 16, content: {
            ForEach(Array(T.allCases), id: \.self) { segment in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        selectedSegment = segment
                    }
                }, label: {
                    makeSegmentButton(segment: segment)
                })
            }
        })
    }
    
    private func makeSegmentButton(segment: T) -> some View {
        VStack(alignment: .center, spacing: 0, content: {
            Text(segment.title)
                .font(selectedSegment == segment ? .Body2_bold : .Body2_regular)
                .foregroundStyle(selectedSegment == segment ? Color.gray900 : Color.gray400)
            
            Capsule()
                .fill(Color.clear)
                .frame(width: 73, height: 2)
            
            if selectedSegment == segment {
                ZStack {
                    Capsule()
                        .fill(Color.gray600)
                        .frame(width: 73, height: 2)
                        .matchedGeometryEffect(id: "Tab", in: name)
                }
            }
        })
    }
}

struct CumtomSegment_Preview: PreviewProvider {
    static var previews: some View {
        CustomSegment<DiagnosingSegment>(selectedSegment: .constant(.journalList))
    }
}
