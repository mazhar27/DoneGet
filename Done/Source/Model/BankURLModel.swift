//
//  BankURLModel.swift
//  Done
//
//  Created by Mazhar Hussain on 24/08/2022.
//

import Foundation

struct BankHostedData : Codable {
    let gatewayUrl : String?
//    let trandata : [Trandata]?

    enum CodingKeys: String, CodingKey {

        case gatewayUrl = "GatewayUrl"
//        case trandata = "trandata"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        gatewayUrl = try values.decodeIfPresent(String.self, forKey: .gatewayUrl)
//        trandata = try values.decodeIfPresent([Trandata].self, forKey: .trandata)
    }

}
struct Trandata : Codable {
    let amt : String?
    let action : String?
    let password : String?
    let id : String?
    let currencyCode : String?
    let trackId : String?
    let responseURL : String?
    let errorURL : String?
    let langid : String?
    let udf1 : String?
    let udf2 : String?

    enum CodingKeys: String, CodingKey {

        case amt = "amt"
        case action = "action"
        case password = "password"
        case id = "id"
        case currencyCode = "currencyCode"
        case trackId = "trackId"
        case responseURL = "responseURL"
        case errorURL = "errorURL"
        case langid = "langid"
        case udf1 = "udf1"
        case udf2 = "udf2"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amt = try values.decodeIfPresent(String.self, forKey: .amt)
        action = try values.decodeIfPresent(String.self, forKey: .action)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        currencyCode = try values.decodeIfPresent(String.self, forKey: .currencyCode)
        trackId = try values.decodeIfPresent(String.self, forKey: .trackId)
        responseURL = try values.decodeIfPresent(String.self, forKey: .responseURL)
        errorURL = try values.decodeIfPresent(String.self, forKey: .errorURL)
        langid = try values.decodeIfPresent(String.self, forKey: .langid)
        udf1 = try values.decodeIfPresent(String.self, forKey: .udf1)
        udf2 = try values.decodeIfPresent(String.self, forKey: .udf2)
    }

}

struct BankResponseData : Codable {
    let arbResponse : ArbResponse?

    enum CodingKeys: String, CodingKey {

        case arbResponse = "ArbResponse"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        arbResponse = try values.decodeIfPresent(ArbResponse.self, forKey: .arbResponse)
    }

}
struct ArbResponse : Codable {
    let date : String?
    let authRespCode : String?
    let authCode : String?
    let transId : Int?
    let trackId : String?
    let udf5 : String?
    let cardType : String?
    let udf6 : String?
    let udf10 : String?
    let amt : String?
    let udf3 : String?
    let udf4 : String?
    let udf1 : String?
    let udf2 : String?
    let result : String?
    let ref : String?
    let udf9 : String?
    let paymentId : Int?
    let udf7 : String?
    let udf8 : String?
    let fcCustId : String?
    let actionCode : String?
    let paymentTimestamp : String?

    enum CodingKeys: String, CodingKey {

        case date = "date"
        case authRespCode = "authRespCode"
        case authCode = "authCode"
        case transId = "transId"
        case trackId = "trackId"
        case udf5 = "udf5"
        case cardType = "cardType"
        case udf6 = "udf6"
        case udf10 = "udf10"
        case amt = "amt"
        case udf3 = "udf3"
        case udf4 = "udf4"
        case udf1 = "udf1"
        case udf2 = "udf2"
        case result = "result"
        case ref = "ref"
        case udf9 = "udf9"
        case paymentId = "paymentId"
        case udf7 = "udf7"
        case udf8 = "udf8"
        case fcCustId = "fcCustId"
        case actionCode = "actionCode"
        case paymentTimestamp = "paymentTimestamp"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        authRespCode = try values.decodeIfPresent(String.self, forKey: .authRespCode)
        authCode = try values.decodeIfPresent(String.self, forKey: .authCode)
        transId = try values.decodeIfPresent(Int.self, forKey: .transId)
        trackId = try values.decodeIfPresent(String.self, forKey: .trackId)
        udf5 = try values.decodeIfPresent(String.self, forKey: .udf5)
        cardType = try values.decodeIfPresent(String.self, forKey: .cardType)
        udf6 = try values.decodeIfPresent(String.self, forKey: .udf6)
        udf10 = try values.decodeIfPresent(String.self, forKey: .udf10)
        amt = try values.decodeIfPresent(String.self, forKey: .amt)
        udf3 = try values.decodeIfPresent(String.self, forKey: .udf3)
        udf4 = try values.decodeIfPresent(String.self, forKey: .udf4)
        udf1 = try values.decodeIfPresent(String.self, forKey: .udf1)
        udf2 = try values.decodeIfPresent(String.self, forKey: .udf2)
        result = try values.decodeIfPresent(String.self, forKey: .result)
        ref = try values.decodeIfPresent(String.self, forKey: .ref)
        udf9 = try values.decodeIfPresent(String.self, forKey: .udf9)
        paymentId = try values.decodeIfPresent(Int.self, forKey: .paymentId)
        udf7 = try values.decodeIfPresent(String.self, forKey: .udf7)
        udf8 = try values.decodeIfPresent(String.self, forKey: .udf8)
        fcCustId = try values.decodeIfPresent(String.self, forKey: .fcCustId)
        actionCode = try values.decodeIfPresent(String.self, forKey: .actionCode)
        paymentTimestamp = try values.decodeIfPresent(String.self, forKey: .paymentTimestamp)
    }

}



