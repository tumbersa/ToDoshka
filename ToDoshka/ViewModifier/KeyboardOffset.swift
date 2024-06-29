//
//  Keyboard.swift
//  ToDoshka
//
//  Created by Глеб Капустин on 29.06.2024.
//

import SwiftUI

struct KeyboardOffset: ViewModifier {
    
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content.padding(.bottom, offset).onAppear{
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                                   object: nil,
                                                   queue: .main) { notification in
                if let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    let height = value.height
                    self.offset = height
                }
            }
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                                   object: nil,
                                                   queue: .main) { notification in
                self.offset = 0
            }
        }
    }
}

extension View {
    func KeyboardResponsiveOffset() -> ModifiedContent<Self, KeyboardOffset> {
        modifier(KeyboardOffset())
    }
}
