//
//  PlantViewModel.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 19.04.2023.
//

import SwiftUI
import CoreML
import RealmSwift

class PlantViewModel: ObservableObject {
    @Published var plants = [Plant]()
    @Published var identifiedPlant: Plant = Plant.init(id: 1, commonName: "", scientificName: [""], photo: DefaultImage(original_url: ""), type: "", description: "", wateringFrequency: "", sunlight: ["", ""], careLevel: "", dimension: "")
    var plantDictionary: [String: String]
    let realm = try! Realm()
    
    init() {
        self.plantDictionary = Utils.processCSV()
        self.reloadList()
    }
    
    func reloadList() {
        plants = [Plant]()
        let realmPlants = realm.objects(Plant.self)
        realmPlants.forEach { plant in
            self.plants.append(plant)
        }
    }
    
    func fetchPlantByName(name: String, completion: @escaping (Bool) -> ()) {
        ApiClient().getPlantByName(name: name.replaceSpaces(), completion: { data in
            if let data = data {
                if data.data.isEmpty {
                    print("No information about this plant")
                    completion(false)
                } else {
                    self.identifiedPlant = data.data[0]
                    
                    self.getPlantDetails(id: self.identifiedPlant.id) { result in
                        completion(true)
                    }
                }
            } else {
                completion(false)
            }
        })
    }
    
    func getPlantDetails(id: Int, completion: @escaping (Bool) -> ()) {
        ApiClient().getPlantDetailsById(id: id) { data in
            if let data = data {
                self.identifiedPlant = data
                print("Plant details received succesfully")
                completion(true)
            }
        }
    }
    
    func updatePlant(id: Int, newPlant: Plant) {
        if let selectionIndex = plants.firstIndex(where: { $0.id == id }) {
            self.plants[selectionIndex] = newPlant
            try! self.realm.write {
                self.realm.add(newPlant, update: .modified)
            }
        }
    }
    
    func savePlant(plant: Plant) {
        plants.append(plant)
        try! self.realm.write {
            self.realm.add(plant, update: .modified)
        }
        print("Item with id \(plant.id) added succesfully!")
        
        // create folder for plant's images
        do {
            let plantDirectory = try FileManagerHelper.createPlantDirectory(for: plant.commonName.concatenate())
            print("path: \(plantDirectory.path)")
        } catch {
            // Handle error creating the plant's directory
            print("Error creating plant directory: \(error)")
            return 
        }
    }
    
    func deletePlant(plant: Plant) {
        NotificationManager.shared.deleteLocalNotifications(identifiers: [String(plant.id)])
        
        let folderPath = FileManagerHelper.getPlantDirectoryPath(filename: plant.commonName.concatenate())
        do {
            try FileManager.default.removeItem(atPath: folderPath)
        } catch {
            print("error on deleting directory")
        }
        
        try! self.realm.write {
            self.realm.delete(plant)
            self.reloadList()
        }
    }
}
