//
//  RosterResponse.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-07-30.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation

struct RosterResponse: Codable {
    struct Player: Codable {
        struct Person: Codable {
            let id: Int
            let fullName: String
            let link: String
        }
        let person: Person
        let jerseyNumber: String?
        let position: Position
        
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            
            person = try values.decode(Person.self, forKey: .person)
            position = try values.decode(Position.self, forKey: .position)
            
            // optionals
            jerseyNumber = try values.decodeIfPresent(String.self, forKey: .jerseyNumber)
        }
    }
    let copyright: String
    let roster: [Player]
    let link: String
}
