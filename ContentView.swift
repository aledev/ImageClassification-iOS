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
                .edgesIgnoringSafeArea(.all)
                .tabItem {
                    
                    Image(systemName: "photo.circle")
                    
                    Text("Local Image")
                    
                } //: tabItem
            
            RemoteClassifierView()
                .edgesIgnoringSafeArea(.all)
                .tabItem {
                    
                    Image(systemName: "icloud.circle")
                    
                    Text("Remote Image")                        
                    
                } //: tabItem
            
        } //: TabView
        .edgesIgnoringSafeArea(.all)
        
    } //:Body
    
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        // Light Theme
        ContentView()
            .preferredColorScheme(.light)
        
        // Dark Theme
        ContentView()
            .preferredColorScheme(.dark)
        
    }
    
}
