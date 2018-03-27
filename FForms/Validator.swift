//
//  Validator.swift
//  FForms
//
//  Created by John Paul on 1/31/18.
//

import Foundation

public protocol Validator {
    
    var validCharacterSet: CharacterSet? { get }
    
    var validCount: Int? { get }
    
    func format(text: String) -> (text: String, offset: Int)
    
    func validate(text: String) -> ValidationError?
    
}

extension Validator {
    
    public var validCharacterSet: CharacterSet? {
        return nil
    }
    
    public var validCount: Int? {
        return nil
    }
    
    public func filter(text: String) -> String {
        guard let set = validCharacterSet else {
            return text
        }
        return String(text.unicodeScalars.filter({ set.contains($0) }))
    }

}

public struct ValidationError : RawRepresentable, Equatable, Hashable {
    
    public let rawValue: String
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
    
    public var hashValue: Int {
        return rawValue.hashValue
    }
    
    public static let empty = ValidationError("empty")
    
}
