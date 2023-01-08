//
//  MLService.swift
//  ImageClassification-iOS
//
//  Created by Alejandro Ignacio Aliaga Martinez on 8/1/23.
//

import Foundation
import CoreML
import UIKit

class MLService {
    // MARK: - Properties
    static let shared = MLService()
    
    // MARK: - Initializer
    private init() {}
    
    // MARK: - Functions
    func imageClassification(_ image: UIImage) -> Prediction? {
        guard let mlModel = try? MobileNetV2(configuration: MLModelConfiguration()) else {
            return nil
        }
        
        let resizedImage = image.resizeTo(size: CGSize(width: 224, height: 224))
        
        guard let imageBuffer = resizedImage?.toBuffer() else {
            return nil
        }
        
        guard let data = try? mlModel.prediction(image: imageBuffer) else {
            return nil
        }
                
        var prediction = Prediction()
        prediction.label = data.classLabel
        
        data.classLabelProbs
            .sorted(by: { $0.value > $1.value })
            .prefix(3).forEach {
            prediction.probabilities[$0.key] = $0.value * 100
        }
        
        return prediction
    }
    
}
