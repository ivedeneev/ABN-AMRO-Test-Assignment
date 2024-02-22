//
//  MockAppChecker.swift
//  ABNLocationPickerTests
//
//  Created by Igor Vedeneev on 22/02/2024.
//

import Foundation
@testable import ABNLocationPicker

final class MockAppChecker: WikiAppCheckerService {
    
    var result: Bool!
    
    var isWikiAppInstalled: Bool {
        result
    }
}
