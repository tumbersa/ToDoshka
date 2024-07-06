//
//  CalendarAndButtonView.swift
//  ToDoshka
//
//  Created by Глеб Капустин on 05.07.2024.
//

import SwiftUI

struct CalendarAndButtonView: View {
    @ObservedObject var viewModel: ToDoListViewModel
    @Binding var isPresentedDetailed: Bool
    
    var body: some View {
        ZStack {
            CalendarToDoView(viewModel: viewModel)
            
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
        .background(Color.backPrimary)
    }
}

#Preview {
    CalendarAndButtonView(viewModel: ToDoListViewModel(fileCache: FileCache()), isPresentedDetailed: .constant(false))
}
