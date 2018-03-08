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

open class EmailValidator: Validator {
    
    public static let shared = EmailValidator()
    
    open func format(text: String) -> (text: String, offset: Int) {
        return (text, 0)
    }
    
    open func validate(text: String) -> ValidationError? {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: text) ? nil : ValidationError.invalidEmail
    }
    
}
