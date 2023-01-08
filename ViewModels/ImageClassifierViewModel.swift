//
//  ImageClassifierViewModel.swift
//  ImageClassification-iOS
//
//  Created by Alejandro Ignacio Aliaga Martinez on 6/1/23.
//

import Foundation
import SwiftUI

class ImageClassifierViewModel: ObservableObject {
    // MARK: - Properties
    @Published var currentPhoto: String = ""
    @Published var prediction: Prediction = Prediction()
    @Published var state: ClassifierState = .none
    
    private var currentIndex: Int = 0 {
        willSet {
            self.currentPhoto = PhotosData.photos[newValue]
        }
    }
        
    private var photosCount: Int {
        PhotosData.photos.count - 1
    }
    
    // MARK: - Initializer
    init() {
        self.currentPhoto = PhotosData.photos[currentIndex]
    }
    
    // MARK: - Functions
    func previousTap() {
        if self.currentIndex > 0 {
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
        
        guard let currentImage = UIImage(named: currentPhoto),
              let predictionData = MLService.shared.imageClassification(currentImage) else {
            self.state = .none
            return
        }
                        
        self.prediction = predictionData
        self.state = .done        
    }
}
