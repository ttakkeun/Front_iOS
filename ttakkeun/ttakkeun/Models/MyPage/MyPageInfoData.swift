//
//  MyPageInfoData.swift
//  ttakkeun
//
//  Created by 황유빈 on 11/18/24.
//

import Foundation

/// 마이페이지 정보 박스에 들어갈 데이터들
/// MyPageInfo Data Struct
struct MyPageInfo {
    let title: String
    let firstBtn: BtnInfo
    let secondBtn: BtnInfo
    let thirdBtn: BtnInfo?
}

/// 개별 버튼 정보
struct BtnInfo {
    let name: String
    let action: () -> Void
}
