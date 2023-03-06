//
//  RadioSelect.swift
//  KalkulatorSaham
//
//  Created by Alfin on 06/03/23.
//

import SwiftUI

struct RadioSelect<T>: View where T: Equatable {
    let options: [String]
    let values: [T]
    
    @Binding var selected: T
    
    var body: some View {
        List {
            ForEach(0..<options.count, id: \.self) { index in
                let isSelected = values[index] == selected
                
                HStack(spacing: 20) {
                    Image(systemName: isSelected ? "record.circle" : "circle")
                        .foregroundColor(isSelected ? .accentColor : .secondaryLabel)
                    
                    Text(options[index])
                    
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    self.selected = values[index]
                }
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .modify {
            if #available(macOS 13, *), #available(iOS 16, *) {
                $0.scrollContentBackground(.hidden)
            }
        }
    }
}
