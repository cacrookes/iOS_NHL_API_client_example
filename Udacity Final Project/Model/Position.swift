//
//  Position.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-07-30.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation

// This struct is used by PlayerInfo to store position data for a player.
struct Position: Codable {
    let code: String
    let name: String
    let type: String
    let abbreviation: String
}
