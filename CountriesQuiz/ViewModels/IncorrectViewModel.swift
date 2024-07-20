//
//  IncorrectViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 08.04.2024.
//

import UIKit

protocol IncorrectViewModelProtocol {
    var background: UIColor { get }
    var radius: CGFloat { get }
    var numberQuestion: String { get }
    var progress: Float { get }
    var buttonFirst: Countries { get }
    var buttonSecond: Countries { get }
    var buttonThird: Countries { get }
    var buttonFourth: Countries { get }
    var heightStackView: CGFloat { get }
    
    init(mode: Setting, game: Games, result: Results)
    
    func setSubviews(subviews: UIView..., on otherSubview: UIView)
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    
    func question() -> UIView
    func view(_ button: Countries, addSubview: UIView, and tag: Int) -> UIView
    func subview(button: Countries, and tag: Int) -> UIView
    func stackView(_ first: UIView,_ second: UIView,_ third: UIView,_ fourth: UIView) -> UIStackView
    
    func widthStackView(_ view: UIView) -> CGFloat
//    func width(_ image: String) -> CGFloat
//    func widthStackViewFlag(_ view: UIView) -> CGFloat
//    func widthLabel(_ view: UIView) -> CGFloat
//    func height() -> CGFloat
//    func widthImage(_ image: String,_ view: UIView) -> CGFloat
//    func heightImage() -> CGFloat
//    func widthOrCenter(_ view: UIView) -> (CGFloat, CGFloat, CGFloat)
    
    func constraintsQuestion(_ subview: UIView, _ view: UIView)
    func setConstraints(_ subview: UIView, on button: UIView,_ view: UIView)
//    func setTitle(title: Countries) -> String
//    func setBackgroundColor(question: Countries, answer: Countries, tag: Int, select: Int) -> UIColor
//    func setTitleColor(question: Countries, answer: Countries, tag: Int, select: Int) -> UIColor
//    func setButtonColor(question: Countries, answer: Countries, tag: Int, select: Int) -> UIColor
//    func setColor(question: Countries, answer: Countries, tag: Int, select: Int) -> UIColor
//    func setCheckmark(question: Countries, answer: Countries, tag: Int, select: Int) -> String
}

class IncorrectViewModel: IncorrectViewModelProtocol {
    var background: UIColor {
        game.background
    }
    let radius: CGFloat = 6
    var numberQuestion: String {
        "\(result.currentQuestion) / \(mode.countQuestions)"
    }
    var progress: Float {
        Float(result.currentQuestion) / Float(mode.countQuestions)
    }
    var buttonFirst: Countries {
        result.buttonFirst
    }
    var buttonSecond: Countries {
        result.buttonSecond
    }
    var buttonThird: Countries {
        result.buttonThird
    }
    var buttonFourth: Countries {
        result.buttonFourth
    }
    var heightStackView: CGFloat {
        isFlag ? 215 : 235
    }
    
    private let mode: Setting
    private let game: Games
    private let result: Results
    private var isFlag: Bool {
        mode.flag ? true : false
    }
    private var issue: Countries {
        result.question
    }
    private var flag: String {
        result.question.flag
    }
    
    required init(mode: Setting, game: Games, result: Results) {
        self.mode = mode
        self.game = game
        self.result = result
    }
    // MARK: - Set subviews
    func setSubviews(subviews: UIView..., on otherSubview: UIView) {
        subviews.forEach { subview in
            otherSubview.addSubview(subview)
        }
    }
    
    func setBarButton(_ button: UIButton, _ navigationItem: UINavigationItem) {
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButton
    }
    // MARK: - Constants
    func widthStackView(_ view: UIView) -> CGFloat {
        isFlag ? view.bounds.width - 40 : view.bounds.width - 20
    }
    /*
    func height() -> CGFloat {
        game.gameType == .questionnaire ? 235 : 215
    }
    
    func widthImage(_ image: String, _ view: UIView) -> CGFloat {
        switch image {
        case "nepal", "vatican city", "switzerland": heightImage()
        default: game.gameType == .questionnaire ? widthOrCenter(view).1 : widthOrCenter(view).0
        }
    }
    
    func heightImage() -> CGFloat {
        let buttonHeight = height() / 2 - 4
        return buttonHeight - 10
    }
    
    func widthOrCenter(_ view: UIView) -> (CGFloat, CGFloat, CGFloat) {
        let buttonWidth = ((view.frame.width - 20) / 2) - 4
        let flagWidth = buttonWidth - 10
        let flagWidthQuestionnaire = buttonWidth - 45
        let centerFlag = flagWidthQuestionnaire / 2 + 5
        let constant = buttonWidth / 2 - centerFlag
        return (flagWidth, flagWidthQuestionnaire, constant)
    }
     */
    // MARK: - Subviews
    func question() -> UIView {
        if isFlag {
            setImage(image: UIImage(named: flag))
        } else {
            setLabel(text: issue.name, size: 32, color: .white)
        }
    }
    
    func view(_ button: Countries, addSubview: UIView, and tag: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = backgroundColor(button, tag)
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = game.gameType == .questionnaire ? 1.5 : 0
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubviews(subview: addSubview, on: view, and: button)
        return view
    }
    
