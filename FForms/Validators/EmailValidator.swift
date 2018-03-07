//
//  EmailValidator.swift
//  FForms
//
//  Created by John Paul on 3/7/18.
//

import Foundation

extension ValidationError {
    
    public static let invalidEmail = ValidationError("invalid_email")
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
