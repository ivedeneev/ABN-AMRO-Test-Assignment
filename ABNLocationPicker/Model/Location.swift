//
//  Location.swift
//  ABNLocationPicker
//
//  Created by Igor Vedeneev on 21/02/2024.
//

import Foundation
import CoreLocation

struct LocationsList: Codable {
    let locations: [Location]
}

struct Location: Codable, Identifiable, Equatable, Hashable {
    let id = UUID()
    let name: String?
    let lat: Double
    let long: Double
}

extension Location {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    
    /// Replaces nil or empty name with coordinates for better UI representation
    var safeName: String {
        if let name, !name.isEmpty {
            return name
        }
        
        return lat.formatted(.number) + " " + long.formatted(.number)
    }
}
