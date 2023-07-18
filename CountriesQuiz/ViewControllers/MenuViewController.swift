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
    private lazy var labelMainCountries: UILabel = {
        let label = setLabel(
            title: "Countries",
            size: 55,
            style: "echorevival",
            color: UIColor(
                red: 184/255,
                green: 227/255,
                blue: 252/255,
                alpha: 1),
            colorOfShadow: CGColor(
                red: 10/255,
                green: 10/255,
                blue: 10/255,
                alpha: 1),
            radiusOfShadow: 4,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2)
        return label
    }()
    
    private lazy var labelMainQuiz: UILabel = {
        let label = setLabel(
            title: "Quiz",
            size: 50,
            style: "echorevival",
            color: UIColor(
                red: 184/255,
                green: 227/255,
                blue: 252/255,
                alpha: 1),
            colorOfShadow: CGColor(
                red: 10/255,
                green: 10/255,
                blue: 10/255,
                alpha: 1),
            radiusOfShadow: 4,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2)
        return label
    }()
    
    private var imageMain: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Worldmap")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var buttonQuizOfFlags: UIButton = {
        let button = setButton(
            title: "Quiz of flags",
            size: 22,
            colorTitle: UIColor(
                red: 184/255,
                green: 247/255,
                blue: 252/255,
                alpha: 1),
            colorBackgroud: UIColor(
                red: 125/255,
                green: 222/255,
                blue: 255/255,
                alpha: 0.2),
            radiusCorner: 10,
            borderWidth: 3,
            borderColor: UIColor(
                red: 184/255,
                green: 247/255,
                blue: 252/255,
                alpha: 1).cgColor,
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 252/255,
                alpha: 1).cgColor,
            radiusShadow: 3,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2)
        button.addTarget(self, action: #selector(startQuizOfFlags), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonSetting: UIButton = {
        let button = setButton(
            title: "Setting",
            size: 22,
            colorTitle: UIColor(
                red: 184/255,
                green: 247/255,
                blue: 252/255,
                alpha: 1),
            colorBackgroud: UIColor(
                red: 125/255,
                green: 222/255,
                blue: 255/255,
                alpha: 0.2),
            radiusCorner: 10,
            borderWidth: 3,
            borderColor: UIColor(
                red: 184/255,
                green: 247/255,
                blue: 252/255,
                alpha: 1).cgColor,
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 252/255,
                alpha: 1).cgColor,
            radiusShadow: 3,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2)
        button.addTarget(self, action: #selector(setting), for: .touchUpInside)
        return button
    }()
    
    private lazy var labelGameMode: UILabel = {
        let label = setLabel(
            title: "",
            size: 20,
            style: "mr_fontick",
            color: UIColor(
                red: 184/255,
                green: 247/255,
                blue: 252/255,
                alpha: 1),
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
        setupSubviews(subviews: imageMain, labelMainCountries, labelMainQuiz,
                      buttonQuizOfFlags, buttonSetting, labelGameMode)
        settingDefault = StorageManager.shared.fetchSetting()
    }
    
    private func setupSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
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
    
    private func showGameMode(countQuestions: Int, continents: String, timeElapsed: String, questionTime: String) {
        labelGameMode.text = """
        Количество вопросов: \(countQuestions)
        Континенты: \(continents)
        Обратный отсчет: \(timeElapsed)
        \(questionTime)
        """
    }
    // MARK: - Set constraints
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageMain.topAnchor.constraint(equalTo: view.topAnchor),
            imageMain.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageMain.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageMain.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelMainCountries.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            labelMainCountries.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            labelMainCountries.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            labelMainQuiz.topAnchor.constraint(equalTo: labelMainCountries.topAnchor, constant: 45),
            labelMainQuiz.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 220),
            labelMainQuiz.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            buttonQuizOfFlags.topAnchor.constraint(equalTo: labelMainQuiz.topAnchor, constant: 150),
            buttonQuizOfFlags.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonQuizOfFlags.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            buttonSetting.topAnchor.constraint(equalTo: buttonQuizOfFlags.topAnchor, constant: 48),
            buttonSetting.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buttonSetting.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        NSLayoutConstraint.activate([
            labelGameMode.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelGameMode.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            labelGameMode.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            labelGameMode.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ])
    }
    
    @objc private func startQuizOfFlags() {
        let quizOfFlagsVC = QuizOfFlagsViewController()
        quizOfFlagsVC.setting = settingDefault
        navigationController?.pushViewController(quizOfFlagsVC, animated: true)
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
    private func setButton(title: String, size: CGFloat, colorTitle: UIColor? = nil,
                           colorBackgroud: UIColor? = nil, radiusCorner: CGFloat,
                           borderWidth: CGFloat? = nil, borderColor: CGColor? = nil,
                           shadowColor: CGColor? = nil, radiusShadow: CGFloat? = nil,
                           shadowOffsetWidth: CGFloat? = nil,
                           shadowOffsetHeight: CGFloat? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: size, weight: .semibold)
        button.setTitleColor(colorTitle, for: .normal)
        button.backgroundColor = colorBackgroud
        button.layer.cornerRadius = radiusCorner
        button.layer.borderWidth = borderWidth ?? 0
        button.layer.borderColor = borderColor
        button.layer.shadowColor = shadowColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = radiusShadow ?? 0
        button.layer.shadowOffset = CGSize(width: shadowOffsetWidth ?? 0,
                                           height: shadowOffsetHeight ?? 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
