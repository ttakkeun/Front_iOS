//
//  TodoCompleteEach.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import SwiftUI

struct TodoCompletionRate: View {
    
    let data: TodoCompleteResponse
    
    init(data: TodoCompleteResponse) {
        self.data = data
    }
    
    var body: some View {
        ZStack(alignment: .top, content: {
            Group {
                makeRectangle(color: partColor(), height: 84)
                
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
            faceIcon().image
                .fixedSize()
            
            Text(data.partItem.toKorean())
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
            
            Text("\(percentage())%")
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
            
        })
        .frame(maxWidth: 37, maxHeight: 69)
    }
}

extension TodoCompletionRate {
    func percentage() -> Int {
        switch data.partItem {
        case .ear:
            return Int((Double(data.earCompleted) / Double(data.earTotal)) * 100)
        case .eye:
            return Int((Double(data.eyeCompleted) / Double(data.eyeTotal)) * 100)
        case .hair:
            return Int((Double(data.hairCompleted) / Double(data.hairTotal)) * 100)
        case .claw:
            return Int((Double(data.clawCompleted) / Double(data.clawTotal)) * 100)
        case .teeth:
            return Int((Double(data.teethCompleted) / Double(data.teethTotal)) * 100)
        }
    }
    
    func makeRectangle(color: Color, height: CGFloat) -> some View {
        UnevenRoundedRectangle(topLeadingRadius: 30, bottomLeadingRadius: 10, bottomTrailingRadius: 10, topTrailingRadius: 30)
            .foregroundStyle(color)
            .frame(width: 60, height: height)
    }
    
    func partColor() -> Color {
        switch data.partItem {
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
    
    func faceIcon() -> Icon {
        switch percentage() {
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

struct TodoCompletionRate_Preview: PreviewProvider {
    static var previews: some View {
        TodoCompletionRate(data: TodoCompleteResponse(partItem: .ear, earTotal: 20, earCompleted: 10, hairTotal: 1, hairCompleted: 1, clawTotal: 1, clawCompleted: 1, eyeTotal: 1, eyeCompleted: 1, teethTotal: 1, teethCompleted: 1))
    }
}
