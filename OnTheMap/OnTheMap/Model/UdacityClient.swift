//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-23.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation

class UdacityClient: NSObject {
	
	
	
	
	// MARK: Create Udacity request URL
	private func createUdacityURL(_ parameters: [String: AnyObject], method: String, withStringExtension: String? = nil, completionHandler: @escaping (_ succes: Bool, _ results: String?, _ error: String?) -> Void ) {
	
		var components = URLComponents()
		components.scheme = Constants.Scheme
		components.host = Constants.Host
		components.path = Constants.Path + (withStringExtension ?? "")
		components.queryItems = [URLQueryItem]()
		
		for (key, value) in parameters {
			let item = URLQueryItem(name: key, value: "\(value)")
			components.queryItems!.append(item)
		}
		
	}
	
}
