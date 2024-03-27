//
//  AlertPresentation.swift
//  MovieQuiz
//
//  Created by Maksim on 25.03.2024.
//




import UIKit


import UIKit

class AlertPresenter {
    private weak var viewController: UIViewController?
    weak var delegate: AlertPresenterDelegate?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func presentAlert(with model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { [weak self] _ in
            model.completion()
            self?.delegate?.alertActionCompleted()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}


