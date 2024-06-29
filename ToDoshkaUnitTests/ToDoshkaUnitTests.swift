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
    
}
