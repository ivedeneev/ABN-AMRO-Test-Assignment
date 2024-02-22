//
//  LocationServiceTests.swift
//  ABNLocationPickerTests
//
//  Created by Igor Vedeneev on 22/02/2024.
//

import XCTest
@testable import ABNLocationPicker

final class LocationServiceTests: XCTestCase {
    
    var sut: LocationsServiceImpl!

    override func setUpWithError() throws {
        sut = LocationsServiceImpl()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_WhenGivenValidCoordinates_ReturnsLocation() {
        let name = "ABN AMRO hoofdkantoor"
        
        let minLat = Double.latitudeRange.lowerBound
        let maxLat = Double.latitudeRange.upperBound
        
        let minLon = Double.longtitudeRange.lowerBound
        let maxLon = Double.longtitudeRange.upperBound
        
        let testData: [(Double, Double)] = [(0,0), (minLat, 0), (maxLat, 0), (0, minLon), (0, maxLon), (minLat, minLon), (minLat, maxLon), (maxLat, minLon), (maxLat, maxLon)]
        
        for (lat, lon) in testData {
            XCTAssertNoThrow(try sut.validateAndCreateLocation(name: name, lat: lat, lon: lon))
        }
    }
    
    
    //TODO: check type of error?
    func test_WhenGivenBadCoordinates_ThrowsError() {
        XCTAssertThrowsError(try sut.validateAndCreateLocation(name: "", lat: nil, lon: nil))
        XCTAssertThrowsError(try sut.validateAndCreateLocation(name: "", lat: 0, lon: nil))
        XCTAssertThrowsError(try sut.validateAndCreateLocation(name: "", lat: nil, lon: 0))
        
        XCTAssertThrowsError(try sut.validateAndCreateLocation(name: "", lat:  Double.latitudeRange.lowerBound - 1, lon: 0))
        XCTAssertThrowsError(try sut.validateAndCreateLocation(name: "", lat: Double.latitudeRange.upperBound + 1, lon: 0))
        
        XCTAssertThrowsError(try sut.validateAndCreateLocation(name: "", lat:  Double.latitudeRange.lowerBound - 1, lon: 0))
        XCTAssertThrowsError(try sut.validateAndCreateLocation(name: "", lat: Double.latitudeRange.upperBound + 1, lon: 0))
    }
}
