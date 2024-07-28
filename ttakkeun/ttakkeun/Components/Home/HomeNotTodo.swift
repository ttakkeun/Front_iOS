//
//  HomeNotTodo.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/19/24.
//

import SwiftUI

/// 투두가 없을 경우 보여지는 빈 뷰
struct HomeNotTodo: View {
    var body: some View {
        
        VStack(spacing: 18, content: {
            
            topCircleComponents
            
            Text("Todo list를 만들어볼까요?")
                .font(.Body3_medium)
                .foregroundStyle(Color.gray_900)
            
        })
        .frame(width: 273, height: 147)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.clear)
                .stroke(Color.gray_200, lineWidth: 1)
        )
    }
    
    
    //MARK: - Components
    
    /// 5개 항목 그룹
    private var topCircleComponents: some View {
        ZStack(alignment: .top, content: {
            firstCircle
            secondCircle
            
            HomeTodoCircle(partItem: .ear, isBefore: true)
                .padding(.top, 13)
        })
    }
    
    
    /// 끝에서 두번째 원
    private var secondCircle: some View {
        HStack(content: {
            HomeTodoCircle(partItem: .tooth, isBefore: true)
            
            Spacer()
            
            HomeTodoCircle(partItem: .eye, isBefore: true)
            
        })
        .frame(maxWidth: 117)
        .padding(.top, 6)
        
    }
    
    
    /// 끝에서 첫번째 원
    private var firstCircle: some View {
        HStack(content: {
            HomeTodoCircle(partItem: .claw, isBefore: true)
            
            Spacer()
            
            HomeTodoCircle(partItem: .hair, isBefore: true)
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
