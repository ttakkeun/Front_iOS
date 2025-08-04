//
//  TodoCompleteEach.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import SwiftUI

struct TodoCompletionRate: View {
    
    var data: TodoCompleteResponse
    
    init(data: TodoCompleteResponse, partItem: PartItem) {
        self.data = data
        self.data.partItem = partItem
    }
    
    var body: some View {
        ZStack(alignment: .top, content: {
            Group {
                if let parrItem = data.partItem {
                    makeRectangle(color: partColor(partItem: parrItem), height: 84)
                }
                
                makeRectangle(color: Color.completionFront, height: 81)
            }
            .padding(.top, 11)
            
            contents
        })
        .frame(maxHeight: 99)
        .background(Color.clear)
    }
    
    private var contents: some View {
        VStack(alignment: .center, spacing: 7, content: {
            if let partItem = data.partItem {
                faceIcon(partItem: partItem).image
                    .fixedSize()
                
                Text(partItem.toKorean())
                    .font(.Body3_semibold)
                    .foregroundStyle(Color.gray900)
                
                Text("\(percentage(partItem: partItem))%")
                    .font(.Body4_medium)
                    .foregroundStyle(Color.gray400)
            }
            
        })
        .frame(maxWidth: 37, maxHeight: 69)
    }
}

extension TodoCompletionRate {
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

    private func calculatePercentage(completed: Int, total: Int) -> Int {
        guard total > 0 else {
            return 0 // 분모가 0일 때 기본값 설정
        }
        return Int((Double(completed) / Double(total)) * 100)
    }
    func makeRectangle(color: Color, height: CGFloat) -> some View {
        UnevenRoundedRectangle(topLeadingRadius: 30, bottomLeadingRadius: 10, bottomTrailingRadius: 10, topTrailingRadius: 30)
            .foregroundStyle(color)
            .frame(width: 60, height: height)
    }
    
    func partColor(partItem: PartItem) -> Color {
        switch partItem {
        case .ear:
            Color.afterEar
        case .eye:
            Color.afterEye
        case .hair:
            Color.afterHair
        case .claw:
            Color.afterClaw
        case .teeth:
            Color.afterTeeth
        }
    }
    
    func faceIcon(partItem: PartItem) -> Icon {
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
}
