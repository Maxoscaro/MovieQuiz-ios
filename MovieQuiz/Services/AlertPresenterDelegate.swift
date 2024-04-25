//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Maksim on 26.03.2024.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func alertPresenterTapButton(restart: Bool)
      func viewControllerAlertPresenting() -> UIViewController
    func presentAlert(_ model: AlertModel)
}
