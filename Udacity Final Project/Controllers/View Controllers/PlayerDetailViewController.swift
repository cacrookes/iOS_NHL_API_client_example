//
//  PlayerDetailViewController.swift
//  Udacity Final Project
//
//  Created on 2020-08-01.
//

import UIKit

class PlayerDetailViewController: UIViewController {

    // MARK: - Global Variables
    var dataController: DataController!
    var player: Player!
    var favePlayerIds = [Int]()
    
    // MARK: - IBOutlets
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var statsHeadingLabel: UILabel!
    @IBOutlet weak var gpLabel: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var assistsLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var plusminusLabel: UILabel!
    @IBOutlet weak var pimLabel: UILabel!
    
    @IBOutlet weak var subtitleView: UIView!
    @IBOutlet weak var gpHeadingLabel: UILabel!
    @IBOutlet weak var goalsHeadingLabel: UILabel!
    @IBOutlet weak var assistsHeadingLabel: UILabel!
    @IBOutlet weak var pointsHeadingLabel: UILabel!
    @IBOutlet weak var plusminusHeadingLabel: UILabel!
    @IBOutlet weak var pimHeadingLabel: UILabel!
    
    @IBOutlet weak var faveButton: UIButton!
    @IBOutlet weak var favouritesButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = player.name ?? "No Name"
        setTopLabel()
        setSubHeading()
        setFaveButtonText()
        configureFavouritesButton()
        activityIndicator.center = self.view.center
        
        setStats()
        
    }
    
    // MARK: Alerts
    fileprivate func showAlert() {
        let alertVC = UIAlertController(title: "Error loading \(player.name ?? "player")'s stats!", message: nil, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { _ in
            self.setStats()
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: IBActions
    @IBAction func faveButtonPressed(_ sender: Any) {
        let playerId = Int(player.id)
        if favePlayerIds.contains(playerId) {
            favePlayerIds.removeAll(where: {$0 == playerId})
        } else {
            favePlayerIds.append(playerId)
        }
        UserDefaults.standard.set(favePlayerIds, forKey: K.UserDefaultValues.favouritePlayers)
        setFaveButtonText()
    }
    
    @IBAction func favouritesButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Configuring UI methods
    fileprivate func configureFavouritesButton() {
        if let navController = self.navigationController {
            let vcCount = navController.viewControllers.count
            if navController.viewControllers[vcCount - 2].isKind(of: FavouritesViewController.self) {
                favouritesButton.isHidden = true
            }
        }
    }
    
    fileprivate func setFaveButtonText() {
        favePlayerIds = UserDefaults.standard.array(forKey: K.UserDefaultValues.favouritePlayers)! as! [Int]
        if favePlayerIds.contains(Int(player.id)) {
            faveButton.setTitle("Remove From Favourites List", for: .normal)
        } else {
            faveButton.setTitle("Add To Favourites List", for: .normal)
        }
    }
    
    fileprivate func setTopLabel() {
        var topLabelArray = [String]()
        if let position = player.primaryPosition {
            topLabelArray.append(position)
        }
        if let height = player.height {
            topLabelArray.append(height)
        }
        topLabelArray.append("\(player.weight) lb")
        topLabelArray.append("Age: \(player.currentAge)")
        topLabel.text = topLabelArray.joined(separator: " | ")
        topLabel.textAlignment = .center
    }
    
    fileprivate func setSubHeading() {
        logoImageView.image = UIImage(imageLiteralResourceName: "\(player.team?.abbreviation?.lowercased() ?? "nhl").png")
        subTitleLabel.text = player.team?.name ?? "No Current Team"
        subtitleView.sizeToFit()
        
    }
    
    fileprivate func setStats() {
        if player.primaryPosition == "Goalie" {
            setGoalieStats()
        } else {
            setPlayerStats()
        }
    }
    
    fileprivate func setNoStats() {
        self.gpLabel.text = "-"
        self.goalsLabel.text = "-"
        self.assistsLabel.text = "-"
        self.pointsLabel.text = "-"
        self.plusminusLabel.text = "-"
        self.pimLabel.text = "-"
    }
    
    fileprivate func setPlayerStats() {
        activityIndicator.startAnimating()
        NHLClient.getPlayerStats(forPlayerID: Int(player.id), forSeason: "20192020") { (stats, error) in
            self.activityIndicator.stopAnimating()
            if let stats = stats {
                self.gpLabel.text = String(stats.games)
                self.goalsLabel.text = String(stats.goals)
                self.assistsLabel.text = String(stats.assists)
                self.pointsLabel.text = String(stats.points)
                self.plusminusLabel.text = String(stats.plusMinus)
                self.pimLabel.text = String(stats.pim)
            } else {
                if error != nil {
                    self.showAlert()
                } else {
                    // player has no stats for current season
                    self.setNoStats()
                }
            }
        }
    }
        
    fileprivate func setGoalieStats() {
        activityIndicator.startAnimating()
        NHLClient.getGoalieStats(forPlayerID: Int(player.id), forSeason: "20192020") { (stats, error) in
            self.activityIndicator.stopAnimating()
            if let stats = stats {
                self.gpLabel.text = String(stats.games)
                self.goalsHeadingLabel.text = "W"
                self.goalsLabel.text = String(stats.wins)
                self.assistsHeadingLabel.text = "L"
                self.assistsLabel.text = String(stats.losses)
                self.pointsLabel.text = "OT"
                self.pointsLabel.text = String(stats.ot)
                self.plusminusHeadingLabel.text = "GAA"
                self.plusminusLabel.text = String(stats.goalAgainstAverage)
                self.pimHeadingLabel.text = "SV%"
                self.pimLabel.text = String(stats.savePercentage)
            } else {
                if error != nil {
                    self.showAlert()
                } else {
                    // goalie has no stats for the current season
                    self.setNoStats()
                }
                
            }
        }
    }
    
}
