//
//  KeyChainHelper.swift
//  Done
//
//  Created by Mazhar Hussain on 7/4/22.
//

import Foundation

final class KeychainHelper {
    
    static let standard = KeychainHelper()
    private init() {}
    private let service = "com.Do-ne.Done"
    
    func save<T>(_ item: T, account: String) where T : Codable {
        
        do {
            let data = try JSONEncoder().encode(item)
            save(data, account)
            
        } catch {
            assertionFailure("Fail to encode item for keychain: \(error)")
        }
    }
    
    func read<T>(_ account: String, _ type: T.Type) -> T? where T : Codable {
        
        guard let data = read(account) else {
            return nil
        }
        do {
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            assertionFailure("Fail to decode item for keychain: \(error)")
            return nil
        }
    }
    
    // Save to keychain
    private func save(_ data: Data, _ account: String)  {
        
        let query = [kSecClass: kSecClassGenericPassword,
               kSecAttrAccount: account,
               kSecAttrService: service,
                 kSecValueData: data] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        print("status: \(status)")
        // If already exists then update
        if status == errSecDuplicateItem {
                let query = [
                    kSecAttrService: service,
                    kSecAttrAccount: account,
                    kSecClass: kSecClassGenericPassword,
                ] as CFDictionary

                let attributesToUpdate = [kSecValueData: data] as CFDictionary
                SecItemUpdate(query, attributesToUpdate)
            }
    }
    
    // read from keychain
    private func read(_ account: String) -> Data? {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    // delete from keychain
    func delete(_ account: String) {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
        
        // Delete item from keychain
        SecItemDelete(query)
    }
    
    
}
