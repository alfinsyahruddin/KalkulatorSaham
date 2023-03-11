//
//  AutoRejectCard.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//

import SwiftUI

struct AutoRejectCard: View {
    var color: Color
    var priceCaption: String
    var price: Double
    var priceChange: Double
    var percentage: Double
    var totalPercentage: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(priceCaption)
                    .font(.caption)
                    .foregroundColor(.secondaryLabel)
                
                HStack {
                    Text(price.f(.currency))
                        .font(.body)
                        .fontWeight(.bold)
                    
                    Text(priceChange.f(.withPlus))
                        .font(.body)
                        .foregroundColor(color)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("percentage".tr())
                    .font(.caption)
                    .foregroundColor(.secondaryLabel)
                
                Text(percentage.f(.withPlus).percentage())
                    .font(.body)
                    .foregroundColor(color)
            }
            
            
            VStack(alignment: .trailing) {
                Text("total_percentage".tr())
                    .font(.caption)
                    .foregroundColor(.secondaryLabel)
                
                Text(totalPercentage.f(.withPlus).percentage())
                    .font(.body)
                    .foregroundColor(color)
            }
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        .background(Color.cardBackground)
        .border(Color.divider, width: 1)
        .border(width: 6, edges: [.leading], color: color)
        
    }
}
