//
//  AlertPresentation.swift
//  MovieQuiz
//
//  Created by Maksim on 25.03.2024.
//




import UIKit

class AlertPresenter {
    
   
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    
    
    func presentAlert(with model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        alert.view.accessibilityIdentifier = model.accessibilityIndicator
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
            
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    
    }
}


