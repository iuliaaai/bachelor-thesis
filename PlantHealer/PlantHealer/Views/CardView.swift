//
//  CardView.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 23.04.2023.
//

import SwiftUI

struct CardView: View {
    var image: String
    var title: String
    var text: String
    var imageWidth: CGFloat
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .resizable()
                .frame(width: imageWidth, height: 20)
                .foregroundColor(Color.gray.opacity(0.7))
                .padding(.leading, 5)
            
            VStack(alignment: .leading) {
                Text(title)
                    .textStyle(font: Font.montserratMedium12(), color: Color.gray.opacity(0.8))
                Text(text)
                    .textStyle(font: Font.montserratBold12(), color: Color.gray)
            }
            .padding([.leading, .trailing], 5)
            
            Spacer()
        }
        .padding()
        .frame(width: 160)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(20)
    }
}
