//
//  GameTypeViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 03.08.2023.
//

import UIKit

class GameTypeViewController: UIViewController {
    private lazy var viewGameType: UIView = {
        let view = setupView(color: .white.withAlphaComponent(0.8))
        return view
    }()
    
    private lazy var imageGameType: UIImageView = {
        let imageView = setupImage(
            image: "\(game.image)",
            color: game.background,
            size: 60)
        return imageView
    }()
    
    private lazy var labelGameName: UILabel = {
        let label = setupLabel(
            title: "\(game.name)",
            color: .white,
            style: "Gill Sans",
            size: 30)
        return label
    }()
    
    private lazy var labelDescription: UILabel = {
        let label = setupLabel(
            title: "\(game.description)",
            color: .white,
            style: "Gill Sans",
            size: 19)
        return label
    }()
    
    private lazy var buttonBack: UIButton = {
        let button = setupButton(
            image: "multiply",
            action: #selector(backToMenu))
        return button
    }()
    
    private lazy var buttonStart: UIButton = {
        let button = setupButton(
            image: "play",
            color: game.play,
            action: #selector(startGame))
        return button
    }()
    
    private lazy var buttonFavoutites: UIButton = {
        let button = setupButton(
            image: "star",
            color: game.favourite,
            action: #selector(favourites))
        return button
    }()
    
    private lazy var buttonFlagOrCountry: UIButton = {
        let button = setupButton(
            image: "flag",
            color: game.swap,
            action: #selector(flagOrCountry))
        return button
    }()
    
    private lazy var stackViewButtons: UIStackView = {
        let stackView = setupStackView(
            buttonFirst: buttonStart,
            buttonSecond: buttonFavoutites,
            buttonThird: buttonFlagOrCountry)
        return stackView
    }()
    
    private lazy var buttonCountQuestions: UIButton = {
        let button = setupButton(
            color: game.swap,
            labelFirst: labelCountQuestion,
            labelSecond: labelCount,
            action: #selector(changeSetting))
        return button
    }()
    
    private lazy var labelCountQuestion: UILabel = {
        let label = setupLabel(
            title: "\(mode.countQuestions)",
            color: .white,
            style: "Gill Sans",
            size: 60)
        return label
    }()
    
    private lazy var labelCount: UILabel = {
        let label = setupLabel(
            title: "Количество вопросов",
            color: .white,
            style: "Gill Sans",
            size: 17)
        return label
    }()
    
    private lazy var buttonContinents: UIButton = {
        let button = setupButton(
            color: game.swap,
            labelFirst: labelContinents,
            labelSecond: labelContinentsDescription,
            action: #selector(changeSetting))
        return button
    }()
    
    private lazy var labelContinents: UILabel = {
        let label = setupLabel(
            title: "\(comma())",
            color: .white,
            style: "Gill Sans",
            size: 30)
        return label
    }()
    
    private lazy var labelContinentsDescription: UILabel = {
        let label = setupLabel(
            title: "Континенты",
            color: .white,
            style: "Gill Sans",
            size: 17)
        return label
    }()
    
    private lazy var buttonTimeElapsed: UIButton = {
        let button = setupButton(
            color: game.swap,
            labelFirst: labelTimeElapsed,
            labelSecond: labelTimeElapsedDesription,
            action: #selector(changeSetting))
        return button
    }()
    
    private lazy var labelTimeElapsed: UILabel = {
        let label = setupLabel(
            title: mode.timeElapsed.timeElapsed ? "Да" : "Нет",
            color: .white,
            style: "Gill Sans",
            size: 60)
        return label
    }()
    
    private lazy var labelTimeElapsedDesription: UILabel = {
        let label = setupLabel(
            title: "Обратный отсчёт",
            color: .white,
            style: "Gill Sans",
            size: 17)
        return label
    }()
    
    private lazy var buttonTime: UIButton = {
        let button = setupButton(
            color: game.swap,
            labelFirst: labelTime,
            labelSecond: labelTimeDesription,
            image: imageInfinity,
            action: #selector(changeSetting))
        return button
    }()
    
    private lazy var labelTime: UILabel = {
        let label = setupLabel(
            title: "\(timeElapsedOnOff())",
            color: .white,
            style: "Gill Sans",
            size: 60)
        return label
    }()
    
    private lazy var labelTimeDesription: UILabel = {
        let label = setupLabel(
            title: "\(checkTimeElapsedDescription())",
            color: .white,
            style: "Gill Sans",
            size: 17)
        return label
    }()
    
    private lazy var imageInfinity: UIImageView = {
        let imageView = setupImage(
            image: "infinity",
            color: .white,
            size: 60)
        return imageView
    }()
    
    var mode: Setting!
    var game: Games!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupSubviews()
        setupBarButton()
        setupConstraints()
    }
    
    private func setupDesign() {
        view.backgroundColor = game.background
        imageInfinity.isHidden = mode.timeElapsed.timeElapsed ? true : false
    }
    
    private func setupSubviews() {
        setupSubviews(subviews: viewGameType, imageGameType, labelGameName,
                      labelDescription, stackViewButtons, buttonCountQuestions,
                      buttonContinents, buttonTimeElapsed, buttonTime,
                      on: view)
    }
    
    private func setupBarButton() {
        let barButton = UIBarButtonItem(customView: buttonBack)
        navigationItem.leftBarButtonItem = barButton
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    @objc private func backToMenu() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func startGame() {
        let startGameVC = QuizOfFlagsViewController()
        startGameVC.mode = mode
        navigationController?.pushViewController(startGameVC, animated: true)
    }
    
    private func comma() -> String {
        let comma = comma(continents: mode.allCountries, mode.americaContinent,
                          mode.europeContinent, mode.africaContinent,
                          mode.asiaContinent, mode.oceaniaContinent)
        return comma
    }
    
    private func comma(continents: Bool...) -> String {
        var text = ""
        var number = 0
        continents.forEach { continent in
            number += 1
            if continent {
                text += text == "" ? checkContinent(continent: number) : ", " + checkContinent(continent: number)
            }
        }
        return text
    }
    
    private func checkContinent(continent: Int) -> String {
        var text = ""
        switch continent {
        case 1: text = "Все страны"
        case 2: text = "Америка"
        case 3: text = "Европа"
        case 4: text = "Африка"
        case 5: text = "Азия"
        default: text = "Океания"
        }
        return text
    }
    
    private func timeElapsedOnOff() -> String {
        mode.timeElapsed.timeElapsed ? "\(checkTimeElapsed())" : ""
    }
    
    private func checkTimeElapsed() -> String {
        mode.timeElapsed.questionSelect.oneQuestion ?
        "\(mode.timeElapsed.questionSelect.questionTime.oneQuestionTime)" :
        "\(mode.timeElapsed.questionSelect.questionTime.allQuestionsTime)"
    }
    
    private func checkTimeElapsedDescription() -> String {
        mode.timeElapsed.questionSelect.oneQuestion ?
        "Время одного вопроса" : "Время всех вопросов"
    }
    
    @objc private func favourites() {
        
    }
    
    @objc private func flagOrCountry() {
        
    }
    
    @objc private func changeSetting() {
        
    }
}
// MARK: - Setup views
extension GameTypeViewController {
    private func setupView(color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = diameter() / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
// MARK: - Setup images
extension GameTypeViewController {
    private func setupImage(image: String, color: UIColor, size: CGFloat) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: size)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
// MARK: - Setup labels
extension GameTypeViewController {
    private func setupLabel(title: String, color: UIColor, style: String,
                            size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = color
        label.font = UIFont(name: style, size: size)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup buttons
extension GameTypeViewController {
    private func setupButton(image: String, action: Selector) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setupButton(image: String, color: UIColor, action: Selector) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = Button(type: .system)
        button.backgroundColor = color
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setupButton(color: UIColor, labelFirst: UILabel,
                             labelSecond: UILabel, image: UIImageView? = nil,
                             action: Selector) -> UIButton {
        let button = Button(type: .custom)
        button.backgroundColor = color
        button.layer.cornerRadius = 20
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        if let image = image {
            setupSubviews(subviews: labelFirst, labelSecond, image, on: button)
        } else {
            setupSubviews(subviews: labelFirst, labelSecond, on: button)
        }
        return button
    }
}
// MARK: - Setup stack views
extension GameTypeViewController {
    private func setupStackView(buttonFirst: UIButton, buttonSecond: UIButton,
                                buttonThird: UIButton) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [buttonFirst, buttonSecond, buttonThird])
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Setup constraints
extension GameTypeViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            viewGameType.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewGameType.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        setupSquare(subview: viewGameType, sizes: 100)
        setupCenterSubview(subview: imageGameType, on: viewGameType)
        
        NSLayoutConstraint.activate([
            labelGameName.topAnchor.constraint(equalTo: viewGameType.bottomAnchor, constant: 10),
            labelGameName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelDescription.topAnchor.constraint(equalTo: labelGameName.bottomAnchor, constant: 10),
            labelDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        setupSquare(subview: buttonBack, sizes: 40)
        
        NSLayoutConstraint.activate([
            stackViewButtons.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 10),
            stackViewButtons.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        setupSize(subview: stackViewButtons, width: 160, height: 40)
        
        setupConstraintsButton(button: buttonCountQuestions,
                               layout: stackViewButtons.bottomAnchor,
                               leading: 20, trailing: -halfWidth(), height: 160)
        setupConstraintsLabel(label: labelCountQuestion, button: buttonCountQuestions, constant: -30)
        setupConstraintsLabel(label: labelCount, button: buttonCountQuestions, constant: 35)
        
        setupConstraintsButton(button: buttonContinents,
                               layout: stackViewButtons.bottomAnchor,
                               leading: halfWidth(), trailing: -20, height: 190)
        setupConstraintsLabel(label: labelContinents, button: buttonContinents, constant: -15)
        setupConstraintsLabel(label: labelContinentsDescription, button: buttonContinents, constant: 75)
        
        setupConstraintsButton(button: buttonTimeElapsed,
                               layout: buttonCountQuestions.bottomAnchor,
                               leading: 20, trailing: -halfWidth(), height: 150)
        setupConstraintsLabel(label: labelTimeElapsed, button: buttonTimeElapsed, constant: -25)
        setupConstraintsLabel(label: labelTimeElapsedDesription, button: buttonTimeElapsed, constant: 35)
        
        setupConstraintsButton(button: buttonTime,
                               layout: buttonContinents.bottomAnchor,
                               leading: halfWidth(), trailing: -20, height: 120)
        setupConstraintsLabel(label: labelTime, button: buttonTime, constant: -25)
        setupConstraintsLabel(label: labelTimeDesription, button: buttonTime, constant: 30)
        NSLayoutConstraint.activate([
            imageInfinity.centerXAnchor.constraint(equalTo: buttonTime.centerXAnchor),
            imageInfinity.centerYAnchor.constraint(equalTo: buttonTime.centerYAnchor, constant: -25)
        ])
    }
    
    private func setupConstraintsButton(button: UIButton, layout: NSLayoutYAxisAnchor,
                                        leading: CGFloat, trailing: CGFloat,
                                        height: CGFloat) {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: layout, constant: 20),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing),
            button.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    private func setupConstraintsLabel(label: UILabel, button: UIButton, constant: CGFloat) {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: constant),
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    private func setupSize(subview: UIView, width: CGFloat, height: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: width),
            subview.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    private func setupCenterSubview(subview: UIView, on subviewOther: UIView) {
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: subviewOther.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: subviewOther.centerYAnchor)
        ])
    }
    
    private func diameter() -> CGFloat {
        100
    }
    
    private func halfWidth() -> CGFloat {
        view.frame.width / 2 + 10
    }
}
