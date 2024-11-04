//
//  TodoCheckProtocol.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/4/24.
//

import Foundation

protocol TodoCheckProtocol {
    func toggleTodoStatus(for category: PartItem, todoID: UUID)
}
