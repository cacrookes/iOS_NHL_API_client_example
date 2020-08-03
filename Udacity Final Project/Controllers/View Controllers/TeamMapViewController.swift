//
//  TeamMapViewController.swift
//  Udacity Final Project
//
//  Created on 2020-07-31.
//

import UIKit
import CoreData
import CoreLocation
import MapKit

class TeamMapViewController: UIViewController {

    var dataController: DataController!
    var teams = [Team]()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        activityIndicator.center = self.view.center
        setupMap()
        activityIndicator.startAnimating()
        dataController.getTeams(completion: getTeamHandler(teams:error:))
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifiers.teamMapToRosterSegue {
            let annotation = mapView.selectedAnnotations.first
            let controller = segue.destination as! RosterViewController
            controller.dataController = dataController
            for team in teams{
                if team.abbreviation == annotation?.title {
                    controller.team = team
                    break
                }
            }
        }
    }
    
    // MARK: Alerts
    fileprivate func showAlert() {
        let alertVC = UIAlertController(title: "Error loading teams!", message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { _ in
            self.activityIndicator.startAnimating()
            self.dataController.getTeams(completion: self.getTeamHandler(teams:error:))
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func favouritesButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupMap() {
        let coordinates = CLLocationCoordinate2D(latitude: 37.0902, longitude:  -95.7129)
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 6000000, longitudinalMeters: 6000000)
        mapView.setRegion(region, animated: true)
    }
    
    func getTeamHandler(teams: [Team]?, error: Error?) -> Void {
        activityIndicator.stopAnimating()
        guard teams != nil else {
            showAlert()
            return
        }
        self.teams = teams!
        for team in self.teams {
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
          
        } else {
            annotationView?.annotation = annotation
        }

        let logoName = "\(annotation.title??.lowercased() ?? "nhl").png"
        annotationView?.image = UIImage(imageLiteralResourceName:logoName)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: K.Identifiers.teamMapToRosterSegue, sender: self)
    }
}
