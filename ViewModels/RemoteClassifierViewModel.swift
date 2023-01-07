//
//  ImageClassifierViewModel.swift
//  ImageClassification-iOS
//
//  Created by Alejandro Ignacio Aliaga Martinez on 6/1/23.
//

import Foundation
import SwiftUI
import CoreML

class RemoteClassifierViewModel: ObservableObject {
    // MARK: - Properties
    @Published var currentPhoto: UIImage? = nil
    @Published var predictionLabel: String = ""
    @Published var predictionProbs: [String: Double] = [:]
    @Published var state: ClassifierState = .none
        
    private var mlModel: MobileNetV2?
    
    // MARK: - Initializer
    init() {
        self.mlModel = try? MobileNetV2(configuration: MLModelConfiguration())
    }
    
    // MARK: - Functions
    func refreshImageTap() async {
        let result = await ImageService.shared.randomImageAsync()
        
        switch result {
        case .success(let image):
            self.currentPhoto = image
        case .failure(let error):
            debugPrint("Unexpected Error. Detail: \(error)")
        }
    }
    
    func performImageClassification() {
        self.state = .working
        
        guard let currentImage = currentPhoto else {
            return
        }
        
        let resizedImage = currentImage.resizeTo(size: CGSize(width: 224, height: 224))
        
        guard let imageBuffer = resizedImage?.toBuffer() else {
            return
        }
        
        guard let data = try? self.mlModel?.prediction(image: imageBuffer) else {
            return
        }
                
        self.predictionLabel = data.classLabel
        self.predictionProbs.removeAll()
        
        data.classLabelProbs.sorted(by: { $0.value > $1.value }).prefix(3).forEach {
            self.predictionProbs[$0.key] = $0.value * 100
        }
                
        self.state = .done
    }
}
