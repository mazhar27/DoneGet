//
//  ServicesDetailFormViewModel.swift
//  Done
//
//  Created by Mazhar Hussain on 14/07/2022.
//

import Foundation
import Combine
import UIKit

class ServicesDetailFormViewModel{
    
    private var cancellables = Set<AnyCancellable>()
    let categoriesResult = CurrentValueSubject<[Service_questions], Error>([])
    let validationResult = PassthroughSubject<FormData, Error>()
    let imagesUploadResult = PassthroughSubject<[String], Error>()
    @Published private(set) var state = State.idle
    
    func getServicesForm(serviceID: String, categoryID: String) {
        DashboardRepo.getServicesDetailForm(serviceId: serviceID, categoryID: categoryID)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.validationResult.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let formdata = result.data{
                    self?.validationResult.send(formdata)
                }

            }).store(in: &cancellables)
    }
    
    func uploadImages(images: [UIImage]?) {
        DashboardRepo.uploadImages(images: images)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.imagesUploadResult.send(completion: .failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] result in
                if let imagesData = result.data{
                    self?.imagesUploadResult.send(imagesData)
                }

            }).store(in: &cancellables)
    }
    
}
