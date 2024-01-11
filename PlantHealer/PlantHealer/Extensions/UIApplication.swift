//
//  UIApplication.swift
//  PlantHealer
//
//  Created by Iulia Ionascu on 14.06.2023.
//

import Foundation
import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func getTopSafeAreaInset(isPositive: Bool) -> CGFloat {
        let value = windows.first?.safeAreaInsets.top ?? 0
        return isPositive ? value : -value
    }
}
