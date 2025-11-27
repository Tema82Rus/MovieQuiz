//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Artem Yaroshenko on 23.11.2025.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func betterThan(_ other: GameResult) -> Bool {
        correct > other.correct
    }
}
