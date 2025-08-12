//
//  DeleteAccountViewModel.swift
//  ttakkeun
//
//  Created by Apple Coding machine on 8/12/25.
//

import Foundation

@Observable
class DeleteAccountViewModel {
    var currentPage: DeletePageType = .firstPage
    var etcReason: String = ""
    var selectedReasons: Set<DeleteReasonType> = .init()
    
    // MARK: - CheckProperty
    var isAgreementCheck: Bool = false
    var isMyAccountCheck: Bool = false
    
    // MARK: - Dependency
    var container: DIContainer
    
    // MARK: - Init
    init(container: DIContainer) {
        self.container = container
    }
}
