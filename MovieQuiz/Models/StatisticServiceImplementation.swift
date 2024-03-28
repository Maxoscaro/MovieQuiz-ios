//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Maksim on 27.03.2024.
//
import UIKit
import Foundation

private enum Keys: String {
    case correct, total, bestGame, gamesCount
    }

final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    private var totalCorrectAnswers = 0
    private var totalQuestionsAnswered: Int = 0
    
    
    var totalAccuracy: Double { get
        {
            userDefaults.double(forKey: Keys.total.rawValue)
        } set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
        var gamesCount: Int {
            get {
                userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            } set {
                userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
            }
        }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }

            return record
        }

        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }

            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        var currentBestRecord = bestGame
        let newRecord = GameRecord(correct: count, total: amount, date: Date())
        
        if newRecord.isBetterThan(currentBestRecord) {
            currentBestRecord = newRecord
            bestGame = currentBestRecord
        }
        gamesCount += 1
        totalCorrectAnswers += count
        totalQuestionsAnswered += amount
        
        let newTotalAccuracy = Double(totalCorrectAnswers) / Double(totalQuestionsAnswered) * 100
        totalAccuracy = newTotalAccuracy
    }
    
}
