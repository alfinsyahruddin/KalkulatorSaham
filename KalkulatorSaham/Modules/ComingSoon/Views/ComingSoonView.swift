//
//  ComingSoonView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 09/03/23.
//

import SwiftUI

struct ComingSoonView: View {
    var body: some View {
        ScreenView {
            VStack(spacing: 10) {
                Image(systemName: "clock.badge.exclamationmark")
                    .font(.system(size: 50))
                    .foregroundColor(.accentColor)
                Text("coming_soon".tr())
                    .font(.title3.weight(.bold))
                    .foregroundColor(.accentColor)
                Text("this_feature_is_not_available_at_this_time".tr())
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
}

struct ComingSoonView_Previews: PreviewProvider {
    static var previews: some View {
        ComingSoonView()
    }
}
