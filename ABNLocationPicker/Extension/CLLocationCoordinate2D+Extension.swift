//
//  CLLocationCoordinate2D+Extension.swift
//  ABNLocationPicker
//
//  Created by Igor Vedeneev on 22/02/2024.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
