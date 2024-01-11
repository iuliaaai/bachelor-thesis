//
//  Progress.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 13.06.2023.
//

import SwiftUI
import UIKit

struct ProgressImage: Codable, Identifiable {
    var id: UUID
    var image: Data
    var description: String
    var timestamp: Date
    
    init(image: Data, description: String, timestamp: Date) {
        self.id = UUID()
        self.image = image
        self.description = description
        self.timestamp = timestamp
    }
}

extension UIImage {
    var data: Data? {
        if let data = self.jpegData(compressionQuality: 1.0) {
            return data
        } else {
            return nil
        }
    }
}

extension Data {
    var image: UIImage? {
        if let image = UIImage(data: self) {
            return image
        } else {
            return nil
        }
    }
}
