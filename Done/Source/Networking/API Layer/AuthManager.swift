//
//  AuthManager.swift
//  Done
//
//  Created by Mazhar Hussain on 7/3/22.
//

import Foundation

//actor AuthManager {
//    private var currentToken: Token?
//    private var refreshTask: Task<Token, Error>?
//    
//    func validToken() async throws -> String? {
//        if let token = UserDefaults.LoginUser?.token {
//            if let access_token = token.accessToken, let expry = token.expiresIn {
//                let expire_date = Date(timeIntervalSince1970: TimeInterval(expry))
//                if Date() < expire_date {
//                    return access_token
//                }
//            }
//        }
//        
//        return try await refreshToken()
//    }
//    
//    func refreshToken() async throws -> Token {
//        if let refreshTask = refreshTask {
//            return try await refreshTask.value
//        }
//
//        let task = Task { () throws -> Token in
//            defer { refreshTask = nil }
//
//            return await OnboardingRepo.refresh()
//            // Normally you'd make a network call here. Could look like this:
//            // return await networking.refreshToken(withRefreshToken: token.refreshToken)
//
//            // I'm just generating a dummy token
//            let tokenExpiresAt = Date().addingTimeInterval(10)
//            let newToken = Token(validUntil: tokenExpiresAt, id: UUID())
//            currentToken = newToken
//
//            return newToken
//        }
//
//        self.refreshTask = task
//
//        return try await task.value
//    }
//    
//}
