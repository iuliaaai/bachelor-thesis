//
//  APIClient.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 17.04.2023.
//

import Foundation

class ApiClient {
    let baseUrl = "http://perenual.com/api"
    let key = "sk-SHyK643c3f9dd50ce541"
    
    func getPlantByName(name: String, completion: @escaping (PlantData?) -> ()) {
        guard let url = URL(string: "\(baseUrl)/species-list?key=\(key)&q=\(name)") else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let response = response as? HTTPURLResponse,
                  response.statusCode >= 200, response.statusCode < 300
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                print("Response Error on read!")
                return
            }
            
            if let decodedPlant = try? JSONDecoder().decode(PlantData.self, from: data) {
                DispatchQueue.main.async {
                    completion(decodedPlant)
                }
            } else {
                print("Error on decoding!")
                completion(nil)
            }
        }.resume()
    }
    
    func getPlantDetailsById(id: Int, completion: @escaping (Plant?) -> ()) {
        guard let url = URL(string: "\(baseUrl)/species/details/\(id)?key=\(key)") else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let response = response as? HTTPURLResponse,
                  response.statusCode >= 200, response.statusCode < 300
            else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                print("Response Error on read!")
                return
            }
            
            let plant = try! JSONDecoder().decode(Plant.self, from: data)
            
            DispatchQueue.main.async {
                completion(plant)
            }
            
        }.resume()
    }
}
