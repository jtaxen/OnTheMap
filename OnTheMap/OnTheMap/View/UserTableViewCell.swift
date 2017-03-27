//
//  UserTableViewCell.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-27.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
		
		textLabel?.font = UIFont(name: "Futura", size: 16)
		detailTextLabel?.font = UIFont(name: "Futura", size: 12)
		imageView?.image = UIImage(named: "icon_pin")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
