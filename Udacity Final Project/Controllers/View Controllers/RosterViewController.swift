//
//  RosterViewController.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-08-01.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit

class RosterViewController: UIViewController {

    var dataController: DataController!
    var team: Team!
    
    @IBOutlet weak var rosterTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = team.teamName ?? ""
    }
    

}

extension RosterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifiers.rosterTableViewCell)!
        
        return cell
    }
    
    
}
