//
//  ClassifierView.swift
//  ImageClassification-iOS
//
//  Created by Alejandro Ignacio Aliaga Martinez on 6/1/23.
//

import SwiftUI

struct ClassifierView: View {
    // MARK: - Properties
    @StateObject private var viewModel = ImageClassifierViewModel()
    @State private var confirmClassifyPresented: Bool = false
    
    // MARK: - Body
    var body: some View {
        
        VStack {
            
            ZStack {
                
                VStack {
                    
                    Text("Tap Image to Classify")
                        .font(.title3)
                        .foregroundColor(.primary)
                    
                    Image(viewModel.currentPhoto)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .cornerRadius(5)
                        .shadow(color: .secondary, radius: 4.0)
                        .onTapGesture {
                            confirmClassifyPresented = true
                            HapticFeedback.shared.notify()
                        }
                    
                } //: VStack
                
                if viewModel.state == .done {
                    
                    ResultsView(
                        result: viewModel.prediction,
                        state: $viewModel.state
                    )
                    
                }
                
                if viewModel.state == .working {
                    
                    LoadingView()
                    
                }
                
            } //: ZStack
            
            HStack {
            
                Button("Previous") {
                    withAnimation(.easeIn(duration: 0.3)) {
                        viewModel.previousTap()
                        HapticFeedback.shared.notify()
                    }
                } //: Button Previous
                .padding()
                
                
                Button("Next") {
                    withAnimation(.easeIn(duration: 0.3)) {
                        viewModel.nextTap()
                        HapticFeedback.shared.notify()
                    }
                } //: Button Next
                .padding()
                                
            } //: HStack
            
        } //: VStack
        .padding()
        .alert("Image Classification",
               isPresented: $confirmClassifyPresented,
               actions: {
            
            // Cancel Button
            Button(role: .cancel) {
            } label: {
                Text("Cancel")
            }
            
            // Classify Button
            Button(role: .none) {
                withAnimation(.easeIn(duration: 0.3)) {
                    viewModel.performImageClassification()
                    HapticFeedback.shared.notify()
                }
            } label: {
                Text("Classify")
            }
            
        }) {
            
            Text("Do you want to classify this image?")
            
        } //: Alert
        
    } //: Body
    
}

// MARK: - Preview
struct ClassifierView_Previews: PreviewProvider {
    
    static var previews: some View {
    
        // Light Theme
        ClassifierView()
            .preferredColorScheme(.light)
        
        // Dark Theme
        ClassifierView()
            .preferredColorScheme(.dark)
        
    }
    
}
