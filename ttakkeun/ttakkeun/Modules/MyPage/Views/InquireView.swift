//
//  InquireView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/13/24.
//

import SwiftUI

struct InquireView: View {
    
    //TODO: 스웨거 안나와서 일단 뷰만 돌리기 위한 임시변수, viewModel 만들어야 함!
    @State private var detail: String = ""
    @State private var email: String = ""
    @State private var isAgreementCheck: Bool = false
    @State private var isMainBtnClicked: Bool = false
    
    @State private var showAgreementSheet: Bool = false
    private let agreement = AgreementDetailData.loadEmailAgreements()
    
    var body: some View {
        ZStack(content: {
            VStack(alignment: .center, spacing: 25, content: {
                CustomNavigation(action: { print("hello world") },
                                 title: "문의하기",
                                 currentPage: nil)
                
                reportContent
                
                emailCheck
                
                agreementCheck
                
                Spacer()
                
                MainButton(btnText: "문의하기", width: 349, height: 63, action: {
                            isMainBtnClicked.toggle()}, color: Color.mainPrimary
                )
            })
            .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            .sheet(isPresented: $showAgreementSheet) {
                AgreementSheetView(agreement: agreement)
                    .presentationCornerRadius(30)
            }
            
            if isMainBtnClicked {
                CustomAlert(alertText: Text("문의내용이 접수되었습니다."), alertSubText: Text("회원님의 소중한 의견을 잘 반영하도록 하겠습니다. \n영업시간 2~3일 이내에 이메일로 답변을 받아보실 수 있습니다."), alertAction: .init(showAlert: $isMainBtnClicked, yes: { print("ok") }))
            }
        })
    }
    
    //MARK: - Components
    ///정보 입력 필드
    private var reportContent: some View {
        VStack(alignment: .leading, spacing: 17, content: {
            //TODO: - '>' 뒤에 카테고리는 앞에 뷰에서 어떤 버튼을 선택하느냐에 따라 달라져야함
            Text("문의하기 > 서비스 이용 문의")
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
            
            reportDetail
            
            imageAdd
        })
    }
    
    
    /// 신고 내용
    private var reportDetail: some View {
        VStack(alignment: .leading, spacing: 18,content: {
            makeTitle(title: "문의 내용을 작성해주세요.")
            
            //TODO: text Binding, maxTextCount 수정
            TextEditor(text: $detail)
                .customStyleTipsEditor(text: $detail, placeholder: "최대 300자 이내", maxTextCount: 300, backColor: Color.white)
                .frame(width: 351, height: 200)
        })
    }
    
    private var imageAdd: some View {
        VStack(alignment: .leading, spacing: 13, content: {
            makeTitle(title: "이미지 첨부")
            
            Button(action: {
                //TODO: - 이미지 피커 연결
            }, label: {
                Text("파일 선택하기")
                    .font(.Body4_medium)
                    .foregroundStyle(Color.gray400)
                    .frame(width: 100, height: 27)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color.clear)
                            .stroke(Color.gray400, lineWidth: 1)
                    )
            })
            
            //TODO: - 사진 선택하면 선택한 사진을 일렬로 배치할 수 있도록 해야 함
        })
    }
    
    private var emailCheck: some View {
        VStack(alignment: .leading, spacing: 13, content: {
            makeTitle(title: "연락 받을 이메일")
        
            CustomTextField(text: $email, placeholder: "입력해주세요.", cornerRadius: 10, maxWidth: 355, maxHeight: 56)
        })
    }
    
    private var agreementCheck: some View {
        VStack(alignment: .leading, spacing: 13, content: {
            HStack(alignment: .center, spacing: 91, content: {
                makeTitle(title: "개인정보 수집 및 이용 약관 동의")
                
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
                    isAgreementCheck.toggle()
                }, label: {
                    (isAgreementCheck ? Icon.check.image : Icon.uncheck.image)
                        .resizable()
                        .frame(width: 25, height: 25)
                })

                
                Text("개인정보 수집 및 이용 약관에 동의합니다.")
                    .font(.Body2_medium)
                    .foregroundStyle(Color.gray400)
            })
        
        })
    }
}

//MARK: - Data Structure
private struct FieldGroup {
    let title: String
    let text: Binding<String>
}

//MARK: - function
extension InquireView {
    private func makeTitle(title: String) -> some View {
        Text(title)
            .font(.H4_bold)
            .foregroundStyle(Color.gray900)
    }
}

//MARK: - Preview
struct InquireView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            InquireView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}



