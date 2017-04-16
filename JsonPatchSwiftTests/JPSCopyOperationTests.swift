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

// http://tools.ietf.org/html/rfc6902#section-4.5
// 4.  Operations
// 4.5. copy
class JPSCopyOperationTests: XCTestCase {
    
    func testIfCopyReplaceValueInObjectReturnsExpectedValue() {
        let json = JSON(data: " { \"foo\" : { \"1\" : 2 }, \"bar\" : { }} ".data(using: String.Encoding.utf8)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"copy\", \"path\": \"/bar\", \"from\": \"/foo\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: " { \"foo\" : { \"1\" : 2 }, \"bar\" : { \"1\" : 2 }} ".data(using: String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)

    }
    
    func testIfCopyArrayReturnsExpectedValue() {
        let json = JSON(data: " { \"foo\" : [1, 2, 3, 4], \"bar\" : []} ".data(using: String.Encoding.utf8)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"copy\", \"path\": \"/bar\", \"from\": \"/foo\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: " { \"foo\" : [1, 2, 3, 4], \"bar\" : [1, 2, 3, 4]}".data(using: String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfCopyArrayOfObjectsReturnsExpectedValue() {
        let json = JSON(data: " { \"foo\" : [{\"foo\": \"bar\"}], \"bar\" : {} } ".data(using: String.Encoding.utf8)!)
        let jsonPatch = try! JPSJsonPatch("{ \"op\": \"copy\", \"path\": \"/bar\", \"from\": \"/foo/0\" }")
        let resultingJson = try! JPSJsonPatcher.applyPatch(jsonPatch, toJson: json)
        let expectedJson = JSON(data: " { \"foo\" : [{\"foo\": \"bar\"}], \"bar\" : {\"foo\": \"bar\"}}".data(using: String.Encoding.utf8)!)
        XCTAssertEqual(resultingJson, expectedJson)
    }
    
    func testIfMissingParameterReturnsError() {
        do {
            let result = try JPSJsonPatch("{ \"op\": \"copy\", \"path\": \"/bar\"}") // from parameter missing
            XCTFail(result.operations.last!.value.rawString()!)
        } catch JPSJsonPatch.JPSJsonPatchInitialisationError.invalidPatchFormat(let message) {
            // Expected behaviour.
            XCTAssertNotNil(message)
            XCTAssertEqual(message, JPSConstants.JsonPatch.InitialisationErrorMessages.FromElementNotFound)
        } catch {
            XCTFail("Unexpected error.")
        }
    }

}
