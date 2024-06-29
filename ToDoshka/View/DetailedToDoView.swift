//
//  DetailedToDoView.swift
//  ToDoshka
//
//  Created by Глеб Капустин on 28.06.2024.
//

import SwiftUI

struct DetailedToDoView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var viewModel: ToDoListViewModel
    
    @Binding var item: TodoItem?
    
    @State private var description: String = ""
    @State private var selectionImportance = 1
    
    @State private var isDeadline:  Bool = false
    @State private var deadlineDate = Date.now.addingTimeInterval(86400)
    @State private var deadlineButtonPressed: Bool = false
    
    @State private var isPortrait = Orientation.isPortrait
    
    var body: some View {
            Group {
                if isPortrait {
                    portraitView
                } else {
                    landscapeView
                }
            }
            .ignoresSafeArea(.keyboard)
            .background(Color.backPrimary)
            .navigationTitle("Дело")
            .navigationBarTitleDisplayMode(.inline)
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                Task { @MainActor in
                    try await Task.sleep(for: .seconds(0.1))
                    withAnimation {
                        isPortrait = Orientation.isPortrait
                    }
                }
            }
            .onAppear {
                description = item?.text ?? ""
                selectionImportance = item?.importance.rawValue ?? 1
                deadlineDate = item?.deadline ?? Date.now.addingTimeInterval(86400)
                isDeadline = item?.deadline != nil
            }
        }
        
        var portraitView: some View {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    TextField("Что надо сделать?", text: $description, axis: .vertical)
                        .submitLabel(.go)
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 16)
                        .padding(.top, -50)
                        .frame(minHeight: 120)
                        .background(Color.customLabel)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .onChange(of: description) { _, newValue in
                            guard let newValueLastChar = newValue.last else { return }
                            if newValueLastChar == "\n" {
                                description.removeLast()
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        }
                    
                    VStack {
                        importancePicker
                        deadlineSection
                        
                    }
                    .background(Color.customLabel)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    deleteButton
                    
                    Spacer()
                }
            }
            .KeyboardResponsiveOffset()
            .padding(16)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        //Добавить, если не было элемента и обновить если был
                        let deadlineForItem = isDeadline ? deadlineDate : item?.deadline ?? nil
                        let newItem = TodoItem(id: item?.id ?? UUID().uuidString, text: description, importance: TodoItem.Importance(rawValue: selectionImportance) ?? .common, deadline: deadlineForItem, isFinished: item?.isFinished ?? false, dateStart: item?.dateStart ?? Date(), dateEdit: item?.dateEdit)
                        
                        if item == nil {
                            viewModel.add(item: newItem)
                        } else {
                            viewModel.update(item: newItem)
                        }
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отменить") {
                        dismiss()
                    }
                }
            }
        }
        
        var landscapeView: some View {
           
            TextField("Что надо сделать?", text: $description, axis: .vertical)
                .submitLabel(.go)
                .font(.headline)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.leading, 16)
                .padding(.top, -250)
                .background(Color.customLabel)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .onChange(of: description) { _, newValue in
                    guard let newValueLastChar = newValue.last else { return }
                    if newValueLastChar == "\n" {
                        description.removeLast()
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
            
        }
        
        var importancePicker: some View {
            VStack {
                HStack(spacing: 16) {
                    Text("Важность")
                        .font(.headline)
                        .frame(minWidth: 149, alignment: .leading)
                        .padding()
                    
                    Picker(selection: $selectionImportance) {
                        Image(.priorityLow)
                            .resizable()
                            .tag(0)
                        Text("нет").tag(1)
                        Image(.priorityHigh)
                            .resizable()
                            .tag(2)
                    } label: {
                        Text("Picker")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.vertical, 10)
                    .padding(.trailing, 12)
                    .foregroundColor(Color(.label))
                }
                
                Divider()
                    .padding(.horizontal, 16)
            }
        }
        
        var deadlineSection: some View {
            VStack {
                HStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        Text("Сделать до")
                            .font(.headline)
                            .frame(minWidth: 149, alignment: .leading)
                        
                        if isDeadline {
                            Button {
                                deadlineButtonPressed.toggle()
                            } label: {
                                Text(DateConverterHelper.dateFormatter.string(from: deadlineDate))
                            }
                            .transition(.scale)
                        }
                    }
                    .padding()
                    
                    Spacer()
                    Toggle("", isOn: $isDeadline)
                        .onChange(of: isDeadline) { _, newValue in
                            if !newValue {
                                deadlineButtonPressed = false
                            }
                        }
                        .padding(12)
                }
                
                if deadlineButtonPressed {
                    VStack {
                        Divider()
                            .padding(.horizontal, 16)
                        
                        DatePicker("", selection: $deadlineDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .frame(maxHeight: 400)
                    }
                    .transition(.slide)
                }
            }
            
        }
        
        var deleteButton: some View {
            Button(action: {
                if let item {
                    viewModel.remove(by: item.id)
                    dismiss()
                }
            }, label: {
                Text("Удалить")
                    .frame(maxWidth: .infinity, idealHeight: 54)
                    .foregroundStyle(.customRed)
                    .background(Color.customLabel)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            })
        }
    
}

#Preview {
    DetailedToDoView(viewModel: ToDoListViewModel(fileCache: FileCache()), item: .constant(nil))
}

