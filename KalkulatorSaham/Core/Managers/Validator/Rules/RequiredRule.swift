//
//  RequiredRule.swift
//  V-Trade
//
//  Created by Alfin on 16/12/22.
//

import Foundation

class RequiredRule: RuleProtocol {
    var options: [Option] = []
    
    init(_ options: [Option] = []) {
        self.options = options
    }
    
    var message: String = "this_field_is_required".tr()
    
    func validate(_ text: String?) -> Bool {
        if options.contains(.notZero) && text == "0.0" {
            return false
        }
        
        return text != nil && text != ""
    }
    
    enum Option {
        case notZero
    }
}

