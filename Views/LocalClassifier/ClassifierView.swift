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
                        .onTapGesture {
                            confirmClassifyPresented = true
                            viewModel.hapticNotification()
                        }
                    
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
                                        viewModel.hapticNotification()
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
            
                Button("Previous") {
                    withAnimation(.easeIn(duration: 0.3)) {
                        viewModel.previousTap()
                        viewModel.hapticNotification()
                    }
                } //: Button Previous
                .padding()
                
                
                Button("Next") {
                    withAnimation(.easeIn(duration: 0.3)) {
                        viewModel.nextTap()
                        viewModel.hapticNotification()
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
                    viewModel.hapticNotification()
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
        ClassifierView()
    }
}
