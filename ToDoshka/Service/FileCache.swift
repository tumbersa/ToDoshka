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
        let jsonArray = todoItems.map { $0.json }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonArray, options: .prettyPrinted)
            try data.write(to: fileURL)
        } catch {
            print(error)
        }
    }
    
    func downloadFrom(filePath: String) {
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        print(documentsDirectory)
        let fileURL = documentsDirectory.appending(path: filePath)
        do {
            let data = try Data(contentsOf: fileURL)
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                let items = jsonArray.compactMap { TodoItem.parse(json: $0) }
                items.forEach { todoItems.insert($0) }
            }
        } catch {
            print(error)
        }
    }
}
