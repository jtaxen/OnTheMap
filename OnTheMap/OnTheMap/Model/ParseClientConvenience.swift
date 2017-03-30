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
			ParameterKeys.Order: StudentLocationKeys.MediaURL
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
		
		
			
			// TEST
			guard parameters != nil else {
				print("Parameters are missing")
				return
			}
			
			var newParameters: [String: String] = [:]
			
			for (key, value) in parameters {
				if let string = value as? String {
					newParameters[key] = string
				} else if let double = value as? Double {
					newParameters[key] = "\(double)"
				} else {
					print("\(value) krånglar fortfarande")
				}
			}
			
			if let string = parameters["objectId"] as? String {
				print(string)
			} else {
				print("Object id är det fel på")
			}
			
			// TEST ENDS HERE
			
			let objectID: String? = parameters["objectId"] as! String?
			
			
			let _ = serverTask(parameters: newParameters, method: .PUT, objectID: objectID) { (results, error) in
				
				guard error == nil else {
					print("ERROR ERROR ERROR")
					print(error!.domain)
					print(error!.userInfo[NSLocalizedDescriptionKey] ?? "No-one knows")
					completionHandler(false, error)
					return
				}
				self.refresh(completionHandler: completionHandler)
			}
		}
	}
}
