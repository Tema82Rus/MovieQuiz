//
//  MovieQuizViewControllerDelegate.swift
//  MovieQuiz
//
//  Created by Artem Yaroshenko on 22.11.2025.
//

import Foundation
import UIKit

protocol MovieQuizViewControllerDelegate: AnyObject {
    func show(in vc: UIViewController, model: AlertModel)
}
