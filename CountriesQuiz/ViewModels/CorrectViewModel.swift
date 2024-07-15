//
//  CorrectViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 15.07.2024.
//

import UIKit

protocol CorrectViewModelProtocol {
    var background: UIColor { get }
    var image: UIImage? { get }
    var radius: CGFloat { get }
    var progress: Float { get }
    var numberQuestion: String { get }
    var flag: String { get }
    var buttonFirst: Countries { get }
    var buttonSecond: Countries { get }
    var buttonThird: Countries { get }
    var buttonFourth: Countries { get }
    
    init(mode: Setting, game: Games, correctAnswer: Corrects)
    
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func setSubviews(subviews: UIView..., on otherSubview: UIView)
    func setConstraints(_ label: UILabel, on button: UIView)
    
    func textColor(_ button: Countries) -> UIColor
    func backgroundColor(_ button: Countries) -> UIColor
    func width(_ image: String) -> CGFloat
    func widthFlag(_ view: UIView) -> CGFloat
}

class CorrectViewModel: CorrectViewModelProtocol {
    var background: UIColor {
        game.background
    }
    var image: UIImage? {
        UIImage(named: correctAnswer.question.flag)
    }
    var radius: CGFloat = 6
    var progress: Float {
        Float(correctAnswer.currentQuestion) / Float(mode.countQuestions)
    }
    var numberQuestion: String {
        "\(correctAnswer.currentQuestion) / \(mode.countQuestions)"
    }
    var flag: String {
        correctAnswer.question.flag
    }
    var buttonFirst: Countries {
        correctAnswer.buttonFirst
    }
    var buttonSecond: Countries {
        correctAnswer.buttonSecond
    }
    var buttonThird: Countries {
        correctAnswer.buttonThird
    }
    var buttonFourth: Countries {
        correctAnswer.buttonFourth
    }
    
    private let mode: Setting
    private let game: Games
    private let correctAnswer: Corrects
    
    required init(mode: Setting, game: Games, correctAnswer: Corrects) {
        self.mode = mode
        self.game = game
        self.correctAnswer = correctAnswer
    }
    
    func setBarButton(_ button: UIButton, _ navigationItem: UINavigationItem) {
        let leftButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = leftButton
    }
    
    func setSubviews(subviews: UIView..., on otherSubview: UIView) {
        subviews.forEach { subview in
            otherSubview.addSubview(subview)
        }
    }
    // MARK: - Constants
    func textColor(_ button: Countries) -> UIColor {
        correctAnswer.question == button ? .white : .grayLight
    }
    
    func backgroundColor(_ button: Countries) -> UIColor {
        correctAnswer.question == button ? .greenYellowBrilliant : .white.withAlphaComponent(0.9)
    }
    
    func width(_ image: String) -> CGFloat {
        switch image {
        case "nepal", "vatican city", "switzerland": return 168
        default: return 280
        }
    }
    
    func widthFlag(_ view: UIView) -> CGFloat {
        view.bounds.width - 40
    }
    // MARK: - Set constraints
    func setConstraints(_ label: UILabel, on button: UIView) {
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20)
        ])
    }
}
