//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-23.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
	
	func taskForPOST(parameters: [String: AnyObject], completionHandler: @escaping (_ results: [String: AnyObject]?, _ error: String?) -> Void ) -> URLSessionDataTask {
		
		/* 1. Set parameters */
		let username = parameters[ParameterKeys.Username]
		let password = parameters[ParameterKeys.Password]
		let httpBody = "{\"udacity\": {\"username\": \"\(username)\", \" password\": \"\(password)\"}}"
		
		/* 2. Build URL */
		let url = URL(string: Constants.Scheme + "://" + Constants.Host + Constants.Path)
		let request = NSMutableURLRequest(url: url!)
		
		/* 3. Configure request */
		request.httpMethod = "POST"
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		request.httpBody = httpBody.data(using: String.Encoding.utf8)
		
		/* 4. Make request */
		let session = URLSession.shared
		let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
			
			// Check to see if an error was returned
			guard error != nil else {
				completionHandler(nil, error as! String?)
				return
			}
			
			// Make sure the server returns a 200-status code
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
				completionHandler(nil, "Error: Server returned status code other than 2xx")
				return
			}
			
			// Make sure data was returned
			guard let data = data else {
				completionHandler(nil, "Error: no data was returned")
				return
			}
		
		/* 5/6. Parse data */
			self.parseData(data) { (results, error) in
				if error != nil {
					completionHandler(nil, error?.localizedDescription)
				} else {
					completionHandler(results, nil)
				}
			}
		}
		/* 7. Start request */
		task.resume()
		return task
	}
	
	private func parseData(_ data: Data, completionHandler: (_ results: [String: AnyObject]?, _ error: NSError?) -> Void) {
	
		var parsedData: [String: AnyObject]? = nil
		do {
			parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : AnyObject]
		} catch {
			let userInfo = [NSLocalizedDescriptionKey: "Error: JSON results could not be parsed"]
			completionHandler(nil, NSError(domain: "parseJSONData", code: 1, userInfo: userInfo))
		}
		completionHandler(parsedData, nil)
	}
	
	
}
