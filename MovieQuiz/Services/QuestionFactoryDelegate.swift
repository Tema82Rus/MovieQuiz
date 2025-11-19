//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Artem Yaroshenko on 19.11.2025.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
