//
//  Storage.swift
//  KalkulatorSaham
//
//  Created by Alfin on 10/03/23.
//

import Foundation

class UserDefaultsStorage: StorageProtocol {
        
    func get<T>(_ key: String, type: T.Type) -> T? where T : Codable {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        
        // Decode JSON data to object
        do {
            let item = try JSONDecoder().decode(type, from: data)
            
            print("[STORAGE - GET] \(key): \(item)")
            
            return item
        } catch {
            print("Fail to decode item for keychain: \(error)")
            return nil
        }
    }
    
    func set<T>(_ key: String, _ item: T) where T : Codable {
        do {
            // Encode as JSON data and save in keychain
            let data = try JSONEncoder().encode(item)
            
            UserDefaults.standard.set(data, forKey: key)
            
            print("[STORAGE - SET] \(key): \(item)")
            
        } catch {
            print("Fail to encode item for keychain: \(error)")
        }
    }
    
    func delete(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
}
