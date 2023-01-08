//
//  Prediction.swift
//  ImageClassification-iOS
//
//  Created by Alejandro Ignacio Aliaga Martinez on 8/1/23.
//

import Foundation

struct Prediction {
    var label: String = ""
    var probabilities: [String: Double] = [:]
}
