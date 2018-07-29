//
//  ResourceUtils.swift
//  FForms
//
//  Created by John Paul on 7/29/18.
//

import Foundation

private var fformsBundle: Bundle {
    let path = Bundle(for: CardValidator.self).path(forResource: "FForms", ofType: "bundle")!
    return Bundle(path: path)!
}

func localizedString(id: String, table: String? = nil) -> String {

    let fullId = "fforms_\(id)"
    let mainString = Bundle.main.localizedString(forKey: fullId, value: nil, table: nil)
    if mainString == fullId {
        return fformsBundle.localizedString(forKey: fullId, value: nil, table: nil)
    } else {
        return mainString
    }
}
