//
//  DataController.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-07-30.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation
import CoreData

protocol DataControllerDelegate {
    func setDataController(dataController: DataController)
}

class DataController {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Udacity_Final_Project")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    // MARK: - Delete operations
    // based on examples in https://stackoverflow.com/questions/24658641/ios-delete-all-core-data-swift/38449688
    func deleteAll(from entity: String, completion: @escaping(Bool, Error?)->Void) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            let results = try persistentContainer.viewContext.fetch(request)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                persistentContainer.viewContext.delete(objectData)
            }
            completion(true, nil)
        } catch {
            completion(false, error)
        }
    }
    
    /// Deletes the roster for a given team. All players for the given team will be deleted from Core Data
    /// - Parameters:
    ///     - team: Team object whose roster players should be deleted.
    ///     - completion: Completion handler that indicates if the task was successful or not.
    func deleteRoster(forTeam team: Team, completion: @escaping(Bool, Error?)->Void) {
        let request: NSFetchRequest<Player> = Player.fetchRequest()
        do {
            request.predicate = NSPredicate(format: "team == %@", team)
            let players = try persistentContainer.viewContext.fetch(request)
            for player in players {
                persistentContainer.viewContext.delete(player)
                try persistentContainer.viewContext.save()
            }
            completion(true, nil)
        } catch {
            completion(false, error)
        }
    }
    
    // MARK: - Update operations
    /// Updates the list of teams in Core Data.
    /// - Parameter completion: completion handler that takes a `Bool` and an option `Error`.
    func updateTeams(completion: @escaping(Bool, Error?)->Void) {
        // Delete existing team objects. This will cascade and delete player objects too.
        deleteAll(from: "Team") { (success, error) in
            guard success else {
                completion(false, error)
                return
            }
            // retrieve teams from API
            NHLClient.getTeamList { (teamsFromApi, error) in
                guard let teamsFromApi = teamsFromApi else {
                    completion(false, error)
                    return
                }
                for apiTeam in teamsFromApi {
                    self.storeTeam(apiTeam, in: nil) { (success, error) in
                        guard success else {
                            completion(false, error)
                            return
                        }
                    }
                }
                UserDefaults.standard.set(Date(), forKey: K.UserDefaultValues.lastUpdateDate)
                completion(true, nil)
            }
        }
    }
    
    /// Stores the players for a given team in Core Data.
    /// - Parameters:
    ///     - team: A `Team` object representing the team whose roster players should be added to Core Data.
    ///     - completion: a completion handler that takes a `Bool` and optional `Error`
    func updateRoster(forTeam team: Team, completion: @escaping(Bool, Error?)->Void) {
        deleteRoster(forTeam: team) { (success, error) in
            guard success else {
                completion(false, error)
                return
            }
            
            // retrieve roster from API
            NHLClient.getTeamRoster(forTeamID: Int(team.id)) { (playersFromApi, error) in
                guard let playersFromApi = playersFromApi else {
                    completion(false, error)
                    return
                }
                var callbackCount = playersFromApi.count
                for apiPlayer in playersFromApi {
                    self.getPlayer(apiPlayer.person.id) { (player, error) in
                        callbackCount -= 1
                        guard player != nil else {
                            completion(false, error)
                            return
                        }
                        if callbackCount == 0 {
                            team.lastUpdated = Date()
                            completion(true, nil)
                        }
                    }
                }
                
            }
        }
    }
    
    // MARK: - Get operations
    /// Retrieves a list of teams stored in Core Data via a completion handler.
    /// - Parameter completion: completion handler that takes an option list of `Team` and an optional `Error`
    func getTeams(completion: ([Team]?, Error?)->Void){
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        var results:[Team] = []
        do {
            results = try persistentContainer.viewContext.fetch(request)
            completion(results, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    /// Retrieves data for a given player via a completion handler.
    /// - Parameters:
    ///     - id: an `Int` representing the id of the player whose data is to be retrieved.
    ///     - completion: a completion handler that takes an option `Player` and an optional `Error`
    func getPlayer(_ id: Int, completion: @escaping(Player?, Error?)->Void) {
        if let player = fetchPlayerById(id) {
            completion(player, nil)
        } else {
            // player is not in database, so try grabbing from API
            var results:Player?
            NHLClient.getPlayerInfo(forPlayerID: id) { (response, error) in
                if error != nil {
                    completion(nil, error)
                } else {
                    do {
                        results = try self.storePlayer(response!, in: nil)
                    } catch {
                        completion(nil, error)
                    }
                    completion(results, nil)
                }
            }
        }
    }
    
    // MARK: - Private helper functions
    fileprivate func fetchPlayerById(_ id: Int) -> Player? {
        let request: NSFetchRequest<Player> = Player.fetchRequest()
        let predicate = NSPredicate(format: "id == %i", id)
        request.predicate = predicate
        request.fetchLimit = 1
        var results:[Player] = []
        do {
            results = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error retrieving player from Core Data: \(error)")
        }
        return results.count > 0 ? results.first : nil
    }
    
    fileprivate func fetchTeamById(_ id: Int) -> Team? {
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        let predicate = NSPredicate(format: "id == %i", id)
        request.predicate = predicate
        request.fetchLimit = 1
        var results:[Team] = []
        do {
            results = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error retrieving team from Core Data: \(error)")
        }
        return results.count > 0 ? results.first : nil
    }
        
    fileprivate func storePlayer(_ apiPlayer: PlayerInfo, in dataPlayer: Player?) throws -> Player{
        let dataPlayer = dataPlayer ?? Player(context: persistentContainer.viewContext)
        dataPlayer.active = apiPlayer.active
        dataPlayer.alternateCaptain = apiPlayer.alternateCaptain
        dataPlayer.birthCity = apiPlayer.birthCity
        dataPlayer.birthCountry = apiPlayer.birthCountry
        dataPlayer.birthDate = apiPlayer.birthDate
        dataPlayer.birthStateProvince = apiPlayer.birthStateProvince
        dataPlayer.captain = apiPlayer.captain
        dataPlayer.currentAge = Int16(apiPlayer.currentAge)
        dataPlayer.firstName = apiPlayer.firstName
        dataPlayer.height = apiPlayer.height
        dataPlayer.id = Int32(apiPlayer.id)
        dataPlayer.lastName = apiPlayer.lastName
        dataPlayer.lastUpdated = Date()
        dataPlayer.name = apiPlayer.fullName
        dataPlayer.nationality = apiPlayer.nationality
        let primaryNumber = apiPlayer.primaryNumber ?? "0"
        dataPlayer.primaryNumber = Int16(primaryNumber) ?? 0
        dataPlayer.primaryPosition = apiPlayer.primaryPosition.name
        dataPlayer.rookie = apiPlayer.rookie
        dataPlayer.rosterStatus = apiPlayer.rosterStatus
        dataPlayer.shootsCatches = apiPlayer.shootsCatches
        dataPlayer.team = fetchTeamById(apiPlayer.currentTeam.id)
        dataPlayer.weight = Int16(apiPlayer.weight)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            throw error
        }
        return dataPlayer
    }
    
    fileprivate func storeTeam(_ apiTeam: TeamListResponse.Team, in dataTeam: Team?, completion: (Bool, Error?)->Void) {
        let dataTeam = dataTeam ?? Team(context: persistentContainer.viewContext)
        dataTeam.abbreviation = apiTeam.abbreviation
        dataTeam.city = apiTeam.locationName
        dataTeam.conference  = apiTeam.conference.name
        dataTeam.division = apiTeam.division.name
        dataTeam.id = Int16(apiTeam.id)
        dataTeam.name = apiTeam.name
        dataTeam.officialSite = apiTeam.officialSiteUrl
        dataTeam.teamName = apiTeam.teamName
        dataTeam.venue = apiTeam.venue.name
        do {
            try persistentContainer.viewContext.save()
            completion(true, nil)
        } catch {
            completion(false, error)
        }
    }
}

