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
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, content: {
                ///네비게이션 바
                CustomNavigation(action: {
                    print("hello, this is myPage")
                }, title: "마이페이지", currentPage: nil, naviIcon: Image(systemName: "chevron.left"))
                
                Spacer().frame(height:36)
                
                petInfo
                
                Spacer().frame(height:20)
                
                myPageInfo
            })
            .frame(width: 350)
            .padding(.horizontal, 10)
        }
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
    
    /// 반려동물 정보 카드
    private var myPageInfo: some View {
        VStack(alignment: .center, spacing: 15, content: {
            myTips
            
            appInfo
            
            useInfo
            
            
        })
    }
    
    /// 나의 TIPS 모음
    private var myTips: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.scheduleCard_Color)
                .frame(width: 347, height: 175)
            
            
            VStack(alignment: .leading, spacing: 11, content: {
                myTipsTitle
                myTipsButton
            })
            .frame(width: 319, height: 128)
            .border(Color.black)
            .padding(.leading, 10) // 좌측 여백 추가
        }
    }
    
    /// 나의 TIPS 타이틀
    private var myTipsTitle: some View {
        HStack(alignment: .center, spacing: 1.5, content: {
            Icon.heartTips.image
            
            Text("TIPS")
                .font(.H4_bold)
                .foregroundStyle(Color.gray_900)
        })
    }
    
    /// 나의 TIPS 모음에 있는 텍스트 버튼 모음
    private var myTipsButton: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            ///내가 쓴 tips 버튼
            Button(action: {
                
            }, label: {
                Text("내가 쓴 tips")
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray_900)
            })
            
            ///내가 좋아요한 tips 버튼
            Button(action: {
                
            }, label: {
                Text("내가 좋아요한 tips")
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray_900)
            })
            
            ///내가 스크랩한 tips 버튼
            Button(action: {
                
            }, label: {
                Text("내가 스크랩한 tips")
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray_900)
            })
        })
    }
    
    /// 앱 정보 칸
    private var appInfo: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.scheduleCard_Color)
            .frame(width: 347, height: 175)
    }
    
    /// 이용 정보 칸
    private var useInfo: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.scheduleCard_Color)
            .frame(width: 347, height: 175)
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
