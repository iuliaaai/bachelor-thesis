//
//  PlantDetailView.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 19.04.2023.
//

import SwiftUI
import RealmSwift

struct PlantDetailView: View {
    var plant: Plant
    @EnvironmentObject var plantsVM: PlantViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var tabSelection: Int
    var addBtnVisible: Bool
    @State var navigateToGallery: Bool = false
    @State var plantDirectoryPath = ""
    @State var showLoadingView = false
    
    var body: some View {
        ZStack {
            Color.green.opacity(0.2).edgesIgnoringSafeArea(.all)
            NavigationLink(isActive: $navigateToGallery,
                           destination: {
                PlantHistoryView(plant: plant)
                                    .navigationBarTitleDisplayMode(.inline)
                           },
                           label: {})
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.white)
                        .frame(width: 210, height: 210)
                        .shadow(radius: 2)
                    
                    AsyncImage(url: URL(string: plant.photo!.original_url ?? "")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.green.opacity(0.3)
                    }
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding()
                }
            }
            .offset(y: -230)
            
            VStack {
                Spacer()
                
                ZStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "photo.on.rectangle.angled")
                                .padding([.top], 50)
                                .padding(.trailing, 40)
                                .onTapGesture {
                                    navigateToGallery = true
                                }

                        }
                        Spacer()
                    }
                    .opacity(addBtnVisible ? 0 : 1)
                    
                    VStack() {
                            Text(plant.commonName.capitalized)
                                .textStyle(font: Font.montserratBold21(), color: Color.black)
                                .padding([.bottom, .top], 20)

                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Text("Type:")
                                        .textStyle(font: Font.montserratMedium16(), color: Color.gray)
                                    Text(plant.type!)
                                        .textStyle(font: Font.montserratMedium16(), color: Color.green.opacity(0.6))
                                }
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(20)
                                .padding([.leading, .trailing], 20)
                                .padding(.bottom, 10)
                                
                                ScrollView(.horizontal) {
                                    HStack {
                                        Text("Scientific name:")
                                            .textStyle(font: Font.montserratMedium16(), color: Color.gray)
                                    
                                        Text(plant.scientificName[0])
                                            .lineLimit(1)
                                            .textStyle(font: Font.montserratMedium16(), color: Color.green.opacity(0.6))
                                    }
                                }
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(20)
                                .padding([.leading, .trailing], 20)
                                .padding(.bottom, 10)
                                
                                HStack(spacing: 10) {
                                    Spacer()
                                    CardView(image: "drop", title: "WATER", text: plant.wateringFrequency, imageWidth: 15)
                                    
                                    CardView(image: "stethoscope", title: "CARE LEVEL", text: plant.careLevel ?? "", imageWidth: 20)
                                    Spacer()
                                }
                                
                                HStack(spacing: 10) {
                                    Spacer()
                                    CardView(image: "sun.max", title: "LIGHT", text: "\(plant.sunlight[0]), \(plant.sunlight[1])", imageWidth: 20)
                                    
                                    CardView(image: "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left", title: "SIZE", text: plant.dimension!, imageWidth: 20)
                                    Spacer()
                                }
                                
                                Text("Description")
                                    .textStyle(font: Font.montserratMedium16(), color: Color.green.opacity(0.6))
                                    .padding([.leading, .trailing], 20)
                                
                                Text(plant.description_!.removingAllExtraNewLines)
                                    .textStyle(font: Font.montserratMedium14(), color: Color.black)
                                    .padding([.leading, .trailing], 20)
                                
                            }
                        }.frame(height: addBtnVisible ? 280 : 330)
                        
                        Spacer()
                    }
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button {
                                plantsVM.savePlant(plant: plant)
                                NotificationManager.shared.scheduleNotifications(plant: plant)
                                showLoadingView = true
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                                    tabSelection = 1
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            } label: {
                                Text("Save plant")
                                    .textStyle(font: Font.montserratBold18(), color: Color.white)
                            }
                            .frame(width: 200, height: 45)
                            .background(Color.green.opacity(0.6))
                            .cornerRadius(10)
                            .padding([.top, .bottom], 15)
                            Spacer()
                        }
                    }
                    .padding(.bottom, addBtnVisible ? 70 : 10)
                    .opacity(addBtnVisible ? 1 : 0)
                }
                .frame(height: 500)
                .cornerRadius(35, corners: [.topLeft, .topRight])
                .shadow(radius: 5)
            }
            .edgesIgnoringSafeArea(.all)
            
            ZStack {
                if showLoadingView {
                    LoadingView()
                        .edgesIgnoringSafeArea(.top)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                self.showLoadingView.toggle()
                            }
                        }
                }
            }
        }
    }
}

struct PlantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlantDetailView(plant: Plant(id: 5809,
                                     commonName: "rose cactus",
                                     scientificName: ["Euphorbia hypericifolia 'Inneuphe' DIAMOND FROST"],
                                     photo: DefaultImage(original_url: "https://perenual.com/storage/species_image/5809_pereskia_grandifolia/thumbnail/27487227123_a9b4d90e13_b.jpg"),
                                     type: "Broadleaf evergreen",
                                     description: "\n\nPeperomia caperata, commonly referred to as emerald ripple or peperomia, is an epiphytic plant native to Brazil. It is a dense mound-forming tropical perennial, typically growing to 8u201d tall and wide.",
                                     wateringFrequency: "Average",
                                     sunlight: ["Full sun","part shade"],
                                     careLevel: "Medium",
                                     dimension: "6.00 to 16.00 feet"), tabSelection: .constant(1),
                        addBtnVisible: true
        )
    }
}
