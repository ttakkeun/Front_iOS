//
//  MakeProfileView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/31/24.
//

import SwiftUI
import PhotosUI

struct MakeProfileView: View {
    
    // MARK: - Property
    @State var viewModel: MakeProfileViewModel
    @EnvironmentObject var container: DIContainer
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Constants
    fileprivate enum MakeProfileConstants {
        static let fieldVspacing: CGFloat = 10
        static let mainVspacing: CGFloat = 25
        static let fieldsVspacing: CGFloat = 20
        
        static let safeHorizonPadding: CGFloat = 31
        static let safeTopPadding: CGFloat = 33
        static let varietyLeadingPadding: CGFloat = 22
        static let varietyTrailingPadding: CGFloat = 16
        
        static let profileImageSize: CGFloat = 120
        static let checkImageSize: CGFloat = 18
        static let varietyIconSize: CGFloat = 16
        static let varietyHeight: CGFloat = 44
        
        static let cornerRadius: CGFloat = 10
        
        static let profileImage: String = "questionmark.circle.fill"
        static let namePlaceholder: String = "반려동물의 이름을 입력해주세요."
        
        static let nameText: String = "이름"
        static let petTypeText: String = "반려동물 종류"
        static let varietyFieldText: String = "품종"
        static let birthDayFieldText: String = "생년월일"
        static let neutralFieldText: String = "중성화여부"
        
        static let petTypeDogName: String = "강아지"
        static let petTypeCatName: String = "고양이"
        static let varietyFieldGuideText: String = "반려동물의 품종을 선택해주세요"
        static let neutralYesText: String = "예"
        static let neutralNoText: String = "아니오"
        static let registerBtnText: String = "등록하기"
    }
    
