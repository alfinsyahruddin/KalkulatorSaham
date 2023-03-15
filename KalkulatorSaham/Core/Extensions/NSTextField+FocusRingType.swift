//
//  NSTextField+FocusRingType.swift
//  KalkulatorSaham
//
//  Created by Alfin on 15/03/23.
//

import SwiftUI

#if os(macOS)
extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
#endif
