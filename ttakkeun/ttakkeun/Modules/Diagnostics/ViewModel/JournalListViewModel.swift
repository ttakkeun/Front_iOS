//
//  JournalListViewModel.swift
//  ttakkeun
//
//  Created by 정의찬 on 11/7/24.
//

import Foundation

class JournalListViewModel: ObservableObject {
    @Published var isSelectionMode: Bool = true
    @Published var selectedCnt: Int = 0
    
    @Published var journalListData: JournalListResponse?
    @Published var journalResultData: JournalResultResponse? = JournalResultResponse(category: .claw, date: "2024-05-11", time: "19:10:22.2211", qnaList: [QnAListData(question: "평소보다 털빠짐이 심한가요?", answer: ["털빠짐이 심해요"], image: ["https://i.namu.wiki/i/tyVGcLlVT6Tun2Q2jMF3wPUJcQBkLFx2sFyv8OtW5Aeg_WSGWMBczlYKyzgHxReqktu8ZqESSqDoCp4J9jyRdzPml5awOeERU3yIaKDBZ1m2qLgml683--d0M4C3YWBer80In3yRSr4suSW0c0Lzsw.webp", "https://i.namu.wiki/i/AAqta2XOGzlv_kLJGyKfVvL2i2nkRGngXI8Oh7a2heu9O4NQA_t9q28pPx2zAojfb_Ehc-SW57Y0xR3TZvDivXnp6KDEtI-Rkpu0aysUaX76giL1Ae9xjHUtNShGGwl9j3NyFRRpGZphzVaE6AzIZw.webp"]), QnAListData(question: "평소보다 털빠짐이 심한가요?", answer: ["털빠짐이 심해요"], image: ["https://i.namu.wiki/i/tyVGcLlVT6Tun2Q2jMF3wPUJcQBkLFx2sFyv8OtW5Aeg_WSGWMBczlYKyzgHxReqktu8ZqESSqDoCp4J9jyRdzPml5awOeERU3yIaKDBZ1m2qLgml683--d0M4C3YWBer80In3yRSr4suSW0c0Lzsw.webp", "https://i.namu.wiki/i/AAqta2XOGzlv_kLJGyKfVvL2i2nkRGngXI8Oh7a2heu9O4NQA_t9q28pPx2zAojfb_Ehc-SW57Y0xR3TZvDivXnp6KDEtI-Rkpu0aysUaX76giL1Ae9xjHUtNShGGwl9j3NyFRRpGZphzVaE6AzIZw.webp"]), QnAListData(question: "평소보다 털빠짐이 심한가요?", answer: ["털빠짐이 심해요"], image: ["https://i.namu.wiki/i/tyVGcLlVT6Tun2Q2jMF3wPUJcQBkLFx2sFyv8OtW5Aeg_WSGWMBczlYKyzgHxReqktu8ZqESSqDoCp4J9jyRdzPml5awOeERU3yIaKDBZ1m2qLgml683--d0M4C3YWBer80In3yRSr4suSW0c0Lzsw.webp", "https://i.namu.wiki/i/AAqta2XOGzlv_kLJGyKfVvL2i2nkRGngXI8Oh7a2heu9O4NQA_t9q28pPx2zAojfb_Ehc-SW57Y0xR3TZvDivXnp6KDEtI-Rkpu0aysUaX76giL1Ae9xjHUtNShGGwl9j3NyFRRpGZphzVaE6AzIZw.webp"]), QnAListData(question: "평소보다 털빠짐이 심한가요?", answer: ["털빠짐이 심해요"], image: ["https://i.namu.wiki/i/tyVGcLlVT6Tun2Q2jMF3wPUJcQBkLFx2sFyv8OtW5Aeg_WSGWMBczlYKyzgHxReqktu8ZqESSqDoCp4J9jyRdzPml5awOeERU3yIaKDBZ1m2qLgml683--d0M4C3YWBer80In3yRSr4suSW0c0Lzsw.webp", "https://i.namu.wiki/i/AAqta2XOGzlv_kLJGyKfVvL2i2nkRGngXI8Oh7a2heu9O4NQA_t9q28pPx2zAojfb_Ehc-SW57Y0xR3TZvDivXnp6KDEtI-Rkpu0aysUaX76giL1Ae9xjHUtNShGGwl9j3NyFRRpGZphzVaE6AzIZw.webp"])], etcString: "오늘은 털빠짐이 너무 심합니다. 왜그럴까요!?, 오늘은 털빠짐이 너무 심합니다. 왜그럴까요!?, 오늘은 털빠짐이 너무 심합니다. 왜그럴까요!?오늘은 털빠짐이 너무 심합니다. 왜그럴까요!?, 오늘은 털빠짐이 너무 심합니다. 왜그럴까요!?,")
    
    @Published var selectedItem: Set<Int> = []
    @Published var showDetailJournalList: Bool = false
    
    @Published var showAiDiagnosing: Bool = false
    @Published var aiPoint: Int = 10
}
