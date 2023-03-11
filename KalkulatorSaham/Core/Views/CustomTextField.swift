//
//  CustomTextField.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//

import SwiftUI

struct CustomTextField: View {
    var label: String
    var placeholder: String? = nil
    var text: Binding<String>?
    var value: Binding<Double>?
    var isRequired: Bool = true
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(label)
                if isRequired {
                    Text("*")
                        .foregroundColor(.red)
                }
            }
            .font(.caption.weight(.bold))

            if let text = text {
                TextField(placeholder ?? label, text: text)
                    .keyboardType(keyboardType)
                    .padding(EdgeInsets(top: 7, leading: 14, bottom: 7, trailing: 14))
                    .card()
            }
            
            if let value = value {
                TextField(placeholder ?? label, value: value, formatter: numberFormatter)
                    .keyboardType(keyboardType)
                    .padding(EdgeInsets(top: 7, leading: 14, bottom: 7, trailing: 14))
                    .card()
            }
        }
    }
}
