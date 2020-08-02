//
//  PlayerDetailViewController.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-08-01.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit

class PlayerDetailViewController: UIViewController {

    var dataController: DataController!
    var player: Player!
    
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
    
    @IBOutlet weak var gpHeadingLabel: UILabel!
    @IBOutlet weak var goalsHeadingLabel: UILabel!
    @IBOutlet weak var assistsHeadingLabel: UILabel!
    @IBOutlet weak var pointsHeadingLabel: UILabel!
    @IBOutlet weak var plusminusHeadingLabel: UILabel!
    @IBOutlet weak var pimHeadingLabel: UILabel!
    
    
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
    }
    
    fileprivate func setPlayerStats() {
        NHLClient.getPlayerStats(forPlayerID: Int(player.id), forSeason: "20192020") { (stats, error) in
            if let stats = stats {
                self.gpLabel.text = String(stats.games)
                self.goalsLabel.text = String(stats.goals)
                self.assistsLabel.text = String(stats.assists)
                self.pointsLabel.text = String(stats.points)
                self.plusminusLabel.text = String(stats.plusMinus)
                self.pimLabel.text = String(stats.pim)
            } else {
                print(error!)
            }
        }
    }
    
    fileprivate func setGoalieStats() {
        NHLClient.getGoalieStats(forPlayerID: Int(player.id), forSeason: "20192020") { (stats, error) in
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
                print(error!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = player.name ?? "No Name"
        setTopLabel()
        setSubHeading()
        
        if player.primaryPosition == "Goalie" {
            setGoalieStats()
        } else {
            setPlayerStats()
        }
    }

}
