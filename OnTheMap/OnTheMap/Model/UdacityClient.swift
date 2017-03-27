//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-23.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit
import Foundation

class UdacityClient: NSObject {
	
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	
	func taskForPOST(parameters: [String: AnyObject], completionHandler: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void ) -> URLSessionDataTask {
		
		/* 1. Set parameters */
		let username = parameters[ParameterKeys.Username]!
		let password = parameters[ParameterKeys.Password]!
		let httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
		
		/* 2. Build URL */
		let url = URL(string: Constants.Scheme + "://" + Constants.Host + Constants.Path)
		let request = NSMutableURLRequest(url: url!)
		
		/* 3. Configure request */
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = httpBody.data(using: String.Encoding.utf8)
		
		/* 4. Make request */
		print("Request being sent: \(request.url!)")
		let session = URLSession.shared
		let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
			
			// Make sure no errors were returned
			let returnedError = self.appDelegate.checkRequestResultsForError(data, response, error)
			guard returnedError == nil else {
				completionHandler(nil, returnedError)
				return
			}
			
			/* 5/6. Parse data */
			self.appDelegate.parseData(data!, isUdacityData: true, completionHandlerForParsedData: completionHandler)
		}
		/* 7. Start request */
		task.resume()
		return task
	}
	
	func taskForDELETE(completionHandler: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
		
		/* 1. No parameters */
		
		/* 2. Build URL */
		let url = URL(string: Constants.Scheme + "://" + Constants.Host + Constants.Path)
		let request = NSMutableURLRequest(url: url!)
		
		/* 3. Configure request */
		request.httpMethod = "DELETE"
		
		var xsrfCookie: HTTPCookie? = nil
		let sharedCookieStorage = HTTPCookieStorage.shared
		for cookie in sharedCookieStorage.cookies! {
			if cookie.name == "XSRF-TOKEN" {
				xsrfCookie = cookie
			}
		}
		if let xsrfCookie = xsrfCookie {
			request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSFR-TOKEN")
		}
		
		/* 4. Make request */
		let session = URLSession.shared
		let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
			
			let returnedError = self.appDelegate.checkRequestResultsForError(data, response, error)
			guard returnedError == nil else {
				completionHandler(nil, returnedError)
				return
			}
			
			self.appDelegate.parseData(data!, isUdacityData: true, completionHandlerForParsedData: completionHandler)
		}
		task.resume()
		return task
	}
	

	
	// MARK: Shared instance
	class func sharedInstance() -> UdacityClient {
		struct Singelton {
			static var sharedInstance = UdacityClient()
		}
		return Singelton.sharedInstance
	}
	
}
