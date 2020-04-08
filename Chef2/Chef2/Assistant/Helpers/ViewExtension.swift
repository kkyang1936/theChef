//
//  ViewExtension.swift
//  ChatViewTutorial
//
//  Created by Stephen Radvansky on 3/2/20.
//  Copyright © 2020 Stephen Radvansky. All rights reserved.
//

import SwiftUI

extension View {
    func endEditing(_ force: Bool) {
        UIApplication.shared.windows.forEach { $0.endEditing(force)}
    }
}
