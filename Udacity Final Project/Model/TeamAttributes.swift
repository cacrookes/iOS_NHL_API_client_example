//
//  TeamAttributes.swift
//  Udacity Final Project
//
//  Created by Christopher Crookes on 2020-08-01.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation
import UIKit

struct TeamAttributes {
    static let attributesByTeam = [
        "ANA": ["primaryHexColour":"#F47A38"],
        "ARI": ["primaryHexColour":"#8C2633"],
        "BOS": ["primaryHexColour":"#FFB81C"],
        "BUF": ["primaryHexColour":"#002654"],
        "CAR": ["primaryHexColour":"#CC0000"],
        "CBJ": ["primaryHexColour":"#002654"],
        "CGY": ["primaryHexColour":"#C8102E"],
        "CHI": ["primaryHexColour":"#CF0A2C"],
        "COL": ["primaryHexColour":"#6F263D"],
        "DAL": ["primaryHexColour":"#006847"],
        "DET": ["primaryHexColour":"#CE1126"],
        "EDM": ["primaryHexColour":"#041E42"],
        "FLA": ["primaryHexColour":"#041E42"],
        "LAK": ["primaryHexColour":"#111111"],
        "MIN": ["primaryHexColour":"#A6192E"],
        "MTL": ["primaryHexColour":"#AF1E2D"],
        "NHL": ["primaryHexColour":"#A2AAAD"],
        "NJD": ["primaryHexColour":"#CE1126"],
        "NSH": ["primaryHexColour":"#FFB81C"],
        "NYI": ["primaryHexColour":"#00539B"],
        "NYR": ["primaryHexColour":"#0038A8"],
        "OTT": ["primaryHexColour":"#C52032"],
        "PHI": ["primaryHexColour":"#F74902"],
        "PIT": ["primaryHexColour":"#000000"],
        "SJS": ["primaryHexColour":"#006D75"],
        "STL": ["primaryHexColour":"#002F87"],
        "TBL": ["primaryHexColour":"#002868"],
        "TOR": ["primaryHexColour":"#00205B"],
        "VAN": ["primaryHexColour":"#00205B"],
        "VGK": ["primaryHexColour":"#B4975A"],
        "WPG": ["primaryHexColour":"#041E42"],
        "WSH": ["primaryHexColour":"#041E42"]
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
        let hex = attributesByTeam[team]?["primaryHexColour"] ?? "#FFFFFFFF"
        return getUIColorFromHex(hex) ?? .white
    }
    

}
