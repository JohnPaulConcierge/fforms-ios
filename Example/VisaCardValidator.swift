//
//  VisaCardValidator.swift
//  FForm
//
//  Created by John Paul on 3/7/18.
//  Copyright © 2018 John Paul. All rights reserved.
//

import FForms

class VisaCardValidator: CardValidator {

    open static let sharedVisa = VisaCardValidator()

    override func format(text: String) -> (text: String, offset: Int) {
        var t = text
        var offset = 0
        if !t.hasPrefix("4") {
            t = "4" + text
            offset = 1
        }
        var v = super.format(text: t)
        v.offset += offset
        return v
    }

}
