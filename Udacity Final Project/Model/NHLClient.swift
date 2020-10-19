//
//  NHLClient.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-07-27.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation

// Client used to handle requests to the NHL API.
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
    
    // Handles generic get requests.
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
    
    /// Returns a list of all NHL teams via a completion handler.
    /// - Parameter completion: a completion handler that includes parameters for an optional list of TeamListResponse.Team, and an optional error.
    class func getTeamList(completion: @escaping ([TeamListResponse.Team]?, Error?) -> Void){
        _ = taskForGETRequest(url: Endpoints.getAllTeams.url, responseType: TeamListResponse.self) { (response, error) in
            if let response = response {
                completion(response.teams, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    /// Returns the roster for a given team via a completion handler.
    /// - Parameters:
    ///     - forTeamID: an Int representing the id of the team whose roster is to be retrieved.
    ///     - completion: a completion handler that accepts an optional list of RosterResponse.Player and an option Error.
    class func getTeamRoster(forTeamID teamID: Int, completion: @escaping ([RosterResponse.Player]?,Error?) -> Void){
        _ = taskForGETRequest(url: Endpoints.getTeamRoster(teamID).url, responseType: RosterResponse.self)  { (response, error) in
            if let response = response {
                completion(response.roster, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    /// Returns info for a specified player via a completion handler.
    /// - Parameters:
    ///     - forPlayerID: an Int representing the id of the player whose information is to be retrieved.
    ///     - completion: a completion handler that accepts an optional PlayerInfo and an option Error.
    class func getPlayerInfo(forPlayerID playerID: Int, completion: @escaping(PlayerInfo?, Error?) -> Void){
        _ = taskForGETRequest(url: Endpoints.getPlayerInfo(playerID).url, responseType: PlayerResponse.self, completion: { (response, error) in
            if let response = response {
                completion(response.people[0], nil)
            } else {
                completion(nil, error)
            }
        })
    }
    
    /// Returns a specified player's stats for a given season via a completion handler. For goalie stats, use getGoalieStats instead.
    /// - Parameters:
    ///     - forPlayerID: an Int that specifies the id of the player whose stats are to be retrieved.
    ///     - forSeason: a string specfying the season for the stats to be retrieved. e.g. for the 2019-2020 season, this will be set to "20192020"
    ///     - completion: a completion handler that accepts an optional SingleSeasonStatsResponse.Stats.Splits.Stat and an option Error.
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
    
    /// Returns a specified goalie's stats for a given season via a completion handler.
    /// - Parameters:
    ///     - forPlayerID: an Int that specifies the id of the goalie whose stats are to be retrieved.
    ///     - forSeason: a string specfying the season for the stats to be retrieved. e.g. for the 2019-2020 season, this will be set to "20192020"
    ///     - completion: a completion handler that accepts an optional SingleSeasonStatsResponse.Stats.Splits.Stat and an option Error.
    class func getGoalieStats(forPlayerID playerID: Int, forSeason season: String, completion: @escaping(SingleSeasonGoalieStatsResponse.Stats.Splits.Stat?, Error?) -> Void) {
        _ = taskForGETRequest(url: Endpoints.getPlayerStats(playerID, season).url, responseType: SingleSeasonGoalieStatsResponse.self, completion: { (response, error) in
            if let response = response {
                // handle case where goalie has no stats for the given year
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
    
}
