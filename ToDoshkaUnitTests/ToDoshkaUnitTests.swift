//
//  ToDoshkaUnitTests.swift
//  ToDoshkaUnitTests
//
//  Created by Глеб Капустин on 22.06.2024.
//

import XCTest
@testable import ToDoshka

final class ToDoshkaUnitTests: XCTestCase {


    func testToDoItemEncodeDecode () throws {
        let item = TodoItem(
            id: "0",
            text: "test 1",
            importance: .common,
            deadline: nil,
            isFinished: false,
            dateStart: Date(timeIntervalSince1970: 8000000),
            dateEdit: Date(timeIntervalSince1970: 3000000)
        )
        
        let json = item.json
        let parsedItem = TodoItem.parse(json: json)
        
        XCTAssertEqual(item, parsedItem)
    }

    func testTodoItemCSVConversion() throws {
        let item = TodoItem(
            id: "0",
            text: "test 1",
            importance: .common,
            deadline: nil,
            isFinished: false,
            dateStart: Date(timeIntervalSince1970: 8000000),
            dateEdit: Date(timeIntervalSince1970: 3000000)
        )
        
        let csvString = item.csv
        let parsedItem = TodoItem.parse(csv: csvString)
        
        XCTAssertEqual(item, parsedItem)
    }
    
    func testTodoItemHashable() throws {
        let item1 = TodoItem(id: "0", text: "qwerty", importance: .common, deadline: nil, isFinished: false, dateStart: Date(), dateEdit: nil)
        let item2 = TodoItem(id: "0", text: "qwerty 2", importance: .important, deadline: nil, isFinished: false, dateStart: Date(), dateEdit: nil)
        
        XCTAssertEqual(item1, item2)
        XCTAssertEqual(item1.hashValue, item2.hashValue)
        
        var set: Set<TodoItem> = []
        set.insert(item1)
        set.insert(item2)
        
        XCTAssertEqual(set.count, 1)
    }
}
