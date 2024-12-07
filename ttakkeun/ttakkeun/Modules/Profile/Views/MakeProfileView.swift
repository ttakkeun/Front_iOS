//
//  MakeProfileView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/31/24.
//

import SwiftUI

struct MakeProfileView: View {
    
    @StateObject var viewModel: MakeProfileViewModel
    @EnvironmentObject var container: DIContainer
    
    
    init(container: DIContainer
    ) {
        self._viewModel = StateObject(wrappedValue: .init(container: container))
    }
    
    var body: some View {
        VStack {
            CustomNavigation(
                action: {
                    container.navigationRouter.pop()
                }, title: "프로필 생성", currentPage: nil)
            
            Spacer().frame(height: 20)
            
            profileImage
            
            Spacer().frame(height: 25)
            
            inputFieldGroup
            
            Spacer()
            
            registerBtn
        }
        .safeAreaPadding(EdgeInsets(top: 7, leading: 0, bottom: 20, trailing: 0))
        .navigationBarBackButtonHidden(true)
        .onAppear {
            UIApplication.shared.hideKeyboard()
        }
        .sheet(isPresented: $viewModel.showingVarietySearch) {
            VarietySearchView(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.isImagePickerPresented, content: {
            ImagePicker(imageHandler: viewModel, selectedLimit: 1)
        })
    }
    
    private var inputFieldGroup: some View {
        VStack(alignment: .center, spacing: 20, content: {
            Group {
                nameField
                typeField
                varietyField
                birthField
                neutralizationField
            }
        })
    }
    
    @ViewBuilder
    private var profileImage: some View {
        VStack {
            Button(action: {
                viewModel.showImagePicker()
            }, label: {
                if viewModel.profileImage.isEmpty {
                    Image(systemName: "questionmark.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .aspectRatio(contentMode: .fill)
                        .tint(Color.gray300)
                } else {
                    if let image = viewModel.profileImage.first {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 120)
                            .shadow02()
                            .clipShape(Circle())
                    }
                }
            })
        }
    }
    
    private var nameField: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            makeFieldTitle(fieldGroup: FieldGroup(title: "이름", mustMark: true, isFieldEnable: viewModel.isNameFieldFilled))
            
            makeNameTextField()
        })
        .frame(width: 331, height: 78, alignment: .leading)
    }
    
    private var typeField: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            makeFieldTitle(fieldGroup: FieldGroup(title: "반려동물 종류", mustMark: true, isFieldEnable: viewModel.isTypeFieldFilled))
            
            ProfileTwoButton(
                selectedButton: Binding(
                    get: { viewModel.requestData.type?.toKorean() },
                    set: { newValue in
                        if newValue == "강아지" {
                            viewModel.requestData.type = .dog
                        } else if newValue == "고양이" {
                            viewModel.requestData.type = .cat
                        }
                        viewModel.isTypeFieldFilled = true
                    }
                ),
                firstButton: ButtonOption(
                    textTitle: "강아지",
                    action: {}
                ),
                secondButton: ButtonOption(
                    textTitle: "고양이",
                    action: {}
                )
            )
        })
        .frame(width: 331, height: 74)
    }
    
    private var varietyField: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            makeFieldTitle(fieldGroup: FieldGroup(title: "품종", mustMark: true, isFieldEnable: viewModel.isVarietyFieldFilled))
            
            Button(action: {
                viewModel.showingVarietySearch.toggle()
            }, label: {
                ZStack(alignment: .center, content: {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray200)
                        .frame(width: 331, height: 44)
                        .foregroundStyle(Color.clear)
                    HStack {
                        Text(viewModel.requestData.variety.isEmpty == false ? viewModel.requestData.variety : "반려동물의 품종을 선택해주세요")
                            .font(.Body3_semibold)
                            .foregroundStyle(viewModel.requestData.variety.isEmpty == false ? Color.gray900 : Color.gray200)
                        
                        Spacer()
                        
                        Icon.bottomArrow.image
                            .resizable()
                            .frame(width: 16, height: 16)
                    }
                    .frame(width: 300, alignment: .leading)
                })
            })
        })
        .frame(width: 331, height: 74)
    }
    
    private var birthField: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            makeFieldTitle(fieldGroup: FieldGroup(title: "생년월일", mustMark: false, isFieldEnable: viewModel.isBirthFieldFilled))
            
            BirthSelect(
                birthDate: Binding(
                    get: { viewModel.requestData.birth },
                    set: {
                        viewModel.requestData.birth = $0
                        viewModel.isBirthFieldFilled = !$0.isEmpty
                    }
                ),
                isBirthFilled: $viewModel.isBirthFieldFilled)
        })
    }
    
    private var neutralizationField: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            makeFieldTitle(fieldGroup: FieldGroup(title: "중성화여부", mustMark: true, isFieldEnable: viewModel.isNeutralizationFieldFilled))
            
            ProfileTwoButton(
                selectedButton: Binding(get: { viewModel.requestData.neutralization == nil ? nil : (viewModel.requestData.neutralization! ? "예" : "아니오") },
                                        set: { newValue in
                                            viewModel.requestData.neutralization = (newValue == "예")
                                            viewModel.isNeutralizationFieldFilled = true
                                        }),
                firstButton: ButtonOption(
                    textTitle: "예",
                    action: {
                    }), secondButton: ButtonOption(
                        textTitle: "아니오",
                        action: {
                        }
                    ))
        })
        .frame(width: 331, height: 74)
    }
    
    private var registerBtn: some View {
        MainButton(
            btnText: "등록하기",
            width: 330,
            height: 56,
            action: {
                if viewModel.isProfileCompleted {
                    viewModel.makePetProfile()
                }
            },
            color: viewModel.isProfileCompleted ? Color.mainPrimary : Color.gray200)
    }
}

extension MakeProfileView {
    
    fileprivate func makeFieldTitle(fieldGroup: FieldGroup) -> HStack<some View> {
        return HStack(content: {
            NameTag(titleText: fieldGroup.title, mustMark: fieldGroup.mustMark)
            
            if fieldGroup.isFieldEnable {
                Icon.check.image
                    .frame(width: 18, height: 18)
            }
        })
    }
    
    func makeNameTextField() -> CustomTextField {
        return CustomTextField(
            keyboardType: .default,
            text: Binding(
                get: { viewModel.requestData.name },
                set: {
                    viewModel.requestData.name = $0
                    viewModel.isNameFieldFilled = !$0.isEmpty
                }
            ),
            placeholder: "반려동물의 이름을 입력해주세요",
            fontSize: 14,
            cornerRadius: 10,
            padding: 23,
            maxWidth: 331,
            maxHeight: 44
        )
    }
}

fileprivate struct FieldGroup {
    let title: String
    let mustMark: Bool
    let isFieldEnable: Bool
}


struct MakeProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MakeProfileView(container: DIContainer())
    }
}
