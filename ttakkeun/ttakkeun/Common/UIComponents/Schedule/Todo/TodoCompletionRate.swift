//
//  TodoCompleteEach.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import SwiftUI

struct TodoCompletionRate: View {
    
    // MARK: - Property
    var data: TodoCompletionResponse
    
    // MARK: - Constants
    fileprivate enum TodoCompletionRateConstants {
        static let bottomAreaTopPadding: CGFloat = 11
        
        static let topCornerRadius: CGFloat = 30
        static let bottomCornerRadius: CGFloat = 10
        static let topContentsSize: CGSize = .init(width: 37, height: 69)
        static let topAreaRectangleHeight: CGFloat = 84
        static let bottomAreaRectangleHeight: CGFloat = 81
        static let contentsHeight: CGFloat = 99
        static let rectangleWidth: CGFloat = 60
    }
    
    // MARK: - Init
    init(data: TodoCompletionResponse, partItem: PartItem) {
        self.data = data
        self.data.partItem = partItem
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .top, content: {
            bottomContents
            topContents
        })
        .frame(maxHeight: TodoCompletionRateConstants.contentsHeight)
        .background(Color.clear)
    }
    
    // MARK: - TopContents
    /// 상단 영역 컨텐츠
    private var topContents: some View {
        VStack(alignment: .center, content: {
            if let partItem = data.partItem {
                Image(faceIcon(partItem: partItem))
                
                Text(partItem.toKorean())
                    .font(.Body3_semibold)
                    .foregroundStyle(Color.gray900)
                
                Text("\(percentage(partItem: partItem))%")
                    .font(.Body4_medium)
                    .foregroundStyle(Color.gray400)
            }
        })
        .frame(maxWidth: TodoCompletionRateConstants.topContentsSize.width, maxHeight: TodoCompletionRateConstants.topContentsSize.height)
    }
    // MARK: - BottomContents
    /// 아래 하단 영역
    private var bottomContents: some View {
        Group {
            if let partItem = data.partItem {
                makeRectangle(color: partItem.toAfterColor(), height: TodoCompletionRateConstants.topAreaRectangleHeight)
            }
            
            makeRectangle(color: Color.completionFront, height: TodoCompletionRateConstants.bottomAreaRectangleHeight)
        }
        .padding(.top, TodoCompletionRateConstants.bottomAreaTopPadding)
    }
}

extension TodoCompletionRate {
    // MARK: - Percentage
    /// 퍼센테지에 따른 얼굴 아이콘
    /// - Parameter partItem: 파트 아이템 얼굴 이미지
    /// - Returns: 얼굴 이미지 반환
    func faceIcon(partItem: PartItem) -> ImageResource {
        switch percentage(partItem: partItem) {
        case 0..<20:
            return .sad
        case 20..<40:
            return .hinghing
        case 40..<60:
            return .soso
        case 60..<80:
            return .smile
        case 80...100:
            return .heart
        default:
            return .neutral
        }
    }
    
    /// 퍼센테이지 계산
    /// - Parameter partItem: 파트 아이템
    /// - Returns: 파트 아이템 퍼센테이지
    func percentage(partItem: PartItem) -> Int {
        switch partItem {
        case .ear:
            return calculatePercentage(completed: data.earCompleted, total: data.earTotal)
        case .eye:
            return calculatePercentage(completed: data.eyeCompleted, total: data.eyeTotal)
        case .hair:
            return calculatePercentage(completed: data.hairCompleted, total: data.hairTotal)
        case .claw:
            return calculatePercentage(completed: data.clawCompleted, total: data.clawTotal)
        case .teeth:
            return calculatePercentage(completed: data.teethCompleted, total: data.teethTotal)
        }
    }
    
    /// 퍼센테이지 계산
    /// - Parameters:
    ///   - completed: 완료 퍼센트
    ///   - total: 토탈 퍼센트
    /// - Returns: 퍼센트 값 반환
    private func calculatePercentage(completed: Int, total: Int) -> Int {
        guard total > .zero else {
            return .zero
        }
        return Int((Double(completed) / Double(total)) * 100)
    }
    
    func makeRectangle(color: Color, height: CGFloat) -> some View {
        UnevenRoundedRectangle(topLeadingRadius: TodoCompletionRateConstants.topCornerRadius, bottomLeadingRadius: TodoCompletionRateConstants.bottomCornerRadius, bottomTrailingRadius: TodoCompletionRateConstants.bottomCornerRadius, topTrailingRadius: TodoCompletionRateConstants.topCornerRadius)
            .foregroundStyle(color)
            .frame(width: TodoCompletionRateConstants.rectangleWidth, height: height)
    }
}


#Preview(traits: .sizeThatFitsLayout) {
    TodoCompletionRate(data: .init(earTotal: 20, earCompleted: 10, hairTotal: 20, hairCompleted: 10, clawTotal: 20, clawCompleted: 10, eyeTotal: 20, eyeCompleted: 10, teethTotal: 20, teethCompleted: 10), partItem: .claw)
}
