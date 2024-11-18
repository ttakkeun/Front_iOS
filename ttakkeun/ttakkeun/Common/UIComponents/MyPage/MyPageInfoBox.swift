//
//  MyPageInfoBox.swift
//  ttakkeun
//
//  Created by 황유빈 on 11/18/24.
//

import SwiftUI

struct MyPageInfoBox: View {
    let myPageInfo: MyPageInfo
    let versionInfo: String?

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
            
            /// 첫 번째 버튼
            Button(action: {
                myPageInfo.firstBtn.action()
            }) {
                Text(myPageInfo.firstBtn.name)
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray900)
            }
            
            /// 두 번째 버튼
            Button(action: {
                myPageInfo.secondBtn.action()
            }) {
                Text(myPageInfo.secondBtn.name)
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray900)
            }
            
            /// 세 번째 버튼
            if let thirdButton = myPageInfo.thirdBtn {
                Button(action: {
                    thirdButton.action()
                }) {
                    Text(thirdButton.name)
                        .font(.Body3_medium)
                        .foregroundStyle(Color.gray900)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 15)
        .frame(width: 347, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.answerBg)
        )
    }
}

struct MypageInfoBox_Preview: PreviewProvider {
    static var previews: some View {
        let myPageInfo = MyPageInfo(
            title: "앱 정보",
            firstBtn: BtnInfo(name: "알림 설정", action: { print("알림 설정 버튼 눌림") }),
            secondBtn: BtnInfo(name: "앱 버전 정보", action: { print("앱 버전 정보 버튼 눌림") }),
            thirdBtn: BtnInfo(name: "이용약관 및 정책", action: { print("이용약관 및 정책 버튼 눌림")})
        )
        
        MyPageInfoBox(myPageInfo: myPageInfo)
            .previewLayout(.sizeThatFits)
    }
}
