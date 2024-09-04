//
//  CorrectAnswersViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 14.07.2024.
//

import UIKit

protocol CorrectAnswersViewModelProtocol {
    var background: UIColor { get }
    var backgroundDetails: UIColor { get }
    var title: String { get }
    var cell: AnyClass { get }
    var numberOfRows: Int { get }
    var heightOfRow: CGFloat { get }
    
    init(mode: Setting, game: Games, correctAnswers: [Corrects])
    
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func setSubviews(subviews: UIView..., on otherSubview: UIView)
    func customCell(cell: UITableViewCell, indexPath: IndexPath)
    func setView(color: UIColor, radius: CGFloat, tag: Int) -> UIView
    func setLabel(title: String, size: CGFloat, color: UIColor) -> UILabel
    func setDetails(_ viewDetails: UIView,_ view: UIView, and indexPath: IndexPath)
    
    func setSquare(button: UIButton, sizes: CGFloat)
    func setConstraints(button: UIButton, on view: UIView)
    func setConstraints(viewDetails: UIView, on view: UIView)
    
    func buttonOnOff(button: UIButton, isOn: Bool)
    func showAnimationView(_ viewDetails: UIView, and visualEffect: UIVisualEffectView)
    func hideAnimationView(_ viewDetails: UIView, and visualEffect: UIVisualEffectView)
    
    func correctViewModel(_ indexPath: Int) -> CorrectViewModelProtocol
}

class CorrectAnswersViewModel: CorrectAnswersViewModelProtocol {
    var background: UIColor {
        game.background
    }
    var backgroundDetails: UIColor {
        game.swap
    }
    var title = "Правильные ответы"
    var cell: AnyClass {
        isFlag ? FlagCell.self : NameCell.self
    }
    var numberOfRows: Int {
        correctAnswers.count
    }
    var heightOfRow: CGFloat {
        isFlag ? 70 : 95
    }
    
    private let mode: Setting
    private let game: Games
    private let correctAnswers: [Corrects]
    private var isFlag: Bool {
        mode.flag ? true : false
    }
    private var radius: CGFloat = 4
    private var heightStackView: CGFloat {
        isFlag ? 215 : 235
    }
    
    private var viewSecondary: UIView!
    private var subview: UIView!
    private var progressView: UIProgressView!
    private var labelNumber: UILabel!
    private var stackView: UIStackView!
    
    required init(mode: Setting, game: Games, correctAnswers: [Corrects]) {
        self.game = game
        self.mode = mode
        self.correctAnswers = correctAnswers
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
    
    func customCell(cell: UITableViewCell, indexPath: IndexPath) {
        if isFlag {
            flagCell(cell: cell as! FlagCell, indexPath: indexPath)
        } else {
            nameCell(cell: cell as! NameCell, indexPath: indexPath)
        }
    }
    
    func setView(color: UIColor, radius: CGFloat, tag: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = radius
        view.tag = tag
        view.translatesAutoresizingMaskIntoConstraints = false
        maskedCorners(view: view)
        return view
    }
    
    func setLabel(title: String, size: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = color
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setDetails(_ viewDetails: UIView, _ view: UIView, and indexPath: IndexPath) {
        let correct = correctAnswers[indexPath.row]
        viewSecondary = setView(color: background, radius: 15, tag: 1)
        subview = setName(correct: correct)
        progressView = progressView(correct: correct)
        labelNumber = setLabel(title: setText(value: correct.currentQuestion), size: 23, color: .white)
        stackView = setStackView(correct: correct, and: view)
        setSubviews(subviews: viewSecondary, on: viewDetails)
        setSubviews(subviews: subview, progressView, labelNumber, stackView, on: viewSecondary)
        setConstraints(viewDetails: viewDetails, and: correct)
    }
    
    func buttonOnOff(button: UIButton, isOn: Bool) {
        let opacity: Float = isOn ? 1 : 0
        isEnabled(buttons: button, isOn: isOn)
        setOpacityButtons(buttons: button, opacity: opacity)
    }
    
    func showAnimationView(_ viewDetails: UIView, and visualEffect: UIVisualEffectView) {
        viewDetails.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        viewDetails.alpha = 0
        UIView.animate(withDuration: 0.5) { [self] in
            alpha(subviews: visualEffect, viewDetails, alpha: 1)
            viewDetails.transform = .identity
        }
    }
    
    func hideAnimationView(_ viewDetails: UIView, and visualEffect: UIVisualEffectView) {
        UIView.animate(withDuration: 0.5) { [self] in
            alpha(subviews: visualEffect, viewDetails, alpha: 0)
            viewDetails.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        } completion: { [self] _ in
            self.removeSubviews(subviews: viewDetails, viewSecondary,
                                subview, progressView, labelNumber, stackView)
        }
    }
    // MARK: - Constraints
    func setSquare(button: UIButton, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: sizes),
            button.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    func setConstraints(button: UIButton, on view: UIView) {
        setSquare(button: button, sizes: 40)
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            button.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])
    }
    
