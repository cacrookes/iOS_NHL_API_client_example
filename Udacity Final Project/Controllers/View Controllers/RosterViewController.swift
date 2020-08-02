//
//  RosterViewController.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-08-01.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit
import CoreData

class RosterViewController: UIViewController {

    var dataController: DataController!
    var team: Team!
    var fetchedResultsController: NSFetchedResultsController<Player>!
    fileprivate var selectedPlayer: Player?
    fileprivate var favePlayerIds = [Int]()
    
    @IBOutlet weak var rosterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = team.teamName ?? ""
        
        rosterTableView.dataSource = self
        rosterTableView.delegate = self
        
        
        
        // check if its been more than 1 day since the roster has been updated.
        // If so, grab roster info from NHL API.
        if let teamLastUpdated = team.lastUpdated {
            if teamLastUpdated.distance(to: Date()) > (60*60*24) {
                dataController.updateRoster(forTeam: team, completion: updateRosterHandler(error:))
            }
            setupFetchedResultsContainer()
        } else {
            dataController.updateRoster(forTeam: team, completion: updateRosterHandler(error:))
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifiers.rosterToPlayerSegue {
            if let playerDetailController = segue.destination as? PlayerDetailViewController {
                playerDetailController.dataController = dataController
                playerDetailController.player = selectedPlayer!
            }
        }
    }
    
    @IBAction func favouritesButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func loadFavePlayerIds(){
        favePlayerIds = UserDefaults.standard.array(forKey: K.UserDefaultValues.favouritePlayers)! as! [Int]
    }
    
    fileprivate func updateRosterHandler(error: Error?) -> Void {
        if error != nil {
            print(error!)
        } else {
            setupFetchedResultsContainer()
            rosterTableView.reloadData()
        }
    }

    fileprivate func setupFetchedResultsContainer() {
        let fetchRequest:NSFetchRequest<Player> = Player.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "team == %@", team)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "primaryNumber", ascending: true)]
    
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: "\(team.name!)-roster")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed.")
        }
    }
}

extension RosterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numResults = fetchedResultsController.sections?[section].numberOfObjects ?? 0
        return numResults
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let player = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifiers.rosterTableViewCell)!
        
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
        selectedPlayer = fetchedResultsController.object(at: indexPath)
        performSegue(withIdentifier: K.Identifiers.rosterToPlayerSegue, sender: self)
    }
    
    
}

extension RosterViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let safeIndexPath = indexPath else { return }
        switch type {
        case .insert:
            rosterTableView.insertRows(at: [safeIndexPath], with: .automatic)
        case .delete:
            rosterTableView.deleteRows(at: [safeIndexPath], with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type{
        case .insert:
            rosterTableView.insertSections(indexSet, with: .automatic)
        default:
            break
        }
    }
}
