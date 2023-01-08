//
//  ImageClassifierViewModel.swift
//  ImageClassification-iOS
//
//  Created by Alejandro Ignacio Aliaga Martinez on 6/1/23.
//

import Foundation
import SwiftUI

@MainActor
class RemoteClassifierViewModel: ObservableObject {
    // MARK: - Properties
    @Published var currentPhoto: UIImage? = nil
    @Published var prediction: Prediction = Prediction()
    @Published var state: ClassifierState = .none
    
    // MARK: - Initializer
    init() {}
    
    // MARK: - Functions
    func refreshImageTap() async {
        self.state = .working
        let result = await ImageService.shared.randomImageAsync()
        
        switch result {
        case .success(let image):
            self.currentPhoto = image
        case .failure(let error):
            self.currentPhoto = nil
            debugPrint("Unexpected Error. Detail: \(error)")
        }
        
        self.state = .none
    }
    
    func performImageClassification() {
        self.state = .working
        
        guard let currentImage = currentPhoto,
              let predictionData = MLService.shared.imageClassification(currentImage) else {
            self.state = .none
            return
        }
                                
        self.prediction = predictionData
        self.state = .done
    }
}
