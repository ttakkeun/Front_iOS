//
//  DiagnosisTower.swift
//  ttakkeun
//
//  Created by 정의찬 on 12/18/24.
//

import SwiftUI

/// 뼈 타워
struct DiagnosticTower: View {
    
    // MARK: - Property
    let data: diagDetailData
    let onTap: () -> Void
    
    
    // MARK: - Constants
    fileprivate enum DiagnosisTowerConstants {
        static let blurValue: CGFloat = 0.5
        static let imageHeight: CGFloat = 71
        static let imageSpacer: CGFloat = 64
        static let cgOffsets: [CGSize] = [
            CGSize(width: -1, height: -1),
            CGSize(width:  0, height: -1),
            CGSize(width:  1, height: -1),
            CGSize(width: -1, height:  0),
            CGSize(width:  1, height:  0),
            CGSize(width: -1, height:  1),
            CGSize(width:  0, height:  1),
            CGSize(width:  1, height:  1)
        ]
    }
    
    // MARK: - Init
    init(data: diagDetailData, onTap: @escaping () -> Void) {
        self.data = data
        self.onTap = onTap
    }
    
    var body: some View {
        ZStack {
            towerImage
            diagInfoText
        }
        .onTapGesture {
            onTap()
        }
    }
    
    /// 일지 날짜 시간 데이터
    private var diagInfoText: some View {
        HStack {
            contentsText(data.created_at.convertedToKoreanTimeDateString())
            Spacer().frame(maxWidth: DiagnosisTowerConstants.imageSpacer)
            contentsText(data.created_at.toHourMinuteString())
        }
    }
    
    /// 일지 점수에 연관된 뼈 이미지
    private var towerImage: some View {
        towerImageBranch()
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity)
    }
    
    /// 날짜 및 시간 표시 데이터
    /// - Parameter date: 날짜 데이터
    /// - Returns: 텍스트 뷰 반환
    private func contentsText(_ date: String) -> some View {
        ZStack {
            ForEach(DiagnosisTowerConstants.cgOffsets, id: \.self) { offset in
                Text(date)
                    .font(.Body2_bold)
                    .foregroundStyle(.black)
                    .offset(offset)
            }

            // 중앙 흰색 텍스트
            Text(date)
                .font(.Body2_bold)
                .foregroundStyle(.white)
        }
    }
    
    private func towerImageBranch() -> Image {
        switch data.score {
        case 0...20:
            return Image(.bonesFirst)
        case 20...40:
            return Image(.bonesSecond)
        case 40...60:
            return Image(.bonesThird)
        case 60...80:
            return Image(.bonesFourth)
        case 80...100:
            return Image(.bonesFifth)
        default:
            return Image(.bonesFirst)
        }
    }
}

#Preview {
    DiagnosticTower(data: .init(diagnose_id: 0, created_at: "2025-07-15T12:32:54.260Z", score: 100), onTap: {
        print("hello")
    })
}
