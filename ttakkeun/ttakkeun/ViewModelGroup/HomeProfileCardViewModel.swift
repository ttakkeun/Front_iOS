//
//  HomeProfileCardViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/15/24.
//

import Foundation

@MainActor
class HomeProfileCardViewModel: ObservableObject {
    @Published var profileData: HomeProfileData?
    @Published var isChangeCard:  Bool = true
}
