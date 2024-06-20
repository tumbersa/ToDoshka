//
//  ContentView.swift
//  ToDoshka
//
//  Created by Глеб Капустин on 19.06.2024.
//

import SwiftUI

struct ContentView: View {
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
        let item = TodoItem(id: "0", text: "2 test", importance: .common,
                             isFinished: false, dateStart: Date())
        let json = item.json
        print(json)
        print(TodoItem.parse(json: json))
    }
}

#Preview {
    ContentView()
}
