//
//  DiagnosisResultView.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/21/24.
//

import SwiftUI

struct DiagnosisResultView: View {
    
    @ObservedObject var viewModel: DiagnosticResultViewModel
    
    init(viewModel: DiagnosticResultViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.vertical, showsIndicators: false) {
                ZStack(alignment: .top) {
                    Icon.ProfileCat.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 114, height: 102)
                        .zIndex(1)
                    
                    LazyVStack(spacing: 0, content: {
                        if let datas = viewModel.diagnosisList?.diagnoses {
                            ForEach(datas, id: \.id) { data in
                                DiagnosisTower(data: data)
                            }
                        }
                    })
                    .frame(alignment: .bottom)
                    .padding(.top, 75)
                    .padding(.bottom, 80)
                    .zIndex(0)
                }
                .frame(minHeight: 750)
            }
            .frame(maxHeight: 590)
            .onAppear {
                if let lastID = viewModel.diagnosisList?.diagnoses.last?.id {
                    scrollProxy.scrollTo(lastID, anchor: .bottom) // 초기 위치를 마지막 항목으로 설정
                }
            }
        }
    }
}

struct DiagnosisResultView_Preview: PreviewProvider {
    static var previews: some View {
        DiagnosisResultView(viewModel: DiagnosticResultViewModel(petId: 0))
            .previewLayout(.sizeThatFits)
    }
}
