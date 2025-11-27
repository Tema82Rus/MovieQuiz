//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Artem Yaroshenko on 23.11.2025.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
    func message(correct: Int, total: Int) -> String
}
