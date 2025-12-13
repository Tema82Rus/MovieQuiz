//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Artem Yaroshenko on 13.12.2025.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    // MARK: - Property
    let questionsAmount: Int = 10
    private var currentQuestionIndex = 0
    
    var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewController?
    var correctAnswers: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    
    // MARK: - Init
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - Buttons
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    // MARK: - Functions
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer { correctAnswers += 1}
    }
    
    func loadData() {
        self.questionFactory?.loadData()
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(data: model.imageData) ?? UIImage(),
                          question: model.text,
                          questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func didAnswer(isYes: Bool) {
        viewController?.buttons.forEach {$0.isEnabled.toggle()}
        guard let currentQuestion = currentQuestion else { return }
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            guard let text = viewController?.statisticService?.message(correct: correctAnswers, total: self.questionsAmount) else { return }
            viewController?.show(quiz: QuizResultsViewModel(
                title: "Этот раунд окончен!",
                textScorePoints: text,
                buttonText: "Сыграть ещё раз?"))
            viewController?.statisticService?.store(correct: correctAnswers, total: self.questionsAmount)
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel) }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
}
