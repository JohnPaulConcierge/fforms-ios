//
//  CountryValidator.swift
//  FForms
//
//  Created by John Paul on 8/2/18.
//

import Foundation

extension ValidationError {

    public static let invalidCountry = ValidationError("invalid_country")

}

//TODO: this is really not very performant, destroy when Validator is generic
open class CountryValidator: Validator {

    public static var shared = CountryValidator()

    private let countries: [String]

    private let isos: [String]

    public init() {
        isos = Locale.isoRegionCodes
        countries = isos.compactMap { Locale.current.localizedString(forRegionCode: $0) }.sorted()
    }

    public func validate(text: String) -> ValidationError? {
        if text.count == 2 {
            for c in isos {
                if c.compare(text, options: [.caseInsensitive]) == .orderedSame {
                    return nil
                }
            }
        }

        guard iso(for: text) != nil else {
            return .invalidCountry
        }

        return nil
    }

    public func format(text: String) -> (text: String, offset: Int) {
        return (text, 0)
    }

    public func iso(for name: String) -> String? {
        for c in isos {
            guard let n = Locale.current.localizedString(forRegionCode: c) else {
                continue
            }
            if n.compare(name, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame {
                return c
            }
        }
        return nil
    }

    public var authorizedValues: [String]? {
        return countries
    }



}
