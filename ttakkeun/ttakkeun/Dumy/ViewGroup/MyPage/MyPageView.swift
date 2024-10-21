//
//  MyPageView.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/8/24.
//

import SwiftUI
import Kingfisher

struct MyPageView: View {
    
    @StateObject var viewModel: MyPageViewModel
    let petId: Int
    
    
    //MARK: - Init
    init(petId: Int) {
        self._viewModel = StateObject(wrappedValue: MyPageViewModel())
        self.petId = petId
    }
    
    //MARK: - Contents
    var body: some View {
        VStack(alignment: .center, content: {
            CustomNavigation(action: {
                //TODO: 마이페이지 아이콘 버튼 눌렀을 때 액션 함수 처리
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
    
    
    /// 반려동물 정보 타이틀 + 카드
    private var petInfo: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            Text("반려동물 정보")
                .font(.H4_bold)
                .foregroundStyle(Color.gray_900)
            
            petInfoCard
        })
        .onAppear {
            Task {
                await viewModel.getPetProfileInfo(petId: petId)
            }
        }
    }
    
    ///반려동물 정보 카드
    private var petInfoCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .stroke(Color.gray_200)
                .frame(width: 347, height: 178)
            
            VStack(alignment: .center, spacing: 22, content: {
                HStack {
                    if let imageUrl = viewModel.profileData?.image,
                       let url = URL(string: imageUrl) {
                        KFImage(url)
                            .placeholder {
                                ProgressView()
                                    .frame(width: 100, height: 100)
                            }.retry(maxCount: 2, interval: .seconds(2))
                            .onFailure { _ in
                                print("프로필 이미지 캐시 오류")
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .shadow01()
                    }
                    
                    Spacer().frame(width: 15)
                    
                    if let name = viewModel.profileData?.name {
                        Text(name)
                            .font(.H4_bold)
                            .foregroundStyle(Color.gray_900)
                    }
                    
                    Spacer().frame(width: 109)
                    
                    Button(action: {
                        //TODO: 프로필 바꾸기 버튼 눌렸을 때 액션 함수
                        print("프로필 바꾸기 버튼 눌림 -> 프로필 화면으로")
                    }, label: {
                        Text("프로필 바꾸기")
                            .frame(width:82, height: 33)
                            .font(.Body4_semibold)
                            .foregroundStyle(Color.primarycolor_700)
                            .background(Color.primarycolor_400)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .overlay(RoundedRectangle(cornerRadius: 30)
                                .fill(Color.clear)
                                .frame(width: 82, height: 33))

                    })
                }
                
                /// Mainbutton 텍스트 폰트 정할 수 있으면 재활용 가능할듯!
                /// 일단 텍스트 폰트 설정 불가해서 직접 만듦
                Button(action: {
                    //TODO: 정보 수정하기 버튼 눌렸을 때 액션 함수
                    print("정보 수정하기 버튼 눌림 -> 반려동물 정보 변경")
                }, label: {
                    Text("정보 수정하기")
                        .frame(width: 307, height: 42)
                        .font(.Body3_medium)
                        .foregroundStyle(Color.gray_900)
                        .background(Color.scheduleCard_Color)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .fill(Color.clear)
                            .frame(width: 307, height: 42))
                })
            })
        }
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
        infoCard(title: "앱 정보", btns: appInfoBtns)
    }

    /// 앱 정보 칸 버튼 모음
    private var appInfoBtns: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            ///알림 설정 버튼
            //TODO: 알림 설정 버튼 눌렸을 때 액션 함수
            makeBtn(action: {print("알림 설정 버튼 눌림")}, text: "알림 설정")
            
            ///앱 버전 정보 버튼
            //TODO: 앱 버전 정보 버튼 눌렸을 때 액션 함수
            makeBtn(action: {print("앱 버전 정보 버튼 눌림")}, text: "앱 버전 정보")
            
            ///이용약관 및 정책 버튼
            //TODO: 이용약관 및 정책 버튼 눌렸을 때 액션 함수
            makeBtn(action: {print("이용약관 및 정책 버튼 눌림")}, text: "이용약관 및 정책")
        })
    }
    
    /// 이용정보 칸
    private var useInfo: some View {
        infoCard(title: "이용 정보", btns: useInfoBtns)
    }

    /// 이용정보 칸 버튼 모음
    private var useInfoBtns: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            ///공지사항 버튼
            //TODO: 공지사항 버튼 눌렸을 때 액션 함수
            makeBtn(action: {print("공지사항 버튼 눌림")}, text: "공지사항")
            

            ///문의하기 버튼
            //TODO: 문의하기 버튼 눌렸을 때 액션 함수
            makeBtn(action: {print("문의하기 버튼 눌림")}, text: "문의하기")
            
            ///신고하기 버튼
            //TODO: 신고하기 버튼 눌렸을 때 액션 함수
            makeBtn(action: {print("신고하기 버튼 눌림")}, text: "신고하기")
        })
    }
}

//MARK: - Function
///마이페이지 정보(앱 정보, 이용 정보) 같은 구조 -> 재활용하기 위한 함수
private func infoCard(title: String, btns: some View) -> some View {
    ZStack {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.scheduleCard_Color)
            .frame(width: 347, height: 175)
        
        
        VStack(alignment: .leading, spacing: 15, content: {
            
            makeTitle(title: title)
            
            btns
        })
        .frame(width: 319, height: 128)
        .padding(.top, -10)
        .padding(.leading, -10)
    }
}

///타이틀 생성 재활용 하기 위한 함수
private func makeTitle(title: String) -> some View {
    Text(title)
        .font(.Body2_extrabold)
        .foregroundStyle(Color.gray_900)
        .frame(width: 300, alignment: .leading)
}


///버튼 생성 재활용 하기 위한 함수
private func makeBtn(action: @escaping () -> Void, text: String) -> some View {
    Button(action: {
        action()
    }, label: {
        Text(text)
            .font(.Body3_medium)
            .foregroundStyle(Color.gray_900)
    })
}

//MARK: - Preview
struct MyPageView_Preview: PreviewProvider {
    
    static let devices: [String] = ["iPhone 11", "iPhone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices , id: \.self) { device in
            MyPageView(petId: 1)
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
