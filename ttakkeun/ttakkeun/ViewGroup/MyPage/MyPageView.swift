//
//  MyPageView.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/8/24.
//

import SwiftUI

struct MyPageView: View {
    
    //MARK: - Contents
    var body: some View {
        VStack(alignment: .center, content: {
            CustomNavigation(action: {
                print("hello, this is myPage")
            }, title: "마이페이지", currentPage: nil, naviIcon: Image(systemName: "chevron.left"), width: 8, height: 16)
            .padding(.top, 17)
            
            Spacer().frame(height:36)
            
            petInfo
            
            Spacer().frame(height:20)
            
            myPageInfo
            
            Spacer()
        })
        .frame(width: 350)
    }
    
    /// 반려동물 정보 카드
    private var petInfo: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            Text("반려동물 정보")
                .font(.H4_bold)
                .foregroundStyle(Color.gray_900)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .stroke(Color.gray_200)
                .frame(width: 347, height: 178)
        })
    }
    
    /// 앱 정보, 이용정보 - 마이페이지 정보 부분
    private var myPageInfo: some View {
        VStack(alignment: .center, spacing: 15, content: {
            
            appInfo
            
            useInfo
            
        })
    }
    
    /// 앱 정보 칸
    private var appInfo: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.scheduleCard_Color)
                .frame(width: 347, height: 175)
            
            
            VStack(alignment: .leading, spacing: 15, content: {
                
                
                appInfoTitle
                
                appInfoBtns
            })
            .frame(width: 319, height: 128)
            .padding(.leading, 10)
            .padding(.top, -10)
        }
    }
    
    /// 앱 정보 칸 타이틀
    private var appInfoTitle: some View {
        HStack {
            Text("앱 정보")
                .font(.Body2_extrabold)
                .foregroundStyle(Color.gray_900)
            
            Spacer()
        }
    }

    /// 앱 정보 칸 버튼 모음
    private var appInfoBtns: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            ///알림 설정 버튼
            Button(action: {
                print("알림 설정 버튼 눌림")
            }, label: {
                Text("알림 설정")
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray_900)
            })
            
            ///앱 버전 정보 버튼
            Button(action: {
                print("앱 버전 정보 버튼 눌림")
            }, label: {
                Text("앱 버전 정보")
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray_900)
            })
            
            ///이용약관 및 정책 버튼
            Button(action: {
                print("이용약관 및 정책 버튼 눌림")
            }, label: {
                Text("이용약관 및 정책")
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray_900)
            })
        })
    }
    
    /// 이용정보 칸
    private var useInfo: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.scheduleCard_Color)
                .frame(width: 347, height: 175)
            
            
            VStack(alignment: .leading, spacing: 15, content: {
                
                useInfoTitle
                
                useInfoBtns
            })
            .frame(width: 319, height: 128)
            .padding(.leading, 10)
            .padding(.top, -10)
        }
    }
    
    /// 이용정보 칸 타이틀
    private var useInfoTitle: some View {
        HStack {
            Text("이용 정보")
                .font(.Body2_extrabold)
                .foregroundStyle(Color.gray_900)
            
            Spacer()
        }
    }

    /// 이용정보 칸 버튼 모음
    private var useInfoBtns: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            ///공지사항 버튼
            Button(action: {
                print("공지사항 버튼 눌림")
            }, label: {
                Text("공지사항")
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray_900)
            })
            
            ///문의하기 버튼
            Button(action: {
                print("문의하기 버튼 눌림")
            }, label: {
                Text("문의하기")
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray_900)
            })
            
            ///신고하기 버튼
            Button(action: {
                print("신고하기 버튼 눌림")
            }, label: {
                Text("힌고하기")
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray_900)
            })
        })
    }
}


struct MyPageView_Preview: PreviewProvider {
    
    static let devices: [String] = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices , id: \.self) { device in
            MyPageView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
