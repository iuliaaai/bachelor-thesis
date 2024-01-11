//
//  ImageSaver.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 28.05.2023.
//

import Foundation
import UIKit

struct FileManagerHelper {
    static func createPlantDirectory(for plantName: String) throws -> URL {
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let plantDirectory = documentsDirectory.appendingPathComponent(plantName)

        try fileManager.createDirectory(at: plantDirectory, withIntermediateDirectories: true, attributes: nil)
        
        return plantDirectory
    }
    static func getPlantDirectoryPath(filename: String) -> String {
        let fileURL = FileManager.documentsDirectory.appendingPathComponent(filename)
        return fileURL.path

    }
}

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
