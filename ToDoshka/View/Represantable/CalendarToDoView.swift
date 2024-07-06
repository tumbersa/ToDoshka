//
//  CalendarToDoView.swift
//  ToDoshka
//
//  Created by Глеб Капустин on 05.07.2024.
//

import SwiftUI

struct CalendarToDoView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: ToDoListViewModel
    
    func makeUIViewController(context: Context) -> CalendarViewController {
        CalendarViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: CalendarViewController, context: Context) {
    }

}
