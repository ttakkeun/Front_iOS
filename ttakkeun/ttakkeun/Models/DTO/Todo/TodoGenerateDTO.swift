//
//  MakeTodoRequest.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/17/24.
//

import Foundation

struct TodoGenerateRequest: Codable {
    let petId: Int
    let todoCategory: PartItem.RawValue
    let todoName: String
}
