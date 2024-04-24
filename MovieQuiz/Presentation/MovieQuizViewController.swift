import UIKit


final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var buttonsStack: UIStackView!
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
    
    @IBAction private func yesbuttonClicked(_ sender: UIButton) {
        presenter.yesbuttonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - ActivityIndicator
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicatorWhenTheImageIsLoaded() {
        hideLoadingIndicator()
    }
    
    // MARK: - Methods
    
    func show(quiz step: QuizStepViewModel) {
        
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
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
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        presenter.presentAlert(AlertModel(title: "Ошибка!",
                                          message: message,
                                          buttonText: "Попробовать еще раз", accessibilityIndicator: "Network error") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.restartGame()
            })
        }
    
    // MARK: - AlertIdentifier
    
    internal func presentAlert(with model: UIAlertController) {
        self.present(model, animated: true)
        model.view.accessibilityIdentifier = "Game results"
    }
}
    
    
    
    
    
    
    
    
    
   



