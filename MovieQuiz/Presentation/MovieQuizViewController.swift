import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Property
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet var buttons: [UIButton]!
    private var presenter: MovieQuizPresenter!
    weak var alertPresenter: MovieQuizViewControllerDelegate?
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }
    // MARK: - Functions
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let model = AlertModel(title: result.title, message: result.textScorePoints, buttonText: result.buttonText) { [weak self] in
            guard let self else { return }
            self.restartGame()
        }
        let alertPresenter = AlertPresenter()
        alertPresenter.show(in: self, model: model)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func highlightImageBorderReset() {
        self.imageView.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func restartGame() {
        self.presenter.restartGame()
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать ещё  раз?") { [weak self] in
            guard let self else { return }
            
            self.presenter.restartGame()
            self.presenter.loadData()
        }
        let alertPresenter = AlertPresenter()
        alertPresenter.show(in: self, model: model)
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
    }
}
