//
//  FFormAppearance.swift
//  FForms
//
//  Created by John Paul on 2/2/18.
//

import Foundation

public struct FormAppearance {

    public typealias ToolbarFactory = (Any, Selector, Selector, Selector) -> UIToolbar

    public static var makeToolbar: ToolbarFactory? = { target, previous, next, done in

        let toolbar = UIToolbar()

        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .rewind, target: target, action: previous),
            UIBarButtonItem(barButtonSystemItem: .fastForward, target: target, action: next),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: target, action: done),
            UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        ]
        toolbar.items![0].width = 10
        toolbar.items!.last!.width = 10

        toolbar.sizeToFit()

        return toolbar
    }

    public typealias FieldFormatter = (UITextField) -> Void

    public static var formatField: FieldFormatter?

}
