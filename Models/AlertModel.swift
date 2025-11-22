//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Artem Yaroshenko on 22.11.2025.
//

import Foundation

struct AlertModel {
    var title: String
    var message: String
    var buttonText: String
    var completion: () -> Void
}
