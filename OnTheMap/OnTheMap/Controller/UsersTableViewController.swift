//
//  UsersTableViewController.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-27.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
	
	var appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

		NotificationCenter.default.addObserver(self, selector: #selector(refresh) , name: Notification.Name(rawValue: "refresh"), object: nil)
		
		
    }
	
	func refresh() {
		tableView.reloadData()
	}


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return appDelegate.locationData?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
		
		let entry = appDelegate.locationData[indexPath.row]
		
		let firstName = entry["firstName"] as? String ?? ""
		let lastName = entry["lastName"] as? String ?? ""
		let mediaUrl = entry["mediaURL"] as? String ?? ""
		
		cell.textLabel?.text = firstName + " " + lastName
		cell.detailTextLabel?.text = mediaUrl
		
        return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let cell = tableView.cellForRow(at: indexPath)
		
		if let url = URL(string: (cell?.detailTextLabel?.text)!) {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		} else {
			let alert = UIAlertController(title: "Invalid link", message: "Web page could not be opened", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			present(alert, animated: true, completion: nil)
		}
		
	}

}
