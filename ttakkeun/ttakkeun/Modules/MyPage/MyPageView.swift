//
//  MyPageView.swift
//  ttakkeun
//
//  Created by 황유빈 on 11/12/24.
//

import SwiftUI

struct MyPageView: View {
    
    var body: some View {
        VStack(alignment: .center, spacing: 37, content: {
            CustomNavigation(action: { print("hello world") },
                             title: "마이페이지",
                             currentPage: nil,
                             naviIcon: Image(systemName: "chevron.left"),
                             width: 8,
                             height: 16)
            
            myInfo
            
            myPageInfo
        })
    }
    
    /// 내 프로필과 콘텐츠들(프로필, 내가 쓴 tips, 스크랩한 tips)
    private var myInfo: some View {
        VStack(alignment: .center, spacing: 17, content: {
            profile
            tipsBtns
        })
    }
    
    /// 프로필 필드(사진, 닉네임, 이메일, 닉네임 수정버튼)
    private var profile: some View {
        HStack(alignment: .center, spacing: 12, content: {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .aspectRatio(contentMode: .fill)
                .tint(Color.gray300)
            
            VStack(alignment: .leading, spacing: 6,content: {
                Text("날아가는 붕붕이")
//                Text(\(UserState.shared.getUserName()))
                    .font(.H4_bold)
                Text("534re@kakaocom") // 여기 @랑 .이 같이 들어가면 출력이 안돼요..
//                Text(\(UserState.shared.getUserName()))
                    .font(.Body4_semibold)
            })
            
            Spacer()
            
            Button(action: {
                print("hello world")
            }, label: {
                Text("닉네임 수정")
                    .font(.Body4_medium)
                    .foregroundStyle(Color.gray900)
                    .frame(width: 78, height: 31)
                    .background(content: {
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color.primarycolor300)
                    })
            })
        })
        .frame(width:348, height: 60)
    }
    
    /// tips 버튼들(내가 쓴 tips, 내가 스크랩한 tips)
    private var tipsBtns: some View {
        HStack(alignment: .center, spacing: 13, content: {
            makeButton(text: "내가 쓴 tips", image: Icon.tips.image, action: {print("내가 쓴 tips 버튼 눌림")})
            makeButton(text: "내가 스크랩한 tips", image: Icon.scrap.image, action: {print("내가 스크랩한 tips 버튼 눌림")})
        })
    }
    
    /// 아래 myPage 기능들
    private var myPageInfo: some View {
        VStack(alignment: .center, spacing: 21,content: {
            ///앱 정보 박스
            MyPageInfoBox(myPageInfo: MyPageInfo(
                title: "앱 정보",
                firstBtn: BtnInfo(name: "알림 설정", action: { print("알림 설정 버튼 눌림") }),
                secondBtn: BtnInfo(name: "이용약관 및 정책", action: { print("이용약관 및 정책 버튼 눌림") }), thirdBtn: nil
            ), versionInfo: "v1.0.0")
            
            ///이용정보 박스
            MyPageInfoBox(myPageInfo: MyPageInfo(
                title: "이용 정보",
                firstBtn: BtnInfo(name: "공지사항", action: { print("공지사항 버튼 눌림") }),
                secondBtn: BtnInfo(name: "문의하기", action: { print("문의하기 버튼 눌림") }),
                thirdBtn: BtnInfo(name: "신고하기", action: { print("신고하기 버튼 눌림")})
            ))
            
            ///계정 박스
            MyPageInfoBox(myPageInfo: MyPageInfo(
                title: "계정",
                firstBtn: BtnInfo(name: "로그아웃하기", action: { print("로그아웃하기 버튼 눌림") }),
                secondBtn: BtnInfo(name: "프로필 삭제하기", action: { print("프로필 삭제하기 버튼 눌림") }),
                thirdBtn: BtnInfo(name: "탈퇴하기", action: { print("탈퇴하기 버튼 눌림")})
            ))
        })
    }
}

//MARK: - Function
extension MyPageView {
    /// 내가 쓴 tips, 스크랩한 tips 버튼 커스텀
    private func makeButton(text: String, image: Image , action: @escaping () -> Void) -> some View {
        
        Button(action: {
            //TODO: 버튼 액션필요
        }, label: {
            VStack(alignment: .center, spacing: 13, content: {
                image
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(text)
                    .font(.Body3_semibold)
                    .foregroundStyle(Color.gray900)
            })
            .frame(width: 167, height: 96)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.clear)
                    .stroke(Color.gray200, lineWidth: 1)
            )
        })
    }
}

//MARK: - Preview
struct MyPageView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            MyPageView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
