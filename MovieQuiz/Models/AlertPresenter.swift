//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Maksim on 25.03.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
