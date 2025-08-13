//
//  MyPageInfoBox.swift
//  ttakkeun
//
//  Created by 황유빈 on 11/18/24.
//

import SwiftUI

/// 마이페이지 메인화면 인포버튼 들어간 박스들(재사용하기 위해서)
struct MyPageInfoBox: View {
    
    // MARK: - Property
    let groupType: MypageGroupType
    let showVersionInfo: Bool
    let actions: [MyPageItemType: () -> Void]
    
    // MARK: - Constants
    fileprivate enum MyPageInfoConstants {
        static let contentsVspacing: CGFloat = 14
    }
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    // MARK: - Init
    init(
        groupType: MypageGroupType,
        showVersionInfo: Bool = false,
        actions: [MyPageItemType : () -> Void]
    ) {
        self.groupType = groupType
        self.showVersionInfo = showVersionInfo
        self.actions = actions
    }
    
    var body: some View {
        GroupBox(content: {
            contents
        }, label: {
            labelBranch
        })
    }
    
    // MARK: - Label
    @ViewBuilder
    private var labelBranch: some View {
        if showVersionInfo {
            appVersionLabel
        } else {
            label
        }
    }
    
    /// 기본 라벨
    private var label: some View {
        Text(groupType.title)
            .font(groupType.font)
            .foregroundStyle(groupType.foregroundStyle)
    }
    
    /// 앱 버전 존재할 경우 상단 라벨
    private var appVersionLabel: some View {
        HStack {
            label
            Spacer()
            versionText
        }
    }
    
    /// 앱 버전 텍스트
    private var versionText: some View {
        Text("V\(appVersion)")
            .font(.Body4_medium)
            .foregroundStyle(Color.gray300)
    }
    
    // MARK: - Contents
    /// 그룹 박스 내부 컨텐츠
    private var contents: some View {
        VStack(alignment: .leading, spacing: MyPageInfoConstants.contentsVspacing, content: {
            ForEach(groupType.items, id: \.self) { item in
                HStack {
                    contentText(item: item)
                    Spacer()
                }
            }
        })
        .padding(.vertical, MyPageInfoConstants.contentsVspacing)
    }
    
    /// 아이템에 해당하는 버튼
    /// - Parameter item: 아이템 타입
    /// - Returns: 버튼 반환
    private func contentText(item: MyPageItemType) -> some View {
        Button(action: {
            withAnimation {
                action(item)
            }
        }, label: {
            Text(item.title)
                .font(item.font)
                .foregroundStyle(item.foregroundStyle)
        })
    }
    
    /// 아이템별 액션 가지기
    /// - Parameter item: 아이템 타입
    private func action(_ item: MyPageItemType) {
        actions[item]?()
    }
}

#Preview {
    MyPageInfoBox(groupType: .account, showVersionInfo: false, actions: [
        .logout: { print("로그아웃 ")}
    ])
}
