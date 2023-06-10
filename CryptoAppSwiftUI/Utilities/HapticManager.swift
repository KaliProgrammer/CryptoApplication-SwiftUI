//
//  HapticManager.swift
//  CryptoAppSwiftUI
//
//  Created by MacBook Air on 04.06.2023.
//

import Foundation
import SwiftUI

class HapticManager {
    static let generator = UINotificationFeedbackGenerator()
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
