//
//  Utils.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 13.05.2023.
//

import Foundation

struct Utils {
    
    static func processCSV() -> [String : String] {
        guard let fileURL = Bundle.main.url(forResource: "labelmap", withExtension: "csv") else {
            print("No csv file!")
            return ["": ""]
        }
        
        do {
            let csvData = try String(contentsOf: fileURL, encoding: .utf8)
            let rows = csvData.components(separatedBy: "\n")
            
            var csvDict: [String: String] = [:]
            
            for row in rows {
                let columns = row.components(separatedBy: ",")
                if columns.count >= 2 {
                    let key = columns[0]
                    let value = columns[1]
                    csvDict[key] = value
                }
            }
            
            return csvDict
            
        } catch {
            print("Error reading CSV file: ", error.localizedDescription)
            return ["": ""]
        }
    }
}