    func subview(button: Countries, and tag: Int) -> UIView {
        if isFlag {
            setLabel(text: text(button), size: 23, color: textColor(button, tag))
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
            let constant: CGFloat = game.gameType == .questionnaire ? 50 : 20
            NSLayoutConstraint.activate([
                subview.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                subview.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: constant),
                subview.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20)
            ])
        } else {
            let center = game.gameType == .questionnaire ? setCenter(view) : 0
            NSLayoutConstraint.activate([
                subview.centerXAnchor.constraint(equalTo: button.centerXAnchor, constant: center),
                subview.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                subview.widthAnchor.constraint(equalToConstant: widthImage(flag, view)),
                subview.heightAnchor.constraint(equalToConstant: setHeight())
            ])
        }
    }
    /*
    // MARK: - Set title
    func setTitle(title: Countries) -> String {
        switch game.gameType {
        case .quizOfFlag, .questionnaire: title.name
        default: title.capitals
        }
    }
    // MARK: - Set colors
    func setBackgroundColor(question: Countries, answer: Countries, tag: Int, select: Int) -> UIColor {
        switch true {
        case question == answer && (tag == select || !(tag == select)):
            return .greenYellowBrilliant
        case !(question == answer) && tag == select:
            return game.gameType == .quizOfFlag ? .redTangerineTango : .bismarkFuriozo
        default:
            return isFlag ? .white.withAlphaComponent(0.9) : checkColor()
        }
    }
    
    func setTitleColor(question: Countries, answer: Countries, tag: Int, select: Int) -> UIColor {
        switch true {
        case question == answer || tag == select:
            return .white
        default:
            return .grayLight
        }
    }
    
    func setButtonColor(question: Countries, answer: Countries, tag: Int, select: Int) -> UIColor {
        switch true {
        case question == answer || tag == select:
            return .white
        default:
            return .clear
        }
    }
    
    func setColor(question: Countries, answer: Countries, tag: Int, select: Int) -> UIColor {
        switch true {
        case question == answer && (tag == select || !(tag == select)):
            return .greenHarlequin
        case !(question == answer) && tag == select:
            return .redTangerineTango
        default:
            return .white
        }
    }
    // MARK: - Set checkmarks
    func setCheckmark(question: Countries, answer: Countries, tag: Int, select: Int) -> String {
        switch true {
        case question == answer && (tag == select || !(tag == select)):
            return "checkmark.circle.fill"
        case !(question == answer) && tag == select:
            return "xmark.circle.fill"
        default:
            return "circle"
        }
    }
    // MARK: - Set colors, countinue
    private func checkColor() -> UIColor {
        game.gameType == .quizOfFlag ? .skyGrayLight : .white.withAlphaComponent(0.9)
    }
     */
}
// MARK: - Private methods, constants
extension IncorrectViewModel {
    private func textColor(_ button: Countries, _ tag: Int) -> UIColor {
        issue.flag == button.flag ? correctTextColor() : incorrectTextColor(tag)
    }
    
    private func correctTextColor() -> UIColor {
        switch game.gameType {
        case .quizOfFlag, .quizOfCapitals: .white
        default: .greenHarlequin
        }
    }
    
    private func incorrectTextColor(_ tag: Int) -> UIColor {
        switch game.gameType {
        case .quizOfFlag, .quizOfCapitals: textColor(tag)
        default: .white
        }
    }
    
    private func textColor(_ tag: Int) -> UIColor {
        result.tag == tag ? .white : .grayLight
    }
    
    private func backgroundColor(_ button: Countries, _ tag: Int) -> UIColor {
        issue.flag == button.flag ? correctBackground() : incorrectBackground(tag)
    }
    
    private func correctBackground() -> UIColor {
        switch game.gameType {
        case .quizOfFlag, .quizOfCapitals: .greenYellowBrilliant
        default: .white
        }
    }
    
    private func incorrectBackground(_ tag: Int) -> UIColor {
        switch game.gameType {
        case .quizOfFlag, .quizOfCapitals: background(tag)
        default: .greenHarlequin
        }
    }
    
    private func background(_ tag: Int) -> UIColor {
        result.tag == tag ? checkBackground() : UIColor.white.withAlphaComponent(0.9)
    }
    
    private func checkBackground() -> UIColor {
        game.gameType == .quizOfFlag ? .redTangerineTango : .bismarkFuriozo
    }
    
    private func checkmark(_ button: Countries) -> String {
        issue.flag == button.flag ? "checkmark.circle.fill" : "circle"
    }
    
    private func color(_ button: Countries) -> UIColor {
        issue.flag == button.flag ? .greenHarlequin : .white
    }
    
    private func text(_ button: Countries) -> String {
        game.gameType == .quizOfCapitals ? button.capitals : button.name
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
    
    private func setCenter(_ view: UIView) -> CGFloat {
        let buttonWidth = ((view.frame.width - 20) / 2) - 4
        let flagWidth = buttonWidth - 45
        let centerFlag = flagWidth / 2 + 5
        let center = buttonWidth / 2 - centerFlag
        return center
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
}
// MARK: - Add subviews on button
extension IncorrectViewModel {
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
// MARK: - Set images
extension IncorrectViewModel {
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
// MARK: - Set labels
extension IncorrectViewModel {
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
// MARK: - Set stack views
extension IncorrectViewModel {
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
extension IncorrectViewModel {
    private func setConstraints(checkmark: UIImageView, on view: UIView) {
        let constant: CGFloat = isFlag ? 10 : 5
        NSLayoutConstraint.activate([
            checkmark.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            checkmark.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant)
        ])
    }
}
