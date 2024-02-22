//
//  MockLocationService.swift
//  ABNLocationPickerTests
//
//  Created by Igor Vedeneev on 22/02/2024.
//

import Foundation
@testable import ABNLocationPicker

final class MockLocationService: LocationsService {
    
    var locationsResult: Result<[Location], ABNError>!
    var validateResult: Result<Location, ABNError>!
    
    func locations() throws -> [Location] {
        try locationsResult.get()
    }
    
    func validateAndCreateLocation(name: String, lat: Double?, lon: Double?) throws -> Location {
        try validateResult.get()
    }
}
