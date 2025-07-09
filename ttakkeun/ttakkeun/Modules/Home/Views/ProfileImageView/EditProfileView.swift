//
//  MakeProfileView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/31/24.
//

import SwiftUI
import Kingfisher

struct EditProfileView: View {
    
    @StateObject var viewModel: EditProfileViewModel
    @EnvironmentObject var container: DIContainer
    
    init(container: DIContainer,
         editPetInfo: PetInfo = PetInfo(name: "", type: .dog, variety: "", birth: "", neutralization: false),
         image: String
    ) {
        self._viewModel = StateObject(wrappedValue: .init(container: container, editPetInfo: editPetInfo, image: image))
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
                .presentationDragIndicator(Visibility.visible)
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
                    if let url = URL(string: viewModel.imageUrl) {
                        KFImage(url)
                            .placeholder {
                                ProgressView()
                                    .controlSize(.regular)
                            }.retry(maxCount: 2, interval: .seconds(2))
                            .resizable()
                            .frame(width: 120, height: 120)
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                    }
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
            makeFieldTitle(fieldGroup: FieldGroup(title: "이름",
                                                  mustMark: true,
                                                  isFieldEnable: Binding(
                                                    get: { !viewModel.editPetInfo.name.isEmpty },
                                                    set: { newValue in
                                                        if !newValue {
                                                            viewModel.editPetInfo.name = ""
                                                        }
                                                    })))
            
            makeNameTextField()
        })
        .frame(width: 331, height: 78, alignment: .leading)
    }
    
    private var typeField: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            makeFieldTitle(fieldGroup: FieldGroup(
                        title: "반려동물 종류",
                        mustMark: true,
                        isFieldEnable: Binding(
                            get: {
                                viewModel.editPetInfo.type != nil
                            },
                            set: { newValue in
                                if !newValue {
                                    viewModel.editPetInfo.type = nil
                                }
                            }
                        )
                    ))
            
            ProfileTwoButton(
                selectedButton: Binding(get: { viewModel.editPetInfo.type == nil ? nil : viewModel.editPetInfo.type?.toKorean() },
                                        set: { newValue in
                                            if newValue == "강아지" {
                                                viewModel.editPetInfo.type = .dog
                                            } else if newValue == "고양이" {
                                                viewModel.editPetInfo.type = .cat
                                            }
                                            viewModel.isTypeFieldFilled = true
                                        }),
                firstButton: ButtonOption(
                    textTitle: "강아지",
                    action: {
                    }),
                secondButton: ButtonOption(
                    textTitle: "고양이",
                    action: {
                    }))
        })
        .frame(width: 331, height: 74)
    }
    
    private var varietyField: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            makeFieldTitle(fieldGroup: FieldGroup(title: "품종",
                                                  mustMark: true,
                                                  isFieldEnable: Binding(get: { !viewModel.editPetInfo.variety.isEmpty },
                                                                         set: { newValue in
                if !newValue {
                            viewModel.editPetInfo.variety = ""
                        }
            })))
            
            Button(action: {
                viewModel.showingVarietySearch.toggle()
            }, label: {
                ZStack(alignment: .center, content: {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray200)
                        .frame(width: 331, height: 44)
                        .foregroundStyle(Color.clear)
                    HStack {
                        Text(viewModel.editPetInfo.variety.isEmpty == false ? viewModel.editPetInfo.variety : "반려동물의 품종을 선택해주세요")
                            .font(.Body3_semibold)
                            .foregroundStyle(viewModel.editPetInfo.variety.isEmpty == false ? Color.gray900 : Color.gray200)
                        
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
            makeFieldTitle(fieldGroup: FieldGroup(
                        title: "생년월일",
                        mustMark: false,
                        isFieldEnable: Binding(
                            get: {
                                !viewModel.editPetInfo.birth.isEmpty
                            },
                            set: { newValue in
                                if !newValue {
                                    viewModel.editPetInfo.birth = ""
                                }
                            }
                        )
                    ))
            
            BirthSelect(
                birthDate: Binding(
                    get: { viewModel.editPetInfo.birth },
                    set: {
                        viewModel.editPetInfo.birth = $0
                        viewModel.isBirthFieldFilled = !$0.isEmpty
                    }
                ),
                isBirthFilled: $viewModel.isBirthFieldFilled)
        })
    }
    
    private var neutralizationField: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            makeFieldTitle(fieldGroup: FieldGroup(title: "중성화여부",
                                                  mustMark: true,
                                                  isFieldEnable: Binding(get: {
                viewModel.editPetInfo.neutralization != nil
            },
                                                                         set: { newValue in
                if !newValue {
                    viewModel.editPetInfo.neutralization = nil
                }
            })))
            
            ProfileTwoButton(
                selectedButton: Binding(get: { viewModel.requestData.neutralization == true ? "예" : "아니오" },
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
            btnText: "수정하기",
            height: 56,
            action: {
                if viewModel.isNameFieldFilled && viewModel.isProfileCompleted && viewModel.isBirthFieldFilled && viewModel.isNeutralizationFieldFilled && viewModel.isNeutralizationFieldFilled {
                    viewModel.patchPetProfile()
                }
            },
            color: viewModel.isProfileCompleted ? Color.mainPrimary : Color.gray200)
    }
}

extension EditProfileView {
    
    fileprivate func makeFieldTitle(fieldGroup: FieldGroup) -> HStack<some View> {
        return HStack(content: {
            NameTag(titleText: fieldGroup.title, mustMark: fieldGroup.mustMark)
            
            if fieldGroup.isFieldEnable.wrappedValue {
                Icon.check.image
                    .frame(width: 18, height: 18)
            }
        })
    }
    
    func makeNameTextField() -> CustomTextField {
        return CustomTextField(
            keyboardType: .default,
            text: Binding(
                get: { viewModel.editPetInfo.name },
                set: {
                    viewModel.editPetInfo.name = $0
                    viewModel.isNameFieldFilled = true
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
    let isFieldEnable: Binding<Bool>
}
