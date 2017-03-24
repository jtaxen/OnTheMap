//
//  MapViewController.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-23.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
	
	@IBOutlet weak var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let locations = hardCodedLocationData()
		
		var annotations = [MKPointAnnotation]()
		
		for dictionary in locations {
		
			let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
			let lon = CLLocationDegrees(dictionary["longitude"] as! Double)
			
			let coordinate = CLLocationCoordinate2DMake(lat, lon)
			
			let firstName = dictionary["firstName"] as! String
			let lastName = dictionary["lastName"] as! String
			let mediaUrl = dictionary["mediaURL"] as! String
			
			let annotation = MKPointAnnotation()
			annotation.coordinate = coordinate
			annotation.title = "\(firstName) \(lastName)"
			annotation.subtitle = mediaUrl
			
			annotations.append(annotation)
		}
		mapView.addAnnotations(annotations)
	}
	
	// TODO: Remove this
	func hardCodedLocationData() -> [[String : AnyObject]] {
		return  [
			[
				"createdAt" : "2015-02-24T22:27:14.456Z" as AnyObject,
				"firstName" : "Jöns" as AnyObject,
				"lastName" : "Jönsson" as AnyObject,
				"latitude" : 56.4 as AnyObject,
				"longitude" : 13.4 as AnyObject,
				"mapString" : "Tarpon Springs, FL" as AnyObject,
				"mediaURL" : "jönsson.com" as AnyObject,
				"objectId" : "kj18GEaWD8" as AnyObject,
				"uniqueKey" : 872458750 as AnyObject,
				"updatedAt" : "2015-03-09T22:07:09.593Z" as AnyObject
			], [
				"createdAt" : "2015-02-24T22:35:30.639Z" as AnyObject,
				"firstName" : "Gabrielle" as AnyObject,
				"lastName" : "Miller-Messner" as AnyObject,
				"latitude" : 56.56 as AnyObject,
				"longitude" : 13.03 as AnyObject,
				"mapString" : "Southern Pines, NC" as AnyObject,
				"mediaURL" : "http://www.linkedin.com/pub/gabrielle-miller-messner/11/557/60/en" as AnyObject,
				"objectId" : "8ZEuHF5uX8" as AnyObject,
				"uniqueKey" : 2256298598 as AnyObject,
				"updatedAt" : "2015-03-11T03:23:49.582Z" as AnyObject
			], [
				"createdAt" : "2015-02-24T22:30:54.442Z" as AnyObject,
				"firstName" : "Jason" as AnyObject,
				"lastName" : "Schatz" as AnyObject,
				"latitude" : 55.5 as AnyObject,
				"longitude" : 13.13 as AnyObject,
				"mapString" : "18th and Valencia, San Francisco, CA" as AnyObject,
				"mediaURL" : "http://en.wikipedia.org/wiki/Swift_%28programming_language%29" as AnyObject,
				"objectId" : "hiz0vOTmrL" as AnyObject,
				"uniqueKey" : 2362758535 as AnyObject,
				"updatedAt" : "2015-03-10T17:20:31.828Z" as AnyObject
			], [
				"createdAt" : "2015-03-11T02:48:18.321Z" as AnyObject,
				"firstName" : "Jarrod" as AnyObject,
				"lastName" : "Parkes" as AnyObject,
				"latitude" : 5.2524 as AnyObject,
				"longitude" : 13.4272 as AnyObject,
				"mapString" : "Huntsville, Alabama" as AnyObject,
				"mediaURL" : "https://linkedin.com/in/jarrodparkes" as AnyObject,
				"objectId" : "CDHfAy8sdp" as AnyObject,
				"uniqueKey" : 996618664 as AnyObject,
				"updatedAt" : "2015-03-13T03:37:58.389Z" as AnyObject
			]
		]
	}
}

// MARK: Map view delegate
extension MapViewController {
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		
		let reuseId = "pin"
		
		var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
		
		if pinView == nil {
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView!.canShowCallout = true
			pinView!.pinTintColor = UIColor.blue
			pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
		} else {
			pinView!.annotation = annotation
		}
		
		return pinView
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		if control == view.rightCalloutAccessoryView {
			let app = UIApplication.shared
			if let toOpen = view.annotation?.subtitle! {
				let url = URL(string: toOpen)!
				app.open(url, options: [:], completionHandler: nil)
			}
		}
	}
}


