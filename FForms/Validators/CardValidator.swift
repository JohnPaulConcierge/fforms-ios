//
//  CardValidator.swift
//  FForms
//
//  Created by John Paul on 3/7/18.
//

import Foundation

extension ValidationError {
    
    static let invalidCard = ValidationError("invalid_card")
}

public struct CardValidator: Validator {
    
    public static var maxNumberOfCharacters = 16
    
    public static let shared = CardValidator()
    
    public var validCharacterSet: CharacterSet? {
        return CharacterSet(charactersIn:"0123456789")
    }
    
    public func format(text: String) -> String {
        var str = text.prefix(CardValidator.maxNumberOfCharacters)
        var i = 4
        while i < str.count {
            str.insert(" ", at: str.index(str.startIndex, offsetBy: i))
            i += 5
        }
        return String(str)
    }
    
    public func validate(text: String) -> ValidationError? {
        let count: Int
        if let c = validCharacterSet {
            count = Utils.filter(text, c).count
        } else {
            count = text.count
        }
        return count == validCount ? nil : ValidationError.invalidCard
    }
    
    public var validCount: Int? {
        return 16
    }
    
}
