//
//  TeamListViewController.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-07-31.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit
import CoreData

class TeamListViewController: UIViewController {

    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<Team>!
    fileprivate var selectedRow: IndexPath?
    
    @IBOutlet weak var teamListTableView: UITableView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamListTableView.delegate = self
        teamListTableView.dataSource = self
        
        setupFetchedResultsContainer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // TODO: set controller to nil when view is dismissed
        //fetchedResultsController = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifiers.teamListToRosterSegue {
            if let destination = segue.destination as? RosterViewController {
                destination.team = fetchedResultsController.object(at: selectedRow!)
                destination.dataController = dataController
            }
        }
    }
    
    fileprivate func setupFetchedResultsContainer() {
        let fetchRequest:NSFetchRequest<Team> = Team.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: "team-list")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed.")
        }
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource methods
extension TeamListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numResults = fetchedResultsController.sections?[section].numberOfObjects ?? 0
        return numResults
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let team = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifiers.teamTableViewCell)!
        
        let logoName = "\(team.abbreviation?.lowercased() ?? "nhl").png"
        cell.imageView?.image = UIImage(imageLiteralResourceName: logoName)
        cell.textLabel?.text = team.name ?? "Team Name Mising"
        cell.contentView.backgroundColor = TeamAttributes.getTeamPrimaryColour(forTeamAbbreviation: team.abbreviation ?? "NHL")
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath
        performSegue(withIdentifier: K.Identifiers.teamListToRosterSegue, sender: self)
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate methods
extension TeamListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            teamListTableView.insertRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type{
        case .insert:
            teamListTableView.insertSections(indexSet, with: .automatic)
        default:
            break
        }
    }
    

}

// MARK: - DataControllerDelegate methods
extension TeamListViewController: DataControllerDelegate {
    func setDataController(dataController: DataController) {
        self.dataController = dataController
    }
}
