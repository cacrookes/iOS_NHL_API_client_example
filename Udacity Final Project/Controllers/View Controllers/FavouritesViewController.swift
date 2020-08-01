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
        
        favouritePlayersTableView.delegate = self
        favouritePlayersTableView.dataSource = self
        
        configureUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifiers.favesToTeamSegue {
            if let tabBarController  = segue.destination as? UITabBarController {
                for child in tabBarController.children {
                    if let destinationController = child.children[0] as? DataControllerDelegate {
                        destinationController.setDataController(dataController: dataController)
                    }
                }
            }
        }
    }
    
    fileprivate func configureUI() {
        if let favePlayerIds = UserDefaults.standard.array(forKey: K.UserDefaultValues.favouritePlayers) as? [Int] {
            if favePlayerIds.count == 0 {
                setupNoFaves()
                loadPlayers([8476459, 8477474, 8474593])
            } else {
                loadPlayers(favePlayerIds)
            }
        } else {
            //setupNoFaves()
            loadPlayers([8476459, 8477474, 8474593])
        }
    }
    
    
    func setupNoFaves() {
        favouritePlayersTableView.isHidden = true
        noFavesLabel.isHidden = false
    }
    
    func loadPlayers(_ playerIds: [Int]) {
        noFavesLabel.isHidden = true
        favouritePlayersTableView.isHidden = false
        for playerId in playerIds {
            guard let player = dataController.getPlayer(playerId) else { continue }
            favouritePlayers.append(player)
        }
        favouritePlayersTableView.reloadData()
    }

}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritePlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favouritePlayersTableView.dequeueReusableCell(withIdentifier: K.Identifiers.favouritePlayerTableViewCell)!
        
        let player = favouritePlayers[indexPath.row]
        let logoName = "\(player.team?.abbreviation?.lowercased() ?? "nhl").png"
        cell.imageView?.image = UIImage(imageLiteralResourceName: logoName)
        cell.textLabel?.text = "#\(player.primaryNumber ?? "00") \(player.name ?? "No Name")"
        
        // Set-up detail
        let positionText = "Position: \(player.primaryPosition ?? "N/A")"
        var shootCatchText = ""
        if player.primaryPosition == "Goalie" {
            shootCatchText = "Catches: \(player.shootsCatches ?? "N/A")"
        } else {
            shootCatchText = "Shoots: \(player.shootsCatches ?? "N/A")"
        }
        cell.detailTextLabel?.text = "\(positionText), \(shootCatchText)"
        
        // Set-up colours
        cell.contentView.backgroundColor = TeamAttributes.getTeamPrimaryColour(forTeamAbbreviation: player.team?.abbreviation ?? "NHL")
        cell.textLabel?.textColor = .white
        cell.detailTextLabel?.textColor = .white
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
