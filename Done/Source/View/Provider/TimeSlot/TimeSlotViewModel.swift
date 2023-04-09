//
//  TimeSlotViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 14/09/2022.
//

import Foundation
import Combine

class TimeSlotViewModel{
    
    private var cancellables = Set<AnyCancellable>()
    let timeSlotsResult = PassthroughSubject<TimeSlotsData, Error>()
    @Published private(set) var state = State.idle
    
    func getAllProviderTimeSlots(date: String) {
        
        ProviderDashBoardRepo.getProviderSlotsBooking(date: date)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
//                    self?.state = .error(error.localizedDescription)
                    self?.timeSlotsResult.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let statData = result.data{
                    self?.timeSlotsResult.send(statData)
                }
//                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }
    func changeTimeSlot(slotId: String, date: String, status: String) {
        self.state = .loading
        ProviderDashBoardRepo.changeProviderTimeSlot(date: date, slotId: slotId, status: status)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.state = .error(error.errorDescription ?? "")
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let data = result.data {
                    print("response : \(result)")
                    print(data)
                    self?.state = .loaded(result.message ?? "")
                }
            }).store(in: &cancellables)
    }
    
    func gettingDateData()-> [String]{
        var dataArray = [String]()
        let anchor = Date()
        let calendar = Calendar.current

        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        for dayOffset in 0...15 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: anchor) {
                print(formatter.string(from: date))
              let dateString = DateFormatter.yyyyMMddWithDash.string(from: date)
                dataArray.append(dateString)
                
            }
        }
        return dataArray
    }
    
}
