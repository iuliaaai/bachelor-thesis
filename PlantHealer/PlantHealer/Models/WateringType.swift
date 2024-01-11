//
//  WateringType.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 27.05.2023.
//

import Foundation

enum WateringType {
    case minimum, average, frequent, none
    
    static func getTimeInterval(type: WateringType) -> TimeInterval {
        switch type {
        case .minimum:
            return 4 * 24 * 60 * 60 // every 4 days
        case .average:
            return 3 * 24 * 60 * 60 // every 3 days
        case .frequent:
            return 2 * 24 * 60 * 60 // every 2 days
        case .none:
            return 0
        }
    }
    
    static func getType(type: String) -> WateringType {
        switch type.lowercased() {
        case "minimum":
            return .minimum
        case "average":
            return .average
        case "frequent":
            return .frequent
        default:
            return .none
        }
    }
}
