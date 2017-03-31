//
//  ParseClientConvenience.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-27.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

extension ParseClient {
	
	func refresh (completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void ) {
		
		let parameters: [String: AnyObject] = [:]
//			ParameterKeys.Limit: "100" as AnyObject,
//			ParameterKeys.Skip: "0" as AnyObject,
//			ParameterKeys.Order: StudentLocationKeys.UpdatedAt as AnyObject
//		]
		
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
		
		let parameters: [String: AnyObject] = [:]
		
		let _ = serverTask(parameters: parameters, method: .GET, uniqueKey: appDelegate.uniqueKey) { (results, error) in
			
			guard error == nil else {
				completionHandler(false, error)
				return
			}
			
			if let userData = results {
				self.appDelegate.userData = userData
				self.appDelegate.objectID = results?[1]["objectId"] as? String
				
				completionHandler(true, error)
				return
			} else {
				let userInfo = [NSLocalizedDescriptionKey: "Error: could not get user data: \(results)."]
				completionHandler(false, NSError(domain: "couldNotGetData", code: 7, userInfo: userInfo))
			}
		}
	}
	
	func updateLocation (location: String, website: String, completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
		
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(location) { (clPlacemark, error) in
			
			guard error == nil else {
				completionHandler(false, error as NSError?)
				print(error.debugDescription)
				return
			}
			
			guard clPlacemark?.count == 1 else {
				let userInfo = [NSLocalizedDescriptionKey: "Ambiguous location"]
				let error = NSError(domain: "ambiguousLocationError", code: 101, userInfo: userInfo)
				completionHandler(false, error)
				return
			}
			guard let latitude = clPlacemark![0].location?.coordinate.latitude,
				let longitude = clPlacemark![0].location?.coordinate.longitude else {
					let userInfo = [NSLocalizedDescriptionKey: "Request did not return coordinates."]
					completionHandler(false, NSError(domain: "coordinateError", code: 102, userInfo: userInfo))
					return
			}
			
			let parameters: [String: AnyObject] = [
				StudentLocationKeys.MapString: location as AnyObject,
				StudentLocationKeys.Latitude: latitude as AnyObject,
				StudentLocationKeys.Longitude: longitude as AnyObject,
				StudentLocationKeys.MediaURL: website as AnyObject
			]
			
			let _ = self.serverTask(parameters: parameters, method: .PUT, objectID: self.appDelegate.objectID!) { (results, error) in
				
				guard error == nil else {
					completionHandler(false, error)
					print(error!.debugDescription)
					return
				}
				
				completionHandler(true, nil)
			}
		}
	}
}
