import Foundation

struct TodoItem: Codable {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isFinished: Bool
    let dateStart: Date
    let dateEdit: Date?
    
    enum Importance: String, Codable {
        case unimportant
        case important
        case common
    }
    
    init(id: String = UUID().uuidString, text: String, importance: Importance, deadline: Date? = nil, isFinished: Bool, dateStart: Date, dateEdit: Date? = nil) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isFinished = isFinished
        self.dateStart = dateStart
        self.dateEdit = dateEdit
    }
    
    enum CodingKeys: CodingKey {
        case id
        case text
        case importance
        case deadline
        case isFinished
        case dateStart
        case dateEdit
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.text = try container.decode(String.self, forKey: .text)
        self.importance = try container.decodeIfPresent(TodoItem.Importance.self, forKey: .importance) ?? .common
        
        let deadlineStr = try container.decodeIfPresent(String.self, forKey: .deadline) ?? ""
        self.deadline = DateConverterHelper.UTCToLocal(date: deadlineStr)
        self.isFinished = try container.decode(Bool.self, forKey: .isFinished)
        
        let dateStartStr = try container.decode(String.self, forKey: .dateStart)
        self.dateStart = DateConverterHelper.UTCToLocal(date: dateStartStr) ?? Date()
        
        let dateEditStr = try container.decodeIfPresent(String.self, forKey: .dateEdit) ?? ""
        self.dateEdit = DateConverterHelper.UTCToLocal(date: dateEditStr)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        switch importance {
        case .unimportant, .important:
            try container.encode(importance, forKey: .importance)
        case .common:
            break
        }
        if let deadline {
            try container.encode( DateConverterHelper.localToUTC(date: deadline), forKey: .deadline)
        }
       
        try container.encode(isFinished, forKey: .isFinished)
        try container.encode( DateConverterHelper.localToUTC(date: dateStart), forKey: .dateStart)
        if let dateEdit {
            try container.encode(DateConverterHelper.localToUTC(date: dateEdit), forKey: .dateEdit)
        }
    }
    
}

extension TodoItem {
    var json: Any {
        do {
            let data = try JSONEncoder().encode(self)
            return try JSONSerialization.jsonObject(with: data)
        } catch {
            print(error)
        }
        return [:]
    }
    
    static func parse(json: Any) -> TodoItem? {
        do {
            let data = try JSONSerialization.data(withJSONObject: json)
            return try JSONDecoder().decode(TodoItem.self, from: data)
        }
        catch {
            print(error)
        }
        return nil
    }
}

extension TodoItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        return lhs.id == rhs.id
    }
}
