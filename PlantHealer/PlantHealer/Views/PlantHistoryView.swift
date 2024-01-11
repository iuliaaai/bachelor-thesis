//
//  PlantHistoryView.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 29.05.2023.
//

import SwiftUI

struct PlantHistoryView: View {
    var plant: Plant
    @EnvironmentObject var plantsVM: PlantViewModel
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    @State var imageURLs = [URL]()
    var columnGrid: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State var history = [ProgressImage]()
    @State var photoTapped: Bool = false
    @State var tappedProgressImage: ProgressImage = ProgressImage(image: Data(), description: "", timestamp: Date())
    
    var body: some View {
        ZStack {
            Color.brown.opacity(0.1)
            VStack(alignment: .center) {
                NavigationLink(isActive: $photoTapped,
                               destination: {
                    ProgressPhotoView(plant: plant, progressImage: $tappedProgressImage)
                                        .navigationBarTitleDisplayMode(.inline)
                               },
                               label: {})
                
                .navigationTitle("Add photo")
                .toolbar {

                    ToolbarTitleMenu {
                        Button("Camera roll") {
                            sourceType = .camera
                            isImagePickerDisplay = true
                        }
                        
                        Button("Library") {
                            sourceType = .photoLibrary
                            isImagePickerDisplay = true
                        }
                        
                    }
                }
                
                VStack(alignment: .center) {
                    Text("Track the progress of your plant:")
                        .textStyle(font: Font.montserratBold18(), color: Color.black.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 5)
                    
                    Text(plant.commonName.capitalized)
                        .textStyle(font: Font.montserratBold18(), color: Color.white)
                }
                .padding()
                .background(Color.green.opacity(0.4))
                .cornerRadius(15)
                .padding([.leading, .trailing], 2)
                if self.history.isEmpty {
                    Spacer()
                    Text("No photos yet. Please add from the navigation bar menu!")
                        .textStyle(font: Font.montserratMedium18(), color: Color.black.opacity(0.8))
                        .multilineTextAlignment(.center)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columnGrid) {
                            ForEach(self.history) { progress in
                                Image(uiImage: progress.image.image ?? UIImage())
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .onTapGesture {
                                        tappedProgressImage = progress
                                        photoTapped.toggle()
                                    }
                            }
                        }
                    }
                    .padding()
                }
            }
            .padding(.top, 20)
            .onAppear {
                self.getHistoryForPlant()
            }
            .sheet(isPresented: self.$isImagePickerDisplay) {
                ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
                    .ignoresSafeArea()
                    .onDisappear {
                        if let selectedImage = selectedImage {
                            let progress = ProgressImage(image: selectedImage.data ?? Data(), description: "", timestamp: Date())
                            self.saveImageToPlantFolder(value: progress, plant: plant)
                            
                            self.getHistoryForPlant()
                        }
                    }
            }
        }
    }
    
    func getHistoryForPlant() {
        history = [ProgressImage]()
        let urls = getPlantImageURLs(plant: plant)
        
        for dataSourceURL in urls {
            do {
                let data = try Data(contentsOf: dataSourceURL)
                if let decodedValue = try? JSONDecoder().decode(ProgressImage.self, from: data) {
                    self.history.append(decodedValue)
                }
            } catch {
                // Handle error saving the image
                print("Error saving image: \(error)")
            }
        }
        
    }
    
    func saveImageToPlantFolder(value: ProgressImage, plant: Plant) {
        let folderPath = FileManagerHelper.getPlantDirectoryPath(filename: plant.commonName.concatenate())
        let imageName = "\(value.id.uuidString).jpg"
        let imagePath = URL(fileURLWithPath: folderPath).appendingPathComponent(imageName)

        do {
            if let data = try? JSONEncoder().encode(value) {
                try data.write(to: imagePath)
                
                // Handle successful image saving
                print("Image saved to path: \(imagePath.path)")
            }
        } catch {
            // Handle error saving the image
            print("Error saving image: \(error)")
        }
    }
    
    func getPlantImageURLs(plant: Plant) -> [URL] {
        let folderPath = FileManagerHelper.getPlantDirectoryPath(filename: plant.commonName.concatenate())
        
        let fileManager = FileManager.default
        let folderURL = URL(fileURLWithPath: folderPath)
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            return fileURLs
        } catch {
            // Handle error retrieving image file URLs
            print("Error retrieving image file URLs: \(error)")
            return []
        }
    }
}

struct PlantHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        PlantHistoryView(plant: Plant.init(id: 1, commonName: "", scientificName: [""], photo: DefaultImage(original_url: ""), type: "", description: "", wateringFrequency: "", sunlight: ["", ""], careLevel: "", dimension: ""))
    }
}
