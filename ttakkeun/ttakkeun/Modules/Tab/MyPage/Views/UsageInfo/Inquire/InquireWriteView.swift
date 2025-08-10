//
//  InquireView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/13/24.
//

import SwiftUI

/// 문의하기 및 신고하기 내용 작성 뷰모델
struct InquireWriteView: View {
    
    // MARK: - Property
    @EnvironmentObject var container: DIContainer
    @State var viewModel: InquireViewModel
    @State private var showAgreementSheet: Bool = false
    
    let selectedCategory: InquireType
    private let agreement = AgreementDetailData.loadEmailAgreements()
    
    // MARK: - Init
    init(container: DIContainer, selectedCategory: InquireType) {
        self.viewModel = .init(container: container)
        self.selectedCategory = selectedCategory
    }
    
    // MARK: - Body
    var body: some View {
        ZStack(content: {
            VStack(alignment: .leading, spacing: 25, content: {
                CustomNavigation(action: { container.navigationRouter.pop() },
                                 title: "문의하기",
                                 currentPage: nil)
                
                reportContent
                
                inputReport
                
                imageAdd
                
                emailCheck
                
                agreementCheck
                
                Spacer()
                
                MainButton(btnText: "문의하기", height: 63,
                           action: { viewModel.isInquireMainBtnClicked.toggle()}, color: isMainButtonEnabled() ? Color.mainPrimary : Color.checkBg)
                .disabled(!isMainButtonEnabled())
            })
            .safeAreaPadding(EdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0))
            .sheet(isPresented: $showAgreementSheet) {
                AgreementSheetView(agreement: agreement)
                    .presentationCornerRadius(30)
            }
            .sheet(isPresented: $viewModel.isImagePickerPresented, content: {
                ImagePicker(imageHandler: viewModel, selectedLimit: 3)
            })
//            
//            if viewModel.isInquireMainBtnClicked {
//                CustomAlert(alertText: Text("문의내용이 접수되었습니다."), alertSubText: Text("회원님의 소중한 의견을 잘 반영하도록 하겠습니다. \n영업시간 2~3일 이내에 이메일로 답변을 받아보실 수 있습니다."), alertAction: .init(showAlert: $viewModel.isInquireMainBtnClicked, yes: {
//                    container.navigationRouter.pop()
//                    
//                }))
//            }
        })
        .onAppear {
            UIApplication.shared.hideKeyboard()
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
    }
    
    //MARK: - Components
    ///정보 입력 필드
    private var reportContent: some View {
        
        Text("문의하기 >())")
            .font(.Body4_medium)
            .foregroundStyle(Color.gray400)
    }
    
    
    /// 신고 내용
    private var inputReport: some View {
        VStack(alignment: .leading, spacing: 18, content: {
            makeTitle(title: "문의 내용을 작성해주세요. (필수)")
            
            TextEditor(text: $viewModel.reportContents)
                .customStyleTipsEditor(text: $viewModel.reportContents, placeholder: "최대 250자 이내", maxTextCount: 250, backColor: Color.white)
                .frame(width: 351, height: 180)
        })
    }
    
    private var imageAdd: some View {
        VStack(alignment: .leading, spacing: 1, content: {
            makeTitle(title: "이미지 등록하기")
            
            HStack(alignment: .top, spacing: 5, content: {
                CameraButton(cameraText: Text("\(viewModel.selectedImageCount) / 3"), action: {
                    if viewModel.selectedImageCount <= 2 {
                        viewModel.showImagePicker()
                    }
                })
                showSelectedImage
            })
        })
        .frame(width: 351)
    }
    
    private var showSelectedImage: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.fixed(80))], spacing: 10) { // GridItem 크기 조정
                ForEach(0..<viewModel.getImages().count, id: \.self) { index in
                    imageAddAndRemove(for: index, image: viewModel.getImages()[index])
                }
            }
            .padding(.top, 5)
            .padding(.bottom, 8)
            .padding(.horizontal, 5)
        }
    }
    
    private var emailCheck: some View {
        VStack(alignment: .leading, spacing: 13, content: {
            makeTitle(title: "연락 받을 이메일 (필수)")
        
            CustomTextField(text: $viewModel.email, placeholder: "입력해주세요.", cornerRadius: 10, maxWidth: 355, maxHeight: 56)
        })
    }
    
    private var agreementCheck: some View {
        VStack(alignment: .leading, spacing: 13, content: {
            HStack(alignment: .center, content: {
                makeTitle(title: "개인정보 수집 및 이용 약관 동의 (필수)")
                
                Spacer()
                
                Button(action: {
                    showAgreementSheet = true
                }, label: {
                    Text("보기")
                        .font(.Body4_medium)
                        .foregroundStyle(Color.gray900)
                        .frame(width: 63, height: 28)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 999)
                                .fill(Color.checkBg)
                        })
                })
            })
            
            HStack(alignment: .center, spacing: 8, content: {
                
                Button(action: {
                    viewModel.isAgreementCheck.toggle()
                }, label: {
                    (viewModel.isAgreementCheck ? Icon.check.image : Icon.uncheck.image)
                        .resizable()
                        .frame(width: 25, height: 25)
                })

                
                Text("개인정보 수집 및 이용 약관에 동의합니다.")
                    .font(.Body2_medium)
                    .foregroundStyle(Color.gray400)
            })
        })
        .frame(width: 351)
    }
}

//MARK: - function
extension InquireWriteView {
    private func makeTitle(title: String) -> some View {
        let keyword = "(필수)"
        
        return Group {
            if title.contains(keyword) {
                let components = title.split(separator: " ", omittingEmptySubsequences: false)
                
                HStack(spacing: 0) {
                    ForEach(components, id: \.self) { part in
                        if part.contains(keyword) {
                            Text(" \(part)")
                                .font(.Body4_medium)
                                .foregroundStyle(Color.red)
                        } else {
                            Text(part)
                                .font(.H4_bold)
                                .foregroundStyle(Color.gray900)
                        }
                    }
                }
            } else {
                Text(title)
                    .font(.H4_bold)
                    .foregroundStyle(Color.gray900)
            }
        }
    }
    
    // Main 버튼 활성화 조건 함수
    private func isMainButtonEnabled() -> Bool {
        return !viewModel.reportContents.isEmpty && !viewModel.email.isEmpty && viewModel.isAgreementCheck
    }
    
    
    private func imageAddAndRemove(for index: Int, image: UIImage) -> some View {
        ZStack(alignment: .topLeading, content: {
            Image(uiImage: image)
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.clear)
                        .stroke(Color.gray200, lineWidth: 1)
                })
            
            Button(action: {
                viewModel.removeImage(at: index)
            }, label: {
                Icon.imageRemove.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding([.horizontal, .vertical], -3)
            })
        })
        .frame(width: 80, height: 80)
    }
}
