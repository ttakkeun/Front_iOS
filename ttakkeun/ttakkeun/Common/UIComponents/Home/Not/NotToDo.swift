//
//  HomeNotToDo.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import SwiftUI

/// 투두 데이터 없을 경우 사용
struct NotToDo: View {
    
    // MARK: - Constants
    fileprivate enum NotToDoConstants {
        static let mainVspacing: CGFloat = 18
        
        static let firstCircleSize: CGFloat = 184
        static let secondCircleSize: CGFloat = 117
        static let mainContentsHeight: CGFloat = 147
        
        static let secondTopPadding: CGFloat = 6
        static let thirdTopPadding: CGFloat = 13
        static let safePadding: CGFloat = 40
        
        static let cornerRadius: CGFloat = 20
        
        static let title: String = "Todo list를 만들어볼까요?"
    }
    
    var body: some View {
        VStack(spacing: NotToDoConstants.mainVspacing, content: {
            linearCircleComponents
            
            Text(NotToDoConstants.title)
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
        })
        .frame(maxWidth: .infinity)
        .frame(height: NotToDoConstants.mainContentsHeight)
        .background {
            RoundedRectangle(cornerRadius: NotToDoConstants.cornerRadius)
                .fill(Color.clear)
                .stroke(Color.gray200, style: .init())
        }
    }
    
    /// 카테고리 순서 보여주기
    private var linearCircleComponents: some View {
        ZStack(alignment: .top, content: {
            makeCircle(partItem: [.claw, .hair])
                .frame(maxWidth: NotToDoConstants.firstCircleSize)
            
            makeCircle(partItem: [.teeth, .eye])
                .frame(maxWidth: NotToDoConstants.secondCircleSize)
                .padding(.top, NotToDoConstants.secondTopPadding)
            
            TodoCircle(partItem: .ear, isBefore: true)
                .padding(.top, NotToDoConstants.thirdTopPadding)
        })
    }
    
    private func makeCircle(partItem: [PartItem]) -> HStack<some View> {
        return HStack {
            TodoCircle(partItem: partItem[0], isBefore: true)
            
            Spacer()
            
            TodoCircle(partItem: partItem[1], isBefore: true)
        }
    }
}

struct NotTodo_Preview: PreviewProvider {
    static var previews: some View {
        NotToDo()
    }
}
