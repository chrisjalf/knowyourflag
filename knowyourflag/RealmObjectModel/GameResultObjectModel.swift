//
//  GameResultObjectModel.swift
//  knowyourflag
//
//  Created by Chris James on 15/06/2024.
//

import Foundation
import RealmSwift

class GameResultObjectModel: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var gameType: GameType.RawValue
    @Persisted var gameMode: GameMode.RawValue
    @Persisted var score: Int64
    @Persisted var time: Int64 = 0
    
    convenience init(
        gameType: GameType,
        gameMode: GameMode,
        score: Int64,
        time: Int64
    ) {
        self.init()
        self.gameType = gameType.rawValue
        self.gameMode = gameMode.rawValue
        self.score = score
        self.time = time
    }
}

enum GameType: String {
    case guessTheCountry = "Guess The Country"
    case guessTheFlag = "Guess The Flag"
}

enum GameMode: String {
    case sixtySeconds = "60 seconds"
    case unlimited = "Unlimited"
}
