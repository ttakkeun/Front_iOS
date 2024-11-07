//
//  DiagnosingHeader.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import SwiftUI

struct DiagnosingValue {
    var selectedSegment: DiagnosingSegment
    var selectedPartItem: PartItem
}

struct DiagnosingHeader: View {
    
    @Binding var diagnosingValue: DiagnosingValue
    @Namespace var name
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
