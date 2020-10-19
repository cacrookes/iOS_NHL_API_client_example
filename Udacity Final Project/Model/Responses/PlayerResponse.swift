//
//  PlayerResponse.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-07-30.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation

// Codable struct to store info JSON returned from https://statsapi.web.nhl.com/api/v1/teams/<teamID>/roster
struct PlayerResponse: Codable {
    
    let copyright: String
    let people: [PlayerInfo]
}
