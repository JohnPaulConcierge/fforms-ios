//
//  Additions.swift
//  SelfService
//
//  Created by John Paul on 2/7/18.
//

import UIKit

public struct FieldContentType: RawRepresentable, Equatable, Hashable {

    public let rawValue: String

    public init?(rawValue: String) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }

    public var textContentType: UITextContentType? {
        if #available(iOS 10, *) {

            switch self {
            case .name:
                return UITextContentType.name
            case .namePrefix:
                return UITextContentType.namePrefix
            case .givenName:
                return UITextContentType.givenName
            case .middleName:
                return UITextContentType.middleName
            case .familyName:
                return UITextContentType.familyName
            case .nameSuffix:
                return UITextContentType.nameSuffix
            case .nickname:
                return UITextContentType.nickname
            case .jobTitle:
                return UITextContentType.jobTitle
            case .organizationName:
                return UITextContentType.organizationName
            case .location:
                return UITextContentType.location
            case .fullStreetAddress:
                return UITextContentType.fullStreetAddress
            case .streetAddressLine1:
                return UITextContentType.streetAddressLine1
            case .streetAddressLine2:
                return UITextContentType.streetAddressLine2
            case .addressCity:
                return UITextContentType.addressCity
            case .addressState:
                return UITextContentType.addressState
            case .addressCityAndState:
                return UITextContentType.addressCityAndState
            case .sublocality:
                return UITextContentType.sublocality
            case .countryName:
                return UITextContentType.countryName
            case .postalCode:
                return UITextContentType.postalCode
            case .telephoneNumber:
                return UITextContentType.telephoneNumber
            case .emailAddress:
                return UITextContentType.emailAddress
            case .URL:
                return UITextContentType.URL
            case .creditCardNumber:
                return UITextContentType.creditCardNumber
            default:
                return nil
            }

        } else {
            return nil
        }
    }

    public var hashValue: Int {
        return rawValue.hashValue
    }

    public var validator: Validator? {
        switch self {
        case .emailAddress:
            return EmailValidator.shared
        case .creditCardNumber:
            return CardValidator.shared
        case .creditCardExpiry:
            return ExpiryDateValidator.shared
        case .telephoneNumber:
            return PhoneNumberValidator.shared
        case .birthDate:
            return DateValidator.shared
        case .creditCardCVV:
            return CVVValidator.shared
        case .countryName:
            return CountryValidator.shared
        default:
            return nil
        }
    }

    public var keyboardType: UIKeyboardType {
        switch self {
        case .postalCode,
             .creditCardNumber,
             .creditCardCVV,
             .creditCardExpiry:
            return .numberPad
        case .emailAddress:
            return .emailAddress
        case .URL:
            return .URL
        case .telephoneNumber:
            return .phonePad
        default:
            return .default
        }
    }

    public var autocorrectionType: UITextAutocorrectionType {
        switch self {
        case .birthDate, .password:
            return .no
        default:
            return .default
        }
    }
}

public func ==(lhs: FieldContentType, rhs: FieldContentType) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

extension FieldContentType {

    public static let name = FieldContentType("Name")
    public static let namePrefix = FieldContentType("Name Prefix")
    public static let givenName = FieldContentType("Given Name")
    public static let middleName = FieldContentType("Middle Name")
    public static let familyName = FieldContentType("Family Name")
    public static let nameSuffix = FieldContentType("Name Suffix")
    public static let nickname = FieldContentType("Nickname")
    public static let jobTitle = FieldContentType("Job Title")
    public static let organizationName = FieldContentType("Organization Name")
    public static let location = FieldContentType("Location")
    public static let fullStreetAddress = FieldContentType("Full Street Address")
    public static let streetAddressLine1 = FieldContentType("Street Address Line1")
    public static let streetAddressLine2 = FieldContentType("Street Address Line2")
    public static let addressCity = FieldContentType("Address City")
    public static let addressState = FieldContentType("Address State")
    public static let addressCityAndState = FieldContentType("Address City And State")
    public static let sublocality = FieldContentType("Sublocality")
    public static let countryName = FieldContentType("Country Name")
    public static let postalCode = FieldContentType("Postal Code")
    public static let telephoneNumber = FieldContentType("Telephone Number")
    public static let emailAddress = FieldContentType("Email Address")
    public static let URL = FieldContentType("Url")
    public static let creditCardNumber = FieldContentType("Credit Card Number")
    public static let creditCardExpiry = FieldContentType("Credit Card Expiration Date")
    public static let creditCardCVV = FieldContentType("Credit Card CVV")
    public static let birthDate = FieldContentType("Birth Date")
    public static let password = FieldContentType("Password")

}
