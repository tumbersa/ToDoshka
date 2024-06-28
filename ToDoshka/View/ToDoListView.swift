//
//  ToDoListView.swift
//  ToDoshka
//
//  Created by Глеб Капустин on 28.06.2024.
//

import SwiftUI

struct ToDoListView: View {
    @State private var isPresentedDetailed = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Button(action: {
                    isPresentedDetailed.toggle()
                }, label: {
                    Image("plusRounded", label: Text("plus"))
                        .resizable()
                        .frame(width: 44, height: 44, alignment: .center)
                        .padding(.bottom, 2)
                        .foregroundStyle(.customBlue)
                        .shadow(color: .shadowBlue, radius: 20)
                })
            }
        }
        .containerRelativeFrame([.horizontal, .vertical])
        .background(Color.backPrimary)
        .navigationTitle("Мои дела")
        .sheet(isPresented: $isPresentedDetailed, content: {
            NavigationStack {
                DetailedToDoView()
            }
        })
    }
}

#Preview {
    NavigationStack {
        ToDoListView()
    }
}
