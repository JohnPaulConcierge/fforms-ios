//
//  Form.Result.swift
//  Pods
//
//  Created by John Paul on 3/7/18.
//

import Foundation

extension Form {
    
    public enum Result {
        case complete([F: String])
        case missing(F, ValidationError)
    }
    
}
