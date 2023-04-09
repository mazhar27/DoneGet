//
//  UserAddress.swift
//  Done
//
//  Created by Mazhar Hussain on 10/06/2022.
//

import Foundation
class AddressList: NSObject, Codable {
    var list = [UserAddress]()
    
    override init() {}
    
    convenience init(list: [UserAddress]) {
        self.init()
        self.list = list
    }
}

class UserAddress: NSObject, Codable {
    var addressId = ""
    var lat = ""
    var long = ""
    var title = ""
    var address = ""
    var noteToProvider = ""
    var street = ""
    var floor = ""
    var isSelected = false
    override init(){}
    
    init(addressId: String, lat: String, long: String, title: String, address: String, noteToProvider: String, street: String,floor: String) {
        self.addressId = addressId
        self.lat = lat
        self.long = long
        self.title = title
        self.address = address
        self.noteToProvider = noteToProvider
        self.street = street
        self.floor = floor
    }
    
    
}

