//===----------------------------------------------------------------------===//
//
// This source file is part of the JSONPatchSwift open source project.
//
// Copyright (c) 2015 EXXETA AG
// Licensed under Apache License v2.0
//
//
//===----------------------------------------------------------------------===//

import XCTest
@testable import JsonPatchSwift
import SwiftyJSON

// swiftlint:disable opening_brace
class JPSJsonPatchTests: XCTestCase {
    
    func testMultipleOperations1() {
        let json = JSON(data: " { \"foo\" : \"bar\" } ".data(using: String.Encoding.utf8)!)
        let patch = "["
            + "{ \"op\": \"remove\", \"path\": \"/foo\" },"
            + "{ \"op\": \"add\", \"path\": \"/bar\", \"value\": \"foo\" },"
            + "]"
        let jsonPatch = try! JPSJsonPatch(patch)
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "{ \"bar\" : \"foo\" }".data(using: String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testMultipleOperations2() {
        let json = JSON(data: " { \"foo\" : \"bar\" } ".data(using: String.Encoding.utf8)!)
        let patch = "["
            + "{ \"op\": \"add\", \"path\": \"/bar\", \"value\": \"foo\" },"
            + "{ \"op\": \"remove\", \"path\": \"/foo\" },"
            + "]"
        let jsonPatch = try! JPSJsonPatch(patch)
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "{ \"bar\" : \"foo\" }".data(using: String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testMultipleOperations3() {
        let json = JSON(data: " { \"foo\" : \"bar\" } ".data(using: String.Encoding.utf8)!)
        let patch = "["
            + "{ \"op\": \"remove\", \"path\": \"/foo\" },"
            + "{ \"op\": \"add\", \"path\": \"/bar\", \"value\": \"foo\" },"
            + "{ \"op\": \"add\", \"path\": \"\", \"value\": { \"bla\" : \"blubb\" }  },"
            + "{ \"op\": \"replace\", \"path\": \"/bla\", \"value\": \"/bla\" },"
            + "{ \"op\": \"add\", \"path\": \"/bla\", \"value\": \"blub\" },"
            + "{ \"op\": \"copy\", \"path\": \"/blaa\", \"from\": \"/bla\" },"
            + "{ \"op\": \"move\", \"path\": \"/bla\", \"from\": \"/blaa\" },"
            + "]"
        let jsonPatch = try! JPSJsonPatch(patch)
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: "{ \"bla\" : \"blub\" }".data(using: String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }

    func testInitWithSwiftyJSON() {
        let jsonPatchString = try! JPSJsonPatch("[{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" }]")
        let jsonPatchSwifty = try! JPSJsonPatch(JSON(data: " [{ \"op\": \"test\", \"path\": \"/a/b/c\", \"value\": \"foo\" }] ".data(using: String.Encoding.utf8)!))
        XCTAssertTrue(jsonPatchString == jsonPatchSwifty)
    }
}
