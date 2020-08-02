//
//  TeamMapViewController.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-07-31.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class TeamMapViewController: UIViewController {

    var dataController: DataController!
    var teams = [Team]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        setupMap()
        populateMap()
    }
    
    
    @IBAction func favouritesButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupMap() {
        let coordinates = CLLocationCoordinate2D(latitude: 37.0902, longitude:  -95.7129)
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 6000000, longitudinalMeters: 6000000)
        mapView.setRegion(region, animated: true)
    }
    
    func populateMap() {
        teams = dataController.getTeams()
        for team in teams {
            let annotation = MKPointAnnotation()
            annotation.title = team.abbreviation ?? "NHL"
            annotation.coordinate = TeamAttributes.getTeamCoordinates(forTeamAbbreviation: team.abbreviation ?? "NHL")
            self.mapView.addAnnotation(annotation)
        }
    }

}

// MARK: - DataControllerDelegate methods
extension TeamMapViewController: DataControllerDelegate {
    func setDataController(dataController: DataController) {
        self.dataController = dataController
    }
    
}

extension TeamMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "teamLocation"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
          
            // let detailButton = UIButton(type: .detailDisclosure)
            // annotationView?.rightCalloutAccessoryView = detailButton
        } else {
            annotationView?.annotation = annotation
        }

        let logoName = "\(annotation.title??.lowercased() ?? "nhl").png"
        annotationView?.image = UIImage(imageLiteralResourceName:logoName)
        return annotationView
    }
}
