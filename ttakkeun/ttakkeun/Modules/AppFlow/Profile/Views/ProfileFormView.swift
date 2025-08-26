//
//  MakeProfileView.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/31/24.
//

import SwiftUI
import PhotosUI
import Kingfisher

/// 동물 프로필 생성 뷰
struct ProfileFormView: View {
    
    // MARK: - Property
    @State var viewModel: ProfileFormViewModel
    @EnvironmentObject var container: DIContainer
    @Environment(\.dismiss) var dismiss
    @FocusState var isFocused: Bool
    
    // MARK: - Constants
    fileprivate enum ProfileFormConstants {
        static let fieldVspacing: CGFloat = 10
        static let mainVspacing: CGFloat = 25
        
        static let safeHorizonPadding: CGFloat = 31
        static let safeTopPadding: CGFloat = 5
        static let varietyLeadingPadding: CGFloat = 22
        static let varietyTrailingPadding: CGFloat = 16
        
        static let profileImageSize: CGFloat = 120
        static let checkImageSize: CGFloat = 18
        static let varietyIconSize: CGFloat = 16
        static let varietyHeight: CGFloat = 44
        
        static let cornerRadius: CGFloat = 10
        static let xmarkWidth: CGFloat = 18
        static let xmarkHeight: CGFloat = 18
        
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
        static let closeButtonString: String = "xmark"
        
        static let profileMakeTitle: String = "프로필 등록"
        static let profileEditTitle: String = "프로필 편집"
    }
    
    // MARK: - Init
    init(
        mode: ProfileMode,
        container: DIContainer,
    ) {
        self.viewModel = .init(mode: mode, container: container)
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: ProfileFormConstants.mainVspacing, content: {
            topNavi
            profileImageSection
            inputFieldGroup
            Spacer()
            registerBtn
        })
        .navigationBarBackButtonHidden(true)
        .safeAreaPadding(.horizontal, ProfileFormConstants.safeHorizonPadding)
        .safeAreaPadding(.top, ProfileFormConstants.safeTopPadding)
        .sheet(isPresented: $viewModel.showingVarietySearch) {
            VarietySearchView(viewModel: viewModel)
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(UIConstants.sheetCornerRadius)
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
        .task {
            viewModel.checkInEditMode()
        }
        .keyboardToolbar {
            isFocused = false
        }
    }
    
    // MARK: - FieldGroup
    private var inputFieldGroup: some View {
        VStack(alignment: .center, spacing: .zero, content: {
            Group {
                makeFieldView(contents: {
                    nameField
                }, fieldGroup: .init(title: ProfileFormConstants.nameText, mustMark: true, isFieldEnable: viewModel.isNameFieldFilled))
                
                Spacer()
                
                makeFieldView(contents: {
                    typeField
                }, fieldGroup: .init(title: ProfileFormConstants.petTypeText, mustMark: true, isFieldEnable: viewModel.isTypeFieldFilled))
                
                Spacer()
                
                makeFieldView(contents: {
                    varietyField
                }, fieldGroup: .init(title: ProfileFormConstants.varietyFieldText, mustMark: true, isFieldEnable: viewModel.isVarietyFieldFilled))
                
                Spacer()
                
                makeFieldView(contents: {
                    birthField
                }, fieldGroup: .init(title: ProfileFormConstants.birthDayFieldText, mustMark: false, isFieldEnable: viewModel.isBirthFieldFilled))
                
                Spacer()
                
                makeFieldView(contents: {
                    neutralizationField
                }, fieldGroup: .init(title: ProfileFormConstants.neutralFieldText, mustMark: true, isFieldEnable: viewModel.isNeutralizationFieldFilled))
            }
        })
    }
    
    // MARK: - TopClose
    private var topNavi: some View {
        ZStack {
            mainTitle
                .frame(maxWidth: .infinity, alignment: .center)
                .font(.H4_bold)
                .foregroundStyle(Color.black)
            
            topClose
        }
    }
    @ViewBuilder
    private var mainTitle: some View {
        switch viewModel.mode {
        case .create:
            Text(ProfileFormConstants.profileMakeTitle)
        case .edit:
            Text(ProfileFormConstants.profileEditTitle)
        }
    }
    
