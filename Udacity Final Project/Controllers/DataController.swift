//
//  DataController.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-07-30.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation
import CoreData

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
    
    
    func updateTeams() {
        print("Update Teams called")
        // Delete existing team objects. This will cascade and delete player objects too.
        deleteAll(from: "Team")
        
        // retrieve teams from API
        NHLClient.getTeamList { (teamsFromApi, error) in
            for apiTeam in teamsFromApi {
                self.storeTeam(apiTeam, in: nil)
            }
        }
        
        UserDefaults.standard.set(Date(), forKey: K.UserDefaultValues.lastUpdateDate)
    }
    
    func fetchTeams() -> [Team] {
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        var results:[Team] = []
        do {
            results = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error fetching teams from Core Data: \(error)")
        }
        return results
    }
    
    fileprivate func getTeamById(_ id: Int) -> Team? {
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
    
    fileprivate func storeTeam(_ apiTeam: TeamListResponse.Team, in dataTeam: Team?){
        let dataTeam = dataTeam ?? Team(context: persistentContainer.viewContext)
        dataTeam.abbreviation = apiTeam.abbreviation
        dataTeam.city = apiTeam.locationName
        dataTeam.conference  = apiTeam.conference.name
        dataTeam.division = apiTeam.division.name
        dataTeam.id = Int16(apiTeam.id)
        dataTeam.lastUpdated = Date()
        dataTeam.name = apiTeam.name
        dataTeam.officialSite = apiTeam.officialSiteUrl
        dataTeam.teamName = apiTeam.teamName
        dataTeam.venue = apiTeam.venue.name
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Error saving team: \(error)")
        }
    }
}

