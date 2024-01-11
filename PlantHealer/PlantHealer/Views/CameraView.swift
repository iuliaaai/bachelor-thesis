//
//  CameraView.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 17.04.2023.
//

import SwiftUI
import CoreML

struct CameraView: View {
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = true
    @State var btnPressed: Bool = false
    @State var identifiedPlant = Plant.init(id: 1, commonName: "", scientificName: [""], photo: DefaultImage(original_url: ""), type: "", description: "", wateringFrequency: "", sunlight: ["", ""], careLevel: "", dimension: "")
    @EnvironmentObject var plantsVM: PlantViewModel
    @Binding var tabSelection: Int
    @State var identifiedPlantName: String = ""
    @State var showAlert = false
    @State var errorMesage: String = ""
    @State var showLoadingView = false
    
    func identifyPlant() -> Bool {
        let resizedImage = selectedImage?.resizeTo(size: CGSize(width: 224, height: 224))
        guard let buffer = resizedImage?.toCVPixelBuffer() else {
            return false
        }
        
        do {
            let config = MLModelConfiguration()
            let model = try IdentifiedPlant(configuration: config)
            
            let prediction = try model.prediction(input_1: buffer)
            
            var array = [Float]()
            for i in 0..<prediction.Identity.count {
                array.append(prediction.Identity[i].floatValue)
            }
            let maxVal = array.max()
            let indexOfMax = array.firstIndex(of: maxVal!)!
            
            if plantsVM.plantDictionary[String(indexOfMax)] != nil {
                identifiedPlantName = plantsVM.plantDictionary[String(indexOfMax)]!
                if identifiedPlantName == "background" {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        errorMesage = "Plant not recognized. Please try again."
                        showAlert = true
                    }
                    return false
                }
                return true
            }

            return false
            
        } catch {
            //errors
        }
        
        return false
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.green.opacity(0.3).edgesIgnoringSafeArea(.top)
                NavigationLink(isActive: $btnPressed,
                               destination: {
                    PlantDetailView(plant: identifiedPlant, tabSelection: $tabSelection, addBtnVisible: true)
                                        .navigationBarTitleDisplayMode(.inline)
                               },
                               label: {})
                
                VStack {
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Text("No photo was taken!")
                            .textStyle(font: Font.montserratRegular21(), color: Color.black)
                        Text("Open camera")
                            .textStyle(font: Font.montserratMedium21(), color: Color.black)
                            .onTapGesture {
                                isImagePickerDisplay.toggle()
                                sourceType = .camera
                            }
                        Text("Open photo library")
                            .textStyle(font: Font.montserratMedium21(), color: Color.black)
                            .onTapGesture {
                                isImagePickerDisplay.toggle()
                                sourceType = .photoLibrary
                            }
                    }
                    
                    Button {
                        showLoadingView.toggle()
                        if identifyPlant() {
                            plantsVM.fetchPlantByName(name: identifiedPlantName) { result in
                                DispatchQueue.main.async {
                                    if result == true {
                                        identifiedPlant = plantsVM.identifiedPlant
                                        btnPressed.toggle()
                                    } else {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            showAlert = true
                                            errorMesage = "No data available about \(identifiedPlantName) at the moment. Please try another plant!"
                                        }
                                    }
                                }
                            }
                        }
                    } label: {
                        Text("Identify plant")
                            .textStyle(font: Font.montserratMedium18(), color: Color.black)
                    }
                    .frame(width: 200, height: 45)
                    .background(Color.green)
                    .cornerRadius(20)
                    .padding([.top, .bottom], 15)
                    .opacity(selectedImage != nil ? 1 : 0)
                    
                    Button {
                        isImagePickerDisplay.toggle()
                        self.sourceType = .camera
                    } label: {
                        Text("Retake photo")
                            .textStyle(font: Font.montserratMedium14(), color: Color.black.opacity(0.8))
                    }
                    .opacity(selectedImage != nil ? 1 : 0)
                    
                    Text("or")
                        .textStyle(font: Font.montserratMedium12(), color: Color.black.opacity(0.5))
                        .opacity(selectedImage != nil ? 1 : 0)
                    
                    Button {
                        isImagePickerDisplay.toggle()
                        self.sourceType = .photoLibrary
                    } label: {
                        Text("Upload photo")
                            .textStyle(font: Font.montserratMedium14(), color: Color.black.opacity(0.8))
                    }
                    .opacity(selectedImage != nil ? 1 : 0)


                }
                .padding()
                .sheet(isPresented: self.$isImagePickerDisplay) {
                    ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
                        .ignoresSafeArea()
                }
                
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
                
            }.alert(isPresented: $showAlert, title: "Error!", message: errorMesage, onDismissButton: {})
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(tabSelection: .constant(2))
    }
}
