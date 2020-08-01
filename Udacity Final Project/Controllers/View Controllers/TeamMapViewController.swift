//
//  TeamMapViewController.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-07-31.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class TeamMapViewController: UIViewController {

    var dataController: DataController!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMap()
    }
    
    func setupMap(){
        let coordinates = CLLocationCoordinate2D(latitude: 37.0902, longitude:  -95.7129)
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 6000000, longitudinalMeters: 6000000)
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - DataControllerDelegate methods
extension TeamMapViewController: DataControllerDelegate {
    func setDataController(dataController: DataController) {
        self.dataController = dataController
    }
    
}

