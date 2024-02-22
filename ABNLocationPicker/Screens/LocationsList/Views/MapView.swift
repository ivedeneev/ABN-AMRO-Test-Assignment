//
//  MapView.swift
//  ABNLocationPicker
//
//  Created by Igor Vedeneev on 21/02/2024.
//

import SwiftUI
import CoreLocation
import MapKit

struct MapView: View {
    
    var viewModel: LocationsViewModel
    
    // Initially hardcoded NL camera position for demo purposes
    @State private var position = MapCameraPosition.automatic
    
    @State private var lastCameraPosition: CLLocationCoordinate2D?
    @State private var selectedNewLocation: CLLocationCoordinate2D?
    @State private var selectedLocation: Location?

    var body: some View {
        MapReader { reader in
            Map(position: $position, selection: $selectedLocation) {
                if let selectedNewLocation {
                    Marker(LocalizedStringKey("Map.NewLocaton"), coordinate: selectedNewLocation)
                        .tint(.indigo)
                }
                
                ForEach(viewModel.locations) { location in
                    Marker(coordinate: location.coordinate) {
                        Text(location.safeName)
                    }
                    .tag(location)
                    .mapOverlayLevel(level: .aboveLabels)
                }
            }
            .onTapGesture { screenCoord in
                 let pinLocation = reader.convert(screenCoord, from: .local)
                 withAnimation(.bouncy) {
                     selectedNewLocation = pinLocation
                 }
            }
            .onMapCameraChange(frequency: .onEnd) { context in
                lastCameraPosition = context.camera.centerCoordinate // We dont want to update cameraPosition in ViewModel directly because it will trigger onUpdate and camera will be set automatically. It could interfere with user interaction and lead to poor UX.
            }
        }
        .onChange(of: selectedLocation) { _, loc in
            guard let loc else { return }
            selectedLocation = nil
            selectedNewLocation = nil
            viewModel.sendAction(.openSavedLocation(loc))
        }
        .onChange(of: selectedNewLocation) { _, loc in
            guard let loc else { return }
            viewModel.sendAction(.selectLocation(loc))
        }
        .overlay(alignment: .top) {
            openWikipediaButtonOrNoAppView
                .padding(Constants.UI.listViewHPadding)
        }
        .onAppear {
            viewModel.sendAction(.requestLocationPermissionAndSetCurrentLocationIfNeeded)
            selectedNewLocation = viewModel.selectedNewLocation
            setCameraPositionIfNeeded()
        }
        .onDisappear {
            guard let lastCameraPosition else { return }
            viewModel.sendAction(.updateCameraPosition(lastCameraPosition)) // MapView is recreated each time we switch to Map segment. We dont want to loose camera position and selected location so we store in in a ViewModel and when we come back we will see the same state of the view
        }
        .onChange(of: viewModel.cameraPosition) {
            setCameraPositionIfNeeded()
        }
    }
    
    @ViewBuilder
    private var openWikipediaButtonOrNoAppView: some View {
        if !viewModel.isWikiAppInstalled {
            NoAppView()
                .padding(.top)
        } else if let selectedNewLocation {
            openWikipediaButton(coordinate: selectedNewLocation) {
                viewModel.sendAction(.openNewLocationFromMap(selectedNewLocation))
            }
        }
    }
    
    private func setCameraPositionIfNeeded() {
        guard let cameraPosition = viewModel.cameraPosition else { return }
        position = MapCameraPosition.region(
            MKCoordinateRegion(
                center: cameraPosition,
                span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
            )
        )
    }
    
    private func openWikipediaButton(coordinate: CLLocationCoordinate2D, action: @escaping () -> Void) -> some View {
        Button("OpenButton.Title") {
            selectedNewLocation = nil
            action()
        }
        .padding()
        .contentShape(Rectangle())
        .bold()
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}
