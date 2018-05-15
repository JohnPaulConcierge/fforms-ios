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

open class DateValidator: Validator {
    
    public var dateFormat = "dd/MM/yyyy"
    public var shouldBeInPast = true

    public static let shared = DateValidator()
    
    private var separators: [Int : Character] = [:]
    
    open var validCharacterSet: CharacterSet? {
        return CharacterSet(charactersIn:"0123456789")
    }
    
    open func format(text: String) -> (text: String, offset: Int) {
        findSeparators()
        var str = text
        for entry in separators {
            let i = entry.key
            if i < str.count {
                str.insert(entry.value, at: str.index(str.startIndex, offsetBy: i))
            }
        }
        return (str, 0)
    }
    
    open func validate(text: String) -> ValidationError? {
        var df = dateFormat
        for entry in separators {
            df = df.replacingOccurrences(of: "\(entry.value)", with: "")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = df
        
        guard let date = dateFormatter.date(from: text), text.count == df.count else {
            return ValidationError.invalidBirthdate
        }
        
        return date.timeIntervalSinceNow < 0 && !shouldBeInPast || date.timeIntervalSinceNow > 0 && shouldBeInPast ? ValidationError.invalidBirthdate : nil
    }
    
    open var validCount: Int? {
        return dateFormat.count - separators.count
    }
    
    private func findSeparators() {
        separators = [:]
        for (index, element) in dateFormat.unicodeScalars.enumerated() {
            if !CharacterSet.letters.contains(element) {
                separators[index] = Character(element)
            }
        }
    }
    
}
