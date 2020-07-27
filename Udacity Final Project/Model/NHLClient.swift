//
//  NHLClient.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-07-27.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation

class NHLClient {
    
    enum Endpoints {
        static let base = "https://statsapi.web.nhl.com/api/v1"
        
        case getAllTeams
        case getTeamRoster(Int)
        case getPlayerInfo(Int)
        case getPlayerStats(Int)
        
        var stringValue: String {
            switch self{
            case .getAllTeams:
                return Endpoints.base + "/teams"
            case .getTeamRoster(let teamID):
                return Endpoints.base + "/teams/\(teamID)/roster"
            case .getPlayerInfo(let playerID):
                return Endpoints.base + "/people/\(playerID)"
            case .getPlayerStats(let playerID):
                return Endpoints.base + "/people/\(playerID)/stats?stats=statsSingleSeason&season=20192020"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
}
