//
//  EnterThingsView.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-28.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit

class EnterThingsView: UIView {

	weak var topTextField: UITextField!
	weak var bottomTextField: UITextField!
	weak var textFieldView: UIView!
	
	weak var spinner: UIActivityIndicatorView!
	
	weak var button: UIButton!
	
	let textFieldAttributes = [
		NSFontAttributeName: UIFont(name: "Futura", size: 17)!
	]
	
	private func configureTextFieldView(topPlaceholder: String, bottomPlaceholder: String) {
	
		textFieldView.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: textFieldView, attribute: .leading, multiplier: 1, constant: 20))
		
	}

}
