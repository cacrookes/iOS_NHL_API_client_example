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
    let attributesByTeam = [
        "ANA": ["primaryHexColour":"#8C2633"],
        "ARI": ["primaryHexColour":"#8C2633"],
        "BOS": ["primaryHexColour":"#8C2633"],
        "BUF": ["primaryHexColour":"#8C2633"],
        "CAR": ["primaryHexColour":"#8C2633"],
        "CBJ": ["primaryHexColour":"#8C2633"],
        "CGY": ["primaryHexColour":"#8C2633"],
        "CHI": ["primaryHexColour":"#8C2633"],
        "COL": ["primaryHexColour":"#8C2633"],
        "DAL": ["primaryHexColour":"#8C2633"],
        "DET": ["primaryHexColour":"#8C2633"],
        "EDM": ["primaryHexColour":"#8C2633"],
        "FLA": ["primaryHexColour":"#8C2633"],
        "LAK": ["primaryHexColour":"#8C2633"],
        "MIN": ["primaryHexColour":"#8C2633"],
        "MTL": ["primaryHexColour":"#8C2633"],
        "NHL": ["primaryHexColour":"#8C2633"],
        "NJD": ["primaryHexColour":"#8C2633"],
        "NSH": ["primaryHexColour":"#8C2633"],
        "NYI": ["primaryHexColour":"#8C2633"],
        "NYR": ["primaryHexColour":"#8C2633"],
        "OTT": ["primaryHexColour":"#8C2633"],
        "PHI": ["primaryHexColour":"#8C2633"],
        "PIT": ["primaryHexColour":"#8C2633"],
        "SJS": ["primaryHexColour":"#8C2633"],
        "STL": ["primaryHexColour":"#8C2633"],
        "TBL": ["primaryHexColour":"#8C2633"],
        "TOR": ["primaryHexColour":"#8C2633"],
        "VAN": ["primaryHexColour":"#8C2633"],
        "VGK": ["primaryHexColour":"#8C2633"],
        "WPG": ["primaryHexColour":"#8C2633"],
        "WSH": ["primaryHexColour":"#8C2633"]
    ]
    
    // this function is inspired by:
    // https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
    fileprivate func getUIColorFromHex(_ hex: String) -> UIColor? {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    return UIColor(red: r, green: g, blue: b, alpha: a)
                    
                }
            }
        }
        
        return nil
    }
    
    func getTeamPrimaryColour(forTeamAbbreviation team: String) -> UIColor {
        let hex = attributesByTeam[team]?["primaryHexColour"] ?? "#ffffff"
        return getUIColorFromHex(hex) ?? .white
    }
    

}
