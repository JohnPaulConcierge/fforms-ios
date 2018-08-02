//
//  Validator.swift
//  FForms
//
//  Created by John Paul on 1/31/18.
//

import Foundation

//TODO: use generics to handle values other than strings
//TODO: split text part into another protocol `TextValidator`
/// Protocol used to control the authorized values and displayed formats in TextFields
public protocol Validator {

    var authorizedValues: [String]? { get }

    /// The set of valid characters.
    /// All other characters are ignored.
    ///
    /// The default implementation returns nil.
    var validCharacterSet: CharacterSet? { get }

    /// The character count at which the string is complete.
    /// (no counting characters are not in `validCharacterSet`)
    ///
    /// This value is used to automatically skip to the next field
    /// when the number is reached.
    ///
    /// The default implementation returns nil.
    var validCount: Int? { get }

    /// Formats the text.
    ///
    /// You should use this method to add non valid characters to make the text more appealing.
    /// (for example, spaces in a credit card number). The new cursor is calculated so that there
    /// are as many valid characters before the cursor before and after the text change, + or -
    /// any user induced changes.
    ///
    /// - Parameter text: a String that only contains valid characters.
    /// No need to call `filter` in your implementation.
    /// - Returns: text: the formatted text
    ///            offset: the cursor offset compared to the calculated position.
    func format(text: String) -> (text: String, offset: Int)

    /// Validates the content.
    ///
    /// - Parameter text: a String that only contains valid characters.
    /// No need to call `filter` in your implementation.
    /// - Returns: nil if the text is valid or the appropriate ValidationError
    //TODO: that function should throw and returned the parsed value (e.g Date, etc.)
    func validate(text: String) -> ValidationError?

    /// Filters the text so that it is appropriate for treatment.
    ///
    /// The default implementation removes characters that are not in
    /// `validCharacterSet`.
    ///
    /// @Note: Overriding this has never been tested.
    ///
    /// - Parameter text: input text
    /// - Returns: the filtered text
    func filter(text: String) -> String

}

extension Validator {

    public var authorizedValues: [String]? {
        return nil
    }


    public var validCharacterSet: CharacterSet? {
        return nil
    }

    public var validCount: Int? {
        return nil
    }

    public func filter(text: String) -> String {
        guard let set = validCharacterSet else {
            return text
        }
        return String(text.unicodeScalars.filter({ set.contains($0) }))
    }

}

/// Validation Error
public struct ValidationError: RawRepresentable, Equatable, Hashable {

    public let rawValue: String

    public init?(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public var hashValue: Int {
        return rawValue.hashValue
    }

    public static let empty = ValidationError("empty")

}
