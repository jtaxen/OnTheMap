//
//  OnTheMapTests.swift
//  OnTheMapTests
//
//  Created by ÅF Jacob Taxén on 2017-04-10.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import XCTest
import CoreLocation
@testable import OnTheMap

class OnTheMapTests: XCTestCase {
	
	var parseClient: ParseClient?
	
	override func setUp() {
		super.setUp()
		parseClient = ParseClient.sharedInstance()
	}
	
	override func tearDown() {
		parseClient = nil
		super.tearDown()
	}
	
	func testCorrectCoordinatesAreReturnedFromFindLocation() {
		let locationString = "1 Infinite Loop, Cupertino, CA"
		parseClient?.findLocation(locationString) { (location, error) in
			XCTAssertNotNil(location, "Coordinates are nil")
			
			let clLocation = CLLocation(latitude: location!.latitude, longitude: location!.longitude)
			CLGeocoder().reverseGeocodeLocation(clLocation) { (clPlacemark, error) in
				guard clPlacemark != nil else { return }
				print("completion")
				XCTAssertEqual(locationString, clPlacemark![0].name, error.debugDescription)
			}
		}
	}
}
