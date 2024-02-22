//
//  LocationsViewModelTests.swift
//  ABNLocationPickerTests
//
//  Created by Igor Vedeneev on 22/02/2024.
//

import XCTest
import CoreLocation
@testable import ABNLocationPicker

final class LocationsViewModelTests: XCTestCase {
    
    var sut: LocationsViewModelImpl!
    var mockService: MockLocationService!
    var linkBuilder: WikipediaPlacesLinkBuilder!
    var appChecker: MockAppChecker!
    var locationManager: MockLocationManager!

    override func setUpWithError() throws {
        mockService = MockLocationService()
        linkBuilder = WikipediaPlacesLinkBuilder()
        appChecker = MockAppChecker()
        locationManager = MockLocationManager()
        
        sut = LocationsViewModelImpl(
            locationsService: mockService,
            linkBuilder: linkBuilder,
            appChecker: appChecker,
            locationManager: locationManager
        )
        
        appChecker.result = false
    }

    override func tearDownWithError() throws {
        mockService = nil
        linkBuilder = nil
        appChecker = nil
        sut = nil
        locationManager = nil
    }

    func test_WhenGivenValidCoordinates_SetsLink_AndResetsAfter() {
        XCTAssertNil(sut.url)
        let lat: Double = 0
        let lon: Double = 0
        mockService.validateResult = .success(Location(name: "", lat: lat, long: lon))
        
        sut.sendAction(.validateAndOpenManualLocation(name: "", lat: lat, lon: lat))
        
        let expectedUrl = linkBuilder.url(for: lat, lon: lon)
        XCTAssertNotNil(sut.url)
        
        sut.sendAction(.didOpenURL)
        XCTAssertNil(sut.url)
        
        sut.sendAction(.openNewLocationFromMap(CLLocationCoordinate2D(latitude: 0, longitude: 0)))
        XCTAssertNotNil(sut.url)
    }
    
    func test_WhenGivenBadCoordinates_UpdatesErrorMessage() {
        mockService.validateResult = .failure(.badCoordinatesValues)
        
        sut.sendAction(.validateAndOpenManualLocation(name: "", lat: nil, lon: nil))
        
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertNil(sut.url)
    }
    
    func test_WhenRequestedLocation_CameraPositionIsSet() async {
        XCTAssertNil(sut.cameraPosition)
        let currrentCoord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        locationManager.currentLocationValue = currrentCoord
        
        _ = await sut.sendAction(.requestLocationPermissionAndSetCurrentLocationIfNeeded)?.result
        
        XCTAssertEqual(sut.cameraPosition, currrentCoord)
    }
    
    func test_WhenCameraPositionIsSet_RequestedCurrentLocationIsIgnored() async {
        let initialCameraPosition = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        locationManager.currentLocationValue = initialCameraPosition
        
        let newCameraPosition = CLLocationCoordinate2D(latitude: 2, longitude: 2)
        XCTAssertNotEqual(initialCameraPosition, newCameraPosition, "Currrent and initial camera positions must be different for this test")
        
        sut.sendAction(.updateCameraPosition(newCameraPosition))
        _ = await sut.sendAction(.requestLocationPermissionAndSetCurrentLocationIfNeeded)?.result
        XCTAssertEqual(sut.cameraPosition, newCameraPosition)
    }
    
    func test_WhenRequestedWikiAppCheck_StateIsUpdated() {
        appChecker.result = false
        sut.sendAction(.checkWikiAppInstalled)
        XCTAssertEqual(sut.isWikiAppInstalled, appChecker.result)
        
        appChecker.result = true
        sut.sendAction(.checkWikiAppInstalled)
        XCTAssertEqual(sut.isWikiAppInstalled, appChecker.result)
    }
    
    func test_WhenOpenLocationFromMap_SelectedLocationsNullified() {
        let savedLoc = Location(name: "", lat: 0, long: 0)
        mockService.validateResult = .success(savedLoc)
        
        sut.sendAction(.openSavedLocation(savedLoc))
        XCTAssertNil(sut.selectedLocation)
        XCTAssertNil(sut.selectedNewLocation)
        
        let coord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        sut.sendAction(.selectLocation(coord))
        sut.sendAction(.openNewLocationFromMap(coord))
        XCTAssertNil(sut.selectedLocation)
        XCTAssertNil(sut.selectedNewLocation)
    }
    
    func test_WhenSelectSavedLocationFromMap_NewLocationNullifies_AndViseVersa() {
        let savedLoc = Location(name: "", lat: 0, long: 0)
        
        sut.sendAction(.openSavedLocation(savedLoc))
        XCTAssertNil(sut.selectedLocation)
        XCTAssertNil(sut.selectedNewLocation)
        
        let coord = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        sut.sendAction(.selectLocation(coord))
        XCTAssertNil(sut.selectedLocation)
        XCTAssertEqual(coord, sut.selectedNewLocation)
    }
}
