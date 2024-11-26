//
//  ttakkeunApp.swift
//  ttakkeun
//
//  Created by 정의찬 on 10/24/24.
//

import SwiftUI

@main
struct ttakkeunApp: App {
    
    @State var value = DiagnosingValue(selectedSegment: .journalList, selectedPartItem: .claw)
    
    var body: some Scene {
        WindowGroup {
            CalendarView()
        }
    }
}
