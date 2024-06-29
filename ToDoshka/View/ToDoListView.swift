//
//  ToDoListView.swift
//  ToDoshka
//
//  Created by Глеб Капустин on 28.06.2024.
//

import SwiftUI

struct ToDoListView: View {
    
    @StateObject var viewModel = ToDoListViewModel(fileCache: FileCache())
    
    @State private var isPresentedDetailed = false
    @State private var selectedItem: TodoItem?
    @State private var isShowedFinishedCells: Bool = true
    
    private let columns: [GridItem] = [
           GridItem(.flexible())
       ]
    
    private func filteredItems() -> [TodoItem] {
        return isShowedFinishedCells ? viewModel.todoItems : viewModel.todoItems.filter { !$0.isFinished }
    }
    
    private func tasksFinished() -> Int {
        return viewModel.todoItems.filter { $0.isFinished }.count
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Выполнено - \(tasksFinished())")
                        .foregroundStyle(.strikeThrough)
                    
                    Spacer()
                    Button(action: {
                        isShowedFinishedCells.toggle()
                    }, label: {
                        Text(isShowedFinishedCells ? "Скрыть" : "Показать")
                    })
                }
                .background(Color.backPrimary)
                .padding(.horizontal)
                
                List {
                    ForEach(filteredItems(), id: \.id) { item in
                        VStack(spacing: 0) {
                            ToDoListRaw(item: item)
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .leading) {
                                    Button(action: {
                                        viewModel.markAsComplete(item: item)
                                    }) {
                                        Image(.checkMarkSwipe)
                                    }
                                    .tint(.green)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        viewModel.remove(by: item.id)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .onTapGesture {
                                    selectedItem = item
                                    isPresentedDetailed.toggle()
                                }
                            Divider()
                                .frame(height: 1)
                                .padding(.leading, 32)
                            
                        }
                        .listRowSeparator(.hidden)
                    }
                    Text("Новое")
                        .listRowSeparator(.hidden)
                        .padding()
                        .padding(.leading, 22)
                        .foregroundStyle(.strikeThrough)
                }
                .background(.customLabel)
            }
            
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
                DetailedToDoView(viewModel: viewModel, item: $selectedItem)
            }
        })
    }
}

#Preview {
    NavigationStack {
        ToDoListView()
    }
}
