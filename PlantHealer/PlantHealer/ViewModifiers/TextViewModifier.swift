//
//  TextViewModifier.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 23.04.2023.
//

import Foundation
import SwiftUI

struct TextViewModifier: ViewModifier {
    var font: Font
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
            .fixedSize(horizontal: false, vertical: true)
    }
}

extension View {
    func textStyle(font: Font, color: Color) -> some View {
        modifier(TextViewModifier(font: font, color: color))
    }
}
