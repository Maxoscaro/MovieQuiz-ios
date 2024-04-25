//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Maksim on 24.03.2024.
//

import Foundation
protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailLoadData(with error: Error)
    func hideLoadingIndicatorWhenTheImageIsLoaded()
}

