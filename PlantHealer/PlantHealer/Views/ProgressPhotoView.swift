//
//  ProgressPhotoView.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 14.06.2023.
//

import SwiftUI

struct ProgressPhotoView: View {
    var plant: Plant
    @Binding var progressImage: ProgressImage
    @Environment(\.presentationMode) var presentationMode
    @State var showLoadingView = false
    
    var body: some View {
        ZStack {
            Color.green.opacity(0.1).edgesIgnoringSafeArea(.top)
            VStack {
                Image(uiImage: progressImage.image.image ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.bottom, 15)
                
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color.white)
                    
                    TextField("Add description", text: $progressImage.description, axis: .vertical)
                        .textStyle(font: Font.montserratMedium14(), color: Color.black)
                        .padding()
                        .lineLimit(4)
                }
                .frame(height: 100)
                
                HStack {
                    Button {
                        updateProgress()
                        showLoadingView = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text("Save changes")
                            .textStyle(font: Font.montserratMedium14(), color: Color.black.opacity(0.8))
                    }
                    .frame(width: 140, height: 45)
                    .background(Color.green.opacity(0.5))
                    .cornerRadius(20)
                    .padding([.top, .bottom], 15)
                    
                    Spacer()
                    
                    Button {
                        deleteImage()
                        showLoadingView = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text("Delete photo")
                            .textStyle(font: Font.montserratMedium14(), color: Color.black.opacity(0.8))
                    }
                    .frame(width: 140, height: 45)
                    .background(Color.green.opacity(0.5))
                    .cornerRadius(20)
                    .padding([.top, .bottom], 15)

                }
                .padding(.top, 15)
                .padding([.leading, .trailing], 10)
                
            }
            .padding([.leading, .trailing], 30)
            
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
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    func deleteImage() {
        let folderPath = FileManagerHelper.getPlantDirectoryPath(filename: plant.commonName.concatenate())
        let fileManager = FileManager.default
        let imageName = "\(progressImage.id.uuidString).jpg"
        let imagePath = URL(fileURLWithPath: folderPath).appendingPathComponent(imageName)
        
        if fileManager.fileExists(atPath: imagePath.path) {
            do {
                try fileManager.removeItem(at: imagePath)
                print("item removed")
            } catch {
                print("error on remove")
            }
        } else {
            print("error getting path")
        }
    }
    
    func updateProgress() {
        let folderPath = FileManagerHelper.getPlantDirectoryPath(filename: plant.commonName.concatenate())
        let imageName = "\(progressImage.id.uuidString).jpg"
        let imagePath = URL(fileURLWithPath: folderPath).appendingPathComponent(imageName)

        do {
            if let data = try? JSONEncoder().encode(progressImage) {
                try data.write(to: imagePath)
                
                // Handle successful image saving
                print("Image saved to path: \(imagePath.path)")
            }
        } catch {
            // Handle error saving the image
            print("Error saving image: \(error)")
        }
    }
}

