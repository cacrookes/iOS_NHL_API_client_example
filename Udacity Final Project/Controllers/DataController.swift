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
    
    // based on examples in https://stackoverflow.com/questions/24658641/ios-delete-all-core-data-swift/38449688
    func deleteAll(from entity: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        do {
            let results = try persistentContainer.viewContext.fetch(request)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                persistentContainer.viewContext.delete(objectData)
            }
        } catch {
            print("Error deleting data from \(entity): \(error)")
        }
    }
    
    func deleteRoster(forTeam team: Team) {
        let request: NSFetchRequest<Player> = Player.fetchRequest()
        do {
            request.predicate = NSPredicate(format: "team == %@", team)
            let players = try persistentContainer.viewContext.fetch(request)
            for player in players {
                persistentContainer.viewContext.delete(player)
            }
        } catch {
            print("Error deleting roster: \(error)")
        }
    }
    
    func updateTeams() {
        print("Update Teams called")
        // Delete existing team objects. This will cascade and delete player objects too.
        deleteAll(from: "Team")
        
        // retrieve teams from API
        NHLClient.getTeamList { (teamsFromApi, error) in
            for apiTeam in teamsFromApi {
                _ = self.storeTeam(apiTeam, in: nil)
            }
        }
        
        UserDefaults.standard.set(Date(), forKey: K.UserDefaultValues.lastUpdateDate)
    }
    
    func updateRoster(forTeam team: Team, completion: @escaping(Error?)->Void) {
        //deleteRoster(forTeam: team)
        // retrieve roster from API
        NHLClient.getTeamRoster(forTeamID: Int(team.id)) { (playersFromApi, error) in
            if error != nil {
                completion(error)
            } else {
                var callbackCount = playersFromApi.count
                for apiPlayer in playersFromApi {
                    self.getPlayer(apiPlayer.person.id) { (player, error) in
                        callbackCount -= 1
                        if error != nil {
                            completion(error)
                        } else if callbackCount == 0 {
                            team.lastUpdated = Date()
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    func getTeams() -> [Team] {
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        var results:[Team] = []
        do {
            results = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error fetching teams from Core Data: \(error)")
        }
        return results
    }
    
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
        dataPlayer.primaryNumber = Int16(apiPlayer.primaryNumber) ?? 0
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
    
    fileprivate func storeTeam(_ apiTeam: TeamListResponse.Team, in dataTeam: Team?) -> Team?{
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
        } catch {
            print("Error saving team: \(error)")
            return nil
        }
        return dataTeam
    }
}

