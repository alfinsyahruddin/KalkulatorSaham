//
//  ActivityView.swift
//  KalkulatorSaham
//
//  Created by Alfin on 11/03/23.
//

import SwiftUI


struct ActivityView: UIViewControllerRepresentable {
    let text: String

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<ActivityView>
    ) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [text], applicationActivities: nil)
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: UIViewControllerRepresentableContext<ActivityView>
    ) {
        
    }
}
