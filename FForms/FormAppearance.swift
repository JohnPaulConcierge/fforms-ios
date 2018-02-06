//
//  FFormAppearance.swift
//  FForms
//
//  Created by John Paul on 2/2/18.
//

import Foundation


public struct FormAppearance {
    
    public struct Toolbar {
        
        enum ItemType {
            case text(String)
            case image(name: String)
            case system(UIBarButtonSystemItem)
        }
        
        var nibName: String?
        
        var previousItem: ItemType?
        
        var nextItem: ItemType?
        
        var doneItem: ItemType?
        
        var backgroundColor: UIColor?
        
        var tintColor: UIColor?
        
        var barTintColor: UIColor?
        
        var padding: CGFloat = 10
        
        var isTranslucent: Bool = true
    }
    
    public struct Field {
        
        var font: UIFont?
        
    }
    
    public static var toolbar: Toolbar?
    
    public static var field: Field?
    
}
