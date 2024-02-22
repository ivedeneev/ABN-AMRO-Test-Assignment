//
//  MockLocationManager.swift
//  ABNLocationPicker
//
//  Created by Igor Vedeneev on 22/02/2024.
//

import CoreLocation
import Foundation

protocol LocationManager {
    func requestPermission() async -> Bool
    func currentLocation() async -> CLLocationCoordinate2D
}

final class MockLocationManager: LocationManager {
    
    var requestPermissionValue: Bool = true
    var currentLocationValue: CLLocationCoordinate2D =  CLLocationCoordinate2D(latitude: 52.3547498, longitude: 4.8339215)
    
    func requestPermission() async -> Bool {
        requestPermissionValue
    }
    
    func currentLocation() async -> CLLocationCoordinate2D {
        currentLocationValue
    }
}
