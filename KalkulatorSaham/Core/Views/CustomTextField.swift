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
    var text: Binding<String>
    var isRequired: Bool = true
    
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

            TextField(placeholder ?? label, text: text)
                .padding(EdgeInsets(top: 7, leading: 14, bottom: 7, trailing: 14))
                .card()
        }
    }
}


