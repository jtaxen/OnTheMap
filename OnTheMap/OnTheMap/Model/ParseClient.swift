//
//  ParseClient.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-22.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import UIKit

/**
Handles requests to the Parse server.
*/
class ParseClient: NSObject {
	
	let appDelegate = UIApplication.shared.delegate as! AppDelegate

	/**
	Sends a request to the server.
	- Parameter parameters: Dictionary of API keywords and their corresponding values.
	- Parameter method: decides which HTTP method is to be used. Supported methods are GET, POST and PUT.
	- Parameter uniqueKey: Key identifying a certain user. This must be provided if the request is a GET request to fetch the information of an individual user. If this is nil, the function will GET all users in the data base.
	- Parameter objectID: The ID of a certain object, needed to identify a user when a POST or PUT request is being made.
	- Parameter results: Array of dictionaries containing the response from the server.
	- Parameter error: Error information if the request fails.
*/
	func serverTask(parameters: [String: AnyObject], method: HTTPMethod, uniqueKey: String? = nil, objectID: String? = nil, completionHandler: @escaping (_ results: [[String: AnyObject]]?, _ error: NSError?) -> Void) -> URLSessionDataTask {
		
		/* 1. Set parameters */
		var urlComponents = URLComponents()
		urlComponents.scheme = Constants.Scheme
		urlComponents.host = Constants.Host
		urlComponents.path = Constants.Path + ((objectID != nil)  ? "/\(objectID!)" : "")
		
		
		/* 2. Build URL */
		/* 3. Configure request */
		let request = NSMutableURLRequest()
		request.httpBody = Data()
		request.timeoutInterval = Timer.Timeout
		
		if method == .GET {
			urlComponents.queryItems = []
			for (key, value) in parameters {
				let item = URLQueryItem(name: key, value: value as? String)
				urlComponents.queryItems?.append(item)
			}
			if uniqueKey != nil {
				let item = URLQueryItem(name: "where", value: "{\"uniqueKey\":\"\(uniqueKey!)\"}")
				urlComponents.queryItems?.append(item)
			}
		} else {
			do {
				let jsonData = try JSONSerialization.data(withJSONObject: parameters)
				request.httpBody = jsonData
			} catch {
				let userInfo = [NSLocalizedDescriptionKey:"Error: could not perform JSON deserialization"]
				completionHandler(nil, NSError(domain: "JSONDeserialization", code: 9, userInfo: userInfo))
			}
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		}
		
		request.url = urlComponents.url!
		request.httpMethod = method.rawValue
		request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
		request.addValue(Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
		
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
			switch method {
			case .GET: self.parseGETRequest(data!, completionHandlerForParsedData: completionHandler)
			case .POST: self.parsePOSTRequest(data!, completionHandlerForParsedData: completionHandler)
			case .PUT: self.parsePOSTRequest(data!, completionHandlerForParsedData: completionHandler)
			}
		}
		
		/* 7. Start request */
		task.resume()
		return task
	}
	
	/// MARK: Shared instance of the client.
	class func sharedInstance() -> ParseClient {
		struct Singelton {
			static var sharedInstance = ParseClient()
		}
		return Singelton.sharedInstance
	}
}
