//
//  NetworkError.swift
//  ImageClassification-iOS
//
//  Created by Alejandro Ignacio Aliaga Martinez on 7/1/23.
//

import Foundation

enum NetworkError: Error {
    case wrongURL
    case requestError
    case responseError
    case parseError
}
