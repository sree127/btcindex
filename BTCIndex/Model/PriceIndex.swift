//
//  PriceIndex.swift
//  BTCIndex
//
//  Created by Sreejith N on 12/12/17.
//  Copyright © 2017 Sreejith N. All rights reserved.
//

import Foundation

/// Model class for Codable PriceIndices and Historical Data

/// PriceIndices
struct PriceIndices: Decodable {
    let ask : Double
    let bid : Double
    let last : Double
    let high : Double
    let low : Double
    let open : Open
    let averages : Averages
    let volume : Double
    let changes : Changes
    let volume_percent : Double
    let timestamp : Int
    let display_timestamp : String
}

struct Averages: Decodable {
    let day : Double
    let week : Double
    let month : Double
}

struct Open: Decodable {
    var day: Double
    var hour: Double
    var month: Double
    var month_3: Double
    var month_6: Double
    var week: Double
    var year: Double
}

struct Changes: Decodable {
    var percent: Open
    var price: Open
}


/// For Historical Data - Daily, Monthly & Alltime
struct MonthlyHistory: Codable {
    var high: Double
    var open: Double
    var time: String
    var average: Double
    var low: Double
}

struct DailyHistory: Codable {
    var time: String
    var average: Double
}

/// Using manual coding keys because the API response for AllTime data sometimes doensn't include
/// some keys and also the Double Values gets mapped to String values
/// Data mapping solved using try-catch blocks
struct AllTimeHistory: Codable {
    var high: Double?
    var open: Double?
    var time: String
    var average: Double
    var volume: Double?
    var low: Double?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        average = try container.decode(Double.self, forKey: CodingKeys.average)
        time = try container.decode(String.self, forKey: CodingKeys.time)
        // First check for a Double
        do {
            open = try container.decode(Double.self, forKey: CodingKeys.open)
        } catch DecodingError.typeMismatch {
            if let typeValue = Double(try container.decode(String.self, forKey: CodingKeys.open)) {
                open = typeValue
            }
        }
        do {
            high = try container.decode(Double.self, forKey: CodingKeys.high)
        } catch DecodingError.typeMismatch {
            if let typeValue = Double(try container.decode(String.self, forKey: CodingKeys.high)) {
                high = typeValue
            }
        }
        do {
            low = try container.decode(Double.self, forKey: CodingKeys.low)
        } catch DecodingError.typeMismatch {
            if let typeValue = Double(try container.decode(String.self, forKey: CodingKeys.low)) {
                low = typeValue
            }
        }
        do {
            volume = try container.decode(Double.self, forKey: CodingKeys.volume)
        } catch DecodingError.typeMismatch {
            if let typeValue = Double(try container.decode(String.self, forKey: CodingKeys.volume)) {
                volume = typeValue
            }
        }
    }
}

