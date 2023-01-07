//
//  UIImage+Extension.swift
//  ImageClassification-iOS
//
//  Created by Alejandro Ignacio Aliaga Martinez on 6/1/23.
//

import Foundation
import UIKit

extension UIImage {
    
    func resizeTo(size: CGSize) -> UIImage? {
        return autoreleasepool { () -> UIImage? in
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            self.draw(in: CGRect(origin: CGPoint.zero, size: size))
            
            guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
                return nil
            }
            
            UIGraphicsEndImageContext()
            return resizedImage
        }
    }
    
    func toBuffer() -> CVPixelBuffer? {
        return autoreleasepool { () -> CVPixelBuffer? in
            let attrs = [
                kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
                kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue
            ] as CFDictionary
            
            var pixelBuffer: CVPixelBuffer?
            let status = CVPixelBufferCreate(
                kCFAllocatorDefault,
                Int(self.size.width),
                Int(self.size.height),
                kCVPixelFormatType_32ARGB,
                attrs,
                &pixelBuffer
            )
            
            guard let pixelBuffer = pixelBuffer,
                  status == kCVReturnSuccess else {
                return nil
            }
            
            CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            
            let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            guard let context = CGContext(
                data: pixelData,
                width: Int(self.size.width),
                height: Int(self.size.height),
                bitsPerComponent: 8,
                bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                space: rgbColorSpace,
                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
            ) else {
                return nil
            }
            
            context.translateBy(x: 0, y: self.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            UIGraphicsPushContext(context)
            
            self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            UIGraphicsPopContext()
            
            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            
            return pixelBuffer
        }
    }
    
}
