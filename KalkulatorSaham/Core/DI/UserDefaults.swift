//
//  UserDefaults.swift
//  KalkulatorSaham
//
//  Created by Alfin on 10/03/23.
//


import Foundation
import ComposableArchitecture

private enum UserDefaultsDependencyKey: DependencyKey {
    static let liveValue: UserDefaults = UserDefaults.standard
}

extension DependencyValues {
  var userDefaults: UserDefaults {
    get { self[UserDefaultsDependencyKey.self] }
    set { self[UserDefaultsDependencyKey.self] = newValue }
  }
}
