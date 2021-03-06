//
//  UserTableViewCell.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-27.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit

/**
Table view cells.
*/
class UserTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
		
		textLabel?.font = UIFont(name: "Futura", size: 16)
		textLabel?.textColor = OnTheMapTools.Colors.Title
		detailTextLabel?.font = UIFont(name: "Futura", size: 12)
		detailTextLabel?.textColor = OnTheMapTools.Colors.Icons
		imageView?.image = UIImage(named: "icon_pin")
		imageView?.tintColor = OnTheMapTools.Colors.Background
    }
}
