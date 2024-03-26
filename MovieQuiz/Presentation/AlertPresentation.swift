//
//  AlertPresentation.swift
//  MovieQuiz
//
//  Created by Maksim on 25.03.2024.
//


import UIKit


class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    func show(quiz result: AlertModel) {
        let alert = UIAlertController(
            title: result.title, message: result.message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default)
        { [weak delegate] _ in
            delegate?.didDismissAlert()
        }
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}
    
    
//    func presentAlert(with model: AlertModel, on viewController: UIViewController) {
//        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
//        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
//            model.completion()
//        }
//        alert.addAction(action)
//        viewController.present(alert, animated: true)
//    }
//}
//
