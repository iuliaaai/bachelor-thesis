//
//  LoadingView.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 11.06.2023.
//

import SwiftUI

struct LoadingView: View {
    @State var isLoading = false
    @State var value = 0.25
    @State var loadingFinished = false
    
    var body: some View {
        ZStack {
            BlurView()
            Circle()
                .foregroundColor(Color.green.opacity(0))
                .frame(width: 140, height: 140)
                
            Circle()
                .stroke(Color.white, lineWidth: 10)
                .frame(width: 110, height: 110)
            
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 10)
                .frame(width: 110, height: 110)
 
            Circle()
                .trim(from: 0, to: value)
                .stroke(LinearGradient(colors: [Color.white, Color.green],
                                       startPoint: .topTrailing,
                                       endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 10,
                                           lineCap: .round,
                                           lineJoin: .round))
                .frame(width: 110, height: 110)
                .rotationEffect(Angle(degrees: isLoading ? 360 : 0))
                .animation(Animation.linear(duration: 1)
                )
                .onAppear {
                    self.isLoading = true
                    self.value += 1
                }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                loadingFinished.toggle()
            }
        }
    }
}
