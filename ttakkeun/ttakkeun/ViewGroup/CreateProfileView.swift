//
//  CreateProfileView.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/30/24.
//

import SwiftUI

struct CreateProfileView: View {
    
    @StateObject var viewModel: CreateProfileViewModel
    
    var body: some View {
        VStack {
            
            //TODO: - 프로필 사진 등록
            ///우선 그냥 동그라미 넣어둠
            Circle()
                .fill(Color.black)
                .frame(width: 120, height: 120)
            
            Spacer().frame(height: 21)
            
            infoField
            
            Spacer().frame(height: 72)
            
            registerBtn
        }
        .onAppear(perform: {
            UIApplication.shared.hideKeyboard()
        })
    }
    
    ///정보 입력 필드
    private var infoField: some View {
        VStack(alignment: .center, spacing: 19, content: {
            nameField
            typeField
            varietyField
            birthField
            neutralizationField
        })
    }
    
    /// 이름 name tag + text field
    private var nameField: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            HStack() {
                MakeProfileNameTag(titleText: "이름", mustMark: true)
                
                Spacer().frame(width: 0)
                
                if viewModel.isNameFilled {
                    Icon.check.image
                        .frame(width: 18, height: 18)
                }
            }
            
            if let requestData = viewModel.requestData {
                CustomTextField(
                    text: Binding(
                        get: { requestData.name },
                        set: {
                            viewModel.requestData?.name = $0
                            viewModel.isNameFilled = !$0.isEmpty
                        }
                    ),
                    placeholder: "반려동물의 이름을 입력해주세요",
                    fontSize: 14,
                    cornerRadius: 10,
                    padding: 23,
                    showGlass: false,
                    maxWidth: 331,
                    maxHeight: 44
                )
                .onAppear(perform: {
                    UIApplication.shared.hideKeyboard()
                })
            }
        })
        .frame(width: 331, height: 78, alignment: .leading)
    }
    
    /// 동물 종류(강아지/고양이) name tag + toggle button
    private var typeField: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            HStack() {
                MakeProfileNameTag(titleText: "반려", mustMark: true)
                
                Spacer().frame(width: 0)
                
                if viewModel.isTypeFilled {
                    Icon.check.image
                        .frame(width: 18, height: 18)
                }
            }
            
            MakeProfileButtonCustom(
                firstText: "강아지",
                secondText: "고양이",
                leftAction: {
                    viewModel.requestData?.type = .dog
                    viewModel.isTypeFilled = true
                },
                rightAction: {
                    viewModel.requestData?.type = .cat
                    viewModel.isTypeFilled = true
                }
            )
        })
        .frame(width: 331, height: 78)
    }
    
    /// 동물 품종 name tag + text field
    private var varietyField: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            HStack() {
                MakeProfileNameTag(titleText: "품종", mustMark: true)
                
                Spacer().frame(width: 0)
                
                if viewModel.isVarietyFilled {
                    Icon.check.image
                        .frame(width: 18, height: 18)
                }
            }
            
            if let requestData = viewModel.requestData {
                CustomTextField(
                    text: Binding(
                        get: { requestData.variety },
                        set: {
                            viewModel.requestData?.variety = $0
                            viewModel.isVarietyFilled = !$0.isEmpty
                        }),
                    placeholder: "반려동물의 품종을 입력해주세요.",
                    fontSize: 14,
                    cornerRadius: 10,
                    padding: 23,
                    showGlass: false,
                    maxWidth: 331,
                    maxHeight: 44
                )
                .ignoresSafeArea(.keyboard)
            }
        })
        .frame(width: 331, height: 80)
    }
    
    /// 생년월일 name tag + text field
    private var birthField: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            HStack() {
                MakeProfileNameTag(titleText: "생년월일", mustMark: false)
                
                Spacer().frame(width: 0)
                
                if viewModel.isBirthFilled {
                    Icon.check.image
                        .frame(width: 18, height: 18)
                }
            }
            
            if let requestData = viewModel.requestData {
                BirthSelect(
                    birthDate: Binding(
                        get: { requestData.birth },
                        set: { 
                            viewModel.requestData?.birth = $0
                            viewModel.isBirthFilled = !$0.isEmpty
                        }
                    ),
                    isBirthFilled: $viewModel.isBirthFilled
                )
            }
        })
        .frame(width: 331, height: 74)
    }
    
    /// 중성화 여부 name tag + text field
    private var neutralizationField: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            HStack() {
                MakeProfileNameTag(titleText: "중성화여부", mustMark: true)
                
                Spacer().frame(width: 0)
                
                if viewModel.isNeutralizationFilled {
                    Icon.check.image
                        .frame(width: 18, height: 18)
                }
            }
            
            MakeProfileButtonCustom(
                firstText: "예",
                secondText: "아니오",
                leftAction: {
                    viewModel.requestData?.neutralization = true
                    viewModel.isNeutralizationFilled = true
                },
                rightAction: {
                    viewModel.requestData?.neutralization = false
                    viewModel.isNeutralizationFilled = true
                }
            )
        })
        .frame(width: 331, height: 80)
    }
    
    /// 등록하기 버튼
    private var registerBtn: some View {
        MainButton(btnText: "등록하기", width: 330, height: 56, action: {
            if viewModel.isProfileCompleted {
                print("마지막 버튼 눌림")
            } else {
                print("모든 필드를 입력해주세요.")
            }
            print("Test")
        }, color: Color.primaryColor_Main)
        .disabled(!viewModel.isProfileCompleted)
    }
}


//MARK: - Preview
struct CreateProfileView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iphone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            CreateProfileView(viewModel: CreateProfileViewModel())
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}