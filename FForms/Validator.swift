//
//  Validator.swift
//  FForms
//
//  Created by John Paul on 1/31/18.
//

import Foundation

public protocol Validator {
    
    func format(text: String) -> String
    
    func validate(text: String) -> ValidationError?
    
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
    
    public func format(text: String) -> String {
        let allowed = CharacterSet.decimalDigits
        var t = text.unicodeScalars.filter(allowed.contains)
        return String(String.UnicodeScalarView(t))
    }
    
    public func validate(text: String) -> ValidationError? {
        return text.count == 16 ? nil : ValidationError.invalidCard
    }
    
}
