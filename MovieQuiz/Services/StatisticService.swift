//
//  StatistticService.swift
//  MovieQuiz
//
//  Created by Maksim on 27.03.2024.
//

import Foundation

protocol StatisticService {
    
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
   
}
