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

class MapViewController: UIViewController, MKMapViewDelegate, ControllerProtocol {
	
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var spinner: UIActivityIndicatorView!
	
	var center: CLLocationCoordinate2D!
	var span: MKCoordinateSpan!
	
	var appDelegate = UIApplication.shared.delegate as! AppDelegate
	
	override func viewDidLoad() {
		super.viewDidLoad()
		NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name(rawValue: "refresh"), object: nil)
		
		spinner.hidesWhenStopped = true
		spinner.stopAnimating()
		
		refresh()
		
	}
	
	/// Updates the map view with new pins when the location array has been updated.
	@objc private func refresh() {
		mapView.removeAnnotations(mapView.annotations)
		let annotations = drawPins()
		mapView.addAnnotations(annotations)
		
		center = CLLocationCoordinate2D(latitude: appDelegate.userData.Latitude as! CLLocationDegrees , longitude: appDelegate.userData.Longitude as! CLLocationDegrees)
		span = MKCoordinateSpan(latitudeDelta: CLLocationDegrees(5), longitudeDelta: CLLocationDegrees(5))
		mapView.region = MKCoordinateRegion(center: center, span: span)
	}
	
	/// Draws the pins onto the map.
	/// - Returns: an array of annotations to be added to the map view.
	func drawPins() -> [MKPointAnnotation] {
		
		let locations = appDelegate.locationData ?? appDelegate.extractStudentLocations(from: appDelegate.hardCodedLocationData())
		var annotations = [MKPointAnnotation]()
		
		for item in locations {
			if let lat = item.Latitude as? Float,
				let lon = item.Longitude as? Float {
				
				let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(lon))
				
				let firstName = item.FirstName as? String ?? ""
				let lastName = item.LastName as? String ?? ""
				let mediaUrl = item.MediaURL as? String ?? ""
				
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
			} else {
				let controller = UIAlertController(title: "Unable to open link", message: "The link you have chosen does not work.", preferredStyle: .alert)
				controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
				present(controller, animated: true, completion: nil)
			}
		}
	}
}
