//
//  FForm.swift
//  Pods-FForm
//
//  Created by John Paul on 1/31/18.
//

import UIKit

public enum FormError: Error {
    case fieldAndViewCountDoNotMatch
    case valueDidNotValidate
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
    
    open func validator(key: F) -> Validator? {
        return delegate?.form(self, validatorFor: key)
    }
    
    open func validator(field: UITextField) -> Validator? {
        guard let index = fields.index(of: field) else {
            return nil
        }
        let key = keys[index]
        print(key)
        return validator(key: key)
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
        delegate?.form(self, field: textField,
                       didEndEditingWith: validator(field: textField)?.validate(text: textField.text ?? ""))
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let validator = validator(field: textField),
            var text = textField.text,
            var swiftRange = Range(range, in: text) else {
            return true
        }
    
        // Fixed range is the range in the string without the invalid chars
        // It allows to ignore unwanted chars when deleting for example
        var fixedRange = range
        
        guard let set = validator.validCharacterSet else {
            textField.text = validator.format(text: text.replacingCharacters(in: swiftRange, with: string)).text
            return false
        }

        func countIgnored(_ string: Substring) -> Int {
            return string.unicodeScalars.reduce(0)  {
                return set.contains($1) ? $0 : $0 + 1
            }
        }
        // Offsetting range location by the number of ignored chars before range
        fixedRange.location -= countIgnored(text[text.startIndex..<swiftRange.lowerBound])
        // Offsetting range lenght by the number of ignored chars inside range
        fixedRange.length -= countIgnored(text[swiftRange])
        
        let validText = Utils.filter(text, set)
        
        // This string will contain the replaced version but only with valid characters
        var validReplaced: String
        
        // Computing cursor position
        // Placing cursor at end of replaced area in valid string
        var cursorPosition: Int
        if let newSwiftRange = Range(fixedRange, in: validText) {
            let replacementString = Utils.filter(string, set)
            cursorPosition = validText.distance(from: validText.startIndex, to: newSwiftRange.lowerBound) + replacementString.count
            validReplaced = validText.replacingCharacters(in: newSwiftRange, with: replacementString)
        } else {
            // Just putting this as safeguard, should not happen
            assert(false)
            cursorPosition = range.lowerBound + string.count
            validReplaced = Utils.filter(text.replacingCharacters(in: swiftRange, with: string), set)
        }
        
        if let count = validator.validCount {
            validReplaced = String(validReplaced.prefix(count))
        }
        
        // Valid replaced now contains a string with only valid characters
        let v = validator.format(text: validReplaced)
        let finalText = v.text
        
        // Moving cursor so that there are `cursorPosition` valid characters before it
        var finalIndex = finalText.startIndex
        while cursorPosition > 0 && finalIndex < finalText.endIndex {
            
            // Only supporting char with a single unicode scalar
            if (set.contains(finalText[finalIndex].unicodeScalars.first!)) {
                cursorPosition -= 1
            }
            
            finalIndex = finalText.index(finalIndex, offsetBy: 1)
        }
        let finalPosition = finalText.distance(from: finalText.startIndex, to: finalIndex) + v.offset
        
        textField.text = finalText
        
        if let begin = textField.position(from: textField.beginningOfDocument, offset: finalPosition) {
            textField.selectedTextRange = textField.textRange(from: begin,
                                                              to: begin)
        }
        
        if let count = validator.validCount,
            count == validReplaced.count {
            
            if let error = validator.validate(text: finalText) {
                delegate?.form(self, field: textField, didEndEditingWith: error)
            } else {
                nextField?.becomeFirstResponder()
            }
        }
        
        return false
    }
    
    @objc func editingChanged(sender: UITextField) {
        
        delegate?.form(self, field: sender, editingDidChangeTo: sender.text)
    }
    
    //MARK: - Values
    
    open var result: Form.Result {
        
        var v = [F: String]()
        
        for (i, f) in fields.enumerated() {
            if f.isHidden {
                continue
            }
            
            let key = keys[i]
            guard let text = f.text,
                !text.isEmpty else {
                    return .missing(key, .empty)
            }
            
            if let v = validator(key: key),
                let error = v.validate(text: text) {
                return .missing(key, error)
            }
            
            v[keys[i]] = f.text
        }
        
        return .complete(v)
    }
    
    open func setValue(_ value: String, for key: F) throws {
        guard key.validator?.validate(text: value) == nil else {
            throw FormError.valueDidNotValidate
        }
        field(key: key).text = key.validator?.format(text: value).text ?? value
    }
    
    open func value(for key: F) -> String? {
        return field(key: key).text
    }

}
