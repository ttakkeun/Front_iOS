//
//  HomeNotTodo.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/19/24.
//

import SwiftUI

/// 5개의 동그라미, Text, 테두리
struct HomeNotTodo: View {
    var body: some View {
        
        VStack(spacing: 18, content: {
            
            topCircleComponents
            
            Text("Todo list를 만들어볼까요?")
                .font(.suit(type: .semibold, size: 14))
            
        })
        .frame(width: 273, height: 147)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.subProfileColor_Color)
        )
    }
    
    
    //MARK: - Components
    
    /// 5개 항목 그룹
    private var topCircleComponents: some View {
        ZStack(alignment: .top, content: {
            firstCircle
            secondCircle
            
            HomeNotTodoCircle(color: .beforeEar_Color, icon: Icon.homeEar.image)
                .padding(.top, 13)
        })
    }
    
    
    /// 끝에서 두번째 원
    private var secondCircle: some View {
        HStack(content: {
            HomeNotTodoCircle(color: .beforeTeeth_Color, icon: Icon.homeTeeth.image)
            
            Spacer()
            
            HomeNotTodoCircle(color: .beforeEye_Color, icon: Icon.homeEye.image)
            
        })
        .frame(maxWidth: 117)
        .padding(.top, 6)
        
    }
    
    
    /// 끝에서 첫번째 원
    private var firstCircle: some View {
        HStack(content: {
            HomeNotTodoCircle(color: .beforeClaw_Color, icon: Icon.homeClaw.image)
            
            Spacer()
            
            HomeNotTodoCircle(color: .beforeHair_COlor, icon: Icon.homeHair.image)
        })
        .frame(maxWidth: 184)
    }
    
    
}

// MARK: - 프리뷰
struct HomeNotTodo_PreView: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            HomeNotTodo()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
            
                .previewLayout(.sizeThatFits)
        }
    }
}
