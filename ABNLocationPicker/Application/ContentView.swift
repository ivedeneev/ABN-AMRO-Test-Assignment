//
//  ContentView.swift
//  ABNLocationPicker
//
//  Created by Igor Vedeneev on 19/02/2024.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            LocationsContainerView(viewModel: LocationsViewModelImpl())
        }
    }
}

#Preview {
    ContentView()
}
