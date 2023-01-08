//
//  ClassifierView.swift
//  ImageClassification-iOS
//
//  Created by Alejandro Ignacio Aliaga Martinez on 6/1/23.
//

import SwiftUI

struct RemoteClassifierView: View {
    // MARK: - Properties
    @StateObject private var viewModel = RemoteClassifierViewModel()
    @State private var confirmClassifyPresented: Bool = false
    
    // MARK: - Body
    var body: some View {
        
        VStack {
            
            ZStack {
                
                VStack {
                    
                    Text("Tap Image to Classify")
                        .font(.title3)
                        .foregroundColor(.primary)
                    
                    if let currentPhoto = viewModel.currentPhoto {
                        
                        Image(uiImage: currentPhoto)
                            .resizable()
                            .frame(width: 200, height: 200)
                            .cornerRadius(5)
                            .shadow(color: .secondary, radius: 4.0)
                            .onTapGesture {
                                confirmClassifyPresented = true
                                HapticFeedback.shared.notify()
                            }
                        
                    } else {
                        
                        VStack(spacing: 20) {
                            
                            Text("Unavailable Image")
                                .font(.title3)
                                .foregroundColor(.secondary)
                            
                            Image(systemName: "x.square")
                                .resizable()
                                .foregroundColor(.secondary)
                                .frame(width: 50, height: 50)
                            
                        } //: VStack
                        .padding(.vertical, 50)
                        
                    } //: Else
                    
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
            
                Button("Refresh Image") {
                    Task.init(operation: {
                        await viewModel.refreshImageTap()
                        HapticFeedback.shared.notify()
                    })
                } //: Button Previous
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
        .task {
            // Load initial image
            await viewModel.refreshImageTap()
        }
        
    } //: Body
    
}

// MARK: - Preview
struct RemoteClassifierView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        // Light Theme
        RemoteClassifierView()
            .preferredColorScheme(.light)
        
        // Dark Theme
        RemoteClassifierView()
            .preferredColorScheme(.dark)
        
    }
    
}
