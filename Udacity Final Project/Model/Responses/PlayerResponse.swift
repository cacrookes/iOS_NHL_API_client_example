//
//  PlayerResponse.swift
//  Udacity Final Project
//
//  Created on 2020-07-30.
//

import Foundation

struct PlayerResponse: Codable {
    
    let copyright: String
    let people: [PlayerInfo]
}
