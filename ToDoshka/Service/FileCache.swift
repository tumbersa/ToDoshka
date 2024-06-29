import Foundation

final class FileCache {
    private let mock: [String: TodoItem] = [
        "1": TodoItem(id: "1", text: "1", importance: .common, isFinished: false, dateStart: Date()),
        "2": TodoItem(id: "2", text: "2", importance: .common, isFinished: true, dateStart: Date()),
        "3": TodoItem(id: "3", text: "3 сыра", importance: .important, isFinished: true, dateStart: Date()),
        "4": TodoItem(id: "4", text: "4 медведя", importance: .important, isFinished: false, dateStart: Date()),
        "5": TodoItem(id: "5", text: "5 элемент", importance: .important, deadline: Date.now.addingTimeInterval(86400), isFinished: false, dateStart: Date())
    ]
    
    private let fileManager = FileManager.default
    private (set) var todoItems: [String: TodoItem] = [:]
    
    init() {
        todoItems = mock
    }
    
    func add(todoItem: TodoItem) {
        todoItems[todoItem.id] = todoItem
    }
    
    func remove(by id: String) {
        todoItems.removeValue(forKey: id)
    }
    
    func markAsComplete(item: TodoItem) {
        if let oldItem = todoItems[item.id] {
        
            todoItems[item.id] = TodoItem(id: oldItem.id, text: oldItem.text, importance: oldItem.importance, deadline: oldItem.deadline, isFinished: true, dateStart: oldItem.dateStart, dateEdit: oldItem.dateEdit)
        }
    }
    
    func update(item: TodoItem) {
        todoItems[item.id] = item
    }
    
    func uploadTo(filePath: String) {
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        print(documentsDirectory)
        let fileURL = documentsDirectory.appendingPathComponent(filePath)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonArray = todoItems.values.map { $0.json }
        
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
        let fileURL = documentsDirectory.appendingPathComponent(filePath)
        do {
            let data = try Data(contentsOf: fileURL)
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                let items = jsonArray.compactMap { TodoItem.parse(json: $0) }
                items.forEach { todoItems[$0.id] = $0 }
            }
        } catch {
            print(error)
        }
    }
}
