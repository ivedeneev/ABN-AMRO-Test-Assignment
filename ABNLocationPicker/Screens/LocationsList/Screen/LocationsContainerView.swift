//
//  LocationsListView.swift
//  ABNLocationPicker
//
//  Created by Igor Vedeneev on 21/02/2024.
//

import SwiftUI

struct LocationsContainerView: View {
    
    @State var viewModel: LocationsViewModel
    @State private var selectedIndex: Tab = .list
    
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        VStack {
            Picker("", selection: $selectedIndex) {
                ForEach(Tab.allCases) { tab in
                    Text(tab.label).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            if selectedIndex == .list {
                LocationsListView(viewModel: viewModel)
            } else {
                MapView(viewModel: viewModel)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Navigation.Title")
        .toolbarBackground(.hidden, for: .navigationBar)
        .alert(
            item: 
                Binding( // we dont want to modify properties of ViewModel from outside, so we have to do it via action
                    get: { viewModel.errorMessage },
                    set: { _ in viewModel.sendAction(.dismissErrorAlert) }
                )
        ) { msg in
            Alert(title: Text("Error.Title"), message: Text(msg), dismissButton: .cancel())
        }
        .onChange(of: viewModel.url) { _, url in
            guard let url else { return }
            openURL(url)
            viewModel.sendAction(.didOpenURL)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            guard oldPhase == .inactive && newPhase == .active else { return }
            viewModel.sendAction(.checkWikiAppInstalled)
        }
        .task {
            viewModel.sendAction(.loadLocations)
        }
    }
}

extension LocationsContainerView {
    enum Tab: Hashable, CaseIterable, Identifiable {
        var id: Int {
            self == .list ? 0 : 1
        }
        
        case list
        case map
        
        var label: LocalizedStringResource {
            switch self {
            case .list:
                "Picker.List"
            case .map:
                "Picker.Map"
            }
        }
    }
}
