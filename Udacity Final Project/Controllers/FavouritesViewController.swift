//
//  FavouritesViewController.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-07-27.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit
import CoreLocation

class FavouritesViewController: UIViewController {

    let dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    
//    fileprivate func printTeams() {
//
//        NHLClient.getTeamList { (teams, error) in
//            let geoCoder = CLGeocoder()
//            for team in teams{
//                print("\(team.name) - \(team.venue.name), \(team.locationName)")
//                let venueAddress = "\(team.venue.name), \(team.locationName)"
////                geoCoder.geocodeAddressString(venueAddress) { (placemarks, error) in
////                    if error != nil {
////                        print(error!)
////                    }
////                    if let location = placemarks?.first?.location {
////                        print(location.coordinate)
////                    }
////                }
//
//            }
//        }
//    }
//
//    fileprivate func printRoster() {
//
//        NHLClient.getTeamRoster(forTeamID: 26) { (roster, error) in
//            print(roster.count)
//            for player in roster {
//                print(player.person.fullName)
//            }
//        }
//    }
//
//    fileprivate func printPlayerInfo() {
//        NHLClient.getPlayerInfo(forPlayerID: 8475204) { (playerInfo, error) in
//            print(playerInfo?.fullName ?? "")
//        }
//    }
//
//    fileprivate func printPlayerStats() {
//        NHLClient.getPlayerStats(forPlayerID: 8475204, forSeason: "20192020") { (stats, error) in
//            print(stats?.points ?? 0)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let teams = dataController.fetchTeams()
        for team in teams {
            print("\(team.id): \(team.abbreviation!) - \(team.name!)")
        }
    }
    


}

