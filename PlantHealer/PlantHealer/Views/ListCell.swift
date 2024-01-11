//
//  ListCell.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 13.05.2023.
//

import SwiftUI

struct ListCell<Content: View>: View {
    @ViewBuilder var content: Content
    var plant: Plant
    
    var body: some View {
        ZStack {
            NavigationLink {
                content
            } label: {
                HStack {
                    AsyncImage(url: URL(string: plant.photo!.original_url ?? "")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.green.opacity(0.3)
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .padding([.top, .bottom], 15)
                    .padding(.leading, 20)
                    
                    
                    VStack(alignment: .leading) {
                        Text(plant.commonName.capitalized)
                            .textStyle(font: Font.montserratBold18(), color: Color.black)
                        Text(plant.scientificName[0])
                            .lineLimit(1)
                            .textStyle(font: Font.montserratMedium14(), color: Color.black.opacity(0.7))
                    }
                    .padding(.leading, 10)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 7, height: 10)
                        .padding(.trailing, 20)
                        .foregroundColor(Color.black)
                }
                .background(.white)
                .cornerRadius(30)
                .padding([.leading, .trailing], 30)
                .shadow(color: Color.black.opacity(0.2), radius: 5, y: 10)
            }
        }
    }
}

struct ListCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green
            let plant = Plant(id: 5809,
                              commonName: "rose cactus",
                              scientificName: ["Euphorbia hypericifolia 'Inneuphe' DIAMOND FROST"],
                              photo: DefaultImage(original_url: "https://perenual.com/storage/species_image/5809_pereskia_grandifolia/thumbnail/27487227123_a9b4d90e13_b.jpg"),
                              type: "Broadleaf evergreen",
                              description: "\n\nPeperomia caperata, commonly referred to as emerald ripple or peperomia, is an epiphytic plant native to Brazil. It is a dense mound-forming tropical perennial, typically growing to 8u201d tall and wide.",
                              wateringFrequency: "Average",
                              sunlight: ["Full sun","part shade"],
                              careLevel: "Medium",
                              dimension: "6.00 to 16.00 feet")
            ListCell(content: { PlantDetailView(plant: plant, tabSelection: .constant(1), addBtnVisible: true) },
                     plant: plant)
            
        }
    }
}
