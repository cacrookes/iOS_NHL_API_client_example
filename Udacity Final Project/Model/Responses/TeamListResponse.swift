//
//  TeamListResponse.swift
//  Udacity Final Project
//
//  Created on 2020-07-30.
//

import Foundation

struct TeamListResponse: Codable {
    struct Team: Codable {
        struct Venue: Codable {
            struct TimeZone: Codable {
                let id: String
                let offset: Int
                let tz: String
            }
            let name: String
            let link: String
            let timeZone: TimeZone
            
        }
        struct Division: Codable {
            let id: Int
            let name: String
            let nameShort: String
            let link: String
            let abbreviation: String
            
        }
        struct Conference: Codable {
            let id: Int
            let name: String
            let link: String
        }
        struct Franchise: Codable {
            let franchiseId: Int
            let teamName: String
            let link: String
        }
        let id: Int
        let name: String
        let link: String
        let venue: Venue
        let abbreviation: String
        let teamName: String
        let locationName: String
        let firstYearOfPlay: String
        let division: Division
        let conference: Conference
        let franchise: Franchise
        let shortName: String
        let officialSiteUrl: String
        let franchiseId: Int
        let active: Bool
    }
    
    let copyright: String
    let teams: [Team]
    
}
