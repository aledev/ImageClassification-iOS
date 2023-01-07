//
//  ImageClassifierViewModel.swift
//  ImageClassification-iOS
//
//  Created by Alejandro Ignacio Aliaga Martinez on 6/1/23.
//

import Foundation
import SwiftUI
import CoreML

class ImageClassifierViewModel: ObservableObject {
    // MARK: - Properties
    @Published var currentPhoto: String = "banana"
    @Published var predictionLabel: String = ""
    @Published var predictionProbs: [String: Double] = [:]
    @Published var state: ClassifierState = .none
        
    private let photos = ["banana", "tiger", "bottle"]
    private var mlModel: MobileNetV2?
    
    private var currentIndex: Int = 0 {
        willSet {
            self.currentPhoto = self.photos[newValue]
        }
    }
        
    private var photosCount: Int {
        photos.count - 1
    }
    
    // MARK: - Initializer
    init() {
        self.mlModel = try? MobileNetV2(configuration: MLModelConfiguration())
    }
    
    // MARK: - Functions
    func hapticNotification() {
        
    }
    
    func previousTap() {
        if self.currentIndex >= self.photosCount {
            self.currentIndex -= 1
            return
        }
        
        self.currentIndex = 0
    }
    
    func nextTap() {
        if self.currentIndex < self.photosCount {
            self.currentIndex += 1
            return
        }
        
        self.currentIndex = self.photosCount
    }
    
    func performImageClassification() {
        self.state = .working
        
        guard let currentImage = UIImage(named: currentPhoto) else {
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
