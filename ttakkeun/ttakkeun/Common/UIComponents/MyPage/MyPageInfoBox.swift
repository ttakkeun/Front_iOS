//
//  MyPageInfoBox.swift
//  ttakkeun
//
//  Created by 황유빈 on 11/18/24.
//

import SwiftUI

/// 마이페이지 메인화면 인포버튼 들어간 박스들(재사용하기 위해서)
struct MyPageInfoBox: View {
    let myPageInfo: MyPageInfo
    let versionInfo: String?

    //MARK: - Init
    
    /// Description
    /// - Parameters:
    ///   - myPageInfo: 해당 박스에 들어가는 정보듦
    ///   - versionInfo: 앱 버전(선택 사항)
    init(myPageInfo: MyPageInfo, versionInfo: String? = nil) {
        self.myPageInfo = myPageInfo
        self.versionInfo = versionInfo
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text(myPageInfo.title)
                    .font(.Body2_extrabold)
                    .foregroundStyle(Color.gray900)
                
                if let text = versionInfo {
                    Spacer()
                    
                    Text(text)
                        .font(.Body4_medium)
                        .foregroundStyle(Color.gray300)
                }
            }
            
            /// 버튼 리스트
            buttonList()
        }
        .frame(width: 320, alignment: .leading)
        .padding(.vertical, 15)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.answerBg)
        )
    }
    
    @ViewBuilder
    private func buttonList() -> some View {
        ForEach(myPageInfo.boxBtn) { button in
            Button(action: {
                button.action()
            }) {
                Text(button.name)
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray900)
            }
        }
    }
}

//MARK: - Preview
struct MypageInfoBox_Preview: PreviewProvider {
    static var previews: some View {
        let myPageInfo = MyPageInfo(
            title: "앱 정보",
            boxBtn: [
                BtnInfo(name: "알림 설정", date: nil, action: { print("알림 설정 버튼 눌림") }),
                BtnInfo(name: "앱 버전 정보", date: nil, action: { print("앱 버전 정보 버튼 눌림") }),
                BtnInfo(name: "이용약관 및 정책", date: nil, action: { print("이용약관 및 정책 버튼 눌림") })
            ]
        )
        
        MyPageInfoBox(myPageInfo: myPageInfo)
            .previewLayout(.sizeThatFits)
    }
}
