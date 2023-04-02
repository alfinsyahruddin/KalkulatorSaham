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
    var keyboardType: KeyboardType = .default
    var isRequired: Bool = true
    var isDisabled: Bool = false
    var error: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 2) {
                Text(label)
                if isRequired {
                    Text("*")
                        .foregroundColor(.red)
                }
            }
            .font(.caption.weight(.bold))

            Group {
                if let text = text {
                    TextField(placeholder ?? label, text: text)
                        .textFieldStyle(.plain)
                        .modify {
                            #if os(iOS)
                            $0.keyboardType(keyboardType.uikit)
                            #endif
                        }
                }
                
                if let value = value {
                    TextField(placeholder ?? label, value: value, formatter: numberFormatter)
                        .textFieldStyle(.plain)
                        .modify {
                            #if os(iOS)
                            $0.keyboardType(keyboardType.uikit)
                            #endif
                        }
                }
            }
            .padding(EdgeInsets(top: 7, leading: 14, bottom: 7, trailing: 14))
            .card(backgroundColor: isDisabled ? Color.label.opacity(0.1) : Color.cardBackground)
            .foregroundColor(isDisabled ? Color.label.opacity(0.5) : Color.label)
            .disabled(isDisabled)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.red, lineWidth: error == nil ? 0 : 1.5)
            )
            
            if let error = error {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            Spacer()
        }
    }
}
