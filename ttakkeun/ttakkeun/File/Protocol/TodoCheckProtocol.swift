//
//  TodoCheckProtocol.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/20/24.
//

import Foundation

protocol TodoCheckProtocol {
    func toggleTodoStatus(for category: PartItem, todoID: UUID)
}
