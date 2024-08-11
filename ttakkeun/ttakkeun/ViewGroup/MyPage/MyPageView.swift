//
//  MyPageView.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/8/24.
//

import SwiftUI
import Kingfisher

struct MyPageView: View {
    
    @ObservedObject var viewModel: MyPageViewModel
    @EnvironmentObject var petState: PetState
    let petId: Int
    
    //MARK: - Init
    init(viewModel: MyPageViewModel, petId: Int) {
        self.viewModel = viewModel
        self.petId = petId
    }
    
    //MARK: - Contents
    var body: some View {
        VStack(alignment: .center, content: {
            CustomNavigation(action: {
                print("hello, this is myPage")
            }, title: "마이페이지", currentPage: nil, naviIcon: Image(systemName: "chevron.left"), width: 8, height: 16)
            .padding(.top, 17)
            
            Spacer().frame(height:36)
            
            petInfo
                .onAppear {
                    Task {
                        await viewModel.getPetProfileInfo(petId: petId)
                    }
                }
            
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
                    //TODO: 프로필 데이터 홈에서 받아온 데이터값 받을 수 있도록 해야함
                    if let imageUrl = viewModel.profileData?.result.image,
                       let url = URL(string: imageUrl) {
                        KFImage(url)
                            .placeholder {
                                ProgressView()
                                    .frame(width: 70, height: 70)
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
                    
                    //TODO: 프로필 데이터 홈에서 받아온 데이터값 받을 수 있도록 해야함
                    if let name = viewModel.profileData?.result.name {
                        Text(name)
                            .font(.H4_bold)
                    }
                    
                    Spacer().frame(width: 109)
                    
                    Button(action: {
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
                Text("신고하기")
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
            MyPageView(viewModel: MyPageViewModel(), petId: PetState().petId ?? 0)
                .environmentObject(PetState())
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
