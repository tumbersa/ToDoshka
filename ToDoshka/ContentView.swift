//
//  ContentView.swift
//  ToDoshka
//
//  Created by Глеб Капустин on 19.06.2024.
//

import SwiftUI


struct ContentView: View {
    var fileCache = FileCache()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            getStarted()
        }
    }
    
    func getStarted() {
        
    }
}

#Preview {
    ContentView()
}
