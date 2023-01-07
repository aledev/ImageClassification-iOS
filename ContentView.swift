//
//  ContentView.swift
//  ImageClassification-iOS
//
//  Created by Alejandro Ignacio Aliaga Martinez on 6/1/23.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Body
    var body: some View {
        
        TabView {
            
            ClassifierView()
                .tabItem {
                    Label("Local Images", image: "photo.circle")
                }
            
            RemoteClassifierView()
                .tabItem {
                    Label("Remote Image", image: "icloud.circle")
                }
            
        }
        
    } //:Body
    
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
