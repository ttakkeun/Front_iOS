//
//  ReportBtnView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/9/24.
//
import SwiftUI

/// 신고하기 분야 선택 뷰
struct ReportBtnView: View {
    
    var body: some View {
        VStack(alignment: .center, spacing: 40, content: {
            CustomNavigation(action: { print("hello world") },
                             title: "신고하기",
                             currentPage: nil,
                             naviIcon: Image(systemName: "xmark"),
                             width: 16,
                             height: 16)
            
            reportBtns
            
            Spacer()
        })
    }
    
    //MARK: - Components
    /// Detail Info 볼 수 있는 버튼들
    private var reportBtns: some View {
        VStack(alignment: .center, spacing: 17, content: {
            //TODO: 버튼 액션 필요함
            SelectBtnBox(title: "품질 문제 보고", action: {print("품질 문제 보고 버튼 눌림")})
            SelectBtnBox(title: "부적절한 콘텐츠", action: {print("부적절한 콘텐츠 버튼 눌림")})
            SelectBtnBox(title: "개인정보 침해", action: {print("개인정보 침해 버튼 눌림")})
            SelectBtnBox(title: "사기", action: {print("사기")})
        })
    }
    
}

//MARK: - Preview
struct ReportBtnView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            ReportBtnView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}

