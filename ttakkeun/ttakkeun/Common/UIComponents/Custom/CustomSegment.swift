//
//  CustomSegment.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//
import SwiftUI

/// 커스텀 세그먼트 추상화
struct CustomSegment<T: SegmentType & CaseIterable>: View {
    
    @State private var segmentWidth: [T: CGFloat] = [:]
    @Binding var selectedSegment: T
    @Namespace var name
    
    let duration: TimeInterval = 0.4
    let height: CGFloat = 2
    let id: String = "Tab"
    
    var body: some View {
        HStack(spacing: 16, content: {
            let segments = Array(T.allCases)
            
            ForEach(segments.indices, id: \.self) { index in
                let segment = segments[index]
                
                Button(action: {
                    withAnimation(.easeInOut(duration: duration)) {
                        selectedSegment = segment
                    }
                }, label: {
                    makeSegmentButton(segment: segment)
                })
            }
        })
        .onPreferenceChange(SegmentWidthPreferenceKey.self, perform: { new in
            for (key, width) in new {
                if let typedKey = key as? T {
                    segmentWidth[typedKey] = width
                }
            }
        })
    }
    
    /// 하단 세그먼트 버튼 표시 가이드
    /// - Parameter segment: 세그먼트 T 제네릭 타입
    /// - Returns: 뷰 반환
    private func makeSegmentButton(segment: T) -> some View {
        VStack(alignment: .center, spacing: .zero, content: {
            segmentTitle(segment: segment)
            
            ZStack(alignment: .bottom, content: {
                Capsule()
                    .fill(Color.clear)
                    .frame(width: segmentWidth[segment] ?? 0, height: height)
                
                if selectedSegment == segment {
                    Capsule()
                        .fill(Color.gray600)
                        .frame(width: segmentWidth[segment] ?? 0, height: 2)
                        .matchedGeometryEffect(id: id, in: name)
                }
            })
        })
    }
    
    /// 세그먼트 타이틀 생성
    /// - Parameter segment: 세그먼트 T 제네릭
    /// - Returns: 세그먼트 타이틀 반환
    private func segmentTitle(segment: T) -> some View {
        Text(segment.title)
            .font(selectedSegment == segment ? .Body2_bold : .Body2_regular)
            .foregroundStyle(selectedSegment == segment ? Color.gray900 : Color.gray400)
            .background(
                GeometryReader { geo in
                    Color.clear
                        .preference(
                            key: SegmentWidthPreferenceKey.self,
                            value: [AnyHashable(segment): geo.size.width]
                        )
                }
            )
    }
}

fileprivate struct SegmentWidthPreferenceKey: PreferenceKey {
    static var defaultValue: [AnyHashable: CGFloat] = [:]
    
    static func reduce(value: inout [AnyHashable: CGFloat], nextValue: () -> [AnyHashable: CGFloat]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct CumtomSegmentPreview: View {
    @State private var segment: DiagnosticSegment = .diagnosticResults
    
    var body: some View {
        CustomSegment<DiagnosticSegment>(selectedSegment: $segment)
    }
}

#Preview {
    CumtomSegmentPreview()
}
