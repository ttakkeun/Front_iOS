//
//  AnswerString.swift
//  ttakkeun
//
//  Created by 정의찬 on 8/6/24.
//

import Foundation

enum AnswerValue: String {
    
    // MARK: - 털 카테고리 답변
    
    /* 털에 윤기가 잘 나고 있나요? */
    case notShine = "윤기가 없어요"
    case shine = "윤기가 나요"
    
    /* 평소보다 털빠짐이 심한가요? */
    case notAlopecia = "털이 많이 빠지지 않아요"
    case alopecia = "털이 많이 빠져요"
    
    /* 집중적으로 핥거나 긁는 부위가 있나요? */
    case notScratch = "해당 부위가 없어요"
    case scratch = "해당 부위가 있어요"

}
