//
//  NotificationsVM.swift
//  Done
//
//  Created by Mazhar Hussain on 21/06/2022.
//

import Foundation
import Combine

class NotificationsVM{
    
    var items = [NotificationsModel]()
    var todayitems = [NotificationsModel]()
    var yesterdayitems = [NotificationsModel]()
    
    private var cancellables = Set<AnyCancellable>()
    let notificationsResult = PassthroughSubject<NotificationsModel, Error>()
    @Published private(set) var state = State.idle
    
    func getAllNotifications(page: String) {
        SideMenuRepo.getNotificationsSummary(page: page)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    //                    self?.state = .error(error.localizedDescription)
                    self?.notificationsResult.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                self?.notificationsResult.send(result)
                
                //                self?.state = .loaded(result.message ?? "")
            }).store(in: &cancellables)
    }
    //    func differentiateItems(){
    //        let formatter = DateFormatter()
    //        formatter.timeStyle = .none
    //        formatter.dateStyle = .full
    //        formatter.timeZone = TimeZone.current
    //
    //        todayitems = items.filter {
    //            formatter.string(from: $0.date) == formatter.string(from: Date())
    //
    //        }
    //        yesterdayitems = items.filter {  formatter.string(from: $0.date) != formatter.string(from: Date()) }
    //    }
    
}