    func setConstraints(viewDetails: UIView, on view: UIView) {
        let multiplier = isFlag ? 0.65 : 0.55
        NSLayoutConstraint.activate([
            viewDetails.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewDetails.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: multiplier),
            viewDetails.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            viewDetails.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
    
    func correctViewModel(_ indexPath: Int) -> CorrectViewModelProtocol {
        CorrectViewModel(mode: mode, game: game, correctAnswer: correctAnswers[indexPath])
    }
}
// MARK: - Constants
extension CorrectAnswersViewModel {
    private func setProgress(value: Int) -> Float {
        Float(value) / Float(mode.countQuestions)
    }
    
    private func setText(value: Int) -> String {
        "\(value) / \(mode.countQuestions)"
    }
    
    private func flagCell(cell: FlagCell, indexPath: IndexPath) {
        cell.image.image = UIImage(named: correctAnswers[indexPath.row].question.flag)
        cell.progressView.progress = setProgress(value: correctAnswers[indexPath.row].currentQuestion)
        cell.labelNumber.text = setText(value: correctAnswers[indexPath.row].currentQuestion)
        cell.contentView.backgroundColor = background
    }
    
    private func nameCell(cell: NameCell, indexPath: IndexPath) {
        cell.nameCountry.text = correctAnswers[indexPath.row].question.name
        cell.progressView.progress = setProgress(value: correctAnswers[indexPath.row].currentQuestion)
        cell.labelNumber.text = setText(value: correctAnswers[indexPath.row].currentQuestion)
        cell.contentView.backgroundColor = background
    }
    
    private func maskedCorners(view: UIView) {
        guard view.tag == 1 else { return }
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    private func background(correct: Corrects, name: String) -> UIColor {
        title(correct.question) == name ? correctBackground() : notSelectBackground()
    }
    
    private func correctBackground() -> UIColor {
        switch game.gameType {
        case .quizOfFlags, .quizOfCapitals: .greenYellowBrilliant
        default: .white
        }
    }
    
    private func notSelectBackground() -> UIColor {
        switch game.gameType {
        case .quizOfFlags: isFlag ? .whiteAlpha : .skyGrayLight
        case .questionnaire: .greenHarlequin
        default: .whiteAlpha
        }
    }
    
    private func textColor(correct: Corrects, name: String) -> UIColor {
        title(correct.question) == name ? correctTextColor() : notSelectTextColor()
    }
    
    private func correctTextColor() -> UIColor {
        switch game.gameType {
        case .quizOfFlags, .quizOfCapitals: .white
        default: .greenHarlequin
        }
    }
    
    private func notSelectTextColor() -> UIColor {
        switch game.gameType {
        case .quizOfFlags, .quizOfCapitals: .grayLight
        default: .white
        }
    }
    
    private func checkmark(_ correct: Corrects, _ name: String) -> String {
        title(correct.question) == name ? "checkmark.circle.fill" : "circle"
    }
    
    private func color(_ correct: Corrects, _ name: String) -> UIColor {
        title(correct.question) == name ? .greenHarlequin : .white
    }
    
    private func setCenter(_ view: UIView) -> CGFloat {
        let buttonWidth = (view.frame.width - 34) / 2
        let flagWidth = buttonWidth - 45
        let centerFlag = flagWidth / 2 + 5
        return buttonWidth / 2 - centerFlag
    }
    
    private func setWidth(_ view: UIView) -> CGFloat {
        let buttonWidth = (view.frame.width - 34) / 2
        if game.gameType == .questionnaire {
            return buttonWidth - 45
        } else {
            return buttonWidth - 10
        }
    }
    
    private func setHeight() -> CGFloat {
        let buttonHeight = (heightStackView - 4) / 2
        return buttonHeight - 10
    }
    
    private func widthImage(_ flag: String, _ view: UIView) -> CGFloat {
        switch flag {
        case "nepal", "vatican city", "switzerland": return setHeight()
        default: return setWidth(view)
        }
    }
    
    private func title(_ name: Countries) -> String {
        switch game.gameType {
        case .quizOfCapitals: name.capitals
        default: isFlag ? name.name : name.flag
        }
    }
    
    private func width(_ image: String) -> CGFloat {
        switch image {
        case "nepal", "vatican city", "switzerland": return 168
        default: return 280
        }
    }
}
// MARK: - Subviews
extension CorrectAnswersViewModel {
    private func setName(correct: Corrects) -> UIView {
        if isFlag {
            setImage(image: correct.question.flag)
        } else {
            setLabel(title: correct.question.name, size: 28, color: .white)
        }
    }
    
    private func setImage(image: String, radius: CGFloat? = nil) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: image)
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = radius ?? 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func setImage(image: String, color: UIColor) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: 26)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func progressView(correct: Corrects) -> UIProgressView {
        let progressView = UIProgressView()
        progressView.progress = setProgress(value: correct.currentQuestion)
        progressView.trackTintColor = .white
        progressView.progressTintColor = .white.withAlphaComponent(0.3)
        progressView.layer.cornerRadius = radius
        progressView.clipsToBounds = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }
    
    private func setStackView(correct: Corrects, and view: UIView) -> UIStackView {
        let first = setView(correct: correct, title(correct.buttonFirst), and: view)
        let second = setView(correct: correct, title(correct.buttonSecond), and: view)
        let third = setView(correct: correct, title(correct.buttonThird), and: view)
        let fourth = setView(correct: correct, title(correct.buttonFourth), and: view)
        if isFlag {
            return setStackView(first, second, third, fourth)
        } else {
            return checkGameType(first, second, third, fourth)
        }
    }
    
    private func setView(correct: Corrects, _ name: String, and view: UIView) -> UIView {
        let background = background(correct: correct, name: name)
        let button = setView(color: background, radius: 12, tag: 0)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = game.gameType == .questionnaire ? 1.5 : 0
        addSubviews(correct: correct, name, button, and: view)
        return button
    }
    
    private func addSubviews(correct: Corrects, _ name: String,
                             _ button: UIView, and view: UIView) {
        if game.gameType == .questionnaire {
            let subview = subview(correct: correct, and: name)
            let checkmark = setImage(image: checkmark(correct, name),
                                     color: color(correct, name))
            setSubviews(subviews: checkmark, subview, on: button)
            setConstraints(checkmark: checkmark, subview, on: button, name, view)
        } else {
            let subview = subview(correct: correct, and: name)
            setSubviews(subviews: subview, on: button)
            setConstraints(subview, on: button, name, view)
        }
    }
    
    private func subview(correct: Corrects, and name: String) -> UIView {
        if isFlag {
            let color = textColor(correct: correct, name: name)
            return setLabel(title: name, size: 23, color: color)
        } else {
            return setSubview(correct: correct, and: name)
        }
    }
    
    private func setSubview(correct: Corrects, and name: String) -> UIView {
        if game.gameType == .quizOfCapitals {
            let color = textColor(correct: correct, name: name)
            return setLabel(title: name, size: 23, color: color)
        } else {
            return setImage(image: name, radius: 8)
        }
    }
    
    private func setStackView(_ first: UIView, _ second: UIView,
                              _ third: UIView, _ fourth: UIView) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [first, second, third, fourth])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackView(_ first: UIView, _ second: UIView,
                              axis: NSLayoutConstraint.Axis? = nil) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [first, second])
        stackView.axis = axis ?? .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func checkGameType(_ first: UIView, _ second: UIView,
                               _ third: UIView, _ fourth: UIView) -> UIStackView {
        if game.gameType == .quizOfCapitals {
            return setStackView(first, second, third, fourth)
        } else {
            let stackViewOne = setStackView(first, second)
            let stackViewTwo = setStackView(third, fourth)
            return setStackView(stackViewOne, stackViewTwo, axis: .vertical)
        }
    }
}
// MARK: - Show / hide subviews
extension CorrectAnswersViewModel {
    private func isEnabled(buttons: UIButton..., isOn: Bool) {
        buttons.forEach { button in
            button.isEnabled = isOn
        }
    }
    
