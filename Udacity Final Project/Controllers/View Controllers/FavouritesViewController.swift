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

    // MARK: - Global Variables
    let dataController = (UIApplication.shared.delegate as! AppDelegate).dataController
    var favouritePlayers = [Player]()
    fileprivate var selectedPlayer: Player?
    
    // MARK: - IBOutlets
    @IBOutlet weak var favouritePlayersTableView: UITableView!
    @IBOutlet weak var noFavesLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.center = self.view.center
        
        favouritePlayersTableView.delegate = self
        favouritePlayersTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifiers.favesToTeamSegue {
            if let tabBarController = segue.destination as? UITabBarController {
                for child in tabBarController.children {
                    if let destinationController = child.children[0] as? DataControllerDelegate {
                        destinationController.setDataController(dataController: dataController)
                    }
                }
            }
        } else if segue.identifier == K.Identifiers.favesToPlayerSegue {
            if let playerDetailController = segue.destination as? PlayerDetailViewController {
                playerDetailController.dataController = dataController
                playerDetailController.player = selectedPlayer!
            }
        }
    }
    
    // MARK: - Alerts
    fileprivate func showAlert() {
        let alertVC = UIAlertController(title: "Error retrieving favourite players!", message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { _ in
            self.configureUI()
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    // MARK: - Helper Functions
    fileprivate func configureUI() {
        favouritePlayers = [Player]() // reset array whenever we configure the UI
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
    
    /// Sets up the UI for the condition when the user has not yet stored any favourite players.
    func setupNoFaves() {
        favouritePlayersTableView.isHidden = true
        noFavesLabel.isHidden = false
    }
    
    /// Loads the users favourites players into the TableView.
    /// - Parameter playerIds: a list of Int representing the ids of the user's favourite players.
    func loadPlayers(_ playerIds: [Int]) {
        noFavesLabel.isHidden = true
        favouritePlayersTableView.isHidden = false
        activityIndicator.startAnimating()
        
        for playerId in playerIds {
            self.dataController.getPlayer(playerId) { (player, error) in
                self.activityIndicator.stopAnimating()
                if error != nil {
                    self.showAlert()
                } else {
                    self.favouritePlayers.append(player!)
                    self.favouritePlayersTableView.reloadData()
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource methods
extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritePlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favouritePlayersTableView.dequeueReusableCell(withIdentifier: K.Identifiers.favouritePlayerTableViewCell)!
        
        let player = favouritePlayers[indexPath.row]
        let logoName = "\(player.team?.abbreviation?.lowercased() ?? "nhl").png"
        cell.imageView?.image = UIImage(imageLiteralResourceName: logoName)
        cell.textLabel?.text = "#\(player.primaryNumber) \(player.name ?? "No Name")"
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlayer = favouritePlayers[indexPath.row]
        performSegue(withIdentifier: K.Identifiers.favesToPlayerSegue, sender: self)
    }
    
}

