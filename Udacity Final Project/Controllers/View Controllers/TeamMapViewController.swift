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
    
    func setupMap() {
        let coordinates = CLLocationCoordinate2D(latitude: 37.0902, longitude:  -95.7129)
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 6000000, longitudinalMeters: 6000000)
        mapView.setRegion(region, animated: true)
    }
    
    func populateMap() {
        teams = dataController.getTeams()
        createTeamAnnotation(teamIndex: 0, getVenue: true)
    }
    
    func createTeamAnnotation(teamIndex index: Int, getVenue: Bool){
        let team = teams[index]
        if team.latitude == 0 || team.longitude == 0 {
            let geoCoder = CLGeocoder()
            var venueAddress = ""
            if getVenue {
                venueAddress = "\(team.venue ?? ""), \(team.city ?? "")"
            } else {
                venueAddress = "\(team.city ?? "")"
            }
            
            geoCoder.geocodeAddressString(venueAddress) { (placemarks, error) in
                print(venueAddress)
                if error != nil {
                    // try getting the coordinates for just the city, without the venue name
                    if getVenue {
                        self.createTeamAnnotation(teamIndex: index, getVenue: false)
                    } else {
                        print(error!)
                    }
                } else {
                    if let location = placemarks?.first?.location {
                        print(location.coordinate)
                        let annotation = MKPointAnnotation()
                        annotation.title = team.abbreviation ?? "NHL"
                        annotation.coordinate = location.coordinate
                        self.mapView.addAnnotation(annotation)
                    }
                    if index < self.teams.count - 1{
                        self.createTeamAnnotation(teamIndex: index + 1, getVenue: true)
                    }
                }
            }
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
          

            // if you want a disclosure button, you'd might do something like:
            //
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
