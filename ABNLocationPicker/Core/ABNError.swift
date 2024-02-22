//
//  ABNError.swift
//  ABNLocationPicker
//
//  Created by Igor Vedeneev on 21/02/2024.
//

import Foundation

enum ABNError: Error, LocalizedError {
    case locationsFileIsMissing
    case badCoordinatesFormat
    case badCoordinatesValues
    
    var errorDescription: String? {
        switch self {
        case .locationsFileIsMissing:
            return "locations.json is missing"
        case .badCoordinatesFormat:
            return NSLocalizedString("Error.BadCoordinatesFormat", comment: "")
        case .badCoordinatesValues:
            return NSLocalizedString("Error.BadCoordinatesValue", comment: "")
        }
    }
}
