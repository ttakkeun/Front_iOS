//
//  WriteTipsRequest.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/13/24.
//

import Foundation

struct WriteTipsRequest: Codable {
    let title: String
    let content: String
    let category: String
}
