//
//  MyInquireBtnView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/16/24.
//
import SwiftUI

/// 내가 문의한 내용 보기
struct MyInquireView: View {
    
    @EnvironmentObject var container: DIContainer
    @State var viewModel: InquireViewModel
    
    init(container: DIContainer) {
        self.viewModel = .init(container: container)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 40, content: {
            CustomNavigation(action: { container.navigationRouter.pop() },
                             title: "문의하기",
                             currentPage: nil)
            
            if !viewModel.isLoading {
                inquireBtns
            } else {
                ProgressView()
                    .controlSize(.large)
            }
            
            Spacer()
        })
        .navigationBarBackButtonHidden(true)
        .task {
            viewModel.getMyInquire()
        }
    }
    
    //MARK: - Components
    /// 내가 문의한 내용들 볼 수 있는 버튼들
    private var inquireBtns: some View {
        VStack(alignment: .leading, spacing: 17, content: {
            Text("내가 문의한 내용 확인하기")
                .font(.H4_bold)
                .foregroundStyle(Color.gray900)

            ForEach(viewModel.myInquiryData, id: \.id) { btnInfo in
                SelectBtnBox(btnInfo: BtnInfo(name: btnInfo.contents, date: DataFormatter.shared.convertToKoreanTime(from: btnInfo.created_at), action: {
                    container.navigationRouter.push(to: .myInquiryConfirm(selectedInquiryData: btnInfo))
                }))
            }
        })
    }
}

#Preview {
    MyInquireView(container: DIContainer())
        .environmentObject(DIContainer())
}
