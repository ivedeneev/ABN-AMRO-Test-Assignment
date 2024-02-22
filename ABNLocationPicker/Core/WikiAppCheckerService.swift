//
//  WikiAppInstallationChecker.swift
//  ABNLocationPicker
//
//  Created by Igor Vedeneev on 21/02/2024.
//

import Foundation
import UIKit.UIApplication

protocol WikiAppCheckerService {
    var isWikiAppInstalled: Bool { get }
}

final class WikiAppCheckerServiceImpl: WikiAppCheckerService {
    var isWikiAppInstalled: Bool {
        guard let url = URL(string: "wikipedia://") else {
            Logger.logDebug("Bad Wikipedia deeplink scheme is provided")
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
}
