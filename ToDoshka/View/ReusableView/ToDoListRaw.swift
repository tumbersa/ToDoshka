//
//  ToDoListRaw.swift
//  ToDoshka
//
//  Created by Глеб Капустин on 29.06.2024.
//

import SwiftUI

struct ToDoListRaw: View {
    
    var item: TodoItem
    
    var body: some View {
        
        HStack {
            let imageResource: ImageResource = if item.isFinished {
                .rawOn
            } else {
                switch item.importance {
                case .unimportant, .common:
                        .rawOff
                case .important:
                        .rawHighPriority
                }
            }
            
            Image(imageResource)
                .padding(.trailing, 2)
                
            if item.importance != .common && !item.isFinished {
                Image(item.importance == .important ? .priorityHigh : .priorityLow)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(item.text)
                    .strikethrough(item.isFinished, color: .strikeThrough)
                    .foregroundStyle(item.isFinished ? .strikeThrough : Color(.label))
                
                if let deadline = item.deadline {
                    HStack {
                        Image(.calendar)
                        Text(DateConverterHelper.dateFormatterShort.string(from: deadline))
                    }
                }
            }
            Spacer()
            Image(.chevronRight)
        }
        .frame(height: 56)
    }
}

#Preview {
    ToDoListRaw(item: TodoItem(text: "Попытка пытка", importance: .unimportant, deadline: Date(), isFinished: false, dateStart: Date()))
}
