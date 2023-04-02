//
//  Validator.swift
//  V-Trade
//
//  Created by Alfin on 16/12/22.
//

import Foundation


class Validator {
    /// Error messages
    var errors: Errors = [:]
    
    private var validations: [Validation] = []
    
    /// Create Validation Schema (String)
    static func schema(
        _ validatorFields: [(String, String, rules: [RuleProtocol])],
        _ errors: Errors = [:]
    ) -> Validator {
        let validator = Validator()
        validator.validations = validatorFields.map { Validation(field: $0.0, value: $0.1, rules: $0.rules) }
        validator.errors = errors
        return validator
    }
    
    /// Create Validation Schema (Double)
    static func schema(
        _ validatorFields: [(String, Double, rules: [RuleProtocol])],
        _ errors: Errors = [:]
    ) -> Validator {
        return .schema(validatorFields.map { ($0, String($1), $2) }, errors)
    }

    /// Validate all fields
    func validate() -> Errors {
        for validation in validations {
            let _ = self.validateField(validation.field)
        }
        
        // Log the errors
        if !errors.isEmpty {
            print(errors)
        }
        
        return errors
    }
    
    /// Validate one field
    func validateField(_ field: String) -> Errors {
        guard var validation = validations.first(where: { $0.field == field }) else { return [:] }
        var error = ""
        
        for rule in validation.rules {
            if !rule.validate(validations.first { $0.field == field }!.value) {
                error = rule.message
                break;
            }
        }
        
        validation.error = error
        
        if error != "" {
            errors[validation.field] = error
        } else {
            errors.removeValue(forKey: validation.field)
        }
        
        return errors
    }
    
    typealias Errors = [String: String]
}

struct Validation {
    var field: String
    var value: String
    var rules: [RuleProtocol]
    var error: String? = nil
}


protocol RuleProtocol {
    var message: String { get set }
    func validate(_ text: String?) -> Bool
}

