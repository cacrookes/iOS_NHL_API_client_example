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
        case getPlayerStats(Int, String)
        
        var stringValue: String {
            switch self{
            case .getAllTeams:
                return Endpoints.base + "/teams"
            case .getTeamRoster(let teamID):
                return Endpoints.base + "/teams/\(teamID)/roster"
            case .getPlayerInfo(let playerID):
                return Endpoints.base + "/people/\(playerID)"
            case .getPlayerStats(let playerID, let season):
                return Endpoints.base + "/people/\(playerID)/stats?stats=statsSingleSeason&season=\(season)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(error)
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func getTeamList(completion: @escaping ([TeamListResponse.Team]?, Error?) -> Void){
        _ = taskForGETRequest(url: Endpoints.getAllTeams.url, responseType: TeamListResponse.self) { (response, error) in
            if let response = response {
                completion(response.teams, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getTeamRoster(forTeamID teamID: Int, completion: @escaping ([RosterResponse.Player]?,Error?) -> Void){
        _ = taskForGETRequest(url: Endpoints.getTeamRoster(teamID).url, responseType: RosterResponse.self)  { (response, error) in
            if let response = response {
                completion(response.roster, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func getPlayerInfo(forPlayerID playerID: Int, completion: @escaping(PlayerInfo?, Error?) -> Void){
        _ = taskForGETRequest(url: Endpoints.getPlayerInfo(playerID).url, responseType: PlayerResponse.self, completion: { (response, error) in
            if let response = response {
                completion(response.people[0], nil)
            } else {
                completion(nil, error)
            }
        })
    }
    
    class func getPlayerStats(forPlayerID playerID: Int, forSeason season: String, completion: @escaping(SingleSeasonStatsResponse.Stats.Splits.Stat?, Error?) -> Void) {
        _ = taskForGETRequest(url: Endpoints.getPlayerStats(playerID, season).url, responseType: SingleSeasonStatsResponse.self, completion: { (response, error) in
            if let response = response {
                // handle case where player has no stats for the given year
                if response.stats[0].splits.count == 0 {
                    completion(nil, nil)
                } else {
                    completion(response.stats[0].splits[0].stat, nil)
                }
            } else {
                completion(nil, error)
            }
        })
    }
    
    class func getGoalieStats(forPlayerID playerID: Int, forSeason season: String, completion: @escaping(SingleSeasonGoalieStatsResponse.Stats.Splits.Stat?, Error?) -> Void) {
        _ = taskForGETRequest(url: Endpoints.getPlayerStats(playerID, season).url, responseType: SingleSeasonGoalieStatsResponse.self, completion: { (response, error) in
            if let response = response {
                completion(response.stats[0].splits[0].stat, nil)
            } else {
                completion(nil, error)
            }
        })
    }
    
}
