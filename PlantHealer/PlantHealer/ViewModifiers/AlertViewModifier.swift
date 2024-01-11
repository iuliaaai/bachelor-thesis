//
//  AlertViewModifier.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 13.05.2023.
//

import SwiftUI

struct AlertViewModifier: ViewModifier {
    // MARK: - Properties
    @Binding var isPresented: Bool
    let title: String
    let message: String?
    let onDismissButton: () -> Void
    
    // MARK: - Body
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented) {
                Alert(title: Text(title),
                      message: message != nil ? Text(message ?? "") : nil,
                      dismissButton: .default(Text("OK"),
                                              action: onDismissButton))
            }
    }
}

extension View {
    func alert(isPresented: Binding<Bool>,
               title: String,
               message: String? = nil,
               onDismissButton: @escaping () -> Void) -> some View {
        modifier(AlertViewModifier(isPresented: isPresented,
                                   title: title,
                                   message: message,
                                   onDismissButton: onDismissButton))
    }
}
