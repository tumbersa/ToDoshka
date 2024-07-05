//
//  ToDoListViewModel.swift
//  ToDoshka
//
//  Created by Глеб Капустин on 29.06.2024.
//
import Foundation
import Combine

final class ToDoListViewModel: ObservableObject {
    private let fileCache: FileCache
    private var cancellables = Set<AnyCancellable>()
    
    @Published var todoItems: [TodoItem] = []
    
    init(fileCache: FileCache) {
        self.fileCache = fileCache
        self.todoItems = Array(fileCache.todoItems.values)
        setupBindings()
    }
    
    func setupBindings() {
        $todoItems
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func add(item: TodoItem) {
        fileCache.add(todoItem: item)
        updateItems()
    }
    
    func markAsComplete(item: TodoItem) {
        print(item.id)
        fileCache.markAsComplete(item: item)
        updateItems()
    }
    
    func remove(by id: String) {
        fileCache.remove(by: id)
        updateItems()
    }
    
    func update(item: TodoItem) {
        fileCache.update(item: item)
        updateItems()
    }
    
    private func updateItems() {
        todoItems = Array(fileCache.todoItems.values)
    }
    
    func unicalDateArray() -> [String] {
        let strArr = todoItems.compactMap{$0.deadline}.map{ DateConverterHelper.dateFormatterShort.string(from: $0).split(separator: " ").joined(separator: "\n")}
        return Array(Set(strArr)).sorted()
    }
}
