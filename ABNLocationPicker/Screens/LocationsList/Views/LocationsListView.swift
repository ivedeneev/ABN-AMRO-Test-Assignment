//
//  LocationsListView.swift
//  ABNLocationPicker
//
//  Created by Igor Vedeneev on 22/02/2024.
//

import SwiftUI

struct LocationsListView: View {
    
    var viewModel: LocationsViewModel
    
    @State private var latitude: Double? = nil
    @State private var longtitude: Double? = nil
    @State private var name: String = ""
    
    var body: some View {
        List {
            if !viewModel.isWikiAppInstalled {
                NoAppView()
            }
            
            Section {
                newLocationInput
            } header: {
                Text("List.AddHeader")
                    .accessibilityLabel("Input new location manually")
            } footer: {
                if !viewModel.isWikiAppInstalled {
                    Text("List.AddFooter")
                }
            }
            
            ForEach(viewModel.locations) { location in
                Button {
                    viewModel.sendAction(.openSavedLocation(location))
                } label: {
                    LocationCell(location: location)
                }

            }
        }
        .onChange(of: viewModel.url) { // clear inputs after opening url
            name = ""
            latitude = nil
            longtitude = nil
        }
    }
    
    @ViewBuilder
    private var newLocationInput: some View {
        TextField("List.Name", text: $name)
            .accessibilityValue("Optional name of the new location")
        
        HStack {
            TextField("List.Latitude", value: $latitude, format: .number)
                .keyboardType(.decimalPad)
                .accessibilityValue("Input latitude of the new location")
            
            Divider()
            
            TextField("List.Longtitude", value: $longtitude, format: .number)
                .keyboardType(.decimalPad)
                .accessibilityValue("Input longtitude of the new location")
        }
        
        Button("OpenButton.Title") {
            viewModel.sendAction(
                .validateAndOpenManualLocation(name: name, lat: latitude, lon: longtitude)
            )
        }
        .disabled(!viewModel.isWikiAppInstalled)
    }
}
