//
//  ExpiryValidator.swift
//  FForms
//
//  Created by John Paul on 3/7/18.
//

import Foundation

extension ValidationError {
    
    static let invalidExpiryDate = ValidationError(rawValue: "invalid_expiry_date")!
    static let pastExpiryDate = ValidationError(rawValue: "past_expiry_date")!
}

public struct ExpiryDateValidator: Validator {
    
    public static var maxNumberOfCharacters = 4
    
    public static let shared = ExpiryDateValidator()
    
    public var validCharacterSet: CharacterSet? {
        return CharacterSet(charactersIn:"0123456789")
    }
    
    public func format(text: String) -> String {
        let i = 2
        var str = text
        if i < str.count {
            str.insert("/", at: str.index(str.startIndex, offsetBy: i))
        }
        return str
    }
    
    public func validate(text: String) -> ValidationError? {
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
        
        let calendar = Calendar(identifier: .gregorian)
        
        guard let date = calendar.date(from: comps),
        let newDate = calendar.date(byAdding: .month, value: 1, to: date) else {
            return ValidationError.invalidExpiryDate
        }
 
        return newDate.timeIntervalSinceNow < 0 ? ValidationError.pastExpiryDate : nil
    }
    
    public var validCount: Int? {
        return 4
    }
    
}
