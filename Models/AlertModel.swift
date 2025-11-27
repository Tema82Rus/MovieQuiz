//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Artem Yaroshenko on 22.11.2025.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
