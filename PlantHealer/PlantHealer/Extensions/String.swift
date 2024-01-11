//
//  String.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 23.04.2023.
//

import Foundation

extension StringProtocol {
    var lines: [SubSequence] { split(whereSeparator: \.isNewline) }
    var removingAllExtraNewLines: String { lines.joined(separator: "\n") }
    
    func replaceSpaces() -> String {
        let replaced = self.replacingOccurrences(of: " ", with: "%20")
        return replaced
    }
    
    func concatenate() -> String {
        return self.replacingOccurrences(of: " ", with: "_")
    }
}
