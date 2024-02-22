//
//  WikiPlacesLinkBuilder.swift
//  ABNLocationPicker
//
//  Created by Igor Vedeneev on 21/02/2024.
//

import Foundation


final class WikipediaPlacesLinkBuilder {
    
    func url(for lat: Double, lon: Double) -> URL {
        guard let url = URL(string: "wikipedia://places?lat=\(lat)&lon=\(lon)") else {
            fatalError("Wrong Wiki deeplink format") // shortcut 
        }
        
        return url
    }
}
