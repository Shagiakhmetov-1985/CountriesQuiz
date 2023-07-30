//
//  MenuViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 01.12.2022.
//

import UIKit
// MARK: - Protocol of delegate rewrite user defaults
protocol SettingViewControllerDelegate {
    func sendDataOfSetting(setting: Setting)
}

class MenuViewController: UIViewController {
    // MARK: - Private properties
    private lazy var labelMenuCountries: UILabel = {
        let label = setLabel(
            title: "Countries",
            size: 55,
            style: "echorevival",
            color: .white,
            colorOfShadow: CGColor(
                red: 10/255,
                green: 10/255,
                blue: 10/255,
                alpha: 1),
            radiusOfShadow: 2,
            shadowOffsetWidth: 1,
            shadowOffsetHeight: 1)
        return label
    }()
    
    private lazy var labelMenuQuiz: UILabel = {
        let label = setLabel(
            title: "Quiz",
            size: 50,
            style: "echorevival",
            color: .white,
            colorOfShadow: CGColor(
                red: 10/255,
                green: 10/255,
                blue: 10/255,
                alpha: 1),
            radiusOfShadow: 2,
            shadowOffsetWidth: 1,
            shadowOffsetHeight: 1)
        return label
    }()
    
    private lazy var buttonQuizOfFlags: UIButton = {
        let button = setButton(
            color: .systemBlue,
            image: imageQuizOfFlags,
            label: labelQuizOfFlags,
            action: #selector(startQuizOfFlags))
        return button
    }()
    
    private lazy var buttonQuizOfFlagsDetails: UIButton = {
        let button = setButton(
            color: .systemBlue,
            image: imageQuizOfFlagsDetails,
            action: #selector(quizOfFlagsDetails))
        return button
    }()
    
    private lazy var imageQuizOfFlags: UIImageView = {
        let imageView = setImage(
            image: "filemenu.and.selection",
            color: .white,
            size: 32)
        return imageView
    }()
    
    private lazy var imageQuizOfFlagsDetails: UIImageView = {
        let imageView = setImage(
            image: "questionmark",
            color: .white,
            size: 24)
        return imageView
    }()
    
    private lazy var labelQuizOfFlags: UILabel = {
        let label = setLabel(
            title: "Викторина флагов",
            size: 23,
            style: "mr_fontick",
            color: .white,
            alignment: .center)
        return label
    }()
    
    private lazy var stackViewQuizOfFlags: UIStackView = {
        let stackView = setupStackView(
            buttonFirst: buttonQuizOfFlags,
            buttonSecond: buttonQuizOfFlagsDetails)
        return stackView
    }()
    
    private lazy var buttonSettings: UIButton = {
        let button = setButton(
            color: UIColor.gray,
            image: imageSettings,
            label: labelSettings,
            action: #selector(setting))
        return button
    }()
    
    private lazy var imageSettings: UIImageView = {
        let imageView = setImage(
            image: "gear",
            color: .white,
            size: 32)
        return imageView
    }()
    
    private lazy var labelSettings: UILabel = {
        let label = setLabel(
            title: "Настройки",
            size: 23,
            style: "mr_fontick",
            color: .white,
            alignment: .center)
        return label
    }()
    
    private lazy var labelGameMode: UILabel = {
        let label = setLabel(
            title: "",
            size: 20,
            style: "mr_fontick",
            color: .blueLight,
            alignment: .center)
        return label
    }()
    
    private var settingDefault: Setting!
    private var transition = Transition()
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setConstraints()
        gameMode()
    }
    
    // MARK: - Private methods
    private func setupDesign() {
        view.backgroundColor = UIColor.skyCyanLight
        setupSubviews(subviews: labelMenuCountries, labelMenuQuiz,
                      stackViewQuizOfFlags, buttonSettings, labelGameMode,
                      on: view)
        settingDefault = StorageManager.shared.fetchSetting()
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    private func gameMode() {
        let countQuestions = settingDefault.countQuestions
        let continents = comma(continents: settingDefault.allCountries, settingDefault.americaContinent,
                               settingDefault.europeContinent, settingDefault.africaContinent,
                               settingDefault.asiaContinent, settingDefault.oceaniaContinent)
        let timeElapsed = settingDefault.timeElapsed.timeElapsed ? "Да" : "Нет"
        let questionTime = questionTime()
        
        showGameMode(countQuestions: countQuestions, continents: continents,
                     timeElapsed: timeElapsed, questionTime: questionTime)
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
    
    private func questionTime() -> String {
        guard settingDefault.timeElapsed.timeElapsed else { return "" }
        let time = settingDefault.timeElapsed.questionSelect.oneQuestion
        let questionTime = time ? "Время одного вопроса:" : "Время всех вопросов:"
        return "\(questionTime) \(checkQuestionTime(check: time))"
    }
    
    private func checkQuestionTime(check: Bool) -> String {
        check ?
        "\(settingDefault.timeElapsed.questionSelect.questionTime.oneQuestionTime)" :
        "\(settingDefault.timeElapsed.questionSelect.questionTime.allQuestionsTime)"
    }
    
    private func showGameMode(countQuestions: Int, continents: String,
                              timeElapsed: String, questionTime: String) {
        labelGameMode.text = """
        Количество вопросов: \(countQuestions)
        Континенты: \(continents)
        Обратный отсчет: \(timeElapsed)
        \(questionTime)
        """
    }
    
    @objc private func startQuizOfFlags() {
        let quizOfFlagsVC = QuizOfFlagsViewController()
        quizOfFlagsVC.setting = settingDefault
        navigationController?.pushViewController(quizOfFlagsVC, animated: true)
    }
    
    @objc private func quizOfFlagsDetails() {
        let quizOfFlagsDetailsVC = QuizOfFlagsDetailsViewController()
        quizOfFlagsDetailsVC.setting = settingDefault
        navigationController?.pushViewController(quizOfFlagsDetailsVC, animated: true)
    }
    
    @objc private func setting() {
        let settingVC = SettingViewController()
        settingVC.modalPresentationStyle = .custom
        settingVC.transitioningDelegate = self
        settingVC.settingDefault = settingDefault
        settingVC.delegate = self
        present(settingVC, animated: true)
    }
}
// MARK: - Setup label
extension MenuViewController {
    private func setLabel(title: String, size: CGFloat, style: String, color: UIColor,
                          colorOfShadow: CGColor? = nil, radiusOfShadow: CGFloat? = nil,
                          shadowOffsetWidth: CGFloat? = nil,
                          shadowOffsetHeight: CGFloat? = nil,
                          alignment: NSTextAlignment? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: style, size: size)
        label.textColor = color
        label.textAlignment = alignment ?? .left
        label.numberOfLines = 0
        label.layer.shadowColor = colorOfShadow
        label.layer.shadowRadius = radiusOfShadow ?? 0
        label.layer.shadowOpacity = 1
        label.layer.shadowOffset = CGSize(width: shadowOffsetWidth ?? 0,
                                          height: shadowOffsetHeight ?? 0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup button
extension MenuViewController {
    private func setButton(color: UIColor, image: UIView, label: UILabel? = nil,
                           action: Selector) -> UIButton {
        let button = Button(type: .custom)
        button.backgroundColor = color
        button.layer.cornerRadius = 15
        button.layer.shadowOpacity = 0.4
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        if let label = label {
            setupSubviews(subviews: image, label, on: button)
        } else {
            setupSubviews(subviews: image, on: button)
        }
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
// MARK: - Setup image
extension MenuViewController {
    private func setImage(image: String, color: UIColor, size: CGFloat) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: size)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
// MARK: - Setup stack view
extension MenuViewController {
    private func setupStackView(buttonFirst: UIButton, buttonSecond: UIButton) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [buttonFirst, buttonSecond])
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Delegate rewrite user defaults
extension MenuViewController: SettingViewControllerDelegate {
    func sendDataOfSetting(setting: Setting) {
        settingDefault = setting
        gameMode()
    }
}
// MARK: - UIViewControllerTransitioningDelegate
extension MenuViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = buttonQuizOfFlags.center
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = buttonQuizOfFlags.center
        return transition
    }
}
extension MenuViewController {
    // MARK: - Set constraints
    private func setConstraints() {
        NSLayoutConstraint.activate([
            labelMenuCountries.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            labelMenuCountries.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            labelMenuCountries.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            labelMenuQuiz.topAnchor.constraint(equalTo: labelMenuCountries.topAnchor, constant: 45),
            labelMenuQuiz.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 240),
            labelMenuQuiz.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            stackViewQuizOfFlags.topAnchor.constraint(equalTo: labelMenuQuiz.bottomAnchor, constant: 120),
            stackViewQuizOfFlags.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackViewQuizOfFlags.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        setupSquare(subview: buttonQuizOfFlagsDetails, sizes: 50)
        
        NSLayoutConstraint.activate([
            imageQuizOfFlags.leadingAnchor.constraint(equalTo: buttonQuizOfFlags.leadingAnchor, constant: 10),
            imageQuizOfFlags.centerYAnchor.constraint(equalTo: buttonQuizOfFlags.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelQuizOfFlags.centerXAnchor.constraint(equalTo: buttonQuizOfFlags.centerXAnchor, constant: 25),
            labelQuizOfFlags.centerYAnchor.constraint(equalTo: buttonQuizOfFlags.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageQuizOfFlagsDetails.centerXAnchor.constraint(equalTo: buttonQuizOfFlagsDetails.centerXAnchor),
            imageQuizOfFlagsDetails.centerYAnchor.constraint(equalTo: buttonQuizOfFlagsDetails.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonSettings.topAnchor.constraint(equalTo: stackViewQuizOfFlags.bottomAnchor, constant: 20),
            buttonSettings.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            buttonSettings.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            buttonSettings.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            imageSettings.leadingAnchor.constraint(equalTo: buttonSettings.leadingAnchor, constant: 10),
            imageSettings.centerYAnchor.constraint(equalTo: buttonSettings.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelSettings.centerXAnchor.constraint(equalTo: buttonSettings.centerXAnchor),
            labelSettings.centerYAnchor.constraint(equalTo: buttonSettings.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelGameMode.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelGameMode.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            labelGameMode.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            labelGameMode.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
}
