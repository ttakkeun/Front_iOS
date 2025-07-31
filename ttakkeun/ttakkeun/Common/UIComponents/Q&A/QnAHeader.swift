//
//  QnAHeader.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/28/24.
//

import SwiftUI

struct QnAHeader: View {
    
    // MARK: - Property
    @Binding var selectedSegment: QnASegment
    @Namespace var name
    
    var body: some View {
        CustomSegment<QnASegment>(selectedSegment: $selectedSegment)
    }
}

struct QnAHeader_Preview: PreviewProvider {
    static var previews: some View {
        QnAHeader(selectedSegment: .constant(QnASegment.faq))
    }
}
