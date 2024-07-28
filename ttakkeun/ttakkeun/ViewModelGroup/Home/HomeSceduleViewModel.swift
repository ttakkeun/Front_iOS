//
//  HomeSceduleManagement.swift
//  ttakkeun
//
//  Created by 정의찬 on 7/28/24.
//

import Foundation
import Moya

@MainActor
class HomeSceduleViewModel: ObservableObject {
    @Published var scheduleData: ScheduleInquiry?
    @Published var inputDate: DateRequestData
    
    private let provider: MoyaProvider<ScheduleAPITarget>
    
    // MARK: - Init
    
    init(provider: MoyaProvider<ScheduleAPITarget> = APIManager.shared.testProvider(for: ScheduleAPITarget.self)) {
        self.provider = provider
        
        let currentDate = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        let day = calendar.component(.day, from: currentDate)
        
        self.inputDate = DateRequestData(year: year, month: month, date: day)
    }
    
    // MARK: - API Function
    
    /// 스케줄 일정 조회 API 호출 함수
    /// - Parameter currentDate: 현재 날짜 기준 전달
    public func getScheduleData(currentDate: DateRequestData) async {
        provider.request(.getCalendar(dateData: currentDate)) { [weak self] result in
            switch result {
            case .success(let response):
                self?.handleScheduleResponse(response: response)
            case .failure(let error):
                print("Todo 캘린더 조회 네트워크 오류: \(error)")
            }
        }
    }
    
    /// ToDo 캘린더 조회 Response 핸들러
    /// - Parameter response: API 호출 후, Response 데이터
    private func handleScheduleResponse(response: Response) {
        do {
            let decodedDate = try JSONDecoder().decode(ScheduleInquiry.self, from: response.data)
            DispatchQueue.main.async {
                self.scheduleData = decodedDate
            }
        } catch {
            print("ToDo 캘린더 조회 디코더 에러: \(error)")
        }
    }

    
}
