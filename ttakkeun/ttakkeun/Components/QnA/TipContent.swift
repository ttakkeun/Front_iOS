//
//  TipContent.swift
//  ttakkeun
//
//  Created by 한지강 on 8/7/24.
//

import SwiftUI
import Kingfisher

/// Tip뷰에서 Tip관련 정보들이 들어있는 컴포넌트
struct TipContent: View {
    let data: QnaTipsResponseData
    @ObservedObject var viewModel: QnaTipsViewModel

    @State private var isExpanded: Bool = false
    @State private var isLike: Bool = false
    @State private var totalLikes: Int = 0
    
    //MARK: - Init
    init(data: QnaTipsResponseData, viewModel: QnaTipsViewModel) {
        self.data = data
        self.viewModel = viewModel
        
        _isLike = State(initialValue: data.recommend_count ?? 0 > 0)
        _totalLikes = State(initialValue: data.recommend_count ?? 0)
    }
    
    //MARK: - Contents
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            categoryAndHeart
            if isExpanded {
                expandedContent
                    .transition(.opacity)
            } else {
                contentSet
            }
            BottomInfo
        }
        .frame(maxWidth: 355)
        .padding(14)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .fill(.clear)
                .stroke(Color.gray400)
        )
        .animation(.easeInOut(duration: 0.5), value: isExpanded)
    }
    
    // 카테고리와 하트버튼
    private var categoryAndHeart: some View {
        HStack{
            categorySet
            Spacer()
            heartBtn
        }
    }
    
    /// 상단에 보이는 카테고리 집합
    private var categorySet: some View {
        HStack(spacing: 5) {
            category
                .font(.Body4_medium)
                .frame(width: 47, height: 23)
                .background(RoundedRectangle(cornerRadius: 30).foregroundStyle(categoryColor))
            
            if data.popular { // 인기 카테고리가 아니라, popular 값이 true일 때 "인기" 텍스트가 표시되도록 수정
                Text("인기")
                    .font(.Body4_medium)
                    .frame(width: 47, height: 23)
                    .background(RoundedRectangle(cornerRadius: 30).foregroundStyle(Color.primarycolor200))
            }
        }
    }
    
    /// 더보기 버튼 눌렀을 때 내용들
    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            title
                .lineLimit(nil)
            expandedcontent
            tipsImages
        }
    }
    
    /// 제목, 내용, 사진 등 tip관련 content집합
    private var contentSet: some View {
        HStack(alignment: .top){
            TitleAndContent
                .lineLimit(3)
            Spacer()
            tipsImageWithCount
        }
    }
    
    /// 제목과 내용
    private var TitleAndContent: some View {
        VStack(alignment: .leading, spacing: 12){
            title
            content
        }
    }
    
    /// 사용자 이름과 지난 시간, 더보기버튼
    private var BottomInfo: some View {
        HStack{
            userNameAndElapsedTime
            Spacer()
            moreInfoBtn
        }
    }
    
    // 하트와 하트 수
    private var heartBtn: some View {
        Button(action: {
            isLike.toggle()
            totalLikes += isLike ? 1 : -1
            Task {
                await viewModel.patchHeartChange(tip_id: data.tip_id)
                DispatchQueue.main.async {
                    isLike = viewModel.heartClicked
                    totalLikes = viewModel.totalLikes
                }
            }
        }, label: {
            HStack(spacing: 6){
                Image(systemName: isLike ? "heart.fill" : "heart")
                    .foregroundColor(isLike ? .red : .gray)
                Text("\(totalLikes)")
                    .foregroundColor(.gray600)
            }
        })
    }
    
    /// 제목
    private var title: some View {
        Text(data.title)
            .frame(maxWidth: 210, alignment: .leading)
            .font(.Body2_semibold)
            .foregroundStyle(Color.gray900)
    }
    
    /// 내용
    private var content: some View {
        Text(data.content.split(separator: "").joined(separator: "\u{200B}"))
            .frame(maxWidth: 210, alignment: .leading)
            .font(.Body4_medium)
            .foregroundStyle(Color.gray_300)
            .multilineTextAlignment(.leading)
    }
    
    /// 펼쳐지면 나오는 내용(레이아웃 바뀌어야 해서 추가함)
    private var expandedcontent: some View {
        Text(data.content.split(separator: "").joined(separator: "\u{200B}"))
            .frame(alignment: .leading)
            .font(.Body4_medium)
            .foregroundStyle(Color.gray_300)
            .multilineTextAlignment(.leading)
    }
    
    /// 팁 관련 이미지
    @ViewBuilder
       private var tipsImages: some View {
           if let imageUrls = data.image_url, !imageUrls.isEmpty {
               ScrollView(.horizontal, showsIndicators: false) {
                   HStack(spacing: 10) {
                       ForEach(imageUrls, id: \.self) { url in
                           if let imageUrl = URL(string: url) {
                               KFImage(imageUrl)
                                   .placeholder {
                                       ProgressView()
                                           .frame(width: 100, height: 100)
                                   }
                                   .retry(maxCount: 2, interval: .seconds(2))
                                   .onFailure { _ in
                                       print("이미지 로드 실패")
                                   }
                                   .resizable()
                                   .aspectRatio(contentMode: .fill)
                                   .frame(width: 65, height: 65)
                                   .clipShape(RoundedRectangle(cornerRadius: 10))
                           }
                       }
                   }
               }
           }
       }
       
       /// 첫 번째 이미지를 표시하고, 이미지가 2개 이상일 경우 개수를 표시하는 뷰
       @ViewBuilder
       private var tipsImageWithCount: some View {
           if let imageUrls = data.image_url, !imageUrls.isEmpty {
               ZStack(alignment: .bottomTrailing) {
                   if let firstImageUrl = URL(string: imageUrls[0]) {
                       KFImage(firstImageUrl)
                           .placeholder {
                               ProgressView()
                                   .frame(width: 65, height: 65)
                           }
                           .retry(maxCount: 2, interval: .seconds(2))
                           .onFailure { _ in
                               print("이미지 로드 실패")
                           }
                           .resizable()
                           .aspectRatio(contentMode: .fill)
                           .frame(width: 65, height: 65)
                           .clipShape(RoundedRectangle(cornerRadius: 10))
                   }
                   
                   if imageUrls.count > 1 {
                       Text("\(imageUrls.count)")
                           .padding(.horizontal,2)
                           .padding(4)
                           .font(.Detail1_bold)
                           .background(Color.gray800)
                           .foregroundColor(.white)
                           .clipShape(RoundedRectangle(cornerRadius: 10))
                   }
               }
           }
       }
    
    /// 사용자 이름과 지난 시간
    private var userNameAndElapsedTime: some View {
        HStack{
            Text(maskUserName(data.author))
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
            
            Text(formatElapsedTime(data.created_at))
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
        }
    }
    
    /// 더보기 버튼
    private var moreInfoBtn: some View {
        Button(action: { isExpanded.toggle() }, label: {
            Text("더보기")
                .font(.Body4_medium)
                .foregroundStyle(Color.gray400)
                .underline()
        })
    }
    
    /// 카테고리 텍스트
    @ViewBuilder
    private var category: some View {
        switch data.category {
        case .ear:
            Text("귀")
        case .eye:
            Text("눈")
        case .hair:
            Text("털")
        case .claw:
            Text("발톱")
        case .tooth:
            Text("이빨")
        case .etc:
            Text("기타")
        case .best:
            Text("인기")
        default:
            Text("")
        }
    }
    
    /// 카테고리 색깔
    private var categoryColor: Color {
        switch data.category {
        case .ear:
            Color.qnAEar
        case .eye:
            Color.afterEye
        case .hair:
            Color.afterClaw
        case .claw:
            Color.afterEye
        case .tooth:
            Color.afterTeeth
        case .best:
            Color.primarycolor200
        default:
            Color.clear
        }
    }

    // 사용자 이름 마스킹 함수
    private func maskUserName(_ name: String) -> String {
        let nameParts = name.split(separator: " ")
        
        if nameParts.count == 1 {
            let firstPart = nameParts[0]
            
            if firstPart.count == 2 {
                let first = firstPart.prefix(1)
                return "\(first)*"
            } else if firstPart.count > 2 {
                let first = firstPart.prefix(1)
                let remaining = firstPart.dropFirst().dropFirst()
                return "\(first)*\(remaining)"
            } else {
                return String(firstPart)
            }
        } else if nameParts.count > 1 {
            let firstName = nameParts.first ?? ""
            let lastName = nameParts.dropFirst().joined(separator: " ")
            
            let maskedLastName = String(repeating: "*", count: lastName.count)
            return "\(firstName) \(maskedLastName)"
        }
        
        return name
    }

    // 경과 시간을 포맷팅하는 함수
    private func formatElapsedTime(_ createdAt: String) -> String {
        guard let date = ISO8601DateFormatter().date(from: createdAt) else { return "알 수 없음" }
        let now = Date()
        let elapsedTime = now.timeIntervalSince(date)
        let minutes = Int(elapsedTime / 60)
        let hours = minutes / 60
        
        if elapsedTime < 24 * 60 * 60 {
            if hours > 0 {
                return "\(hours)시간 \(minutes % 60)분 전"
            } else {
                return "\(minutes)분 전"
            }
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"
            return dateFormatter.string(from: date)
        }
    }
}

// MARK: - Preview
struct TipContent_Preview: PreviewProvider {
    static var previews: some View {
        let sampleData = QnaTipsResponseData(
            tip_id: 1,
            category: .ear,
            author: "한강민지",
            popular: true,
            title: "털 안꼬이게 빗는 법 꿀팁공유",
            content: "털은 빗어주지 않으면 어쩌구저쩌구 솰라솰라 어쩌구저쩌구 솰라솰라아 진짜 미치겠다 아아아아 그만할래아아",
            image_url: ["https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg",
                        "https://cdn.news.unn.net/news/photo/202110/516864_318701_956.jpg"],
            created_at: "2024-08-14T12:00:00Z",
            recommend_count: 20
        )
        
        TipContent(data: sampleData, viewModel: QnaTipsViewModel())
            .previewLayout(.sizeThatFits)
    }
}
