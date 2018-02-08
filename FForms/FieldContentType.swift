//
//  Additions.swift
//  SelfService
//
//  Created by John Paul on 2/7/18.
//

import UIKit

public struct FieldContentType: RawRepresentable, Equatable, Hashable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
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
}

public func ==(lhs: FieldContentType, rhs: FieldContentType) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

extension FieldContentType {
    
    public static let name = FieldContentType(rawValue: "Name")
    public static let namePrefix = FieldContentType(rawValue: "Name Prefix")
    public static let givenName = FieldContentType(rawValue: "Given Name")
    public static let middleName = FieldContentType(rawValue: "Middle Name")
    public static let familyName = FieldContentType(rawValue: "Family Name")
    public static let nameSuffix = FieldContentType(rawValue: "Name Suffix")
    public static let nickname = FieldContentType(rawValue: "Nickname")
    public static let jobTitle = FieldContentType(rawValue: "Job Title")
    public static let organizationName = FieldContentType(rawValue: "Organization Name")
    public static let location = FieldContentType(rawValue: "Location")
    public static let fullStreetAddress = FieldContentType(rawValue: "Full Street Address")
    public static let streetAddressLine1 = FieldContentType(rawValue: "Street Address Line1")
    public static let streetAddressLine2 = FieldContentType(rawValue: "Street Address Line2")
    public static let addressCity = FieldContentType(rawValue: "Address City")
    public static let addressState = FieldContentType(rawValue: "Address State")
    public static let addressCityAndState = FieldContentType(rawValue: "Address City And State")
    public static let sublocality = FieldContentType(rawValue: "Sublocality")
    public static let countryName = FieldContentType(rawValue: "Country Name")
    public static let postalCode = FieldContentType(rawValue: "Postal Code")
    public static let telephoneNumber = FieldContentType(rawValue: "Telephone Number")
    public static let emailAddress = FieldContentType(rawValue: "Email Address")
    public static let URL = FieldContentType(rawValue: "Url")
    public static let creditCardNumber = FieldContentType(rawValue: "Credit Card Number")
    public static let creditCardExpiry = FieldContentType(rawValue: "Credit Card Expiration Date")
    public static let creditCardCVV = FieldContentType(rawValue: "Credit Card CVV")
    
}
