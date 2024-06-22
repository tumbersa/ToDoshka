import Foundation

final class FileCache {
    private let fileManager = FileManager.default
    private (set) var todoItems: Set<TodoItem> = []
    
    func add(todoItem: TodoItem) {
        todoItems.insert(todoItem)
    }
    
    func remove(by id: String) {
        if let item = todoItems.first(where: { $0.id == id}) {
            todoItems.remove(item)
        }
    }
    
    func uploadTo(filePath: String) {
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        print(documentsDirectory)
        let fileURL = documentsDirectory.appending(path: filePath)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(todoItems)
            try data.write(to: fileURL)
        } catch {
            print("\(error)")
        }
    }
    
    func downloadFrom(filePath: String) {
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        print(documentsDirectory)
        let fileURL = documentsDirectory.appending(path: filePath)
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL)
            let items = try decoder.decode(Set<TodoItem>.self, from: data)
            items.forEach{ todoItems.insert($0) }
        } catch {
            print("\(error)")
        }
    }
}
