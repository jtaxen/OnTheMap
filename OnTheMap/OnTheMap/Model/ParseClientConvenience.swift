//
//  ParseClientConvenience.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-27.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation

extension ParseClient {
	
	func refresh (completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void ) {
		
		let parameters: [String: String] = [
			ParameterKeys.Limit: "100",
			ParameterKeys.Skip: "0",
			ParameterKeys.Order: StudentLocationKeys.UpdatedAt
		]
		
		let _ = serverTask(parameters: parameters, method: .GET) { (results, error) in
			
			guard error == nil else {
				completionHandler(false, error)
				return
			}
			if let locationData = results {
				self.appDelegate.locationData = locationData
				completionHandler(true, nil)
			} else {
				let userInfo = [NSLocalizedDescriptionKey: "Error: could not get location data: \(results)."]
				completionHandler(false, NSError(domain: "couldNotGetData", code: 7, userInfo: userInfo))
			}
		}
	}
	
	func getUserData (completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void ) {
		
		let parameters: [String: String] = [:]
		
		let _ = serverTask(parameters: parameters, method: .GET, uniqueKey: appDelegate.uniqueKey) { (results, error) in
			
			guard error == nil else {
				completionHandler(false, error)
				return
			}
			
			if let userData = results {
				self.appDelegate.userData = userData
				completionHandler(true, error)
				return
			} else {
				let userInfo = [NSLocalizedDescriptionKey: "Error: could not get user data: \(results)."]
				completionHandler(false, NSError(domain: "couldNotGetData", code: 7, userInfo: userInfo))
			}
		}
	}
	
	func updateLocation (location: String, website: String, completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
		
		// TODO: Something is wrong here
		if var parameters = appDelegate.userData[0] as? [String:String] {
			parameters["mapString"] = location
			parameters["mediaURL"] = website
			
			let _ = serverTask(parameters: parameters, method: .PUT, objectID: parameters["objectId"]) { (results, error) in
				
				guard error == nil else {
					completionHandler(false, error)
					return
				}
				
				self.refresh() { (success, error) in
					print("The success was \(success)")
				}
			}
		} else {
			print("OND BRÅD DÖD ☠️☠️☠️")
		}
	}
}