    // MARK: - Init
    init(
        container: DIContainer,
    ) {
        self.viewModel = .init(container: container)
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: MakeProfileConstants.mainVspacing, content: {
            profileImage
            inputFieldGroup
            Spacer()
            registerBtn
        })
        .safeAreaPadding(.horizontal, MakeProfileConstants.safeHorizonPadding)
        .safeAreaPadding(.top, MakeProfileConstants.safeTopPadding)
        .sheet(isPresented: $viewModel.showingVarietySearch) {
            VarietySearchView(viewModel: viewModel)
        }
        .photosPicker(isPresented: $viewModel.showImagePickerPresented,
                      selection: $viewModel.selectedItem,
                      matching: .images,
                      photoLibrary: .shared())
        .loadingOverlay(isLoading: viewModel.isLoading, loadingTextType: .createProfile)
        .onChange(of: viewModel.selectedItem, { old, new in
            Task {
                await viewModel.loadImage(new)
            }
        })
    }
    
    // MARK: - FieldGroup
    private var inputFieldGroup: some View {
        VStack(alignment: .center, spacing: MakeProfileConstants.fieldsVspacing, content: {
            Group {
                makeFieldView(contents: {
                    nameField
                }, fieldGroup: .init(title: MakeProfileConstants.nameText, mustMark: true, isFieldEnable: viewModel.isNameFieldFilled))
                
                makeFieldView(contents: {
                    typeField
                }, fieldGroup: .init(title: MakeProfileConstants.petTypeText, mustMark: true, isFieldEnable: viewModel.isTypeFieldFilled))
                
                makeFieldView(contents: {
                    varietyField
                }, fieldGroup: .init(title: MakeProfileConstants.varietyFieldText, mustMark: true, isFieldEnable: viewModel.isVarietyFieldFilled))
                
                makeFieldView(contents: {
                    birthField
                }, fieldGroup: .init(title: MakeProfileConstants.birthDayFieldText, mustMark: false, isFieldEnable: viewModel.isBirthFieldFilled))
                
                makeFieldView(contents: {
                    neutralizationField
                }, fieldGroup: .init(title: MakeProfileConstants.neutralFieldText, mustMark: true, isFieldEnable: viewModel.isNeutralizationFieldFilled))
            }
        })
    }
    
    // MARK: - Profile
    /// 상단 프로파일 이미지
    @ViewBuilder
    private var profileImage: some View {
        VStack {
            Button(action: {
                viewModel.showImagePickerPresented.toggle()
            }, label: {
                if let image = viewModel.selectedImage {
                    makeProfileImage(image: Image(uiImage: image))
                        .shadow02()
                        .clipShape(Circle())
                } else {
                    makeProfileImage(image: Image(systemName: MakeProfileConstants.profileImage))
                        .tint(Color.gray300)
                }
            })
        }
    }
    
    /// 프로파일 이미지 생성 함수
    /// - Parameter image: 이미지 값
    /// - Returns: 이미지 반환
    private func makeProfileImage(image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: MakeProfileConstants.profileImageSize, height: MakeProfileConstants.profileImageSize)
    }
    
    // MARK: - NameTextField
    /// 이름 입력 텍스트 필드
    private var nameField: some View {
        TextField("",
                  text: Binding(
                    get: { viewModel.requestData.name },
                    set: {
                        viewModel.requestData.name = $0
                        viewModel.isNameFieldFilled = !$0.isEmpty
                    }),
                  prompt: placeholderText(MakeProfileConstants.namePlaceholder))
        .textFieldStyle(ttakkeunTextFieldStyle())
        .submitLabel(.done)
    }
    
    // MARK: - Dog or Cat Type
    /// 반려 동물 펫 타입 필드
    private var typeField: some View {
        ProfileTwoButton(
            selectedButton: Binding(
                get: { viewModel.requestData.type?.toKorean() },
                set: { _ in
                    viewModel.isTypeFieldFilled = true
                }
            ),
            firstButton: ButtonOption(
                textTitle: MakeProfileConstants.petTypeDogName,
                action: {
                    viewModel.requestData.type = .dog
                }
            ),
            secondButton: ButtonOption(
                textTitle: MakeProfileConstants.petTypeCatName,
                action: {
                    viewModel.requestData.type = .cat
                }
            )
        )
    }
    
    // MARK: - Varieties
    /// 품종 필드
    private var varietyField: some View {
        Button(action: {
            viewModel.showingVarietySearch.toggle()
        }, label: {
            ZStack(alignment: .center, content: {
                RoundedRectangle(cornerRadius: MakeProfileConstants.cornerRadius)
                    .fill(Color.clear)
                    .stroke(Color.gray200, style: .init())
                    .frame(height: MakeProfileConstants.varietyHeight)
                
                varieyFieldInContents
            })
        })
    }
    
    /// 품종 선택 내부 가이드 표시
    private var varieyFieldInContents: some View {
        HStack {
            Text(viewModel.requestData.variety.isEmpty == false ? viewModel.requestData.variety : MakeProfileConstants.varietyFieldGuideText)
                .font(.Body3_semibold)
                .foregroundStyle(viewModel.requestData.variety.isEmpty == false ? Color.gray900 : Color.gray200)
            
            Spacer()
            
            Image(.bottomArrow)
                .resizable()
                .frame(width: MakeProfileConstants.varietyIconSize, height: MakeProfileConstants.varietyIconSize)
        }
        .padding(.leading, MakeProfileConstants.varietyLeadingPadding)
        .padding(.trailing, MakeProfileConstants.varietyTrailingPadding)
    }
    
    // MARK: - BirthDay
    /// 생년월일 필드
    private var birthField: some View {
        BirthSelect(
            birthDate: Binding(
                get: { viewModel.requestData.birth },
                set: {
                    viewModel.requestData.birth = $0
                    viewModel.isBirthFieldFilled = !$0.isEmpty
                }
            ),
            isBirthFilled: $viewModel.isBirthFieldFilled)
    }
    
    // MARK: - Neutralization
    /// 중성화 여부
    private var neutralizationField: some View {
        ProfileTwoButton(
            selectedButton: Binding(
                get: {
                    viewModel.requestData.neutralization == nil ? nil : (
                        viewModel.requestData.neutralization! ? MakeProfileConstants.neutralYesText : MakeProfileConstants.neutralNoText
                    )
                },
                set: { newValue in
                    viewModel.requestData.neutralization = (
                        newValue == MakeProfileConstants.neutralYesText
                    )
                    viewModel.isNeutralizationFieldFilled = true
                }),
            firstButton: ButtonOption(
                textTitle: MakeProfileConstants.neutralYesText,
                action: {
                }),
            secondButton: ButtonOption(
                textTitle: MakeProfileConstants.neutralNoText,
                action: {
                }
            )
        )
    }
    
    // MARK: - RegistButton
    /// 등록 버튼
    private var registerBtn: some View {
        MainButton(
            btnText: MakeProfileConstants.registerBtnText,
            action: {
                guard viewModel.isProfileCompleted else { return }
                
                viewModel.makePetProfile {
                    dismiss()
                }
            },
            color: viewModel.isProfileCompleted ? Color.mainPrimary : Color.gray200)
    }
}

extension MakeProfileView {
    
    private func makeFieldTitle(fieldGroup: CreateProfileFieldValue) -> HStack<some View> {
        return HStack(content: {
            NameTag(titleText: fieldGroup.title, mustMark: fieldGroup.mustMark)
            
            if fieldGroup.isFieldEnable {
                Image(.check)
                    .frame(width: MakeProfileConstants.checkImageSize, height: MakeProfileConstants.checkImageSize)
            }
        })
    }
    
    private func placeholderText(_ text: String) -> Text {
        Text(text)
            .font(.Body3_medium)
            .foregroundStyle(Color.gray400)
    }
    
    private func makeFieldView<Content: View>(@ViewBuilder contents: @escaping () -> Content, fieldGroup: CreateProfileFieldValue) -> some View {
        VStack(alignment: .leading, spacing: MakeProfileConstants.fieldVspacing, content: {
            makeFieldTitle(fieldGroup: fieldGroup)
            
            contents()
        })
    }
}

#Preview {
    MakeProfileView(container: DIContainer())
        .environmentObject(DIContainer())
}
