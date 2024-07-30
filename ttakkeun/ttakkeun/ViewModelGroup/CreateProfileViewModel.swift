//
//  CreateProfileViewModel.swift
//  ttakkeun
//
//  Created by 황유빈 on 7/30/24.
//

import Foundation

@MainActor
class CreateProfileViewModel: ObservableObject {
    @Published var requestData: CreatePetProfileRequestData?
}
