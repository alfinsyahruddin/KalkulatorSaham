//
//  Separator.swift
//  KalkulatorSaham
//
//  Created by Alfin on 02/04/23.
//

import SwiftUI

struct Separator: View {
    var text: String? = nil
    
    var body: some View {
        ZStack(alignment: .center) {
            Divider()
                .frame(height: 1)
                .background(Color.divider)
            
            if let text = text {
                Text(text)
                    .font(.caption.weight(.light))
                    .foregroundColor(.secondaryLabel)
                    .padding(.horizontal, 20)
                    .background(Color.systemBackground)
            }
        }
    }
}
