//
//  CardValidator.swift
//  FForms
//
//  Created by John Paul on 3/7/18.
//

import Foundation

extension ValidationError {
    
    public static let invalidCard = ValidationError("invalid_card")
}

open class CardValidator: Validator {
    
    public static var maxNumberOfCharacters = 16
    
    open static let shared = CardValidator()
    
    public init() {
        
    }
    
    open var validCharacterSet: CharacterSet? {
        return CharacterSet(charactersIn:"0123456789")
    }
    
    open func format(text: String) -> (text: String, offset: Int) {
        var str = text.prefix(CardValidator.maxNumberOfCharacters)
        var i = 4
        while i < str.count {
            str.insert(" ", at: str.index(str.startIndex, offsetBy: i))
            i += 5
        }
        return (String(str), 0)
    }
    
    open func validate(text: String) -> ValidationError? {
        let count: Int
        if let c = validCharacterSet {
            count = Utils.filter(text, c).count
        } else {
            count = text.count
        }
        return count == validCount ? nil : ValidationError.invalidCard
    }
    
    open var validCount: Int? {
        return 16
    }
    
}
