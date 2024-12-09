//
//  ReportView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/9/24.
//

import SwiftUI

struct ReportView: View {
    
    //TODO: 스웨거 안나와서 일단 뷰만 돌리기 위한 임시변수, viewModel 만들어야 함!
    @State private var detail: String = ""
    @State private var name: String = ""
    @State private var nickname: String = ""
    @State private var isInfoConfirmed: Bool = false // 이름, 닉네임 확인 체크박스 상태
    @State private var isAgreementChecked: Bool = false // 개인정보 수집 동의 체크박스 상태
    
    var body: some View {
        VStack(alignment: .center, spacing: 25, content: {
            CustomNavigation(action: { print("hello world") },
                             title: "신고하기",
                             currentPage: nil,
                             naviIcon: Image(systemName: "xmark"),
                             width: 16,
                             height: 16)
            
            ScrollView(.vertical, content: {
                VStack(alignment: .center, spacing: 25, content: {
                    reportContent
                    
                    MainButton(btnText: "신고하기", width: 349, height: 63, action: {
                        if isInfoConfirmed && isAgreementChecked {
                            //TODO: - 신고하기 버튼 눌렸을 때 액션 필요
                            print("신고하기 버튼 눌림")
                        }
                    }, color: (isInfoConfirmed && isAgreementChecked) ? Color.mainPrimary : Color.checkBg
                    )
                    .disabled(!(isInfoConfirmed && isAgreementChecked))
                    
                })
            })
        })
    }
    
    //MARK: - Components
    ///정보 입력 필드
    private var reportContent: some View {
        VStack(alignment: .leading, spacing: 50, content: {
            reportDetail
            
            memInfo
            
            agreement
        })
        .safeAreaPadding(EdgeInsets(top: 0, leading: 22, bottom: 0, trailing: 22))
    }
    
    
    /// 신고 내용
    private var reportDetail: some View {
        VStack(alignment: .leading, spacing: 18,content: {
            
            //TODO: - 그 전 페이지에서 어떤 카테고리 버튼을 눌렀냐에 따라 > 뒤에 텍스트 달라지게 수정해야함
            Text("신고하기 > 품질 문제 보고")
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
            
            fieldTitle(title: "신고내용을 작성해주세요.")
            
            //TODO: text Binding, maxTextCount 수정
            TextEditor(text: $detail)
                .customStyleTipsEditor(text: $detail, placeholder: "신고 내용은 문제를 신속히 파악하고 해결하는 데 큰 도움이 됩니다.", maxTextCount: 300, backColor: Color.white)
                .frame(width: 351, height: 200)
            
            imageAdd
        })
    }
    
    private var imageAdd: some View {
        VStack(alignment: .leading, spacing: 13, content: {
            fieldTitle(title: "이미지 첨부")
            
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
        })
    }
    
    ///회원정보 입력필드
    private var memInfo: some View {
        VStack(alignment: .leading, spacing: 18, content: {
            fieldTitle(title: "회원정보")
            
            //TODO: 스웨거 안나와서 일단 뷰만 돌리기 위한 임시변수 $name! Binding 해야함
            makeInputField(fieldGroup: FieldGroup(title: "이름",
                                                  text: $name))
            
            //TODO: 스웨거 안나와서 일단 뷰만 돌리기 위한 임시변수 $nickname! Binding 해야함
            makeInputField(fieldGroup: FieldGroup(title: "닉네임",
                                                  text: $nickname))
            
            checkField(text: "앱 로그인 정보와 동일해요.", isChecked: $isInfoConfirmed)
        })
    }
    
    ///개인정보 수집 동의 필드
    private var agreement: some View {
        VStack(alignment: .leading, spacing: 22, content: {
            HStack(alignment: .center, spacing: 85, content: {
                fieldTitle(title: "개인정보 수집 및 이용 약관 동의")
                
                Button(action: {
                    //TODO: - 이용약관 보는 페이지로 넘어가는 버튼 액션 필요
                }, label: {
                    Text("보기")
                        .font(.Body4_medium)
                        .foregroundStyle(Color.gray900)
                        .frame(width: 63, height: 28)
                        .background(content: {
                            RoundedRectangle(cornerRadius: 40)
                                .fill(Color.checkBg)
                        })
                })
            })
            
            checkField(text: "개인정보 수집 및 이용 약관에 동의합니다.", isChecked: $isAgreementChecked)
        })
    }
}

//MARK: - Function
extension ReportView {
    /// 입력해야할 필드 타이틀 재사용
    private func fieldTitle(title : String) -> some View {
        Text(title)
            .font(.H4_bold)
            .foregroundStyle(Color.gray900)
    }
    
    ///회원정보 입력 필드 재사용(타이틀 + 텍스트 필드)
    private func makeInputField(fieldGroup: FieldGroup) -> some View {
        VStack(alignment: .leading, spacing: 9,content: {
            Text(fieldGroup.title)
                .font(.Body3_semibold)
                .foregroundStyle(Color.gray900)
            
            CustomTextField (
                    keyboardType: .default,
                    text: fieldGroup.text,
                    placeholder: "입력해주세요.",
                    fontSize: 16,
                    cornerRadius: 10,
                    padding: 17,
                    maxWidth: 349,
                    maxHeight: 56
            )
        })
    }
    
    /// 체크 상태에 따른 이미지를 반환하는 함수
    private func checkmarkImage(for isChecked: Bool) -> Image {
        return isChecked ? Icon.check.image : Icon.uncheck.image
    }
    
    ///체크박스 필드 재사용(체크박스 + 텍스트)
    private func checkField(text: String, isChecked: Binding<Bool>) -> some View {
        HStack(alignment: .center, spacing: 10, content: {
            Button(action: {
                isChecked.wrappedValue.toggle()
            }, label: {
                checkmarkImage(for: isChecked.wrappedValue)
                    .resizable()
                    .frame(width: 25, height: 25)
            })
            
            Text(text)
                .font(.Body2_medium)
                .foregroundStyle(Color.gray400)
        })
    }
}

//MARK: - Data Structure
private struct FieldGroup {
    let title: String
    let text: Binding<String>
}

//MARK: - Preview
struct ReportView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            ReportView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}


