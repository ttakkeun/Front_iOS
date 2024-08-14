//
//  AgreementView.swift
//  ttakkeun
//
//  Created by 황유빈 on 8/13/24.
//

import SwiftUI

struct AgreementView: View {
    @StateObject var viewModel = AgreementViewModel()
    
    //MARK: - INIT
    init() {
        self._viewModel = StateObject(wrappedValue: AgreementViewModel())
    }
    
    //MARK: - Contents
    var body: some View {
        VStack(alignment: .center, spacing: 50, content: {
            CustomNavigation(action: {}, title: "본인확인", currentPage: nil, naviIcon: Image(systemName: "xmark"), width: 14, height: 14)
                .padding(.top, 15)
            
            emailField

            agreementPart
            
            Spacer()
            
            registerBtn
        })
    }
    
    /// 로그인 후 넘겨받은 이메일 출력
    private var emailField: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text("이메일")
                .font(.H4_bold)
                .foregroundStyle(Color.gray_900)
            
            Text(verbatim: "asdasd0000@naver.com")
                .font(.Body3_medium)
                .foregroundStyle(Color.gray_400)
                .frame(width: 325, height: 44, alignment: .leading)
                .padding(.leading, 15)
                .clipShape(.rect(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray_200, lineWidth: 1)
                )
        })
    }
    
    ///동의항목 파트
    private var agreementPart: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            Text("동의 항목")
                .font(.H4_bold)
                .foregroundStyle(Color.gray_900)
            
            agreements
                .frame(width: 341, height: 167, alignment: .leading)
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray_200, lineWidth: 1)
                )
    
            totalAgreement
        })
        .frame(width: 341, height: 248)
    }
    
    
    /// 동의항목 선택 요소들
    private var agreements: some View {
        
        LazyVGrid(columns: [GridItem(.flexible())], alignment: .leading, spacing: 20) {
            ForEach(viewModel.agreements, id: \.id) { item in
                HStack(alignment: .center, spacing: 17, content: {
                    checkmarkImage(for: item.isChecked)
                        .resizable()
                        .frame(width: 23, height: 23)
                        .onTapGesture {
                            viewModel.toggleCheck(for: item)
                        }
                    
                    Button(action: {
                        viewModel.selectedAgreement = item
                    }, label: {
                        Text(item.title)
                            .font(.Body2_regular)
                            .foregroundStyle(Color.gray_900)
                    })
                })
            }
            .padding(.leading, 19)
        }
        .frame(width: 341, height: 167, alignment: .leading)
        .sheet(item: $viewModel.selectedAgreement) { item in
            AgreementDetailSheet(agreement: item)
        }
    }
    
    /// 전체 동의 버튼
    private var totalAgreement: some View {
        HStack(alignment: .center, spacing: 9, content: {
            Spacer()
            
            checkmarkImage(for: viewModel.isAllChecked)
                .resizable()
                .frame(width: 23, height: 23)
                .onTapGesture {
                    viewModel.toggleAllAgreements()
                }
            
            Text("전체동의")
                .font(.Body2_bold)
                .foregroundStyle(Color.gray_900)
                .onTapGesture {
                    viewModel.toggleAllAgreements()
                }
        })
    }
    
    //TODO: 완료버튼 눌렀을 때 액션 함수 추가 필요
    /// 완료 버튼
    private var registerBtn: some View {
        MainButton(
            btnText: "완료",
            width: 339,
            height: 63,
            action: {
                if viewModel.isAllMandatoryChecked {
                    print("완료버튼 눌림")
                } else {
                    print("필수 동의 사항에 모두 체크해주세요")
                }
            },
            color: viewModel.isAllMandatoryChecked ? Color.primaryColor_Main : Color.gray_200
        )
        .disabled(!viewModel.isAllMandatoryChecked)
    }
    
}

//MARK: - Function
/// 체크 상태에 따른 이미지를 반환하는 함수
private func checkmarkImage(for isChecked: Bool) -> Image {
    return isChecked ? Icon.check.image : Icon.uncheck.image
}

//MARK: - Preview
struct AgreementView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iphone 15 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            AgreementView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}
