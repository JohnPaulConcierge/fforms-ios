//
//  FFormDelegate.swift
//  FForms
//
//  Created by John Paul on 1/31/18.
//

import Foundation

public protocol FormDelegate: class {
    
    func form<F: FieldKey>(_ form: Form<F>, field: UITextField, didEndEditingWith error: String?)
    
    func form<F: FieldKey>(_ form: Form<F>, field: UITextField, editingDidChangeTo text: String?)
    
}
