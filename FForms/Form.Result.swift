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

        public var values: [F: String]? {
            switch self {
            case .complete(let v):
                return v
            default:
                return nil
            }
        }
    }

}
