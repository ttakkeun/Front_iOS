//
//  MyPageDetailView.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/10/24.
//

import SwiftUI

struct MyPageDetailView: View {
    
    //MARK: - Contents
    var body: some View {
        VStack(alignment: .center, content: {
            CustomNavigation(action: {
                print("hello, this is myPageDetail")
            }, title: "마이페이지", currentPage: nil, naviIcon: Image(systemName: "chevron.left"), width: 8, height: 16)
            .padding(.top, 17)
            
            Spacer().frame(height: 56)
            
            petInfoDetailCard
            
            Spacer().frame(height: 23)
            
            account
            
            Spacer()
            
        })
        .frame(width: 350)
    }
    
    /// 반려동물 정보 디테일 카드
    private var petInfoDetailCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .stroke(Color.gray_200)
                .frame(width: 347, height: 242)
            
            VStack(alignment: .leading, spacing: 18, content: {
                
                petInfoDetailNameTag
                    .padding(.top, -7)
                
                petInfoDetail
                
            })
        }
    }
    
    ///반려동물 정보 디테일 카드 네임태그
    private var petInfoDetailNameTag: some View {
        HStack(alignment: .center, spacing: 197, content: {
            Text("내 정보")
                .font(.H4_bold)
                .foregroundStyle(Color.gray_900)
            
            Button(action: {
                print("수정 버튼 눌림")
            }, label: {
                HStack(alignment: .center, spacing: 5, content: {
                    Icon.pencil.image
                    
                    Text("수정")
                        .font(.Body4_semibold)
                        .foregroundStyle(Color.gray_300)
                })
                .frame(width:61, height: 26.89)
                .background(Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .stroke(Color.gray_200, lineWidth: 1)
                )
            })
        })
    }
    
    
    ///반려동물 디테일 정보 카드
    //TODO: 프로필 데이터 홈에서 받아온 데이터값 받을 수 있도록 해야함
    private var petInfoDetail: some View {
        VStack(alignment: .leading, spacing: 18, content: {
            makeInfo(nametag: "이름", content: "유애", spacing: 72)
            makeInfo(nametag: "반려", content: "고양이", spacing: 72)
            makeInfo(nametag: "품종", content: "코리안 쇼트 헤어", spacing: 72)
            makeInfo(nametag: "생년월일", content: "2022년 3월 4일", spacing: 48)
            makeInfo(nametag: "중성화 여부", content: "유", spacing: 32)

        })
    }
    
    ///계정 관련된 기능 제공 카드
    private var account: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.scheduleCard_Color)
                .frame(width: 347, height: 164)
            
            VStack(alignment: .leading, spacing: 15, content: {
                
                accountTitle
                
                accountBtns
            })
            .frame(width: 319, height: 128)
            .padding(.leading, 10)
        }
    }
    
    /// 계정 관련된 기능 제공 카드 타이틀
    private var accountTitle: some View {
        HStack {
            Text("계정")
                .font(.Body2_extrabold)
                .foregroundStyle(Color.gray_900)
            
            Spacer()
        }
    }

    /// 계정 관련된 기능 제공 버튼 모음
    private var accountBtns: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            ///알림 설정 버튼
            Button(action: {
                print("로그아웃하기 버튼 눌림")
            }, label: {
                Text("로그아웃하기")
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray_900)
            })
            
            ///앱 버전 정보 버튼
            Button(action: {
                print("프로필 삭제하기 버튼 눌림")
            }, label: {
                Text("프로필 삭제하기")
                    .font(.Body3_medium)
                    .foregroundStyle(Color.gray_900)
            })
            
            ///이용약관 및 정책 버튼
            Button(action: {
                print("탈퇴하기 버튼 눌림")
            }, label: {
                Text("탈퇴하기")
                    .font(.Body3_medium)
                    .foregroundStyle(Color.exit_Color)
            })
        })
    }
}


//MARK: - function
///내 정보 내용들 다 똑같은 구조 가지고 있어서 뷰 생성에 재활용하기 위한 함수
private func makeInfo(nametag: String, content: String, spacing: CGFloat) -> some View {
    HStack(alignment: .center, spacing: spacing, content: {
        Text(nametag)
            .font(.Body3_medium)
            .foregroundStyle(Color.gray_700)
        
        Text(content)
            .font(.Body3_medium)
            .foregroundStyle(Color.gray_900)
    })
}

//MARK: - preview
struct MyPageDetailView_Preview: PreviewProvider {
    
    static let devices: [String] = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices , id: \.self) { device in
            MyPageDetailView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
