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
	
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	
	func taskForGET(parameters: [String: String]? = nil, _ objectID: String? = nil, completionHandler: @escaping (_ results: [[String: AnyObject]]?, _ error: NSError?) -> Void) -> URLSessionDataTask {
		
		var urlComponents = URLComponents()
		urlComponents.scheme = Constants.Scheme
		urlComponents.host = Constants.Host
		urlComponents.path = Constants.Path + (objectID ?? "")
		urlComponents.queryItems = []
		
		/* 1. Set parameters */
		if parameters != nil {
			for (key, value) in parameters! {
				let queryItem = URLQueryItem(name: key, value: value)
				urlComponents.queryItems?.append(queryItem)
			}
		}
		
		/* 2. Build URL */
		let url = urlComponents.url
		let request = NSMutableURLRequest(url: url!)
		
		/* 3. Setup */
		request.addValue(Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
		request.addValue(Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
		
		print("Request being sent: \(request.url!)")
		let session = URLSession.shared
		let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
			
			// Make sure no errors were returned
			let returnedError = self.appDelegate.checkRequestResultsForError(data, response, error)
			guard returnedError == nil else {
				completionHandler(nil, returnedError)
				return
			}
			print("Preparing to parse \(data)")
			/* 5/6 Parse data */
			self.parseGETRequest(data!, completionHandlerForParsedData: completionHandler)
		}
		task.resume()
		return task
	}

	func serverTask(parameters: [String: String], method: HTTPMethod, uniqueKey: String? = nil, objectID: String? = nil, completionHandler: @escaping (_ results: [[String: AnyObject]]?, _ error: NSError?) -> Void) -> URLSessionDataTask {
		
		/* 1. Set parameters */
		var urlComponents = URLComponents()
		urlComponents.scheme = Constants.Scheme
		urlComponents.host = Constants.Host
		urlComponents.path = Constants.Path + ((objectID != nil)  ? "/\(objectID!)" : "")
		print(urlComponents.url!)
		
		
		/* 2. Build URL */
		/* 3. Configure request */
		let request = NSMutableURLRequest()
		
		if method == .GET {
			urlComponents.queryItems = []
			for (key, value) in parameters {
				let item = URLQueryItem(name: key, value: value)
				urlComponents.queryItems?.append(item)
			}
			if uniqueKey != nil {
				let item = URLQueryItem(name: "where", value: "{\"uniqueKey\":\"\(uniqueKey!)\"}")
				urlComponents.queryItems?.append(item)
				print(urlComponents.url!.absoluteString)
			}
		} else {
			do {
				let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
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
	
	class func sharedInstance() -> ParseClient {
		struct Singelton {
			static var sharedInstance = ParseClient()
		}
		return Singelton.sharedInstance
	}
}
