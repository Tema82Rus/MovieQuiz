//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Artem Yaroshenko on 13.12.2025.
//

import UIKit

final class MovieQuizPresenter {
    // MARK: - Property
    let questionsAmount: Int = 10
    private var currentQuestionIndex = 0
    
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    // MARK: - Buttons
    func yesButtonClicked() {
        viewController?.buttons.forEach {$0.isEnabled.toggle()}
        guard let currentQuestion = currentQuestion else { return }
        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    func noButtonClicked() {
        viewController?.buttons.forEach {$0.isEnabled.toggle()}
        guard let currentQuestion = currentQuestion else { return }
        viewController?.showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    
    // MARK: - Functions
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(data: model.imageData) ?? UIImage(),
                          question: model.text,
                          questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
}
