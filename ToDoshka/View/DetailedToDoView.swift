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
                        importancePicker
                        deadlineSection
                        
                    }
                    .background(Color.white)
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
                .background(Color.white)
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
                //TODO: - Implement delete action here
            }, label: {
                Text("Удалить")
                    .frame(maxWidth: .infinity, idealHeight: 54)
                    .foregroundStyle(.red)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            })
        }
    
}

#Preview {
    DetailedToDoView()
}

struct Orientation {
    static var isLandscape: Bool {
        get {
            let orientation = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.interfaceOrientation
            return orientation!.isLandscape
        }
    }
    static var isPortrait: Bool {
        get {
            let orientation = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.interfaceOrientation
            return orientation!.isPortrait
        }
    }
}
