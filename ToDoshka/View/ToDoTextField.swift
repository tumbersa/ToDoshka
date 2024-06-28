//
//  ToDoTextField.swift
//  ToDoshka
//
//  Created by Глеб Капустин on 29.06.2024.
//

import SwiftUI

struct ToDoTextField: View {
    
    @Binding var description: String
    
    var body: some View {
        TextField("Что надо сделать?", text: $description, axis: .vertical)
            .submitLabel(.go)
            .font(.headline)
            .multilineTextAlignment(.leading)
            .padding(.leading, 16)
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
}

#Preview {
    ToDoTextField(description: .constant(""))
}
