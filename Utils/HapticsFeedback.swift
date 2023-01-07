//
//  HapticsFeedback.swift
//  ImageClassification-iOS
//
//  Created by Alejandro Ignacio Aliaga Martinez on 7/1/23.
//

import Foundation
import UIKit

class HapticFeedback {
    // MARK: - Singleton
    static let shared = HapticFeedback()
    private var haptics: UINotificationFeedbackGenerator? = nil
    
    // MARK: - Initializer
    private init() {
        self.haptics = UINotificationFeedbackGenerator()
    }
    
    // MARK: - Functions
    func notify() {
        self.haptics?.notificationOccurred(.success)
    }
    
}
