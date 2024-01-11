//
//  CustomCornerRadius.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 23.04.2023.
//

import SwiftUI

struct CustomCornerRadius: Shape {
    var radius = CGFloat.infinity
    var corners = UIRectCorner.allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(CustomCornerRadius(radius: radius, corners: corners))
    }
}
