//
//  Storage.swift
//  KalkulatorSaham
//
//  Created by Alfin on 10/03/23.
//

import Foundation
import ComposableArchitecture

private enum StorageDependencyKey: DependencyKey {
    static let liveValue: StorageProtocol = UserDefaultsStorage()
}

extension DependencyValues {
  var storage: StorageProtocol {
    get { self[StorageDependencyKey.self] }
    set { self[StorageDependencyKey.self] = newValue }
  }
}
