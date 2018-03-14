//
//  PhoneNumberValidator.swift
//  FForms
//
//  Created by John Paul on 3/13/18.
//

import Foundation
import PhoneNumberKit

extension ValidationError {
    
    public static let invalidPhone = ValidationError("invalid_phone")
}

open class PhoneNumberValidator: Validator {
    
    public static let shared = PhoneNumberValidator()
    
    public let phoneNumberKit: PhoneNumberKit
    
    public init(phoneNumberKit: PhoneNumberKit = PhoneNumberKit()) {
        self.phoneNumberKit = phoneNumberKit
    }
    
    open func format(text: String) -> (text: String, offset: Int) {
        return (PartialFormatter().formatPartial(text), 0)
    }
    
    open func validate(text: String) -> ValidationError? {
        let n = try? self.phoneNumberKit.parse(text)
        return n == nil ? .invalidPhone : nil
    }
    
    open var validCharacterSet: CharacterSet? {
        return CharacterSet(charactersIn: "+*#0123456789")
    }
    
}
