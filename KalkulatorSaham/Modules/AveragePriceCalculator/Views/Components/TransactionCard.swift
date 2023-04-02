//
//  TransactionCard.swift
//  KalkulatorSaham
//
//  Created by Alfin on 01/04/23.
//


import SwiftUI

struct TransactionCard: View {
    var type: String
    var value: Double
    var price: Double
    var lot: Double
    var color: Color = .yellow
    var onDeleteButtonTapped: (() -> Void)? = nil
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack {
                VStack(alignment: .leading) {
                    Text(type)
                        .font(.caption)
                        .foregroundColor(.secondaryLabel)
                    
                    Text(value.f(.currency))
                        .font(.body)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("price".tr())
                        .font(.caption)
                        .foregroundColor(.secondaryLabel)
                    
                    Text(price.f(.currency))
                        .font(.body)
                }
                
                
                VStack(alignment: .trailing) {
                    Text("lot".tr())
                        .font(.caption)
                        .foregroundColor(.secondaryLabel)
                    
                    Text(lot.f())
                        .font(.body)
                }
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            .background(Color.cardBackground)
            .border(Color.divider, width: 1)
            .border(width: 6, edges: [.leading], color: color)
            
            Image(systemName: "xmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 8, height: 8)
                .foregroundColor(.secondaryLabel)
                .padding(6)
                .onTapGesture {
                    onDeleteButtonTapped?()
                }
        }
        
    }
}
