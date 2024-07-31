//
//  PetState.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/23/24.
//

import Foundation

/// 선택된 펫 정보 관리
class PetState: ObservableObject {
    @Published var petName: String? = nil
    @Published var petId: Int?
}
