//
//  ResultsView.swift
//  ImageClassification-iOS
//
//  Created by Alejandro Ignacio Aliaga Martinez on 8/1/23.
//

import SwiftUI

struct ResultsView: View {
    // MARK: - Properties
    let result: Prediction
    @Binding var state: ClassifierState
    
    // MARK: - Body
    var body: some View {
        
        VStack(spacing: 5) {

            HStack(spacing: 10) {
                
                Text("TYPE:")
                    .bold()
                    .font(.footnote)
                    .foregroundColor(.primary)
                                            
                Text(result.label)
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
                            self.state = .none
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
                
                ForEach(result.probabilities.sorted(by: >), id: \.key) { (key, value) in
                    
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
        
    } //: Body
    
}

// MARK: - Preview
struct ResultsView_Previews: PreviewProvider {
    
    private static let prediction = Prediction(
        label: "[Type]",
        probabilities: [
            "Type A": 10.5,
            "Type B": 45.3,
            "Type C": 90.4
        ]
    )
    
    static var previews: some View {
        
        // Light Theme
        ResultsView(
            result: prediction,
            state: .constant(.done)
        )
        .preferredColorScheme(.light)
        
        // Dark Theme
        ResultsView(
            result: prediction,
            state: .constant(.done)
        )
        .preferredColorScheme(.dark)
        
    }
    
}
