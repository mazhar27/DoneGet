//
//  Enums.swift
//  Done
//
//  Created by Mazhar Hussain on 6/22/22.
//

import Foundation

enum UserType: Int, Codable{
    case guest = 0
    case customer
    case provider
}
 
enum State {
    case idle
    case loading
    case loaded(String)
    case noInternet(String)
    case error(String)
}
