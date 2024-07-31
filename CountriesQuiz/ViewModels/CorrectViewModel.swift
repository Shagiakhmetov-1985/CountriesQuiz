//
//  CorrectViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 15.07.2024.
//

import UIKit

protocol CorrectViewModelProtocol {
    var background: UIColor { get }
    var radius: CGFloat { get }
    var progress: Float { get }
    var numberQuestion: String { get }
    var buttonFirst: Countries { get }
    var buttonSecond: Countries { get }
    var buttonThird: Countries { get }
    var buttonFourth: Countries { get }
    var heightStackView: CGFloat { get }
    
    init(mode: Setting, game: Games, correctAnswer: Corrects)
    
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func setSubviews(subviews: UIView..., on otherSubview: UIView)
    func constraintsQuestion(_ subview: UIView,_ view: UIView)
    func setConstraints(_ subview: UIView, on button: UIView,_ view: UIView,_ flag: String)
    
    func widthStackView(_ view: UIView) -> CGFloat
    
    func question() -> UIView
    func view(_ button: Countries, addSubview: UIView) -> UIView
    func subview(button: Countries) -> UIView
    func stackView(_ first: UIView,_ second: UIView,_ third: UIView,_ fourth: UIView) -> UIStackView
}

class CorrectViewModel: CorrectViewModelProtocol {
    var background: UIColor {
        game.background
    }
    let radius: CGFloat = 6
    var progress: Float {
        Float(correctAnswer.currentQuestion) / Float(mode.countQuestions)
    }
    var numberQuestion: String {
        "\(correctAnswer.currentQuestion) / \(mode.countQuestions)"
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
    var heightStackView: CGFloat {
        isFlag ? 215 : 235
    }
    
    private let mode: Setting
    private let game: Games
    private let correctAnswer: Corrects
    private var isFlag: Bool {
        mode.flag ? true : false
    }
    private var flag: String {
        correctAnswer.question.flag
    }
    private var issue: Countries {
        correctAnswer.question
    }
    
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
    func widthStackView(_ view: UIView) -> CGFloat {
        isFlag ? view.bounds.width - 40 : view.bounds.width - 20
    }
    // MARK: - Set constraints
    func constraintsQuestion(_ subview: UIView, _ view: UIView) {
        if isFlag {
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
                subview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                subview.widthAnchor.constraint(equalToConstant: width(flag)),
                subview.heightAnchor.constraint(equalToConstant: 168)
            ])
        } else {
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
                subview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                subview.widthAnchor.constraint(equalToConstant: widthStackView(view))
            ])
        }
    }
    
    func setConstraints(_ subview: UIView, on button: UIView, _ view: UIView,
                        _ flag: String) {
        if isFlag {
            let constant: CGFloat = game.gameType == .questionnaire ? 50 : 20
            NSLayoutConstraint.activate([
                subview.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                subview.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: constant),
                subview.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20)
            ])
        } else {
            NSLayoutConstraint.activate([
                layoutConstraint(subview: subview, on: button, view),
                subview.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                subview.widthAnchor.constraint(equalToConstant: widthImage(flag, view)),
                subview.heightAnchor.constraint(equalToConstant: setHeight())
            ])
        }
    }
    // MARK: - Subviews
    func question() -> UIView {
        if isFlag {
            setImage(image: UIImage(named: flag))
        } else {
            setLabel(text: issue.name, size: 32, color: .white)
        }
    }
    
    func view(_ button: Countries, addSubview: UIView) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor(button)
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = game.gameType == .questionnaire ? 1.5 : 0
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(subview: addSubview, on: view, and: button)
        return view
    }
    
    func subview(button: Countries) -> UIView {
        if isFlag {
            setLabel(text: text(button), size: 23, color: textColor(button))
        } else {
            setImage(image: UIImage(named: button.flag))
        }
    }
    
    func stackView(_ first: UIView, _ second: UIView, 
                   _ third: UIView, _ fourth: UIView) -> UIStackView {
        if isFlag {
            return setStackView(first, second, third, fourth)
        } else {
            let stackViewOne = setStackView(first, second)
            let stackViewTwo = setStackView(third, fourth)
            return setStackView(stackViewOne, stackViewTwo, axis: .vertical)
        }
    }
}
// MARK: - Private methods, constants
extension CorrectViewModel {
    private func textColor(_ button: Countries) -> UIColor {
        issue.flag == button.flag ? correctTextColor() : notSelectTextColor()
    }
    
