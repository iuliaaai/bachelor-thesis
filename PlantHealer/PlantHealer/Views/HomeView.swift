//
//  HomeView.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 17.04.2023.
//

import SwiftUI
import RealmSwift

struct HomeView: View {
    @EnvironmentObject var plantsVM: PlantViewModel
    @Binding var tabSelection: Int
    @State var showDeleteAlert: Bool = false
    @State var index: IndexSet?
    @State var editList: Bool = false
    @State var selectedPlant: Plant = Plant(id: 1, commonName: "", scientificName: [""], photo: nil, type: "", description: "", wateringFrequency: "", sunlight: [""], careLevel: "", dimension: "")
    @State var showLoadingView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.greenGradient.edgesIgnoringSafeArea(.top)
                VStack(alignment: .leading) {
                    HStack {
                        Text("My plants")
                            .textStyle(font: Font.montserratBold21(), color: Color.black)
                            .padding([.leading], 30)
                            .padding(.top, 70)
                            .padding(.bottom, 20)
                        Spacer()
                        
                        Image(systemName: "square.and.pencil")
                            .padding(.top, 70)
                            .padding([.bottom, .trailing], 20)
                            .onTapGesture {
                                editList.toggle()
                            }
                    }
                    .background(Color.white)
                    .cornerRadius(30, corners: [.bottomLeft, .bottomRight])
                    .shadow(radius: 2)
                    .padding(.bottom, 20)
                    
                    if plantsVM.plants.isEmpty {
                        VStack(alignment: .center) {
                            Spacer()
                            Text("You haven't added any plants to your list yet")
                                .textStyle(font: Font.montserratMedium18(), color: Color.black)
                                .multilineTextAlignment(.center)
                                
                            Spacer()
                        }.padding([.leading, .trailing], 40)
                        
                    } else {
                        ScrollView {
                                ForEach(plantsVM.plants,  id: \.id) { plant in
                                    ZStack {
                                        ListCell(content: { PlantDetailView(plant: plant, tabSelection: $tabSelection, addBtnVisible: false).environmentObject(plantsVM) },
                                                 plant: plant)
                                        VStack {
                                            HStack {
                                                Spacer()
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(Color.red)
                                                    .padding(.trailing, 30)
                                                    .onTapGesture {
                                                        selectedPlant = plant
                                                        showDeleteAlert = true
                                                    }
                                            }
                                            Spacer()
                                        }
                                        .opacity(editList ? 20 : 0)
                                    
                                    }
                                }
                                .onDelete(perform: alertAndDelete)
                                .alert(isPresented: $showDeleteAlert, content: {
                                    
                                    let cancelButton = Alert.Button.default(Text("Cancel")) {}
                                    let deleteButton = Alert.Button.default(Text("Delete")) {
                                        showLoadingView = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            plantsVM.deletePlant(plant: selectedPlant)
                                            editList.toggle()
                                        }
                                    }
                                    return Alert(title: Text("Are you sure you want to delete this plant?"), message: Text(""), primaryButton: cancelButton, secondaryButton: deleteButton)
                                })
                        }
                        .onAppear(perform: NotificationManager.shared.requestAuthorization)
                        .onAppear {
                            NotificationManager.shared.reloadLocalNotifications()
                        }
                    }
                    Spacer()
                }.edgesIgnoringSafeArea(.top)
                
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
    
    private func alertAndDelete(at offsets: IndexSet) {
        self.showDeleteAlert = true
        self.index = offsets
    }
    
    private func removePlant(id: Int) {
        var index = 0
        for elem in plantsVM.plants {
            if elem.id == id {
                plantsVM.deletePlant(plant: selectedPlant)
            }
            index += 1
        }
    }
}
