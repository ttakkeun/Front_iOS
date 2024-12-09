//
//  FloatingButton.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import SwiftUI
import FloatingButton

struct FloatingCircle: View {
    
    @Binding var isShowFloating: Bool
    @State private var selectedFloatingMenu: ExtendPartItem? = nil
    
    var body: some View {
        
        VStack {
            Spacer()
            
            HStack {
                
                Spacer()
                
                FloatingButton(mainButtonView: floatingMainBtn, buttons: floatingList(), isOpen: $isShowFloating)
                    .straight()
                    .direction(.top)
                    .delays(delayDelta: 0.1)
                    .alignment(.right)
                    .spacing(10)
                    .initialOpacity(0)
            }
            .padding(.bottom, 80)
        }
        .onTapGesture {
            isShowFloating.toggle()
        }
        .background(isShowFloating ? Color.btnBg.opacity(0.6) : Color.clear)
    }
    
    private var floatingMainBtn: some View {
        Image(systemName: isShowFloating ? "xmark" : "plus")
            .renderingMode(.template)
            .resizable()
            .foregroundStyle(Color.black)
            .aspectRatio(contentMode: .fit)
            .frame(width: returnSize(), height: returnSize())
            .padding(16)
            .background {
                Circle()
                    .fill(isShowFloating ? Color.white : Color.floatingBtn)
                    .shadow03()
            }
    }
}

extension FloatingCircle {
    func floatingList() -> [some View] {
        ExtendPartItem.floatingCases.map { segment in
            FloatingCategory(floatingCategory: segment)
                .onTapGesture {
                    selectedFloatingMenu = segment
                    isShowFloating.toggle()
                }
        }
    }
    
    func returnSize() -> CGFloat {
        if isShowFloating {
            return 15
        } else {
            return 18
        }
    }
}

struct FloatingButton_Preview: PreviewProvider {
    
    @State static var isShowFloating: Bool = true
    
    static var previews: some View {
        FloatingCircle(isShowFloating: $isShowFloating)
    }
}
