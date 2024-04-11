import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenter?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var statisticService = StatisticServiceImplementation()
    private let moviesLoader = MoviesLoader()
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(moviesLoader: moviesLoader, delegate: self)
        alertPresenter = AlertPresenter(viewController: self)
        statisticService = StatisticServiceImplementation()
        showLoadingIndicator()
        questionFactory?.loadData()
        
    }
    
    // MARK: - IBActions
    
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesbuttonClicked(_ sender: UIButton) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    
    // MARK: - Data Loading
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailLoadData(with error: any Error) {
        showNetworkError(message: error.localizedDescription)
    }
    func hideLoadingIndicatorWhenTheImageIsLoaded() {
        hideLoadingIndicator()
    }
    
    // MARK: - Private Methods
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
    }
    
    
    private func showFinalResults() {
        
        let bestGame = statisticService.bestGame
        let message = "Ваш результат: \(correctAnswers)/\(questionsAmount)\nКоличество сыгранных квизов: \(statisticService.gamesCount)\nРекорд: \(bestGame.correct)/\(questionsAmount) (\(bestGame.date.dateTimeString))\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        
        
        let alertModel = AlertModel(title: "Этот раунд окончен!",
                                    message: message,
                                    buttonText: "Сыграть еще раз") { [weak self] in
            self?.restartQuiz()
        }
        
        alertPresenter?.presentAlert(with: alertModel)
    }
    
    private func restartQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        yesButton.isEnabled = true
        noButton.isEnabled = true
        questionFactory?.requestNextQuestion()
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {correctAnswers += 1
        }
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in guard let self = self else { return }
            
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        
        if currentQuestionIndex >= questionsAmount - 1 {
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            showFinalResults()
        } else {
            currentQuestionIndex += 1
            showLoadingIndicator()
            questionFactory?.requestNextQuestion()
            
            yesButton.isEnabled = true
            noButton.isEnabled = true
        }
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showLoadingIndicator() {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка!",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            self.questionFactory?.loadData()
        }
        
        alertPresenter?.presentAlert(with: model)
    }
}


