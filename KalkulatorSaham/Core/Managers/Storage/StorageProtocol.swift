//
//  StorageProtocol.swift
//  KalkulatorSaham
//
//  Created by Alfin on 10/03/23.
//

import Foundation


protocol StorageProtocol {
    func get<T>(_ key: String, type: T.Type) -> T? where T : Codable
    func set<T>(_ key: String, _ item: T) where T : Codable
    func delete(_ key: String)
}
