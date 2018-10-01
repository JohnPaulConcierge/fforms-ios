//
//  DateValidator.swift
//  FForms
//
//  Created by John Paul on 7/29/18.
//

import Foundation

extension ValidationError {

    public static let invalidDateFormat = ValidationError(rawValue: "invalid_date")!
    public static let invalidDateFuture = ValidationError(rawValue: "invalid_date_future")!
}

open class DateValidator: Validator {

    public static var shared = DateValidator(
        dateFormat: localizedString(id: "date_validator_format", table: "FForms"),
        past: true)

    public let dateFormat: String
    public let past: Bool

    private let separators: [Int: Character]
    private let filteredDateFormat: String

    public init(dateFormat: String, past: Bool) {
        //TODO: use localized string resource
        self.dateFormat = dateFormat
        self.past = past

        var separators: [Int: Character] = [:]
        var filteredDateChars: [Character] = []
        for (index, element) in dateFormat.unicodeScalars.enumerated() {
            if CharacterSet.letters.contains(element) {
                filteredDateChars.append(Character(element))
            } else {
                separators[index] = Character(element)
            }
        }
        self.separators = separators
        filteredDateFormat = String(filteredDateChars)
    }

    open var validCharacterSet: CharacterSet? {
        return CharacterSet(charactersIn: "0123456789")
    }

    open func format(text: String) -> (text: String, offset: Int) {
        var str = text
        for entry in separators.sorted(by: <) {
            let i = entry.key
            if i < str.count {
                str.insert(entry.value, at: str.index(str.startIndex, offsetBy: i))
            }
        }
        return (str, 0)
    }

    open func validate(text: String) -> ValidationError? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = filteredDateFormat

        guard let date = dateFormatter.date(from: text), text.count == filteredDateFormat.count else {
            return ValidationError.invalidDateFormat
        }

        if past && date.timeIntervalSinceNow > 0 {
            return ValidationError.invalidDateFuture
        }
        return nil
    }

    open var validCount: Int? {
        return dateFormat.count - separators.count
    }

}
