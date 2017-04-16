//===----------------------------------------------------------------------===//
//
// This source file is part of the JSONPatchSwift open source project.
//
// Copyright (c) 2015 EXXETA AG
// Licensed under Apache License v2.0
//
//
//===----------------------------------------------------------------------===//

import SwiftyJSON

/// Possible errors thrown by the applyPatch function.
public enum JPSJsonPointerError: Error {
    /** ValueDoesNotContainDelimiter: JSON pointer values are delimited by a delimiter character, see https://tools.ietf.org/html/rfc6901#page-2. */
    case valueDoesNotContainDelimiter
    /** NonEmptyPointerDoesNotStartWithDelimiter: A JSON pointer must start with a delimiter character, see https://tools.ietf.org/html/rfc6901#page-2. */
    case nonEmptyPointerDoesNotStartWithDelimiter
    /** ContainsEmptyReferenceToken: Every reference token in a JSON pointer must not be empty, see https://tools.ietf.org/html/rfc6901#page-2. */
    case containsEmptyReferenceToken
}

/// RFC 6901 compliant JavaScript Object Notation (JSON) Pointer implementation.
public struct JPSJsonPointer {
    
    let rawValue: String
    let pointerValue: [JSONSubscriptType]
    
}

extension JPSJsonPointer {

    /**
     Initializes a new `JPSJsonPointer` based on a given String representation.
     
     - Parameter rawValue: A String representing a valid JSON pointer, see https://tools.ietf.org/html/rfc6901.
     
     - Throws: can throw any error from `JPSJsonPointer.JPSJsonPointerError` to notify failed initialization.
     
     - Returns: a `JPSJsonPointer` representation of the given JSON pointer string.
     */
    public init(rawValue: String) throws {
        
        guard rawValue.isEmpty || rawValue.contains(JPSConstants.JsonPointer.Delimiter) else {
            throw JPSJsonPointerError.valueDoesNotContainDelimiter
        }
        guard rawValue.isEmpty || rawValue.hasPrefix(JPSConstants.JsonPointer.Delimiter) else {
            throw JPSJsonPointerError.nonEmptyPointerDoesNotStartWithDelimiter
        }
        
        let pointerValueWithoutFirstElement = Array(rawValue.components(separatedBy: JPSConstants.JsonPointer.Delimiter).dropFirst())
        
        guard rawValue.isEmpty || !pointerValueWithoutFirstElement.contains(JPSConstants.JsonPointer.EmptyString) else {
            throw JPSJsonPointerError.containsEmptyReferenceToken
        }
        
        let pointerValueAfterDecodingDelimiter = pointerValueWithoutFirstElement.map { $0.replacingOccurrences(of: JPSConstants.JsonPointer.EscapedDelimiter, with: JPSConstants.JsonPointer.Delimiter) }
        let pointerValue: [JSONSubscriptType] = pointerValueAfterDecodingDelimiter.map { $0.replacingOccurrences(of: JPSConstants.JsonPointer.EscapedEscapeCharacter, with: JPSConstants.JsonPointer.EscapeCharater)}
        
        self.init(rawValue: rawValue, pointerValue: pointerValue)
    }
    
}

extension JPSJsonPointer {
    static func traverse(_ pointer: JPSJsonPointer) -> JPSJsonPointer {
        let pointerValueWithoutFirstElement = Array(pointer.rawValue.components(separatedBy: JPSConstants.JsonPointer.Delimiter).dropFirst().dropFirst()).joined(separator: JPSConstants.JsonPointer.Delimiter)
        // swiftlint:disable force_try
        return try! JPSJsonPointer(rawValue: JPSConstants.JsonPointer.Delimiter + pointerValueWithoutFirstElement)
        // swiftlint:enable force_try
    }
}
