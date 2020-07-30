//
//  PlayerResponse.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-07-30.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation

struct PlayerResponse: Codable {
    struct PlayerInfo: Codable {
        struct Team: Codable {
            let id: Int
            let name: String
            let link: String
        }
        let id: Int
        let fullName: String
        let link: String
        let firstName: String
        let lastName: String
        let primaryNumber: String
        let birthDate: String
        let currentAge: Int
        let birthCity: String
        let birthStateProvince: String
        let birthCountry: String
        let nationality: String
        let height: String
        let weight: Int
        let active: Bool
        let alternateCaptain: Bool
        let captain: Bool
        let rookie: Bool
        let shootsCatches: String
        let rosterStatus: String
        let currentTeam: Team
        let primaryPosition: Position
    }
    
    let copyright: String
    let people: [PlayerInfo]
}
