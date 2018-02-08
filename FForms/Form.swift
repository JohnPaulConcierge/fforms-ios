//
//  FForm.swift
//  Pods-FForm
//
//  Created by John Paul on 1/31/18.
//

import UIKit

public enum FormError: Error {
    case fieldAndViewCountDoNotMatch
}

open class Form<F: FieldKey>: NSObject, UITextFieldDelegate {
    
    open let keys: [F]
    
    open let fields: [UITextField]
    
    open private(set) var activeIndex: Int?
    
    open weak var delegate: FormDelegate?
    
    public init(keys: [F], fields: [UITextField]) throws {
        self.keys = keys
        self.fields = fields
        
        guard fields.count == keys.count else {
            throw FormError.fieldAndViewCountDoNotMatch
        }
        
        super.init()
        
        let toolbar = buildToolbar()
        
        for (i, f) in fields.enumerated() {
            f.tag = i
            f.delegate = self
            f.returnKeyType = .next
            f.inputAccessoryView = toolbar
            
            FormAppearance.formatField?(f)
            
            f.addTarget(self, action: #selector(editingChanged(sender:)), for: .editingChanged)
            
            let key = keys[i]
            
            if #available(iOS 10, *) {
                f.textContentType = key.contentType.textContentType
            }
            
            f.keyboardType = key.keyboardType
        }
        fields.last?.returnKeyType = .done
        
    }
    
    //MARK: - Utils
    
    open func field(key: F) -> UITextField {
        return fields[key.rawValue]
    }
    
    //MARK: - Toolbar
    
    open func buildToolbar() -> UIToolbar? {
        return FormAppearance.makeToolbar?(self, #selector(toolbarPrevious(_:)), #selector(toolbarNext(_:)), #selector(toolbarDone(_:)))
    }
    
    @objc func toolbarNext(_ sender: Any?){
        nextField?.becomeFirstResponder()
    }
    
    open var nextField: UITextField? {
        guard var i = activeIndex,
            i < fields.count - 1 else {
                return nil
        }
        i += 1
        repeat {
            let f = fields[i]
            if !f.isHidden {
                return f
            }
            i += 1
        } while i < fields.count
        
        return nil
    }
    
    @objc func toolbarPrevious(_ sender: Any?) {
        previousField?.becomeFirstResponder()
    }
    
    open var previousField: UITextField? {
        guard var i = activeIndex,
            i > 0 else {
                return nil
        }
        i -= 1
        repeat {
            let f = fields[i]
            if !f.isHidden {
                return f
            }
            i -= 1
        } while i >= 0
        
        return nil
    }
    
    @objc func toolbarDone(_ sender: Any?) {
        guard let i = activeIndex else {
            return
        }
        fields[i].resignFirstResponder()
    }
    
    
    
    //MARK: - UITextFieldDelegate
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard var index = fields.index(of: textField) else {
            return true
        }
        index += 1
        
        if index == fields.count {
            textField.resignFirstResponder()
        } else {
            fields[index].becomeFirstResponder()
        }
        
        return true
    }
    
    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        activeIndex = nil
        return true
    }
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        activeIndex = fields.index(of: textField)
        
        let toolbar = textField.inputAccessoryView as! UIToolbar
        toolbar.items![1].isEnabled = previousField != nil
        toolbar.items![2].isEnabled = nextField != nil
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let index = fields.index(of: textField) else {
            return
        }
        let key = keys[index]
        guard let validator = key.validator else {
            return
        }
        
//        let floating = textField as! FloatingLabelTextField
//        guard let field = Field(rawValue: textField.tag),
//            let text = textField.text else {
//                return
//        }
//        switch field {
//        case .card:
//            floating.error = text.count == 16 ? nil : __("invalid_card")
//        case .email:
//            floating.error = text.isValidEmail ? nil : __("invalid_email")
//        default:
//            break
//        }
    }
    
    @objc func editingChanged(sender: UITextField) {
        delegate?.form(self, field: sender, editingDidChangeTo: sender.text)
    }
    
    //MARK: - Values
    
    open var values: [F: String] {
        
        var v = [F: String]()
        
        for (i, f) in fields.enumerated() {
            if f.isHidden {
                continue
            }
            v[keys[i]] = f.text
        }
        return v
    }
    

}
