//
//  QuizOfFlagsDetailsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 30.07.2023.
//

import UIKit

class QuizOfFlagsDetailsViewController: UIViewController {
    private lazy var imageQuiz: UIImageView = {
        let size = UIImage.SymbolConfiguration(pointSize: 80)
        let image = UIImage(systemName: "filemenu.and.selection", withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var labelGameName: UILabel = {
        let label = setupLabel(
            title: "Викторина флагов",
            size: 35)
        return label
    }()
    
    private lazy var labelDescriptions: UILabel = {
        let label = setupLabel(
            title: """
            Данный тип игры предлагает вам выбрать правильный ответ на заданный вопрос о флаге той или иной страны. Вам предоставляются четыре ответа на выбор с обратным отсчётом или без него. Один из четырех ответов - правильный. У вас есть одна попытка для выбора ответа, чтобы перейти к следующему вопросу.
            """,
            size: 20)
        return label
    }()
    
    private lazy var labelQuestion: UILabel = {
        let label = setupLabel(
            title: "Хотите начать игру?",
            size: 27)
        return label
    }()
    
    private lazy var buttonCancel: UIButton = {
        let button = setupButton(
            title: "Отмена",
            action: #selector(cancel))
        return button
    }()
    
    private lazy var buttonStartGame: UIButton = {
        let button = setupButton(
            title: "Старт",
            action: #selector(startGame))
        return button
    }()
    
    private lazy var stackViewButtons: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [buttonCancel, buttonStartGame])
        stackView.spacing = 140
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var setting: Setting!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupDesign() {
        view.backgroundColor = UIColor.systemBlue
    }
    
    private func setupSubviews() {
        setupSubviews(subviews: imageQuiz, labelGameName, labelDescriptions,
                      labelQuestion, stackViewButtons)
    }
    
    private func setupSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    @objc private func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func startGame() {
        let quizOfFlagsVC = QuizOfFlagsViewController()
        quizOfFlagsVC.setting = setting
        navigationController?.pushViewController(quizOfFlagsVC, animated: true)
    }
}
// MARK: - Setup label
extension QuizOfFlagsDetailsViewController {
    private func setupLabel(title: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup button
extension QuizOfFlagsDetailsViewController {
    private func setupButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont(name: "mr_fontick", size: 20)
        button.backgroundColor = .white.withAlphaComponent(0.65)
        button.layer.shadowColor = UIColor.blueLight.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.cornerRadius = buttonHeight() / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func buttonHeight() -> CGFloat {
        35
    }
}
// MARK: - Setup constraints
extension QuizOfFlagsDetailsViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageQuiz.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            imageQuiz.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelGameName.topAnchor.constraint(equalTo: imageQuiz.bottomAnchor, constant: 20),
            labelGameName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelGameName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            labelDescriptions.topAnchor.constraint(equalTo: labelGameName.bottomAnchor, constant: 20),
            labelDescriptions.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelDescriptions.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            labelQuestion.topAnchor.constraint(equalTo: labelDescriptions.bottomAnchor, constant: 35),
            labelQuestion.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackViewButtons.topAnchor.constraint(equalTo: labelQuestion.bottomAnchor, constant: 35),
            stackViewButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackViewButtons.heightAnchor.constraint(equalToConstant: buttonHeight())
        ])
    }
}
