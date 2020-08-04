//
//  TeamAttributes.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-08-01.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct TeamAttributes {
    static let attributesByTeam = [
        "ANA": [
            "primaryHexColour":"#F47A38",
            "latitude": 33.807419,
            "longitude": -117.876556
        ],
        "ARI": [
            "primaryHexColour":"#8C2633",
            "latitude": 33.532580,
            "longitude": -112.261270
        ],
        "BOS": [
            "primaryHexColour":"#FFB81C",
            "latitude": 42.366970,
            "longitude": -71.061989
        ],
        "BUF": [
            "primaryHexColour":"#002654",
            "latitude": 42.873910,
            "longitude": -78.875990
        ],
        "CAR": [
            "primaryHexColour":"#CC0000",
            "latitude": 35.804211,
            "longitude": -78.726486
        ],
        "CBJ": [
            "primaryHexColour":"#002654",
            "latitude": 39.9691873,
            "longitude": -83.00608
        ],
        "CGY": [
            "primaryHexColour":"#C8102E",
            "latitude": 51.0374124,
            "longitude": -114.0519642
        ],
        "CHI": [
            "primaryHexColour":"#CF0A2C",
            "latitude": 41.8806831,
            "longitude": -87.6741851
        ],
        "COL": [
            "primaryHexColour":"#6F263D",
            "latitude": 39.74835968017578,
            "longitude": -105.00650024414062
        ],
        "DAL": [
            "primaryHexColour":"#006847",
            "latitude": 32.7905076,
            "longitude": -96.8102721
        ],
        "DET": [
            "primaryHexColour":"#CE1126",
            "latitude": 42.3419423,
            "longitude": -83.0543609
        ],
        "EDM": [
            "primaryHexColour":"#041E42",
            "latitude": 53.5467936,
            "longitude": -113.4977946
        ],
        "FLA": [
            "primaryHexColour":"#041E42",
            "latitude": 26.145757,
            "longitude": -80.298062
        ],
        "LAK": [
            "primaryHexColour":"#111111",
            "latitude": 33.9600377,
            "longitude": -118.2827169
        ],
        "MIN": [
            "primaryHexColour":"#A6192E",
            "latitude": 44.9433371,
            "longitude": -93.0993324
        ],
        "MTL": [
            "primaryHexColour":"#AF1E2D",
            "latitude": 45.4968995,
            "longitude": -73.5696547
        ],
        "NHL": [
            "primaryHexColour":"#A2AAAD",
            "latitude": 40.758044,
            "longitude": -73.9822212
        ],
        "NJD": [
            "primaryHexColour":"#CE1126",
            "latitude": 40.7334047,
            "longitude": -74.1711646
        ],
        "NSH": [
            "primaryHexColour":"#FFB81C",
            "latitude": 36.159869,
            "longitude": -86.779637
        ],
        "NYI": [
            "primaryHexColour":"#00539B",
            "latitude": 40.7141109,
            "longitude": -73.6037403
        ],
        "NYR": [
            "primaryHexColour":"#0038A8",
            "latitude": 40.7505247,
            "longitude": -73.9935503
        ],
        "OTT": [
            "primaryHexColour":"#C52032",
            "latitude": 45.2969069,
            "longitude": -75.9268973
        ],
        "PHI": [
            "primaryHexColour":"#F74902",
            "latitude": 39.9292503,
            "longitude": -75.1685534
        ],
        "PIT": [
            "primaryHexColour":"#000000",
            "latitude": 40.43877029418945,
            "longitude": -79.99016571044922
        ],
        "SJS": [
            "primaryHexColour":"#006D75",
            "latitude": 37.332008361816406,
            "longitude": -121.90171813964844
        ],
        "STL": [
            "primaryHexColour":"#002F87",
            "latitude": 38.6268084,
            "longitude": -90.2026393
        ],
        "TBL": [
            "primaryHexColour":"#002868",
            "latitude": 27.942704,
            "longitude": -82.4518903
        ],
        "TOR": [
            "primaryHexColour":"#00205B",
            "latitude": 43.643448,
            "longitude": -79.379005
        ],
        "VAN": [
            "primaryHexColour":"#00205B",
            "latitude": 49.277648,
            "longitude": -123.109074
        ],
        "VGK": [
            "primaryHexColour":"#B4975A",
            "latitude": 36.0680691,
            "longitude": -115.1722598
        ],
        "WPG": [
            "primaryHexColour":"#041E42",
            "latitude": 49.892724,
            "longitude": -97.143712
        ],
        "WSH": [
            "primaryHexColour":"#041E42",
            "latitude": 38.8981835,
            "longitude": -77.0209382
        ]
    ]
    
    // this function is inspired by:
    // https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
    fileprivate static func getUIColorFromHex(_ hex: String) -> UIColor? {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            var hexColor = String(hex[start...])
            // Add alpha channel to hex code if missing
            if hexColor.count == 6 {
                hexColor.append("F")
                hexColor.append("F")
            }
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(1.0)
                    
                    return UIColor(red: r, green: g, blue: b, alpha: a)
                    
                }
            }
        }
        
        return nil
    }
    
    static func getTeamPrimaryColour(forTeamAbbreviation team: String) -> UIColor {
        let hex = attributesByTeam[team]?["primaryHexColour"] as? String ?? "#FFFFFFFF"
        return getUIColorFromHex(hex) ?? .white
    }
    
    static func getTeamCoordinates(forTeamAbbreviation team: String) -> CLLocationCoordinate2D {
        let latitude = attributesByTeam[team]?["latitude"] as! Double
        let longitude = attributesByTeam[team]?["longitude"] as! Double
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

}
