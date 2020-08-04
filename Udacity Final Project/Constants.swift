//
//  Constants.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-07-30.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation

struct K {
    struct UserDefaultValues {
        static let hasLaunchedBefore = "hasLaunchedBefore"
        static let lastUpdateDate = "lastUpdateDate"
        static let favouritePlayers = "favouritePlayers"
    }
    struct Identifiers {
        static let favouritePlayerTableViewCell = "FavouritePlayerTableViewCell"
        static let teamTableViewCell = "TeamTableViewCell"
        static let rosterTableViewCell = "RosterTableViewCell"
        static let favesToTeamSegue = "favesToTeamSegue"
        static let teamListToRosterSegue = "teamListToRosterSegue"
        static let teamMapToRosterSegue = "teamMapToRosterSegue"
        static let rosterToPlayerSegue = "rosterToPlayerSegue"
        static let favesToPlayerSegue = "favesToPlayerSegue"
    }
}