    private func correctTextColor() -> UIColor {
        switch game.gameType {
        case .quizOfFlag, .quizOfCapitals: .white
        default: .greenHarlequin
        }
    }
    
    private func notSelectTextColor() -> UIColor {
        switch game.gameType {
        case .quizOfFlag, .quizOfCapitals: .grayLight
        default: .white
        }
    }
    
    private func backgroundColor(_ button: Countries) -> UIColor {
        issue.flag == button.flag ? correctBackground() : notSelectBackground()
    }
    
    private func correctBackground() -> UIColor {
        switch game.gameType {
        case .quizOfFlag, .quizOfCapitals: .greenYellowBrilliant
        default: .white
        }
    }
    
    private func notSelectBackground() -> UIColor {
        switch game.gameType {
        case .quizOfFlag: isFlag ? .whiteAlpha : .skyGrayLight
        case .questionnaire: .greenHarlequin
        default: .skyGrayLight
        }
    }
    
    private func checkmark(_ button: Countries) -> String {
        issue.flag == button.flag ? "checkmark.circle.fill" : "circle"
    }
    
    private func color(_ button: Countries) -> UIColor {
        issue.flag == button.flag ? .greenHarlequin : .white
    }
    
    private func width(_ image: String) -> CGFloat {
        switch image {
        case "nepal", "vatican city", "switzerland": return 168
        default: return 280
        }
    }
    
    private func setWidth(_ view: UIView) -> CGFloat {
        let buttonWidth = ((view.frame.width - 20) / 2) - 4
        if game.gameType == .questionnaire {
            return buttonWidth - 45
        } else {
            return buttonWidth - 10
        }
    }
    
    private func setHeight() -> CGFloat {
        let buttonHeight = heightStackView / 2 - 4
        return buttonHeight - 10
    }
    
    private func widthImage(_ flag: String, _ view: UIView) -> CGFloat {
        switch flag {
        case "nepal", "vatican city", "switzerland": return setHeight()
        default: return setWidth(view)
        }
    }
    
    private func setCenter(_ view: UIView) -> CGFloat {
        let buttonWidth = ((view.frame.width - 20) / 2) - 4
        let flagWidth = buttonWidth - 45
        let centerFlag = flagWidth / 2 + 5
        return buttonWidth / 2 - centerFlag
    }
    
    private func text(_ button: Countries) -> String {
        game.gameType == .quizOfCapitals ? button.capitals : button.name
    }
}
// MARK: - Add subviews on button
extension CorrectViewModel {
    private func addSubviews(subview: UIView, on view: UIView, and button: Countries) {
        if game.gameType == .questionnaire {
            let checkmark = setCheckmark(image: checkmark(button),
                                         color: color(button))
            setSubviews(subviews: checkmark, subview, on: view)
            setConstraints(checkmark: checkmark, on: view)
        } else {
            setSubviews(subviews: subview, on: view)
        }
    }
}
// MARK: - Set labels
extension CorrectViewModel {
    private func setLabel(text: String, size: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = color
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Set images
extension CorrectViewModel {
    private func setImage(image: UIImage?) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = isFlag ? 0 : 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func setCheckmark(image: String, color: UIColor) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: 26)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
// MARK: - Set stack views
extension CorrectViewModel {
    private func setStackView(_ first: UIView, _ second: UIView,
                              _ third: UIView, _ fourth: UIView) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [first, second, third, fourth])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackView(_ first: UIView, _ second: UIView,
                              axis: NSLayoutConstraint.Axis? = nil) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [first, second])
        stackView.axis = axis ?? .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Private methods, constraints
extension CorrectViewModel {
    private func setConstraints(checkmark: UIImageView, on view: UIView) {
        let constant: CGFloat = isFlag ? 10 : 5
        NSLayoutConstraint.activate([
            checkmark.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            checkmark.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant)
        ])
    }
    
    private func layoutConstraint(subview: UIView, on button: UIView,
                                  _ view: UIView) -> NSLayoutConstraint {
        if game.gameType == .questionnaire {
            let center = setCenter(view)
            return subview.centerXAnchor.constraint(equalTo: button.centerXAnchor, constant: center)
        } else {
            return subview.centerXAnchor.constraint(equalTo: button.centerXAnchor)
        }
    }
}
