//
//  ExpiryValidator.swift
//  FForms
//
//  Created by John Paul on 3/7/18.
//

import Foundation

extension ValidationError {
    
    public static let invalidExpiryDate = ValidationError(rawValue: "invalid_expiry_date")!
    public static let pastExpiryDate = ValidationError(rawValue: "past_expiry_date")!
}

open class ExpiryDateValidator: Validator {
    
    public static var maxNumberOfCharacters = 4
    
    public static let shared = ExpiryDateValidator()
    
    open var validCharacterSet: CharacterSet? {
        return CharacterSet(charactersIn:"0123456789")
    }
    
    open func format(text: String) -> (text: String, offset: Int) {
        let i = 2
        var str = text
        if i < str.count {
            str.insert("/", at: str.index(str.startIndex, offsetBy: i))
        }
        return (str, 0)
    }
    
    open func validate(text: String) -> ValidationError? {
        let values = text.split(separator: "/")
        guard values.count == 2,
            let month = Int(values[0]),
            let year = Int(values[1]) else {
                return ValidationError.invalidExpiryDate
        }
        
        var comps = DateComponents()
        comps.day = 1
        comps.month = month
        comps.year = 2000 + year
        
        guard month > 0 && month <= 12 else {
            return ValidationError.invalidExpiryDate
        }
        
        let calendar = Calendar(identifier: .gregorian)
        
        guard let date = calendar.date(from: comps),
        let newDate = calendar.date(byAdding: .month, value: 1, to: date) else {
            return ValidationError.invalidExpiryDate
        }
 
        return newDate.timeIntervalSinceNow < 0 ? ValidationError.pastExpiryDate : nil
    }
    
    open var validCount: Int? {
        return 4
    }
    
}
