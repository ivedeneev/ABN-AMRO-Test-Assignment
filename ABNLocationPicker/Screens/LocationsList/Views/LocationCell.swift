//
//  LocationCell.swift
//  ABNLocationPicker
//
//  Created by Igor Vedeneev on 22/02/2024.
//

import SwiftUI

struct LocationCell: View {
    
    let location: Location
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "globe")
                .resizable()
                .frame(width: 14, height: 14)
                .foregroundColor(.secondary)
            
            Text(location.safeName)
                .foregroundColor(.primary)
        }
        .accessibilityLabel(location.name ?? "Unnamed location")
    }
}
