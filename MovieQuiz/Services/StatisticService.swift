//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Artem Yaroshenko on 23.11.2025.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    private enum Keys: String {
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalCorrectAnswers
        case totalQuestionsAsked
    }
    private let storage: UserDefaults = .standard
    
    private var totalCorrectAnswers: Int {
        get {
            storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    private var totalQuestionsAsked: Int {
        get {
            storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestionsAsked.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            let gameResults = GameResult(correct: correct,
                                         total: total,
                                         date: date)
            return gameResults
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        var sum: Double = 0
        guard totalQuestionsAsked > 0 else { return sum }
        sum = (Double(totalCorrectAnswers) / Double(totalQuestionsAsked)) * 100.0
        return sum
    }
    
    func store(correct count: Int, total amount: Int) {
        self.totalCorrectAnswers += count
        self.totalQuestionsAsked += amount
        self.gamesCount += 1
        let thisGameBetterThanNewGame = self.bestGame.betterThan(GameResult(correct: count, total: amount, date: Date()))
        if !thisGameBetterThanNewGame {
            self.bestGame = GameResult(correct: count, total: amount, date: Date())
        }
    }
    
    func message(correct: Int, total: Int) -> String {
        let message = """
        Ваш результат: \(correct)/\(total)
        Количество сыгранных квизов: \(gamesCount)
        Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
        Средняя точность: \(String(format: "%.2f", totalAccuracy))%
        """
        return message
    }
    
}
