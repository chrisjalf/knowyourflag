//
//  GameResult.swift
//  knowyourflag
//
//  Created by Chris James on 16/06/2024.
//

import Foundation

struct GameResult: Codable {
    var id: Int
    var gameType: String
    var gameMode: String
    var score: Int
    var time: Int
}
