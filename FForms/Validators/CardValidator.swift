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

/// Validator for credit card numbers
///
/// Only allows numbers and adds spaces
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
        return text.count == validCount ? nil : ValidationError.invalidCard
    }
    
    open var validCount: Int? {
        return 16
    }
    
}
