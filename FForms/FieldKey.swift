//
//  FieldProtocol.swift
//  FForms
//
//  Created by John Paul on 1/31/18.
//

import Foundation
import UIKit

public protocol FieldKey: Hashable {
    
    var rawValue: Int { get }
    
    var contentType: FieldContentType { get }
    
    var validator: Validator? { get }
    
    var keyboardType: UIKeyboardType { get }
    
}


public extension FieldKey {
    
    public var keyboardType: UIKeyboardType {
        switch contentType {
        case .postalCode,
             .creditCardNumber,
             .creditCardExpiry,
             .creditCardCVV:
            return .numberPad
        case .emailAddress:
            return .emailAddress
        case .URL:
            return .URL
        default:
            return .default
        }
    }
    
    public var validator: Validator? {
        return nil
    }
    
}
