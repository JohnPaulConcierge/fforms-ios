//
//  FieldProtocol.swift
//  FForms
//
//  Created by John Paul on 1/31/18.
//

import Foundation
import UIKit

public protocol FieldKey {
    
    var rawValue: Int { get }
    
    var contentType: UITextContentType { get }
    
    var validator: Validator? { get }
    
    var keyboardType: UIKeyboardType { get }
    
}


extension FieldKey {
    
    var keyboardType: UIKeyboardType {
        
        if #available(iOS 10, *) {
            switch contentType {
            case .postalCode, .creditCardNumber:
                return .numberPad
            case .emailAddress:
                return .emailAddress
            case .URL:
                return .URL
            default:
                break
            }
        }
        return .default
        
    }
    
}
