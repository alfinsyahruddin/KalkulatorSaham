//
//  MenuRow.swift
//  KalkulatorSaham
//
//  Created by Alfin on 05/03/23.
//

import SwiftUI

struct MenuRow: View {
    var id: String
    var label: String
    
    var body: some View {
        HStack {
            Text(id)
                .foregroundColor(Color.accentColor)
                .font(.caption)
                .fontWeight(.bold)
                .frame(width: 30, height: 30)
                .background(Color.accentColor.opacity(0.15))
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.accentColor, lineWidth: 1)
                )
            
            Spacer()
                .frame(width: 20)
            
            Text(label)
                .font(.body)
                .fontWeight(.regular)
                .foregroundColor(.label)
            
            Spacer()
        }
    }
}

