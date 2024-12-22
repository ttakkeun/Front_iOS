//
//  ReportView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/9/24.
//

import SwiftUI

struct ReportView: View {
    
    @EnvironmentObject var container: DIContainer
    @StateObject var viewModel: MyPageViewModel
    
    @State private var isReportMainBtnClicked: Bool = false
    
    //TODO: 스웨거 안나와서 일단 뷰만 돌리기 위한 임시변수, viewModel 만들어야 함!
    @State private var detail: String = ""
    
    init(container: DIContainer) {
        self._viewModel = .init(wrappedValue: .init(container: container))
    }
    
    var body: some View {
        ZStack(content: {
            VStack(alignment: .center, spacing: 25, content: {
                CustomNavigation(action: { container.navigationRouter.pop() },
                                 title: "신고하기",
                                 currentPage: nil)
                
                reportContent
                
                Spacer()
                
                MainButton(btnText: "신고하기", width: 349, height: 63, action: {
                    isReportMainBtnClicked.toggle()}, color: detail.isEmpty ? Color.checkBg : Color.mainPrimary)
                .disabled(detail.isEmpty)
            })
            .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
            
            if isReportMainBtnClicked {
                CustomAlert(alertText: Text("신고내용이 접수되었습니다."), alertSubText: Text("회원님의 소중한 의견을 잘 반영하도록 하겠습니다. \n검토 후 신고내용을 반영하여 조치를 취하겠습니다."), alertAction: .init(showAlert: $isReportMainBtnClicked, yes: { print("ok") }))
            }
        })
        .navigationBarBackButtonHidden(true)
    }
    
    //MARK: - Components
    ///정보 입력 필드
    private var reportContent: some View {
        VStack(alignment: .leading, spacing: 17, content: {
            Text("신고하기 > 기타 신고 내용 작성하기")
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
            
            reportDetail
            
            imageAdd
        })
    }
    
    
    /// 신고 내용
    private var reportDetail: some View {
        VStack(alignment: .leading, spacing: 18,content: {
            Text("신고내용을 작성해주세요.")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
            //TODO: text Binding, maxTextCount 수정
            TextEditor(text: $detail)
                .customStyleTipsEditor(text: $detail, placeholder: "신고 내용은 문제를 신속히 파악하고 해결하는 데 큰 도움이 됩니다.", maxTextCount: 300, backColor: Color.white)
                .frame(width: 351, height: 200)
        })
    }
    
    private var imageAdd: some View {
        VStack(alignment: .leading, spacing: 13, content: {
            Text("이미지 첨부")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)
            
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
            ReportView(container: DIContainer())
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(DIContainer())
        }
    }
}


