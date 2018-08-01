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

    public var isRequired: Bool {
        return true
    }

    public var keyboardType: UIKeyboardType {
        return contentType.keyboardType
    }

    public var validator: Validator? {
        return contentType.validator
    }

    public var autocorrectionType: UITextAutocorrectionType {
        return contentType.autocorrectionType
    }

}