    private func setOpacityButtons(buttons: UIButton..., opacity: Float) {
        buttons.forEach { button in
            UIView.animate(withDuration: 0.5) {
                button.layer.opacity = opacity
            }
        }
    }
    
    private func alpha(subviews: UIView..., alpha: CGFloat) {
        subviews.forEach { subview in
            subview.alpha = alpha
        }
    }
    
    private func removeSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
}
// MARK: - Constraints
extension CorrectAnswersViewModel {
    private func setConstraints(checkmark: UIImageView, _ subview: UIView, on
                                button: UIView, _ name: String, _ view: UIView) {
        let constant: CGFloat = isFlag ? 10 : 5
        NSLayoutConstraint.activate([
            checkmark.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            checkmark.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: constant)
        ])
        setConstraints(subview, on: button, name, view)
    }
    
    private func setConstraints(_ subview: UIView, on button: UIView,
                                _ name: String, _ view: UIView) {
        if isFlag {
            let constant: CGFloat = isFlag ? 40 : 10
            NSLayoutConstraint.activate([
                subview.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                subview.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: constant),
                subview.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10)
            ])
        } else {
            NSLayoutConstraint.activate([
                layoutConstraint(subview: subview, on: button, button),
                subview.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                subview.widthAnchor.constraint(equalToConstant: widthImage(name, view)),
                subview.heightAnchor.constraint(equalToConstant: setHeight())
            ])
        }
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
    
    private func setConstraints(viewDetails: UIView, and correct: Corrects) {
        NSLayoutConstraint.activate([
            viewSecondary.topAnchor.constraint(equalTo: viewDetails.topAnchor, constant: 52),
            viewSecondary.leadingAnchor.constraint(equalTo: viewDetails.leadingAnchor),
            viewSecondary.trailingAnchor.constraint(equalTo: viewDetails.trailingAnchor),
            viewSecondary.bottomAnchor.constraint(equalTo: viewDetails.bottomAnchor)
        ])
        
        if isFlag {
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: viewSecondary.topAnchor, constant: 25),
                subview.centerXAnchor.constraint(equalTo: viewSecondary.centerXAnchor),
                subview.widthAnchor.constraint(equalToConstant: width(correct.question.flag)),
                subview.heightAnchor.constraint(equalToConstant: 168)
            ])
        } else {
            NSLayoutConstraint.activate([
                subview.topAnchor.constraint(equalTo: viewSecondary.topAnchor, constant: 25),
                subview.leadingAnchor.constraint(equalTo: viewSecondary.leadingAnchor, constant: 10),
                subview.trailingAnchor.constraint(equalTo: viewSecondary.trailingAnchor, constant: -10)
            ])
        }
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: subview.bottomAnchor, constant: 25),
            progressView.leadingAnchor.constraint(equalTo: viewSecondary.leadingAnchor, constant: 10),
            progressView.heightAnchor.constraint(equalToConstant: radius * 2)
        ])
        
        NSLayoutConstraint.activate([
            labelNumber.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            labelNumber.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 15),
            labelNumber.trailingAnchor.constraint(equalTo: viewSecondary.trailingAnchor, constant: -10),
            labelNumber.widthAnchor.constraint(equalToConstant: 85)
        ])
        
        let constant: CGFloat = isFlag ? 10 : 5
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: labelNumber.bottomAnchor, constant: 25),
            stackView.leadingAnchor.constraint(equalTo: viewSecondary.leadingAnchor, constant: constant),
            stackView.trailingAnchor.constraint(equalTo: viewSecondary.trailingAnchor, constant: -constant),
            stackView.heightAnchor.constraint(equalToConstant: heightStackView)
        ])
    }
}
