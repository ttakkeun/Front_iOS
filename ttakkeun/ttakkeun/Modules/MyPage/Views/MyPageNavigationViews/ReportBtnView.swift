//
//  ReportBtnView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/9/24.
//
import SwiftUI

/// 신고하기 분야 선택 뷰
struct ReportBtnView: View {
    
    let btnInfoArray: [BtnInfo] = [
        //TODO: 버튼 액션 필요함 -> 1~8은 ReportDetailBtnView에 name 넘겨서 해당 타이틀에 맞는 페이지 출력하도록 해야하고 / 9 기타 누르면 ReportView로 네비게이션되어야 함
        BtnInfo(name: "스팸/광고", date: nil, action: {print("스팸/광고 눌림")}),
        BtnInfo(name: "부적절한 콘텐츠", date: nil, action: {print("부적절한 콘텐츠 버튼 눌림")}),
        BtnInfo(name: "허위 정보", date: nil, action: {print("허위 정보 버튼 눌림")}),
        BtnInfo(name: "반려동물 학대", date: nil, action: {print("반려동물 학대 버튼 눌림")}),
        BtnInfo(name: "저작권 침해", date: nil, action: {print("저작권 침해 버튼 눌림")}),
        BtnInfo(name: "개인 정보 노출", date: nil, action: {print("개인 정보 노출 버튼 눌림")}),
        BtnInfo(name: "비방 및 혐오 표현", date: nil, action: {print("비방 및 혐오 표현 버튼 눌림")}),
        BtnInfo(name: "부정 행위", date: nil, action: {print("부정 행위 버튼 눌림")}),
        BtnInfo(name: "기타 신고 내용 작성하기", date: nil, action: {print("기타 신고 내용 작성하기 버튼 눌림")})
    ]
    
    var body: some View {
        VStack(alignment: .center, spacing: 40, content: {
            CustomNavigation(action: { print("hello world") },
                             title: "신고하기",
                             currentPage: nil)
            
            reportBtns
            
            Spacer()
        })
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
            ReportBtnView()
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
        }
    }
}

