//
//  UdacityClientConvenience.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-23.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation

extension UdacityClient {
	
	/**
	Creates a session for the user and returns the session ID needed for requests to the Parse server.
	- Parameter username: The user's Udacity username.
	- Parameter password: The user's Udacity password.
	- Parameter success: Returns true if the request was successfull, false otherwise.
	- Parameter result: Results from the server.
	- Parameter error: Error information if the request is unsuccessful.
	*/
	func getSessionID(username: String, password: String , completionHandler: @escaping (_ success: Bool, _ result: String?, _ error: NSError?) -> Void ) {
		
		let parameters = [ParameterKeys.Username: username,
		                  ParameterKeys.Password: password]
		
		let _ = taskForPOST(parameters: parameters as [String : AnyObject]) { (results, error) in
			
			guard error == nil else {
				completionHandler(false, nil, error)
				return
			}
			if let session = results?["session"] as? [String: AnyObject],
				let account = results?["account"] as? [String: AnyObject] {
				if let id = session["id"] as? String,
					let key = account["key"] as? String {
					self.appDelegate.sessionID = id
					self.appDelegate.uniqueKey = key
					completionHandler(true, id, nil)
				} else {
					let userInfo = [NSLocalizedDescriptionKey: "Error: key id not found in results"]
					completionHandler(false, nil, NSError(domain: "keyMissingInResult", code: 6, userInfo: userInfo))
				}
			} else {
				let userInfo = [NSLocalizedDescriptionKey: "Error: key session not found in results"]
				completionHandler(false, nil, NSError(domain: "keyMissingInResult", code: 5, userInfo: userInfo))
			}
		}
	}
	
	/**
	Ends the current session.
	- Parameter success: Returns true if the request was successfull, false otherwise.
	- Parameter result: Results from the server.
	- Parameter error: Error information if the request is unsuccessful.
	*/
	func endSession(completionHandler: @escaping (_ success: Bool, _ result: String?, _ error: NSError?) -> Void) {
		
		let _ = taskForDELETE() { (results, error) in
			
			guard error == nil else {
				completionHandler(false, nil, error)
				return
			}
			
			guard error == nil else {
				completionHandler(false, nil, error)
				return
			}
			if let session = results?["session"] as? [String: AnyObject] {
				if let id = session["id"] as? String {
					print("Session with ID \(id) was ended.")
					completionHandler(true, id, nil)
				} else {
					let userInfo = [NSLocalizedDescriptionKey: "Error: key id not found in results"]
					completionHandler(false, nil, NSError(domain: "keyMissingInResult", code: 6, userInfo: userInfo))
				}
			} else {
				let userInfo = [NSLocalizedDescriptionKey: "Error: key session not found in results"]
				completionHandler(false, nil, NSError(domain: "keyMissingInResult", code: 5, userInfo: userInfo))
			}
		}
	}
}
