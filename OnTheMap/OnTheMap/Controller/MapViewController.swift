//
//  MapViewController.swift
//  OnTheMap
//
//  Created by ÅF Jacob Taxén on 2017-03-23.
//  Copyright © 2017 Jacob Taxén. All rights reserved.
//

import UIKit
import MapKit

/**
Map view controller
*/

class MapViewController: UIViewController, MKMapViewDelegate {
	
	@IBOutlet weak var mapView: MKMapView!
	
	var appDelegate = UIApplication.shared.delegate as! AppDelegate
	
	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name(rawValue: "refresh"), object: nil)
		
		/// Draws and presents the pins on the map.
		let annotations = drawPins()
		mapView.addAnnotations(annotations)
	}
	
	/// Updates the map view with new pins when the location array has been updated.
	@objc private func refresh() {
		mapView.removeAnnotations(mapView.annotations)
		let annotations = drawPins()
		mapView.addAnnotations(annotations)
	}
	
	/// Draws the pins onto the map.
	/// - Returns: an array of annotations to be added to the map view.
	func drawPins() -> [MKPointAnnotation] {
		
		let locations = appDelegate.locationData ?? appDelegate.hardCodedLocationData()
		var annotations = [MKPointAnnotation]()
		
		for item in locations {
			if let lat = item["latitude"] as? Float,
				let lon = item["longitude"] as? Float {
				
				let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(lon))
				
				let firstName = item["firstName"] as? String ?? ""
				let lastName = item["lastName"] as? String ?? ""
				let mediaUrl = item["mediaUrl"] as? String ?? ""
				
				let annotation = MKPointAnnotation()
				annotation.coordinate = coordinate
				annotation.title = "\(firstName) \(lastName)"
				annotation.subtitle = mediaUrl
				
				annotations.append(annotation)
			}
		}
		return annotations
	}
	
}

/// MARK: Map view delegate
extension MapViewController {
	
	/// Design the pins. If pin is pushed, a bubble with the corresponding name and web site is shown.
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
	
	/// If a bubble is pressed, the link in it is opened in a web browser.
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		if control == view.rightCalloutAccessoryView {
			let app = UIApplication.shared
			if let toOpen = view.annotation?.subtitle,
				let url = URL(string: toOpen!),
				app.canOpenURL(url) {
				app.open(url, options: [:], completionHandler: nil)
			}
		}
	}
}