    private var topClose: some View {
        HStack {
            Button(action: {
                switch viewModel.mode {
                case .create:
                    dismiss()
                case .edit:
                    container.navigationRouter.pop()
                }
            }, label: {
                Image(systemName: ProfileFormConstants.closeButtonString)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: ProfileFormConstants.xmarkWidth, height: ProfileFormConstants.xmarkHeight)
                    .foregroundStyle(Color.black)
                
            })
            
            Spacer()
        }
    }
    
    // MARK: - Profile
    /// 상단 프로파일 이미지
    @ViewBuilder
    private var profileImageSection: some View {
        Button(action: {
            viewModel.showImagePickerPresented.toggle()
        }, label: {
            if let image = viewModel.selectedImage {
                makeProfileImage(image: Image(uiImage: image))
                    .shadow02()
                    .clipShape(Circle())
            } else if let imageURL = viewModel.imageURL, let url = URL(string: imageURL) {
                kingfisherProfile(url: url)
            } else {
                makeProfileImage(image: Image(systemName: ProfileFormConstants.profileImage))
                    .tint(Color.gray300)
            }
        })
    }
    
    private func kingfisherProfile(url: URL) -> some View {
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
    
    /// 프로파일 이미지 생성 함수
    /// - Parameter image: 이미지 값
    /// - Returns: 이미지 반환
    private func makeProfileImage(image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: ProfileFormConstants.profileImageSize, height: ProfileFormConstants.profileImageSize)
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
                  prompt: placeholderText(ProfileFormConstants.namePlaceholder))
        .textFieldStyle(ttakkeunTextFieldStyle())
        .submitLabel(.done)
        .focused($isFocused)
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
                textTitle: ProfileFormConstants.petTypeDogName,
                action: {
                    viewModel.requestData.type = .dog
                }
            ),
            secondButton: ButtonOption(
                textTitle: ProfileFormConstants.petTypeCatName,
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
                RoundedRectangle(cornerRadius: ProfileFormConstants.cornerRadius)
                    .fill(Color.clear)
                    .stroke(Color.gray200, style: .init())
                    .frame(height: ProfileFormConstants.varietyHeight)
                
                varieyFieldInContents
            })
        })
    }
    
    /// 품종 선택 내부 가이드 표시
    private var varieyFieldInContents: some View {
        HStack {
            Text(viewModel.requestData.variety.isEmpty == false ? viewModel.requestData.variety : ProfileFormConstants.varietyFieldGuideText)
                .font(.Body3_semibold)
                .foregroundStyle(viewModel.requestData.variety.isEmpty == false ? Color.gray900 : Color.gray200)
            
            Spacer()
            
            Image(.bottomArrow)
                .resizable()
                .frame(width: ProfileFormConstants.varietyIconSize, height: ProfileFormConstants.varietyIconSize)
        }
        .padding(.leading, ProfileFormConstants.varietyLeadingPadding)
        .padding(.trailing, ProfileFormConstants.varietyTrailingPadding)
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
                        viewModel.requestData.neutralization! ? ProfileFormConstants.neutralYesText : ProfileFormConstants.neutralNoText
                    )
                },
                set: { newValue in
                    viewModel.requestData.neutralization = (
                        newValue == ProfileFormConstants.neutralYesText
                    )
                    viewModel.isNeutralizationFieldFilled = true
                }),
            firstButton: ButtonOption(
                textTitle: ProfileFormConstants.neutralYesText,
                action: {
                }),
            secondButton: ButtonOption(
                textTitle: ProfileFormConstants.neutralNoText,
                action: {
                }
            )
        )
    }
    
    // MARK: - RegistButton
    /// 등록 버튼
    private var registerBtn: some View {
        MainButton(
            btnText: ProfileFormConstants.registerBtnText,
            action: {
                guard viewModel.isProfileCompleted else { return }
                viewModel.submit {
                    dismiss()
                }
            },
            color: viewModel.isProfileCompleted ? Color.mainPrimary : Color.gray200)
    }
}

extension ProfileFormView {
    
    private func makeFieldTitle(fieldGroup: CreateProfileFieldValue) -> HStack<some View> {
        return HStack(content: {
            NameTag(titleText: fieldGroup.title, mustMark: fieldGroup.mustMark)
            
            if fieldGroup.isFieldEnable {
                Image(.check)
                    .frame(width: ProfileFormConstants.checkImageSize, height: ProfileFormConstants.checkImageSize)
            }
        })
    }
    
    private func placeholderText(_ text: String) -> Text {
        Text(text)
            .font(.Body3_medium)
            .foregroundStyle(Color.gray400)
    }
    
    private func makeFieldView<Content: View>(@ViewBuilder contents: @escaping () -> Content, fieldGroup: CreateProfileFieldValue) -> some View {
        VStack(alignment: .leading, spacing: ProfileFormConstants.fieldVspacing, content: {
            makeFieldTitle(fieldGroup: fieldGroup)
            
            contents()
        })
    }
}

#Preview {
    ProfileFormView(mode: .create, container: DIContainer())
        .environmentObject(DIContainer())
}
