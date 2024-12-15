//
//  TodoCompletionViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/21/24.
//

import Foundation

class TodoCompletionViewModel: ObservableObject {
    @Published var completionData: TodoCompleteResponse?
    
    let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
}
