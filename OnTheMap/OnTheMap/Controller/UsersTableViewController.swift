//
//  UsersTableViewController.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-27.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
	
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	var appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
		
		spinner.hidesWhenStopped = true
		spinner.stopAnimating()
		
		/// Listen for updates from the server.
		NotificationCenter.default.addObserver(self, selector: #selector(refresh) , name: Notification.Name(rawValue: "refresh"), object: nil)
    }
	
	func refresh() {
		tableView.reloadData()
	}


    /// MARK: Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return appDelegate.locationData?.count ?? 0
    }

	/// Cell layout
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
		
		let entry = appDelegate.locationData[indexPath.row]
		
		let firstName = entry.FirstName as? String ?? ""
		let lastName = entry.LastName as? String ?? ""
		let mediaUrl = entry.MediaURL as? String ?? ""
		
		cell.textLabel?.text = firstName + " " + lastName
		cell.detailTextLabel?.text = mediaUrl
		
        return cell
	}
	
	/// If a cell in the table view is tapped and the link is valid, it is opened in the system's default web browser.
	/// If the link is invalid, an error message is shown to the user.
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
