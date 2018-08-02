//
//  FForm.swift
//  Pods-FForm
//
//  Created by John Paul on 1/31/18.
//

import UIKit

public enum FormError: Error {
    case fieldAndViewCountDoNotMatch
    case valueDidNotValidate(ValidationError)
}

open class Form<F: FieldKey>:
    NSObject,
    UITextFieldDelegate,
    UIPickerViewDelegate,
    UIPickerViewDataSource
{

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
            f.autocorrectionType = key.autocorrectionType

            if validator(key: key)?.authorizedValues != nil {

                let pickerView = UIPickerView(frame: CGRect.zero)
                pickerView.dataSource = self
                pickerView.delegate = self
                f.inputView = pickerView
            }
        }
        fields.last?.returnKeyType = .done

    }

    // MARK: - Utils

    open func field(key: F) -> UITextField {
        return fields[self.keys.index(of: key)!]
    }

    open func key(field: UITextField) -> F {
        return keys[self.fields.index(of: field)!]
    }

    open func validator(key: F) -> Validator? {
        if let d = delegate {
            return d.form(self, validatorFor: key)
        } else {
            return key.validator
        }
    }

    open func isRequired(key: F) -> Bool {
        return delegate?.form(self, requires: key) ?? key.isRequired
    }

    open func validator(field: UITextField) -> Validator? {
        return validator(key: key(field: field))
    }

    // MARK: - Toolbar

    open func buildToolbar() -> UIToolbar? {
        return FormAppearance.makeToolbar?(self, #selector(toolbarPrevious(_:)), #selector(toolbarNext(_:)), #selector(toolbarDone(_:)))
    }

    @objc func toolbarNext(_ sender: Any?) {
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

    // MARK: - UITextFieldDelegate

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
        let v = validator(field: textField)
        delegate?.form(self, field: textField,
                       didEndEditingWith: v?.validate(text: v?.filter(text: textField.text ?? "") ?? ""))
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let validator = validator(field: textField),
            var text = textField.text,
            var swiftRange = Range(range, in: text),
            !(range.location == 0
                && range.length == 0
                && text.isEmpty
                && string == " ") else { // To fix weird bug when using ios saved forms in iOS 11
            return true
        }

        // Fixed range is the range in the string without the invalid chars
        // It allows to ignore unwanted chars when deleting for example
        var fixedRange = range

        guard let set = validator.validCharacterSet else {
            textField.text = validator.format(text: text.replacingCharacters(in: swiftRange, with: string)).text
            self.delegate?.form(self, field: textField, editingDidChangeTo: textField.text)
            return false
        }

        func countIgnored(_ string: Substring) -> Int {
            return string.unicodeScalars.reduce(0) {
                return set.contains($1) ? $0 : $0 + 1
            }
        }
        // Offsetting range location by the number of ignored chars before range
        fixedRange.location -= countIgnored(text[text.startIndex..<swiftRange.lowerBound])
        // Offsetting range lenght by the number of ignored chars inside range
        fixedRange.length -= countIgnored(text[swiftRange])

        let validText = validator.filter(text: text)

        // This string will contain the replaced version but only with valid characters
        var validReplaced: String

        // Computing cursor position
        // Placing cursor at end of replaced area in valid string
        var cursorPosition: Int
        if let newSwiftRange = Range(fixedRange, in: validText) {
            let replacementString = validator.filter(text: string)
            cursorPosition = validText.distance(from: validText.startIndex, to: newSwiftRange.lowerBound) + replacementString.count
            validReplaced = validText.replacingCharacters(in: newSwiftRange, with: replacementString)
        } else {
            // Just putting this as safeguard, should not happen
            assert(false)
            cursorPosition = range.lowerBound + string.count
            validReplaced = validator.filter(text: text.replacingCharacters(in: swiftRange, with: string))
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

            if let error = validator.validate(text: validReplaced) {
                delegate?.form(self, field: textField, didEndEditingWith: error)
            } else {
                nextField?.becomeFirstResponder()
            }
        }

        self.delegate?.form(self, field: textField, editingDidChangeTo: textField.text)
        return false
    }

    @objc func editingChanged(sender: UITextField) {

        delegate?.form(self, field: sender, editingDidChangeTo: sender.text)
    }

    // MARK: - Values

    //TODO: this probably should throw instead
    open func result(formatted: Bool = true) -> Form.Result {
        var v = [F: String]()

        for (i, f) in fields.enumerated() {
            if f.isHidden {
                continue
            }

            let key = keys[i]
            guard let text = f.text,
                !text.isEmpty else {
                    // Skipping non required keyss
                    if isRequired(key: key) {
                        return .missing(key, .empty)
                    } else {
                        continue
                    }
            }

            if let validator = validator(key: key) {
                if let error = validator.validate(text: validator.filter(text: text)) {
                    return .missing(key, error)
                }

                v[key] = formatted ? text : validator.filter(text: text)
            } else {
                v[key] = text
            }
        }

        return .complete(v)
    }

    open func setValue(_ value: String, for key: F, validate: Bool = true) throws {

        guard let v = self.validator(key: key) else {
            field(key: key).text = value
            return
        }

        let valid = v.filter(text: value)

        if validate, let v = v.validate(text: valid) {
            throw FormError.valueDidNotValidate(v)
        }
        field(key: key).text = v.format(text: valid).text
    }

    open func value(for key: F) -> String? {
        return field(key: key).text
    }

    open func setValues(_ values: [F: String], validate: Bool = true) throws {
        try values.forEach {
            try setValue($0.value, for: $0.key, validate: validate)
        }
    }

    //MARK: - UIPickerViewDataSource

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        guard let i = activeIndex,
            let values = validator(key: keys[i])?.authorizedValues else {
                return 0
        }
        return values.count

    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let i = activeIndex,
            let values = validator(key: keys[i])?.authorizedValues else {
                return nil
        }
        return values[row]
    }

    //MARK: - UIPickerViewDelegate

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let i = activeIndex,
            let values = validator(key: keys[i])?.authorizedValues else {
                return
        }
        fields[i].text = values[row]
    }


}
