import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        questionFactory = QuestionFactory()
        questionFactory.delegate = self
        //self.questionFactory = questionFactory
        
        // questionFactory = QuestionFactory(delegate: self)
        
        // if let firstQuestion = questionFactory.requestNextQuestion() {
        //   currentQuestion = firstQuestion
        // let viewModel = convert(model: firstQuestion)
        //show(quiz: viewModel)}
        
        
        questionFactory.requestNextQuestion()
        
    }
    
    
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private var imageView: UIImageView!
    
    @IBOutlet private var textLabel: UILabel!
    
    @IBOutlet private var counterLabel: UILabel!
    
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
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactory = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
    
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
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
        imageView.layer.cornerRadius = 20
    }
    
    
    
//    private func showQuizResults() {
//        let alertModel = AlertModel(title: "Этот раунд окончен!", message: "Ваш результат: \(correctAnswers) из \(questionsAmount)", buttonText: "Сыграть еще раз") { [weak self] in
//            self?.restartQuiz()
//        }
//        
//        let alertPresenter = AlertPresenter()
//        alertPresenter.presentAlert(with: alertModel, on: self)
//    }
//    
//    private func restartQuiz() {
//        currentQuestionIndex = 0
//        correctAnswers = 0
//        questionFactory.requestNextQuestion()
//        yesButton.isEnabled = true
//        noButton.isEnabled = true
//    }
    
        private func show(quiz result: QuizResultsViewModel) {
    
            let alert = UIAlertController(title: result.title,
                                          message: result.text,
                                          preferredStyle: .alert)
    
    
            let action = UIAlertAction(title: result.buttonText, style: .default) { [ weak self] _ in guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                questionFactory.requestNextQuestion()
                //if let firstQuestion = self.questionFactory.requestNextQuestion() {
                //  self.currentQuestion = firstQuestion
                //let viewModel = self.convert(model: firstQuestion)
                // self.show(quiz: viewModel)
    
                self.yesButton.isEnabled = true
                self.noButton.isEnabled = true
            }
    
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
        if currentQuestionIndex == questionsAmount - 1 {
           let text = correctAnswers == questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
        

            
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще раз")
            show(quiz: viewModel)
            
        } else {
            currentQuestionIndex += 1
            self.questionFactory.requestNextQuestion()
           //if let nextQuestion = questionFactory.requestNextQuestion() { currentQuestion = nextQuestion
             //   let viewModel = convert(model: nextQuestion)
               // show(quiz: viewModel)
            }
            yesButton.isEnabled = true
            noButton.isEnabled = true
        }
    }




