//
//  LocationsListViewModel.swift
//  ABNLocationPicker
//
//  Created by Igor Vedeneev on 21/02/2024.
//

import Foundation
import CoreLocation

protocol LocationsViewModel: Observable {
    
    var isWikiAppInstalled: Bool { get }
    var locations: [Location] { get }
    var url: URL? { get }
    var selectedNewLocation: CLLocationCoordinate2D? { get }
    var cameraPosition: CLLocationCoordinate2D? { get }
    var errorMessage: String? { get }
    
    @discardableResult
    func sendAction(_ action: LocationsViewModelActions) -> Task<Void, Never>?
}

enum LocationsViewModelActions {
    case loadLocations
    case checkWikiAppInstalled
    case validateAndOpenManualLocation(name: String, lat: Double?, lon: Double?)
    /// Opens location which is part of history of openings
    case openSavedLocation(Location)
    case selectLocation(CLLocationCoordinate2D)
    /// Opens location from map which is not part of history of openings
    case openNewLocationFromMap(CLLocationCoordinate2D)
    case dismissErrorAlert
    case requestLocationPermissionAndSetCurrentLocationIfNeeded
    case updateCameraPosition(CLLocationCoordinate2D)
    case didOpenURL
}
