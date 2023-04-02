//
//  CustomRule.swift
//  V-Trade
//
//  Created by Alfin on 07/02/23.
//

import Foundation

class CustomRule: RuleProtocol {
    var message: String = ""
    
    var validationTest: ((_ text: String) -> Bool)?
    
    init(_ message: String, validationTest: ((_ text: String) -> Bool)?) {
        self.message = message
        self.validationTest = validationTest
    }
    
    func validate(_ text: String?) -> Bool {
        return self.validationTest?(text ?? "") ?? false
    }
}
