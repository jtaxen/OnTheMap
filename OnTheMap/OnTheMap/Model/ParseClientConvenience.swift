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
	
	/**
	Fetches a new and fresh list of student locations from the server.
	- Parameter success: True if the request is successful, false otherwise.
	- Parameter error: Error information if the request fails, nil otherwise.
	*/
	func refresh (completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void ) {
		
		let parameters: [String: AnyObject] = [
			ParameterKeys.Limit: "100" as AnyObject,
			ParameterKeys.Skip: "0" as AnyObject,
			ParameterKeys.Order: "-" + StudentLocationKeys.UpdatedAt as AnyObject
		]
		
		let _ = serverTask(parameters: parameters, method: .GET) { (results, error) in
			
			guard error == nil else {
				completionHandler(false, error)
				return
			}
			if let locationData = results {
				self.appDelegate.locationData = self.appDelegate.extractStudentLocations(from: locationData)
				self.getUserData() { (succ, err) in
					completionHandler(succ, err)
				}
			} else {
				let userInfo = [NSLocalizedDescriptionKey: "Error: could not get location data: \(results)."]
				completionHandler(false, NSError(domain: "couldNotGetData", code: 7, userInfo: userInfo))
			}
		}
	}
	
	/**
	Fetches information for a single user.
	- Parameter success: True if the request is successful, false otherwise.
	- Parameter error: Error information if the request fails, nil otherwise.
	*/
	func getUserData (completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void ) {
		
		let parameters: [String: AnyObject] = [:]
		
		let _ = serverTask(parameters: parameters, method: .GET, uniqueKey: appDelegate.uniqueKey) { (results, error) in
			
			guard error == nil else {
				completionHandler(false, error)
				return
			}
			
			if results != nil {
				self.appDelegate.userData = StudentLocation(results![0])
				self.appDelegate.objectID = results![0]["objectId"] as? String
				
				completionHandler(true, error)
				return
			} else {
				let userInfo = [NSLocalizedDescriptionKey: "Error: could not get user data: \(results)."]
				completionHandler(false, NSError(domain: "couldNotGetData", code: 7, userInfo: userInfo))
			}
		}
	}
	
	
	/**
	Posts a new location and web site for the current user.
	- Parameter locatiom: Name of a location, city, address etc.
	- Parameter website: A website of the user's choice.
	- Parameter success: True if the request is successful, false otherwise.
	- Parameter error: Error information if the request fails, nil otherwise.
	*/
	func updateLocation (location: String, website: String, completionHandler: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
		
		var parameters: [String: AnyObject] = [:]
		var newLocation: String
		
		if location == "" {
			newLocation = appDelegate.userData.MapString as! String
		} else {
			newLocation = location
		}
		
		
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(location) { (clPlacemark, error) in
			
			guard error == nil && clPlacemark != nil else {
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
			
			let placemark = clPlacemark![0]
			if let latitude = (placemark.location?.coordinate.latitude),
				let longitude = (placemark.location?.coordinate.longitude) {
				
				print("Updating to new location: lat: \(latitude), lon: \(longitude)")
				parameters[StudentLocationKeys.Latitude] = latitude as AnyObject
				parameters[StudentLocationKeys.Longitude] = longitude as AnyObject
			}
			
			
			parameters[StudentLocationKeys.MapString] = newLocation as AnyObject
			
			if website != "" {
				parameters[StudentLocationKeys.MediaURL] = website as AnyObject
			}
			
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
	
	func findLocation(_ location: String, completionHandler: @escaping ((_ location: CLLocationCoordinate2D?, _ error: NSError?) -> Void )) {
		var locationCoordinates: CLLocationCoordinate2D?
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(location) { (clPlacemark, error) in
			guard clPlacemark != nil && error == nil else {
				debugPrint(error.debugDescription)
				completionHandler(nil, error as NSError?)
				return
			}
			let placemark = clPlacemark![0]
			locationCoordinates = placemark.location?.coordinate
			completionHandler(locationCoordinates, error as NSError?)
		}
	}
}
