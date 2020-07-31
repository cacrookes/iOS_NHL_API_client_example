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
    
    var favouritePlayers = [Player]()
    
    @IBOutlet weak var favouritePlayersTableView: UITableView!
    @IBOutlet weak var noFavesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noFavesLabel.isHidden = true
        
        if let favePlayerIds = UserDefaults.standard.array(forKey: K.UserDefaultValues.favouritePlayers) as? [Int] {
            if favePlayerIds.count == 0 {
                setupNoFaves()
            } else {
                loadPlayers(favePlayerIds)
            }
        } else {
            setupNoFaves()
        }
    }
    
    func setupNoFaves() {
        favouritePlayersTableView.isHidden = true
        noFavesLabel.isHidden = false
        
//        let noFavesLabel = UILabel(frame: CGRect()
//        noFavesLabel.textAlignment = .center
//        noFavesLabel.lineBreakMode = .byWordWrapping
//        noFavesLabel.numberOfLines = 0
//        noFavesLabel.text = "You have not selected any favourite players yet. Click the add button in the top right to get started"
//        self.view.addSubview(noFavesLabel)
//        noFavesLabel.center = self.view.center
    }
    
    func loadPlayers(_ playerIds: [Int]) {
        
    }

}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritePlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favouritePlayersTableView.dequeueReusableCell(withIdentifier: K.Identifiers.favouritePlayerTableViewCell)!
        
        let player = favouritePlayers[indexPath.row]
        cell.textLabel?.text = "\(player.team?.abbreviation ?? "N/A"): \(player.primaryNumber ?? "00") - \(player.name ?? "No Name")"
        
        return cell
    }
    
}

/*
 fileprivate func printTeams() {

     NHLClient.getTeamList { (teams, error) in
         let geoCoder = CLGeocoder()
         for team in teams{
             print("\(team.name) - \(team.venue.name), \(team.locationName)")
             let venueAddress = "\(team.venue.name), \(team.locationName)"
             geoCoder.geocodeAddressString(venueAddress) { (placemarks, error) in
                 if error != nil {
                     print(error!)
                 }
                 if let location = placemarks?.first?.location {
                     print(location.coordinate)
                 }
             }

         }
     }
 }

 fileprivate func printRoster() {

     NHLClient.getTeamRoster(forTeamID: 26) { (roster, error) in
         print(roster.count)
         for player in roster {
             print(player.person.fullName)
         }
     }
 }

 fileprivate func printPlayerInfo() {
     NHLClient.getPlayerInfo(forPlayerID: 8475204) { (playerInfo, error) in
         print(playerInfo?.fullName ?? "")
     }
 }

 fileprivate func printPlayerStats() {
     NHLClient.getPlayerStats(forPlayerID: 8475204, forSeason: "20192020") { (stats, error) in
         print(stats?.points ?? 0)
     }
 }
 */
