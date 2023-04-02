//
//  ValidatorDependency.swift
//  KalkulatorSaham
//
//  Created by Alfin on 02/04/23.
//


import Foundation
import ComposableArchitecture

private enum ValidatorDependencyKey: DependencyKey {
    static let liveValue: Validator = Validator()
}

extension DependencyValues {
    var validator: Validator {
        get { self[ValidatorDependencyKey.self] }
        set { self[ValidatorDependencyKey.self] = newValue }
    }
}
