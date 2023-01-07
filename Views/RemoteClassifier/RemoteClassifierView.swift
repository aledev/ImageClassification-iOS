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
                            .onTapGesture {
                                confirmClassifyPresented = true
                                HapticFeedback.shared.notify()
                            }
                        
                    } else {
                        
                        VStack(spacing: 10) {
                            
                            Text("Unavailable Image")
                                .font(.title3)
                                .foregroundColor(.secondary)
                            
                            Image(systemName: "x.square")
                                .resizable()
                                .foregroundColor(.secondary)
                                .frame(width: 50, height: 50)
                            
                        } //: VStack
                        .padding(.top, 50)
                        
                    } //: Else
                    
                } //: VStack
                
                if viewModel.state == .done {
                    
                    VStack(spacing: 5) {
 
                        HStack(spacing: 10) {
                            
                            Text("TYPE:")
                                .bold()
                                .font(.footnote)
                                .foregroundColor(.primary)
                                                        
                            Text(viewModel.predictionLabel)
                                .textCase(.uppercase)
                                .bold()
                                .font(.footnote)
                                .font(.caption)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            
                            Spacer()
                            
                            Image(systemName: "xmark.circle")
                                .font(.title3)
                                .foregroundColor(.secondary)
                                .onTapGesture {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        viewModel.state = .none
                                        HapticFeedback.shared.notify()
                                    }
                                }
                            
                        } //: HStack
                        .padding(.horizontal, 10)
                        .padding(.top, 5)
                        
                        Divider()
                            .frame(height: 1)
                            .background(.secondary)
                        
                        VStack {
                            
                            HStack {
                                
                                Text("Probabilities:")
                                    .font(.footnote)
                                    .bold()
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                            } //: HStack
                            
                            ForEach(viewModel.predictionProbs.sorted(by: >), id: \.key) { (key, value) in
                                
                                HStack {
                                    
                                    Text(key)
                                        .font(.footnote)
                                        .foregroundColor(.primary)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                    
                                    Spacer()
                                    
                                    Text(String(format: "%.2f%@", value, "%"))
                                        .font(.footnote)
                                        .foregroundColor(.primary)
                                    
                                } //: HStack
                                
                            } //: ForEach
                            
                        } //: VStack
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        
                    } //: VStack
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(.accentColor)
                            .opacity(0.3)
                    )
                    .frame(maxWidth: 300)
                    .offset(x: 0, y: -250)
                    .padding()
                    
                }
                
                if viewModel.state == .working {
                    
                    ProgressView(label: {
                        Text("Loading...")
                    })
                    
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
