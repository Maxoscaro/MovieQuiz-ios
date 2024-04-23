import UIKit


final class MovieQuizViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    
    private var presenter: MovieQuizPresenter!
 

  
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
       showLoadingIndicator()
       
        
    }
    
    // MARK: - IBActions
 
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
            
        presenter.yesButtonClicked()
        }
   
    @IBAction private func noButtonClicked(_ sender: UIButton) {
            
            presenter.noButtonClicked()
        }
 
    
    
   
    
    
    // MARK: - Data Loading
    
    
    
    
    func hideLoadingIndicatorWhenTheImageIsLoaded() {
        hideLoadingIndicator()
    }
    

 
    
    // MARK: - Private Methods
    
    
    func show(quiz step: QuizStepViewModel) {
        
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    
    }
    
    
    func showFinalResults() {
        
       
        let message = presenter.makeResultsMessage()

        
        
        let alertModel = AlertModel(title: "Этот раунд окончен!",
                                    message: message,
                                    buttonText: "Сыграть еще раз", accessibilityIndicator: "Game results") { [weak self]  in
            guard let self = self else { return }
            self.presenter.restartGame()
            
        }
      
        presenter.presentAlert(alertModel)
        
    }
    
    // MARK: - Show Alert
    
   internal func presentAlert(with model: UIAlertController) {
        self.present(model, animated: true)
        model.view.accessibilityIdentifier = "Game results"
    }
    
//    private func restartQuiz() {
//        
//        presenter.restartGame()
//        presenter.correctAnswers = 0
//        yesButton.isEnabled = true
//        noButton.isEnabled = true
//        
//    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
            imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        }
    

    
    
    
     func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
     func showNetworkError(message: String) {
        hideLoadingIndicator()
        
         presenter.presentAlert(AlertModel(title: "Ошибка!",
                               message: message,
                               buttonText: "Попробовать еще раз", accessibilityIndicator: "Network error") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
            
            
          
        })
        
       
    }
}


