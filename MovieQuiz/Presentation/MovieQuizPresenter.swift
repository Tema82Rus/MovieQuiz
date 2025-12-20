//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Artem Yaroshenko on 13.12.2025.
//

import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func highlightImageBorderReset()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func toggleButtons()
}

final class MovieQuizPresenter: QuestionFactoryDelegate {
    // MARK: - Property
    private let statisticService: StatisticServiceProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var currentQuestion: QuizQuestion?
    private let questionsAmount: Int = 10
    private var currentQuestionIndex = 0
    private var correctAnswers: Int = 0
    // MARK: - Init
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    // MARK: - Buttons
    func buttonClicked(check: Bool) { didAnswer(isYes: check) }
    // MARK: - Functions
    private var isLastQuestion: Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func switchToNextQuestion() { currentQuestionIndex += 1 }
    
    private func didAnswer(isCorrectAnswer: Bool) {
        if isCorrectAnswer { correctAnswers += 1}
    }
    
    func loadData() { questionFactory?.loadData() }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(data: model.imageData) ?? UIImage(),
                          question: model.text,
                          questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func didAnswer(isYes: Bool) {
        viewController?.toggleButtons()
        guard let currentQuestion else { return }
        proceedWithAnswer(isCorrect: currentQuestion.correctAnswer)
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            proceedToNextQuestionOrResults()
            viewController?.highlightImageBorderReset()
            viewController?.toggleButtons()
        }
    }
    
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion {
            let text = makeResultsMessage()
            viewController?.show(quiz: QuizResultsViewModel(
                title: "Этот раунд окончен!",
                textScorePoints: text,
                buttonText: "Сыграть ещё раз?"))
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func makeResultsMessage() -> String {
        guard let message = statisticService?.message(correct: correctAnswers, total: questionsAmount) else { return makeResultsMessage()}
        return message
    }
    // MARK: - QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { self.viewController?.show(quiz: viewModel) }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
}
