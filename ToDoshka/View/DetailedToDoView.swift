//
//  DetailedToDoView.swift
//  ToDoshka
//
//  Created by Глеб Капустин on 28.06.2024.
//

import SwiftUI

struct DetailedToDoView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var description: String = ""
    @State private var selectionImportance = 1
    @State private var isDeadline:  Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                TextField("Что надо сделать?", text: $description, axis: .vertical)
                    .submitLabel(.go)
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 16)
                    .padding(.top, -50)
                    .frame(minHeight: 120)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .onChange(of: description) { _, newValue in
                        guard let newValueLastChar = newValue.last else { return }
                        if newValueLastChar == "\n" {
                            description.removeLast()
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                
                VStack {
                    HStack(spacing: 16) {
                        Text("Важность")
                            .font(.headline)
                            .frame(minWidth: 149, alignment: .leading)
                            .padding(16)
                            
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
                    }
                    
                    Divider()
                    .padding(.horizontal, 16)
                        
                    HStack(spacing: 16) {
                        Text("Сделать до")
                            .font(.headline)
                            .frame(minWidth: 149, alignment: .leading)
                            .padding(16)
                        
                        Toggle("", isOn: $isDeadline)
                            .padding(12)
                    }
                    
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
                Button(action: {
                    
                }, label: {
                    Text("Удалить")
                        .frame(maxWidth: .infinity, idealHeight: 54)
                        .foregroundStyle(.red)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                })
                
                Spacer()
            }
        }
        .padding(16)
        .ignoresSafeArea(.keyboard)
        .background(Color.backPrimary)
        .navigationTitle("Дело")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Сохранить") {
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
    
}

#Preview {
    DetailedToDoView()
}
