//
//  ViewController.swift
//  FForm
//
//  Created by John Paul on 1/31/18.
//  Copyright © 2018 John Paul. All rights reserved.
//

import UIKit
import FForms
import CasperText

class ViewController: UIViewController {

    public enum Field: Int, FieldKey {

        case number
        case expiry
        case cvv
        case name
        case address
        case city
        case zip
        case country
        case phoneNumber

        public static var all: [Field] = [.number, .expiry, .cvv, .name, .address, .city, .zip, .country, .phoneNumber]

        public var contentType: FieldContentType {
            switch self {
            case .number:
                return .creditCardNumber
            case .expiry:
                return .creditCardExpiry
            case .cvv:
                return .creditCardCVV
            case .name:
                return .name
            case .address:
                return .streetAddressLine1
            case .city:
                return .addressCity
            case .zip:
                return .postalCode
            case .country:
                return .countryName
            case .phoneNumber:
                return .telephoneNumber
            }
        }
    }

    @IBOutlet var fields: [CasperTextField] = []

    var form: Form<Field>!

    override func viewDidLoad() {
        super.viewDidLoad()

        form = try! Form(keys: Field.all, fields: fields)
        form.field(key: .number).text = "4"
        form.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: FormDelegate {

    func form<F>(_ form: Form<F>, field: UITextField, didEndEditingWith error: ValidationError?) {
        if let e = error {
            (field as? CasperTextField)?.error = NSLocalizedString(e.rawValue, comment: "")
        } else {
            (field as? CasperTextField)?.error = nil
        }
    }

    func form<F>(_ form: Form<F>, field: UITextField, editingDidChangeTo text: String?) {

    }
}
