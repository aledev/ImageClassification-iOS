//
//  LoadingView.swift
//  ImageClassification-iOS
//
//  Created by Alejandro Ignacio Aliaga Martinez on 8/1/23.
//

import SwiftUI

struct LoadingView: View {
    
    // MARK: - Body
    var body: some View {
        
        VStack {
            
            ProgressView(label: {
                
                Text("Loading...")
                
            }) //: ProgressView
            .tint(.accentColor)
            .foregroundColor(.accentColor)
            .progressViewStyle(.circular)
            
        } //: VStack
        .padding()
        
    } //: Body
    
}

// MARK: - Preview
struct LoadingView_Previews: PreviewProvider {
    
    static var previews: some View {
    
        // Light Theme
        LoadingView()
            .preferredColorScheme(.light)
        
        // Dark Theme
        LoadingView()
            .preferredColorScheme(.dark)
        
    }
    
}
