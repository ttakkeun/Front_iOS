//
//  FloatingButton.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import SwiftUI
import FloatingButton

struct FloatingCircle: View {
    
    @EnvironmentObject var container: DIContainer
    @Binding var isShowFloating: Bool
    @State private var selectedFloatingMenu: ExtendPartItem? = nil
    
    var body: some View {
        ZStack {
            if isShowFloating {
                Color.btnBg.opacity(0.6)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowFloating.toggle()
                    }
            } else {
                Color.clear
            }
            
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
                .padding(.bottom, 110)
                .padding(.trailing, -20)
            }
        }
    }
    
    private var floatingMainBtn: some View {
        Image(systemName: "plus")
            .renderingMode(.template)
            .resizable()
            .foregroundStyle(Color.black)
            .aspectRatio(contentMode: .fit)
            .frame(width: 18, height: 18)
            .padding(20)
            .background {
                Circle()
                    .fill(isShowFloating ? Color.white : Color.floatingBtn)
                    .shadow03()
            }
            .rotationEffect(.degrees(isShowFloating ? 45 : 0))
            .animation(.easeInOut(duration: 0.3), value: isShowFloating)
    }
}

extension FloatingCircle {
    func floatingList() -> [some View] {
        ExtendPartItem.floatingCases.map { segment in
            FloatingCategory(floatingCategory: segment)
                .onTapGesture {
                    selectedFloatingMenu = segment
                    isShowFloating.toggle()
                    
                    if let selectedFloatingMenu = selectedFloatingMenu {
                        container.navigationRouter.push(to: .writeTipsView(category: selectedFloatingMenu))
                    }
                }
        }
    }
}

struct FloatingButton_Preview: PreviewProvider {
    
    @State static var isShowFloating: Bool = true
    
    static var previews: some View {
        FloatingCircle(isShowFloating: $isShowFloating)
    }
}
