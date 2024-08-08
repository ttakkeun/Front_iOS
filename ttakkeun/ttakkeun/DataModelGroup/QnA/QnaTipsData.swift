//
//  QnaTipsData.swift
//  ttakkeun
//
//  Created by 한지강 on 8/7/24.
//

import SwiftUI

struct QnaTipsData : Identifiable, Codable {
    var id = UUID()
    var category: PartItem
    var title: String
    var content: String
    var userName: String
    var elapsedTime: Int
    
    var heartNumber: Int?
}
