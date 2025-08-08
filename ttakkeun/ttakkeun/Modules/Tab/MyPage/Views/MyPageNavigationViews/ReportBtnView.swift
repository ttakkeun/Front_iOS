//
//  ReportBtnView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/9/24.
//
import SwiftUI

/// 신고하기 분야 선택 뷰
struct ReportBtnView: View {
    
    @EnvironmentObject var container: DIContainer
    @State var viewModel: MyPageViewModel
    
    init(container: DIContainer) {
        self._viewModel = .init(wrappedValue: .init(container: container))
    }
    
    var btnInfoArray: [BtnInfo] {
        return [
            //TODO: 버튼 액션 필요함 -> 1~8은 ReportDetailBtnView에 name 넘겨서 해당 타이틀에 맞는 페이지 출력하도록 해야하고 / 9 기타 누르면 ReportView로 네비게이션되어야 함
            BtnInfo(name: "스팸/광고", date: nil, action: {
                container.navigationRouter.push(to: .reportDetailBtn(selectedReportCategory: "스팸/광고"))}),
            BtnInfo(name: "부적절한 콘텐츠", date: nil, action: {
                container.navigationRouter.push(to: .reportDetailBtn(selectedReportCategory: "부적절한 콘텐츠"))}),
            BtnInfo(name: "허위 정보", date: nil, action: {
                container.navigationRouter.push(to: .reportDetailBtn(selectedReportCategory: "허위 정보"))}),
            BtnInfo(name: "반려동물 학대", date: nil, action: {
                container.navigationRouter.push(to: .reportDetailBtn(selectedReportCategory: "반려동물 학대"))}),
            BtnInfo(name: "저작권 침해", date: nil, action: {
                container.navigationRouter.push(to: .reportDetailBtn(selectedReportCategory: "저작권 침해"))}),
            BtnInfo(name: "개인 정보 노출", date: nil, action: {
                container.navigationRouter.push(to: .reportDetailBtn(selectedReportCategory: "개인 정보 노출"))}),
            BtnInfo(name: "비방 및 혐오 표현", date: nil, action: {
                container.navigationRouter.push(to: .reportDetailBtn(selectedReportCategory: "비방 및 혐오 표현"))}),
            BtnInfo(name: "부정 행위", date: nil, action: {
                container.navigationRouter.push(to: .reportDetailBtn(selectedReportCategory: "부정 행위"))}),
            BtnInfo(name: "기타 신고 내용 작성하기", date: nil, action: {
                        container.navigationRouter.push(to: .writeReport)})
        ]
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 40, content: {
            CustomNavigation(action: { container.navigationRouter.pop() },
                             title: "신고하기",
                             currentPage: nil)
            
            reportBtns
            
            Spacer()
        })
        .navigationBarBackButtonHidden(true)
        .navigationDestination(for: NavigationDestination.self) { destination in
            NavigationRoutingView(destination: destination)
                .environmentObject(container)
        }
    }
    
    //MARK: - Components
    /// Detail Info 볼 수 있는 버튼들
    private var reportBtns: some View {
        VStack(alignment: .center, spacing: 17, content: {
            ForEach(btnInfoArray, id: \.id) { btnInfo in
                SelectBtnBox(btnInfo: btnInfo)
            }
        })
    }
    
}

//MARK: - Preview
struct ReportBtnView_Preview: PreviewProvider {
    
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            ReportBtnView(container: DIContainer())
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(DIContainer())
        }
    }
}

