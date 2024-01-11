//
//  BlurView.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 11.06.2023.
//

import SwiftUI

open class UIBackdropView: UIView {
  open override class var layerClass: AnyClass {
    NSClassFromString("CABackdropLayer") ?? CALayer.self
  }
}

public struct BackdropView: UIViewRepresentable {
  public init() {}

  public func makeUIView(context: Context) -> UIBackdropView {
    UIBackdropView()
  }

  public func updateUIView(_ uiView: UIBackdropView, context: Context) {}
}

public struct BlurView: View {
  public var radius: CGFloat

  public init(radius: CGFloat = 5.0) {
    self.radius = radius
  }

  public var body: some View {
    BackdropView()
      .blur(radius: radius)
  }
}
