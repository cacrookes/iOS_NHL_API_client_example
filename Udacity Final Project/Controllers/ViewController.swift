//
//  ViewController.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-07-27.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate func printTeams() {
        
        NHLClient.getTeamList { (teams, error) in
            print(teams.count)
            for team in teams{
                print(team.name)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        printPlayerStats()
    }
    


}

