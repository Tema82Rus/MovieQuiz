//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Artem Yaroshenko on 22.11.2025.
//

import Foundation
import UIKit

final class AlertPresenter: MovieQuizViewControllerDelegate {
    
    func show(in vc: UIViewController, model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion()
        }
        
        alert.addAction(action)
        
        vc.present(alert, animated: true, completion: nil)
    }
}
