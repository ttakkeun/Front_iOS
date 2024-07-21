//
//  TodoCompleteEach.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/18/24.
//

import SwiftUI

///  투두 완수율 각 항목 카드
struct TodoCompleteEach: View {
    
    let data: TodoCompleteData
    
    init(data: TodoCompleteData) {
        self.data = data
    }
    
    var body: some View {
        ZStack(alignment: .top, content: {
            ZStack(alignment: .top) {
                bottomView
                upperView
            }.padding(.top, 11)
            
            content
        })
        .frame(maxHeight: 99)
        .background(Color.clear)
    }
    
    //MARK: - 컴포넌트
    /// 아래에 색깔 있는 bottom카드
    private var bottomView: some View {
        UnevenRoundedRectangle()
            .clipShape(.rect(topLeadingRadius: 30, bottomLeadingRadius: 10, bottomTrailingRadius: 10, topTrailingRadius: 30))
            .foregroundStyle(partColor)
            .frame(width: 60, height: 84)
    }
    
    /// 위에 회색 upper카드
    private var upperView: some View {
        UnevenRoundedRectangle()
            .clipShape(.rect(topLeadingRadius: 30, bottomLeadingRadius: 10, bottomTrailingRadius: 10, topTrailingRadius: 30))
            .foregroundStyle(Color.scheduleCard_Color)
            .frame(width: 60, height: 81)
    }
    
    /// 카드 안에 들어갈 내용(이미지+파트+완수율)
    private var content: some View {
        VStack(alignment: .center, spacing: 7, content: {
            
            face.image
            
            partName
                .font(.suit(type: .semibold, size: 14))
                .foregroundStyle(Color.gray_900)
            
            Text("\(Int((data.currentInt / data.totalInt) * 100))%")
                .font(.suit(type: .regular, size: 12))
                .foregroundStyle(Color.gray_400)
        })
        .frame(maxWidth: 37, maxHeight: 69)
    }
    
    
    //MARK: - Switch 분기
    /// 파트 이름
    @ViewBuilder
    private var partName: some View {
        switch data.partType {
        case .ear:
            Text("귀")
        case .eye:
            Text("눈")
        case .hair:
            Text("털")
        case .claw:
            Text("발톱")
        case .teeth:
            Text("이빨")
        }
    }
    /// 파트 bottomView 색상
    private var partColor: Color {
        switch data.partType {
        case .ear:
            Color.afterEar_Color
        case .eye:
            Color.afterEye_Color
        case .hair:
            Color.afterHair_Color
        case .claw:
            Color.afterClaw_Color
        case .teeth:
            Color.afterTeeth_Color
        }
    }
    /// 완수율에 따른 표정 범위
    private var face: Icon {
        switch (data.currentInt/data.totalInt)*100 {
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

struct TodoCompleteEach_Preview: PreviewProvider {
    static var previews: some View {
        TodoCompleteEach(data: TodoCompleteData(partType: .hair, currentInt: 5, totalInt: 10))
            .previewLayout(.sizeThatFits)
    }
}
