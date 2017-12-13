//
//  PriceIndex.swift
//  BTCIndex
//
//  Created by Sreejith N on 12/12/17.
//  Copyright © 2017 Sreejith N. All rights reserved.
//

import Foundation

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


/// For Graph
struct History: Decodable {
    var high: Double?
    var open: Double?
    var time: String
    var average: Double
    var volume: Double?
    var low: Double?
}

