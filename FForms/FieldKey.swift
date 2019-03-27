//
//  FieldProtocol.swift
//  FForms
//
//  Created by John Paul on 1/31/18.
//

import Foundation
import UIKit

public protocol FieldKey: Hashable {

    var contentType: FieldContentType { get }

    var validator: Validator? { get }

    var keyboardType: UIKeyboardType { get }

    var isRequired: Bool { get }

    var autocorrectionType: UITextAutocorrectionType { get }

}

public extension FieldKey {

    var isRequired: Bool {
        return true
    }

    var keyboardType: UIKeyboardType {
        return contentType.keyboardType
    }

    var validator: Validator? {
        return contentType.validator
    }

    var autocorrectionType: UITextAutocorrectionType {
        return contentType.autocorrectionType
    }

}
