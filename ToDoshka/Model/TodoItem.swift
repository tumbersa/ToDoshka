import Foundation

struct TodoItem:Equatable {
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isFinished: Bool
    let dateStart: Date
    let dateEdit: Date?
    
    enum Importance: Int {
        case unimportant = 0
        case important = 2
        case common = 1
        
        func getString() -> String {
            return switch self {
            case .important:
                "important"
            case .common:
                "common"
            case .unimportant:
                "unimportant"
            }
        }
        
        static func getInt(str: String) -> Int {
            return switch str {
            case "unimportant":
                0
            case "common":
                1
            case "important":
                2
            default:
                3
            }
        
        }
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
    
}

extension TodoItem {
    var json: Any {
        var dict: [String: Any] = [
            "id": id,
            "text": text,
            "isFinished": isFinished,
            "dateStart": DateConverterHelper.localToUTC(date: dateStart)
        ]
        
        if importance != .common {
            dict["importance"] = importance.getString
        }
        
        if let deadline = deadline {
            dict["deadline"] = DateConverterHelper.localToUTC(date: deadline)
        }
        
        if let dateEdit = dateEdit {
            dict["dateEdit"] = DateConverterHelper.localToUTC(date: dateEdit)
        }
        
        return dict
    }
    
    static func parse(json: Any) -> TodoItem? {
        guard let dict = json as? [String: Any],
              let id = dict["id"] as? String,
              let text = dict["text"] as? String,
              let isFinished = dict["isFinished"] as? Bool,
              let dateStartStr = dict["dateStart"] as? String,
              let dateStart = DateConverterHelper.UTCToLocal(date: dateStartStr)
        else {
            return nil
        }
        
        let importanceStr = dict["importance"] as? String ?? Importance.common.getString()
        let importance = Importance(rawValue: Importance.getInt(str: importanceStr)) ?? .common
        
        let deadlineStr = dict["deadline"] as? String
        let deadline = deadlineStr.flatMap { DateConverterHelper.UTCToLocal(date: $0) }
        
        let dateEditStr = dict["dateEdit"] as? String
        let dateEdit = dateEditStr.flatMap { DateConverterHelper.UTCToLocal(date: $0) }
        
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            deadline: deadline,
            isFinished: isFinished,
            dateStart: dateStart,
            dateEdit: dateEdit
        )
    }
}

extension TodoItem {
    var csv: String {
        var deadlineStr = " "
        if let deadline {
            deadlineStr = DateConverterHelper.localToUTC(date: deadline)
        }
        let dateStartStr = DateConverterHelper.localToUTC(date: dateStart)
        
        var dateEditStr = " "
        if let dateEdit {
            dateEditStr = DateConverterHelper.localToUTC(date: dateEdit)
        }
        
        let values: [String] = [
            String(id),
            "\"\(text)\"",
            importance != .common ? importance.getString() : " ",
            deadlineStr,
            String(isFinished),
            dateStartStr,
            dateEditStr
        ]
        
        return values.joined(separator: ",")
    }
    
    static func parse(csv: String) -> TodoItem? {
        var insideQuotes = false
        var currentStr = ""
        var values: [String] = []
        
        for char in csv {
            if char == "\"" {
                insideQuotes.toggle()
            } else if char == "," && !insideQuotes {
                values.append(currentStr)
                currentStr = ""
            } else {
                currentStr += String(char)
            }
        }
        
        let impotance = values[2] == " " ? .common : (Importance(rawValue: Importance.getInt(str:values[2])) ?? .common)
        let deadlineStr = values[3] == " " ? nil : DateConverterHelper.UTCToLocal(date: values[3])
        let dateEditStr = values[5] == " " ? nil : DateConverterHelper.UTCToLocal(date: values[5])
        guard let isFinished = Bool(values[4]),
              let dateStartStr = DateConverterHelper.UTCToLocal(date: values[5]) else {
            return nil
        }
        return TodoItem(
            id: values[0],
            text: values[1],
            importance:  impotance,
            deadline: deadlineStr,
            isFinished: isFinished,
            dateStart: dateStartStr,
            dateEdit: dateEditStr
        )
    }
}
