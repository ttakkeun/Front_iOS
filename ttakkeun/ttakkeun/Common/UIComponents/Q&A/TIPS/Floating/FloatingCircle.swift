//
//  FloatingButton.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import SwiftUI
import FloatingButton

/// 플로팅 버튼 전체 Circle
struct FloatingCircle: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @Binding var isShowFloating: Bool
    @State private var selectedFloatingMenu: ExtendPartItem? = nil
    
    // MARK: - Constants
    fileprivate enum FloatingCircleConstants {
        static let floatingBgSize: CGSize = .init(width: 50, height: 50)
        static let floatingImageSize: CGSize = .init(width: 18, height: 18)
        
        static let floatingPosition: CGSize = .init(width: 0.85, height: 0.75)
        static let rotationEffectDegree: Double = 45
        static let rotationAnimation: TimeInterval = 0.3
        static let floatingDelayTime: Double = 0.1
        static let floatingSpacing: CGFloat = 10
        
        static let floatingImage: String = "plus"
    }
    
    var body: some View {
        floatingButton
            .position(x: getScreenSize().width * FloatingCircleConstants.floatingPosition.width, y: getScreenSize().height * FloatingCircleConstants.floatingPosition.height)
    }
    
    /// 플로팅 라이브러리 사용 버튼
    private var floatingButton: some  View {
        FloatingButton(mainButtonView: floatingMainBtn, buttons: floatingList(), isOpen: $isShowFloating)
            .straight()
            .direction(.top)
            .delays(delayDelta: FloatingCircleConstants.floatingDelayTime)
            .alignment(.right)
            .spacing(FloatingCircleConstants.floatingSpacing)
            .initialOpacity(.zero)
    }
    
    /// 플로팅 메인 버튼
    private var floatingMainBtn: some View {
        ZStack {
            Circle()
                .fill(isShowFloating ? Color.white : Color.floatingBtn)
                .frame(width: FloatingCircleConstants.floatingBgSize.width, height: FloatingCircleConstants.floatingBgSize.height)
                .shadow03()
            
            Image(systemName: FloatingCircleConstants.floatingImage)
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(Color.black)
                .aspectRatio(contentMode: .fit)
                .frame(width: FloatingCircleConstants.floatingImageSize.width, height: FloatingCircleConstants.floatingImageSize.height)
                .rotationEffect(.degrees(isShowFloating ? FloatingCircleConstants.rotationEffectDegree : .zero))
                .animation(.easeInOut(duration: FloatingCircleConstants.rotationAnimation), value: isShowFloating)
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
                    
                    if let category = selectedFloatingMenu {
                        container.navigationRouter.push(to: .tips(.writeTips(category: category)))
                    }
                }
        }
    }
}

#Preview {
    @Previewable @State var isShowFloating: Bool = true
    FloatingCircle(isShowFloating: $isShowFloating)
}
