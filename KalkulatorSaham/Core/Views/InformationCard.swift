//
//  InformationCard.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//

import SwiftUI


struct InformationCardHeaderStyle: Hashable {
    var color: Color = .label
    var backgroundColor: Color = .secondarySystemBackground
}

struct InformationCardItemStyle: Hashable {
    var color: Color = .label
}

struct InformationCardItem: Hashable {
    var key: String
    var value: String
    var keyStyle: InformationCardItemStyle = InformationCardItemStyle()
    var valueStyle: InformationCardItemStyle = InformationCardItemStyle()
}

struct InformationCard: View {
    var title: String
    var headerStyle: InformationCardHeaderStyle = InformationCardHeaderStyle()
    var items: [InformationCardItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .font(.title3.weight(.bold))
                
                Spacer()
            }
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .background(headerStyle.backgroundColor)
            .foregroundColor(headerStyle.color)
            .cornerRadius(12, corners: [.topLeft, .topRight])
            
            Divider()
                .frame(height: 1)
                .background(Color.divider)

            VStack(spacing: 20) {
                ForEach(items.chunked(into: 2), id: \.self) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.first!.key)
                                .foregroundColor(item.first!.keyStyle.color)
                            Text(item.first!.value)
                                .fontWeight(.bold)
                                .foregroundColor(item.first!.valueStyle.color)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text(item.last!.key)
                                .foregroundColor(item.last!.keyStyle.color)
                            Text(item.last!.value)
                                .fontWeight(.bold)
                                .foregroundColor(item.last!.valueStyle.color)
                        }
                    }
                }
            }
            .padding()
        }
        .card(cornerRadius: 12)
        
    }
}
