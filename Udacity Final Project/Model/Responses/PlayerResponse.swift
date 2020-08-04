//
//  PlayerResponse.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-07-30.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation

struct PlayerResponse: Codable {
    
    let copyright: String
    let people: [PlayerInfo]
}
