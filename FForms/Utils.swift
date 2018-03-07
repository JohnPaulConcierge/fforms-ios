//
//  Utils.swift
//  FForms
//
//  Created by John Paul on 3/7/18.
//

import Foundation

class Utils {
    
    static func filter(_ string: String, _ set: CharacterSet) -> String {
        return String(string.unicodeScalars.filter({ set.contains($0) }))
    }

}
