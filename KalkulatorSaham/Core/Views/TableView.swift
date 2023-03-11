//
//  TableView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 11/03/23.
//

import SwiftUI


struct TableView: View {
    var columns: [TableColumn]
    var rows: [[String]]
    var colors: [[Color]] = []

    var body: some View {
        let totalWidth: Double = columns.reduce(0, { $0 + $1.width })
        return GeometryReader { geometry in
            let widths: [Double] = columns.map { geometry.size.width * CGFloat($0.width / totalWidth) }
            
            VStack(spacing: 0) {
                // Header
                HStack(spacing: 0) {
                    ForEach(0..<columns.count, id: \.self) { index in
                        let header = columns[index]
                        let width = widths[index]
                        
                        Text(" \(header.text) ")
                            .font(.caption.weight(.bold))
                            .frame(
                                width: width,
                                height: 30,
                                alignment: header.alignment
                            )
                    }
                }
                .background(Color.secondarySystemBackground)
                .border(Color.divider, width: 1)
                
                // Rows
                ForEach(0..<rows.count, id: \.self) { index in
                    let row = rows[index]
                    let color = colors[index]
                    
                    HStack(spacing: 0) {
                        ForEach(0..<row.count, id: \.self) { index2 in
                            let width = widths[index2]
                            
                            Text(" \(row[index2]) ")
                                .font(.caption)
                                .foregroundColor(color[index2])
                                .frame(
                                    width: width,
                                    height: 30,
                                    alignment: columns[index2].alignment
                                )
                        }
                    }
                    .modify {
                        if index % 2 != 0 {
                            $0.background(Color.secondarySystemBackground)
                        }
                    }
                }
                
                Divider()
            }
        }
    }
}


struct TableColumn {
    var text: String
    var width: Double
    var alignment: Alignment
    
    init(_ text: String, width: Double = 100, alignment: Alignment = .center) {
        self.text = text
        self.width = width
        self.alignment = alignment
    }
}


