//
//  FScrollableForm.swift
//  FForms
//
//  Created by John Paul on 2/2/18.
//

import UIKit

public protocol ScrollableFormDelegate: FormDelegate {
    
    func form<T>(_ form: ScrollableForm<T>, shouldScrollTo frame: CGRect, animated: Bool)
    
}

open class ScrollableForm<F: FieldKey>: Form<F> {
    
    private(set) weak var scrollView: UIScrollView?
    
    public init(keys: [F], fields: [UITextField], scrollView: UIScrollView) throws {
        self.scrollView = scrollView
        
        try super.init(keys: keys, fields: fields)
    }
    
    open func scrollToActiveField(animated: Bool) {
        
        guard activeIndex != nil,
            let scrollView = self.scrollView else {
            return
        }
        
        let textField = fields[activeIndex!]
        
        let offset = scrollView.contentOffset
        var frame = scrollView.convert(textField.frame, from: textField.superview!)
        frame.origin.y -= offset.y
        
        (delegate as? ScrollableFormDelegate)?.form(self, shouldScrollTo: frame, animated: animated)
    }
    
    open override func textFieldDidBeginEditing(_ textField: UITextField) {
        super.textFieldDidBeginEditing(textField)
        
        scrollToActiveField(animated: true)
    }

}
