//
//  ImageService.swift
//  ImageClassification-iOS
//
//  Created by Alejandro Ignacio Aliaga Martinez on 6/1/23.
//

import Foundation
import UIKit

class ImageService {
    // MARK: - Properties
    static let shared = ImageService()
    
    // MARK: - Initializer
    private init() {}
    
    // MARK: - Functions
    func randomImageAsync() async -> Result<UIImage, NetworkError> {
        guard let imageURL = URL(string: EndPoints.randomImage.rawValue) else {
            return .failure(.wrongURL)
        }
        
        guard let (imageData, response) = try? await URLSession.shared.data(from: imageURL) else {
            return .failure(.requestError)
        }
        
        guard let networkResponse = (response as? HTTPURLResponse),
              networkResponse.statusCode == 200 else {
            return .failure(.responseError)
        }
        
        guard let image = UIImage(data: imageData) else {
            return .failure(.parseError)
        }
        
        return .success(image)
    }
    
}
