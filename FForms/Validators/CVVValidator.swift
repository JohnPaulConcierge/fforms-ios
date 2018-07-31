//
//  CVVValidator.swift
//  VisaConcierge
//
//  Created by John Paul on 3/8/18.
//  Copyright © 2018 John Paul. All rights reserved.
//

import Foundation

extension ValidationError {
    static let cvvInvalid = ValidationError("invalid_cvv")
}

struct CVVValidator: Validator {
    
    public static let shared = CVVValidator()
    
    var validCharacterSet: CharacterSet? {
        return CharacterSet(charactersIn: "0123456789")
    }
    
    var validCount: Int? {
        return 3
    }
    
    func format(text: String) -> (text: String, offset: Int) {
        return (text, 0)
    }
    
    func validate(text: String) -> ValidationError? {
        return text.count == 3 ? nil : ValidationError.cvvInvalid
    }
    
}
