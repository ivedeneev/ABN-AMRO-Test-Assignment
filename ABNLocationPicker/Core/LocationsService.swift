//
//  LocationsService.swift
//  ABNLocationPicker
//
//  Created by Igor Vedeneev on 21/02/2024.
//

import Foundation

protocol LocationsService {
    func locations() throws -> [Location]
    
    @discardableResult
    func validateAndCreateLocation(name: String, lat: Double?, lon: Double?) throws -> Location
}

final class LocationsServiceImpl: LocationsService {
    
    func locations() throws -> [Location] {
        guard let url = Bundle.main.url(forResource: "locations", withExtension: "json") else {
            throw ABNError.locationsFileIsMissing
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(LocationsList.self, from: data).locations
    }
    
    func validateAndCreateLocation(name: String, lat: Double?, lon: Double?) throws -> Location {
        guard let lat, let lon else {
            throw ABNError.badCoordinatesFormat
        }
        
        guard Double.latitudeRange ~= lat, Double.longtitudeRange ~= lon else {
            throw ABNError.badCoordinatesValues
        }
        
        let location = Location(name: name, lat: lat, long: lon)
        var locs = try locations()
        locs.append(location)
        
        return location
    }
}
