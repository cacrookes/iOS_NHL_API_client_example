//
//  SingleSeasonStatsResponse.swift
//  Udacity Final Project
//
//  Created on 2020-07-30.
//

import Foundation

struct SingleSeasonStatsResponse: Codable {
    struct Stats: Codable {
        struct StatsType: Codable {
            let displayName: String
        }
        struct Splits: Codable {
            struct Stat: Codable {
                let timeOnIce: String
                let assists: Int
                let goals: Int
                let pim: Int
                let shots: Int
                let games: Int
                let hits: Int
                let powerPlayGoals: Int
                let powerPlayPoints: Int
                let powerPlayTimeOnIce: String
                let evenTimeOnIce: String
                let penaltyMinutes: String
                let faceOffPct: Double
                let shotPct: Double
                let gameWinningGoals: Int
                let overTimeGoals: Int
                let shortHandedGoals: Int
                let shortHandedPoints: Int
                let shortHandedTimeOnIce: String
                let blocked: Int
                let plusMinus: Int
                let points: Int
                let shifts: Int
                let timeOnIcePerGame: String
                let evenTimeOnIcePerGame: String
                let shortHandedTimeOnIcePerGame: String
                let powerPlayTimeOnIcePerGame: String
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
