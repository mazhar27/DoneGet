//
//  providerProfileRepo.swift
//  Done
//
//  Created by Dtech Mac on 12/09/2022.
//

import Foundation
import Combine
class providerProfileRepo {
    // Get User Profile
    static func getProviderProfileData() -> Future<BaseModel<ProfileInnerData>,NetworkError> {
        let params:[String: Any] = [:]
        return NetworkManager.shared.request(url: Router.providerProfile(parameters: params))

    }
    // Delete Provider Account
    static func deleteProviderAccount(pin: String) -> Future<APIResponse,NetworkError>  {
        let params:[String: Any] = ["pin": pin]
        return NetworkManager.shared.netWorkRequest(url: Router.deleteProviderAccount(parameters: params))

    }
}
