//
//  Validator.swift
//  FForms
//
//  Created by John Paul on 1/31/18.
//

import Foundation

public protocol Validator {
    
    var validCharacterSet: CharacterSet? { get }
    
    func format(text: String) -> String
    
    func validate(text: String) -> ValidationError?
    
}

extension Validator {
    
    public var validCharacterSet: CharacterSet? {
        return nil
    }

}

public struct ValidationError : RawRepresentable, Equatable, Hashable {
    
    public let rawValue: String
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public var hashValue: Int {
        return rawValue.hashValue
    }
    
}

public func ==(lhs: ValidationError, rhs: ValidationError) -> Bool {
    return lhs.rawValue == rhs.rawValue
}


// MARK: - Email

extension ValidationError {
    
    static let invalidEmail = ValidationError(rawValue: "invalid_email")!
}

public struct EmailValidator: Validator {
    
    public static let shared = EmailValidator()
    
    public func format(text: String) -> String {
        return text
    }
    
    public func validate(text: String) -> ValidationError? {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: text) ? nil : ValidationError.invalidEmail
    }
    
}

// MARK: - Credit Card

extension ValidationError {
    
    static let invalidCard = ValidationError(rawValue: "invalid_card")!
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
        return text.count == 16 ? nil : ValidationError.invalidCard
    }
    
}
