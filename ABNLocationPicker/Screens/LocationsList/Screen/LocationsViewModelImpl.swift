//
//  LocationsViewModelImpl.swift
//  ABNLocationPicker
//
//  Created by Igor Vedeneev on 22/02/2024.
//

import Foundation
import CoreLocation

@Observable
final class LocationsViewModelImpl: LocationsViewModel {
    
    private(set) var isWikiAppInstalled = true
    private(set) var locations:[Location] = []
    private(set) var url: URL?
    private(set) var selectedNewLocation: CLLocationCoordinate2D?
    private(set) var selectedLocation: Location?
    private(set) var cameraPosition: CLLocationCoordinate2D?
    private(set) var errorMessage: String?
    
    private let locationsService: LocationsService
    private let linkBuilder: WikipediaPlacesLinkBuilder
    private let appChecker: WikiAppCheckerService
    private let locationManager: LocationManager
    
    init(
        locationsService: LocationsService = LocationsServiceImpl(),
        linkBuilder: WikipediaPlacesLinkBuilder = .init(),
        appChecker: WikiAppCheckerService = WikiAppCheckerServiceImpl(),
        locationManager: LocationManager = MockLocationManager()
    ) {
        self.locationsService = locationsService
        self.linkBuilder = linkBuilder
        self.appChecker = appChecker
        self.locationManager = locationManager
    }
    
    @discardableResult
    func sendAction(_ action: LocationsViewModelActions) -> Task<Void, Never>? {
        switch action {
        case .checkWikiAppInstalled:
            isWikiAppInstalled = appChecker.isWikiAppInstalled
        case .loadLocations:
            loadLocations()
        case .validateAndOpenManualLocation(let name, let lat, let lon):
            validateAndSaveLocation(name: name, lat: lat, lon: lon)
        case .openNewLocationFromMap(let coordinate):
            validateAndSaveLocation(name: "", lat: coordinate.latitude, lon: coordinate.longitude)
        case .openSavedLocation(let location):
            selectedNewLocation = nil
            openURL(lat: location.lat, lon: location.long) // we dont need validation for saved location
        case .selectLocation(let coordinates):
            selectedNewLocation = coordinates
            selectedLocation = nil
        case .dismissErrorAlert:
            errorMessage = nil
        case .requestLocationPermissionAndSetCurrentLocationIfNeeded:
            return Task { @MainActor in
                guard cameraPosition == nil else { return }
                guard await locationManager.requestPermission() else {
                    Logger.logDebug("Location permissions denied")
                    return
                }
                
                cameraPosition = await locationManager.currentLocation()
            }
        case .updateCameraPosition(let coord):
            cameraPosition = coord
        case .didOpenURL:
            url = nil
            selectedNewLocation = nil
            selectedLocation = nil
        }
        
        return nil
    }
    
    private func loadLocations() {
        do {
            locations = try locationsService.locations()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func wikipediaLink(lat: Double, lon: Double) -> URL {
        return linkBuilder.url(for: lat, lon: lon)
    }
    
    private func validateAndSaveLocation(name: String, lat: Double?, lon: Double?) {
        do {
            let location = try locationsService.validateAndCreateLocation(name: name, lat: lat, lon: lon)
            locations.append(location)
            selectedNewLocation = nil
            selectedLocation = nil
            openURL(lat: location.lat, lon: location.long)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func openURL(lat: Double, lon: Double) {
        url = wikipediaLink(lat: lat, lon: lon)
    }
}
