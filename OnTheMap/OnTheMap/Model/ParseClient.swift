//
//  ParseClient.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-22.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import UIKit

// MARK: ParseClient

class ParseClient: NSObject {
	
	let methodUrl = Constants.Scheme + "://" + Constants.Host + Constants.Path

	func serverTask(parameters: [String: AnyObject], method: String, objectID: String? = nil, completionHandler: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
		
		/* 1. Set parameters */
		var parameterString: String
		if method == "GET" {
			parameterString = "?"
			for (key, value) in parameters {
				parameterString += key + "=" + (value as! String)
			}
		} else {
			parameterString = parameters.description
			parameterString = parameterString.replacingOccurrences(of: "[", with: "{")
			parameterString = parameterString.replacingOccurrences(of: "]", with: "}")
		}
		
		/* 2. Build URL */
		var url: URL?
		switch method {
		case "GET":
			url = URL(string: methodUrl + parameterString)
		case "POST":
			url = URL(string: methodUrl)
		case "PUT":
			url = URL(string: methodUrl + objectID!)
		default:
			print("Error: HTTP method is not valid.")
			break
		}
		
		let request = NSMutableURLRequest(url: url!)
		
		/* 3. Configure request */
		request.httpMethod = method
		request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
		request.addValue(Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
		if method != "GET" {
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
			request.httpBody = parameterString.data(using: String.Encoding.utf8)
		}
		
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
			
			/* 5/6 Parse data */
			self.appDelegate.parseData(data!, isUdacityData: false, completionHandlerForParsedData: completionHandler)
		}
		/* 7. Start request */
		task.resume()
		return task
	}
}
