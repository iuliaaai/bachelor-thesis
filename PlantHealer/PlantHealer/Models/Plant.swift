//
//  Plant.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 17.04.2023.
//

import SwiftUI
import RealmSwift

class PlantData: Codable {
    var data: [Plant]
}

class Plant: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var commonName: String
    @Persisted var scientificName = RealmSwift.List<String>()
    @Persisted var photo: DefaultImage?
    @Persisted var type: String?
    @Persisted var description_: String?
    @Persisted var wateringFrequency: String
    @Persisted var sunlight = RealmSwift.List<String>()
    @Persisted var careLevel: String?
    @Persisted var dimension: String?
    
    enum CodingKeys: String, CodingKey {
        case id, commonName = "common_name",scientificName = "scientific_name", photo = "default_image", type, description_ = "description", wateringFrequency = "watering", sunlight, careLevel = "care_level", dimension
    }
    
    convenience init(id: Int, commonName: String, scientificName: [String], photo: DefaultImage?, type: String?, description: String?, wateringFrequency: String, sunlight: [String], careLevel: String?, dimension: String?) {
        self.init()
        self.id = id
        self.commonName = commonName
        self.scientificName.append(objectsIn: scientificName)
        self.photo = photo
        self.type = type
        self.description_ = description
        self.wateringFrequency = wateringFrequency
        self.sunlight.append(objectsIn: sunlight)
        self.careLevel = careLevel
        self.dimension = dimension
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(commonName, forKey: .commonName)
        try container.encode(scientificName, forKey: .scientificName)
        try container.encode(photo, forKey: .photo)
        try container.encode(type, forKey: .type)
        try container.encode(description_, forKey: .description_)
        try container.encode(wateringFrequency, forKey: .wateringFrequency)
        try container.encode(sunlight, forKey: .sunlight)
        try container.encode(careLevel, forKey: .careLevel)
        try container.encode(dimension, forKey: .dimension)
    }
}

class DefaultImage: Object, Codable {
    @Persisted var original_url: String?
    
    convenience init(original_url: String) {
        self.init()
        self.original_url = original_url
    }
}
