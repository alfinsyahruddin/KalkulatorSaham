//
//  ResultCard.swift
//  KalkulatorSaham
//
//  Created by Alfin on 01/04/23.
//


import SwiftUI

struct ResultCard: View {
    var title: String
    var content: String
    var color: Color = .yellow
    var alignment: HorizontalAlignment = .center
    var contentFont: Font = .title
    
    var body: some View {
        HStack {
            VStack(alignment: alignment) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondaryLabel)
                
                Text(content)
                    .font(contentFont)
                    .fontWeight(.bold)
            }
            
            if alignment == .leading {
                Spacer()
            }
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .border(Color.divider, width: 1)
        .border(width: 6, edges: [alignment == .leading ? .leading : .bottom], color: color)
        
    }
}
