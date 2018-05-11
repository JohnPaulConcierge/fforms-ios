//
//  DateValidator.swift
//  FForms
//
//  Created by Admin on 11/05/2018.
//

import Foundation

extension ValidationError {
    
    public static let invalidBirthdate = ValidationError(rawValue: "invalid_birth_date")!
}

open class BirthdateValidator: Validator {
    
    public static var maxNumberOfCharacters = 10
    
    public static let shared = BirthdateValidator()
    
    open var validCharacterSet: CharacterSet? {
        return CharacterSet(charactersIn:"0123456789/")
    }
    
    open func format(text: String) -> (text: String, offset: Int) {
        return (text, 0)
    }
    
    open func validate(text: String) -> ValidationError? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        guard let date = dateFormatter.date(from: text), text.count == 10 else {
            return ValidationError.invalidBirthdate
        }
        
        return date.timeIntervalSinceNow < 0 ? ValidationError.invalidBirthdate : nil
    }
    
    open var validCount: Int? {
        return 10
    }
    
}
