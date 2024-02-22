//
//  ABNLocationPickerApp.swift
//  ABNLocationPicker
//
//  Created by Igor Vedeneev on 19/02/2024.
//

import SwiftUI

@main
struct ABNLocationPickerApp: App {
    
    init() {
        UITextField.appearance().clearButtonMode = .always
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
