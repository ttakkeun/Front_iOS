//
//  ReportDetailBtnView.swift
//  ttakkeun
//
//  Created by 황유빈 on 12/16/24.
//

import SwiftUI

/// 신고하기 카테고리 디테일 선택 뷰
struct ReportDetailBtnView: View {
    
    let selectedCategory: String
    
    @EnvironmentObject var container: DIContainer
    @State var viewModel: MyPageViewModel
    
    @State private var selectedIndex: Int? = nil // 선택된 버튼의 인덱스
    
    init(container: DIContainer, selectedCategory: String) {
        self._viewModel = .init(wrappedValue: .init(container: container))
        self.selectedCategory = selectedCategory
    }
    
    var btnInfoArray: [BtnInfo] {
        return ReportDetailBtnView.getCategoryButtons(for: selectedCategory)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 32, content: {
            CustomNavigation(action: { container.navigationRouter.pop() },
                             title: "신고하기",
                             currentPage: nil)
            
            reportBtnsForEachCategory
            
            Spacer()
            
            MainButton(btnText: "신고하기", height: 63, action: {
                //TODO: - 신고하기 버튼 눌렸을 때 액션 필요
                print("신고하기 버튼 눌림")}, color: selectedIndex != nil ? Color.mainPrimary : Color.checkBg
            )
        })
        .navigationBarBackButtonHidden(true)
        .navigationDestination(for: NavigationDestination.self) { destination in
            NavigationRoutingView(destination: destination)
                .environmentObject(container)
        }
    }
    
    private var reportBtnsForEachCategory: some View {
        VStack(alignment: .leading, spacing: 17, content: {
            Text("신고하기 > \(selectedCategory)")
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
            
            reportBtns
        })
    }
    
    //MARK: - Components
    /// Detail Info 볼 수 있는 버튼들
    private var reportBtns: some View {
        VStack(alignment: .center, spacing: 17, content: {
            ForEach(btnInfoArray.indices, id: \.self) { index in
                SelectBtnBox(
                    btnInfo: btnInfoArray[index],
                    isSelected: Binding(
                        get: { selectedIndex == index },
                        set: { isSelected in
                            selectedIndex = index
                        }
                    )
                )
            }
        })
    }
}

// MARK: - 데이터 확장
extension ReportDetailBtnView {
    static func getCategoryButtons(for category: String) -> [BtnInfo] {
        switch category {
        case "스팸/광고":
            return [
                BtnInfo(name: "상업적인 광고글", date: nil, action: { print("상업적인 광고글 눌림") }),
                BtnInfo(name: "홍보성 게시글", date: nil, action: { print("홍보성 게시글 눌림") }),
                BtnInfo(name: "반복적인 스팸 메시지", date: nil, action: { print("반복적인 스팸 메시지 눌림") }),
                BtnInfo(name: "유해 링크 포함", date: nil, action: { print("유해 링크 포함 눌림") })
            ]
            
        case "부적절한 콘텐츠":
            return [
                BtnInfo(name: "욕설 및 폭언", date: nil, action: { print("욕설 및 폭언 눌림") }),
                BtnInfo(name: "반려동물과 무관한 부적절한 내용", date: nil, action: { print("무관한 내용 눌림") }),
                BtnInfo(name: "선정적/불쾌한 이미지", date: nil, action: { print("선정적/불쾌한 이미지 눌림") })
            ]
            
        case "허위 정보":
            return [
                BtnInfo(name: "근거가 없는 잘못된 정보", date: nil, action: { print("근거가 없는 정보 눌림") }),
                BtnInfo(name: "반려동물에게 해가 될 수 있는 비전문적인 정보", date: nil, action: { print("비전문적 정보 눌림") }),
                BtnInfo(name: "과장되거나 조작된 정보", date: nil, action: { print("조작된 정보 눌림") })
            ]
            
        case "반려동물 학대":
            return [
                BtnInfo(name: "학대 장면 포함", date: nil, action: { print("학대 장면 포함 눌림") }),
                BtnInfo(name: "학대 조장 또는 방조", date: nil, action: { print("학대 조장 또는 방조 눌림") }),
                BtnInfo(name: "방치 또는 불법행위", date: nil, action: { print("방치 또는 불법행위 눌림") })
            ]
            
        case "저작권 침해":
            return [
                BtnInfo(name: "무단 이미지 사용", date: nil, action: { print("무단 이미지 사용 눌림") }),
                BtnInfo(name: "무단 복제 및 도용", date: nil, action: { print("무단 복제 및 도용 눌림") })
            ]
            
        case "개인 정보 노출":
            return [
                BtnInfo(name: "연락처 공개", date: nil, action: { print("연락처 공개 눌림") }),
                BtnInfo(name: "주소 노출", date: nil, action: { print("주소 노출 눌림") }),
                BtnInfo(name: "기타 개인 정보 노출", date: nil, action: { print("기타 개인 정보 노출 눌림") })
            ]
            
        case "비방 및 혐오 표현":
            return [
                BtnInfo(name: "사용자 비방", date: nil, action: { print("사용자 비방 눌림") }),
                BtnInfo(name: "특정 집단 혐오", date: nil, action: { print("특정 집단 혐오 눌림") }),
                BtnInfo(name: "동물에 대한 비방 및 혐오", date: nil, action: { print("동물 혐오 눌림") }),
                BtnInfo(name: "공격적 표현", date: nil, action: { print("공격적 표현 눌림") })
            ]
            
        case "부정 행위":
            return [
                BtnInfo(name: "추천수 조작", date: nil, action: { print("추천수 조작 눌림") }),
                BtnInfo(name: "특정 단체가 개입한 조작", date: nil, action: { print("단체 개입 조작 눌림") }),
                BtnInfo(name: "기타 부정행위", date: nil, action: { print("기타 부정행위 눌림") })
            ]
            
        default:
            return []
        }
    }
}

//MARK: - Preview
struct ReportDetailBtnView_Preview: PreviewProvider {
    static let devices = ["iPhone 11", "iPhone 16 Pro"]
    
    static var previews: some View {
        ForEach(devices, id: \.self) { device in
            ReportDetailBtnView(container: DIContainer(), selectedCategory: "스팸/광고")
                .previewDevice(PreviewDevice(rawValue: device))
                .previewDisplayName(device)
                .environmentObject(DIContainer())
        }
    }
}
