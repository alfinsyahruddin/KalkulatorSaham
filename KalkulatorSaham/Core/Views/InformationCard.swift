//
//  InformationCard.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//

import SwiftUI


struct InformationCardHeaderStyle: Hashable {
    var color: Color = .label
    var backgroundColor: Color = .tertiarySystemBackground
}

struct InformationCardItemStyle: Hashable {
    var color: Color = .label
}

enum InformationCardItemType {
    case text, divider, hidden
}

struct InformationCardItem: Hashable {
    var type: InformationCardItemType = .text
    var key: String = ""
    var value: String = ""
    var keyStyle: InformationCardItemStyle = InformationCardItemStyle()
    var valueStyle: InformationCardItemStyle = InformationCardItemStyle()
}

struct InformationCard: View {
    var title: String
    var totalColumn: Int = 2
    var headerStyle: InformationCardHeaderStyle = InformationCardHeaderStyle()
    var items: [InformationCardItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(title)
                    .font(.body.weight(.bold))
                
                Spacer()
            }
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .background(headerStyle.backgroundColor)
            .foregroundColor(headerStyle.color)
            .modify {
                #if os(iOS)
                $0.cornerRadius(12, corners: [.topLeft, .topRight])
                #endif
            }
            
            Separator()
                .frame(height: 1)
                .background(Color.divider)

            VStack(spacing: 20) {
                if totalColumn == 2 {
                    ForEach(items.chunked(into: 2), id: \.self) { item in
                        if item.first!.type == .divider {
                            Separator()
                        } else {
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
                } else if totalColumn == 3 {
                    ForEach(items.chunked(into: 3), id: \.self) { item in
                        if item.first!.type == .divider {
                            Separator()
                        } else {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.first!.key)
                                        .foregroundColor(item.first!.keyStyle.color)
                                    Text(item.first!.value)
                                        .fontWeight(.bold)
                                        .foregroundColor(item.first!.valueStyle.color)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .center) {
                                    Text(item[1].key)
                                        .foregroundColor(item[1].keyStyle.color)
                                    Text(item[1].value)
                                        .fontWeight(.bold)
                                        .foregroundColor(item[1].valueStyle.color)
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
                }
              
            }
            .font(.caption)
            .padding()
        }
        .card(cornerRadius: 12)
        
    }
}
