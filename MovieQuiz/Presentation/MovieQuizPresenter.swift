//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Maksim on 22.04.2024.
//
import UIKit

import Foundation

final class MovieQuizPresenter: QuestionFactoryDelegate, AlertPresenterDelegate  {
    
    //MARK: - Private properties
    
   
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewController?
    
    private var alertPresenter: AlertPresenter?
    private var currentQuestion: QuizQuestion?
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let statisticService = StatisticServiceImplementation()
   
    // MARK: - Initialization
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
    
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        guard let questionFactory = questionFactory as? QuestionFactory else { return }
        questionFactory.loadData()
        alertPresenter = AlertPresenter(delegate: self)
        viewController.showLoadingIndicator()
    }
    
    // MARK: - Button Actions
    
    func yesbuttonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func didAnswer(isYes: Bool) {
        disableButtonsInteraction()
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    private func disableButtonsInteraction() {
      viewController?.buttonsStack.isUserInteractionEnabled = false
    }
    
    private func enableButtonsInteraction() {
      viewController?.buttonsStack.isUserInteractionEnabled = true
    }
    
    // MARK: - Quiz
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer {
            correctAnswers += 1
        }
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func proceedToNextQuestionOrResults() {
        
        if self.isLastQuestion() {
       
            viewController?.showFinalResults()
        } else {
            self.switchToNextQuestion()
            viewController?.showLoadingIndicator()
            questionFactory?.requestNextQuestion()
            
        }
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            enableButtonsInteraction()
            proceedToNextQuestionOrResults()
        }
    }
    
    
    
    // MARK: - Data
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func makeResultsMessage() -> String {
        
        statisticService.store(correct: correctAnswers, total: questionsAmount)
        
        let bestGame = statisticService.bestGame
        
        let totalPlaysCountLine = "Количество сыграных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)"
        + "(\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine].joined(separator: "\n")
        
        return resultMessage
    }
    
    func loadQuestionData() {
        guard let questionFactory = questionFactory as? QuestionFactory else { return }
        questionFactory.loadData()
    }
    
    func presentAlert(_ model: AlertModel) {
        alertPresenter?.presentAlert( model)
    }
    
    //MARK: - QuestionFactoryDelegate
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicatorWhenTheImageIsLoaded()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func hideLoadingIndicatorWhenTheImageIsLoaded() {
        viewController?.hideLoadingIndicator()
    }
    
    //MARK: - AlertPresenterDelegate
    func alertPresenterTapButton(restart: Bool) {
      if restart {
        restartGame()
      } else {
        questionFactory?.requestNextQuestion()
      }
      
      viewController?.hideLoadingIndicator()
    }
    
    func viewControllerAlertPresenting() -> UIViewController {
      viewController ?? MovieQuizViewController()
    }
}
