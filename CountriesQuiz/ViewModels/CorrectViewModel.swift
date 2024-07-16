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
    func setConstraints(_ subview: UIView, on button: UIView,_ view: UIView)
    
    func widthFlag(_ view: UIView) -> CGFloat
    
    func question() -> UIView
    func view(button: Countries, addSubview: UIView) -> UIView
    func subview(button: Countries) -> UIView
    func stackView(_ first: UIView,_ second: UIView,_ third: UIView,_ fourth: UIView) -> UIStackView
}

class CorrectViewModel: CorrectViewModelProtocol {
    var background: UIColor {
        game.background
    }
    var radius: CGFloat = 6
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
    func widthFlag(_ view: UIView) -> CGFloat {
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
                subview.widthAnchor.constraint(equalToConstant: widthLabel(view))
            ])
        }
    }
    
    func setConstraints(_ subview: UIView, on button: UIView, _ view: UIView) {
        if isFlag {
            NSLayoutConstraint.activate([
                subview.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                subview.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 20),
                subview.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20)
            ])
        } else {
            NSLayoutConstraint.activate([
                subview.centerXAnchor.constraint(equalTo: button.centerXAnchor),
                subview.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                subview.widthAnchor.constraint(equalToConstant: widthImage(flag, view)),
                subview.heightAnchor.constraint(equalToConstant: setHeight())
            ])
        }
    }
    // MARK: - Subviews
    func question() -> UIView {
        if isFlag {
            setImage(image: UIImage(named: correctAnswer.question.flag))
        } else {
            setLabel(text: correctAnswer.question.name, size: 32, color: .white)
        }
    }
    
    func subview(button: Countries) -> UIView {
        if isFlag {
            setLabel(text: button.name, size: 23, color: textColor(button))
        } else {
            setImage(image: UIImage(named: button.flag))
        }
    }
    
    func view(button: Countries, addSubview: UIView) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor(button)
        view.layer.cornerRadius = 12
        view.layer.shadowColor = backgroundColor(button).cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.translatesAutoresizingMaskIntoConstraints = false
        setSubviews(subviews: addSubview, on: view)
        return view
    }
    
    func stackView(_ first: UIView, _ second: UIView, 
                   _ third: UIView, _ fourth: UIView) -> UIStackView {
        if isFlag {
            return setStackView(first, second, third, fourth)
        } else {
            let stackViewOne = setStackView(first, second)
            let stackViewTwo = setStackView(third, fourth)
            return setStackViews(stackViewOne, stackViewTwo)
        }
    }
}
// MARK: - Private methods, constants
extension CorrectViewModel {
    private func textColor(_ button: Countries) -> UIColor {
        correctAnswer.question == button ? .white : .grayLight
    }
    
    private func backgroundColor(_ button: Countries) -> UIColor {
        correctAnswer.question == button ? .greenYellowBrilliant : .white.withAlphaComponent(0.9)
    }
    
    private func width(_ image: String) -> CGFloat {
        switch image {
        case "nepal", "vatican city", "switzerland": return 168
        default: return 280
        }
    }
    
    private func widthLabel(_ view: UIView) -> CGFloat {
        view.bounds.width - 20
    }
    
    private func setWidth(_ view: UIView) -> CGFloat {
        let buttonWidth = ((view.frame.width - 20) / 2) - 4
        return buttonWidth - 10
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
    
    private func setStackView(_ first: UIView, _ second: UIView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [first, second])
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackViews(_ first: UIView, _ second: UIView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [first, second])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
