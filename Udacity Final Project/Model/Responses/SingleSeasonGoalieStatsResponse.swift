//
//  SingleSeasonGoalieStatsResponse.swift
//  Udacity Final Project
//
//  Created on 2020-08-01.
//

import Foundation

struct SingleSeasonGoalieStatsResponse: Codable {
    struct Stats: Codable {
        struct StatsType: Codable {
            let displayName: String
        }
        struct Splits: Codable {
            struct Stat: Codable {
                let timeOnIce: String
                let ot: Int
                let shutouts: Int
                let ties: Int
                let wins: Int
                let losses: Int
                let saves: Int
                let powerPlaySaves: Int
                let shortHandedSaves: Int
                let evenSaves: Int
                let shortHandedShots: Int
                let evenShots: Int
                let powerPlayShots: Int
                let savePercentage: Double
                let goalAgainstAverage: Double
                let games: Int
                let gamesStarted: Int
                let shotsAgainst: Int
                let goalsAgainst: Int
                let timeOnIcePerGame: String
                let powerPlaySavePercentage: Double
                let shortHandedSavePercentage: Double
                let evenStrengthSavePercentage: Double
                
            }
            let season: String
            let stat: Stat
        }
        let type: StatsType
        let splits: [Splits]
    }
    let copyright: String
    let stats: [Stats]
}
