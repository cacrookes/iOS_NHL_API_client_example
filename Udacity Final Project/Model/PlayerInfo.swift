//
//  PlayerInfo.swift
//  Udacity Final Project
//
//  Created on 2020-07-31.
//

import Foundation

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
    let primaryNumber: String?
    let birthDate: String
    let currentAge: Int
    let birthCity: String
    let birthStateProvince: String?
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
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        fullName = try values.decode(String.self, forKey: .fullName)
        link = try values.decode(String.self, forKey: .link)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
       
        birthDate = try values.decode(String.self, forKey: .birthDate)
        currentAge = try values.decode(Int.self, forKey: .currentAge)
        birthCity = try values.decode(String.self, forKey: .birthCity)
        birthCountry = try values.decode(String.self, forKey: .birthCountry)
        nationality = try values.decode(String.self, forKey: .nationality)
        height = try values.decode(String.self, forKey: .height)
        weight = try values.decode(Int.self, forKey: .weight)
        active = try values.decode(Bool.self, forKey: .active)
        alternateCaptain = try values.decode(Bool.self, forKey: .alternateCaptain)
        captain = try values.decode(Bool.self, forKey: .captain)
        rookie = try values.decode(Bool.self, forKey: .rookie)
        shootsCatches = try values.decode(String.self, forKey: .shootsCatches)
        rosterStatus = try values.decode(String.self, forKey: .rosterStatus)
        currentTeam = try values.decode(PlayerInfo.Team.self, forKey: .currentTeam)
        primaryPosition = try values.decode(Position.self, forKey: .primaryPosition)
        
        // optionals
        primaryNumber = try values.decodeIfPresent(String.self, forKey: .primaryNumber)
        birthStateProvince = try values.decodeIfPresent(String.self, forKey: .birthStateProvince)
    }
}
