//
//  ProfitPerTickCalculatorView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//

import SwiftUI
import ComposableArchitecture

struct ProfitPerTickCalculatorView: View {
    let store: StoreOf<ProfitPerTickCalculator>
    
    var body: some View {
        ScreenView {
            ScrollView {
                WithViewStore(store, observe: { $0 }) { viewStore in
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(spacing: 10) {
                                CustomTextField(
                                    label: "price".tr(),
                                    text: viewStore.binding(\.$price)
                                )
                                
                                CustomTextField(
                                    label: "lot".tr(),
                                    text: viewStore.binding(\.$lot)
                                )
                            }
                            
//                            BrokerFeeInformation()
                            
                            Button("calculate".tr()) {
                                
                            }
                            .buttonStyle(CustomButtonStyle())
                        }
                        .padding()
                        
                        
                        
                        
                        TableView(
                            columns: [
                                TableColumn("Value", width: 20, alignment: .trailing),
                                TableColumn("Loss", width: 15, alignment: .trailing),
                                TableColumn("Price", width: 15, alignment: .trailing),
                                TableColumn("Price", width: 15, alignment: .leading),
                                TableColumn("Profit", width: 15, alignment: .leading),
                                TableColumn("Value", width: 20, alignment: .leading)
                            ],
                            rows: [
                                ["xxx", "xxx", "xxx", "xxx", "xxx", "xxx"],
                                ["xxx", "xxx", "xxx", "xxx", "xxx", "xxx"],
                                ["xxx", "xxx", "xxx", "xxx", "xxx", "xxx"]
                            ]
                        )
                        
                        Spacer()
                    }
                }
            }
        }
        .modify {
            #if os(iOS)
            $0.navigationBarTitle("profit_per_tick_calculator".tr(), displayMode: .inline)
            #endif
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

struct TableView: View {
    var columns: [TableColumn]
    var rows: [[String]]
    
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
                
                // Data
                ForEach(0..<rows.count, id: \.self) { index in
                    let row = rows[index]
                    
                    HStack(spacing: 0) {
                        ForEach(0..<row.count, id: \.self) { index2 in
                            let width = widths[index2]
                            
                            Text(" \(row[index2]) ")
                                .font(.caption)
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



struct ProfitPerTickCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            initialState: Main.State(),
            reducer: Main()
        )
        
        ProfitPerTickCalculatorView(
            store: store.scope(
                state: \.profitPerTickCalculator,
                action: Main.Action.profitPerTickCalculator
            )
        )
    }
}
