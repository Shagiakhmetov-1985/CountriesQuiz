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
    private lazy var viewMiddlePanel: UIView = {
        let view = setupView(color: .skyCyanLight, radius: 45)
        return view
    }()
    
    private lazy var viewTopPanel: UIView = {
        let view = setupView(color: .cyanDark, radius: 45)
        return view
    }()
    
    private lazy var viewQuizOfFlags: UIView = {
        let view = setupView(
            color: .panelViewLightBlueLight,
            radius: 12,
            image: imageQuizOfFlags,
            label: labelQuizOfFlags,
            stackView: stackViewQuizOfFlags)
        return view
    }()
    
    private lazy var labelMenuCountries: UILabel = {
        let label = setLabel(
            title: "Countries",
            size: 55,
            style: "echorevival",
            color: .white)
        return label
    }()
    
    private lazy var labelMenuQuiz: UILabel = {
        let label = setLabel(
            title: "Quiz",
            size: 50,
            style: "echorevival",
            color: .white)
        return label
    }()
    
    private lazy var buttonStart: UIButton = {
        let button = setButton(
            color: .blueBlackSea,
            image: imageStart,
            label: labelStart,
            action: #selector(start))
        return button
    }()
    
    private lazy var buttonQuizOfFlags: UIButton = {
        let button = setButton(
            color: .systemBlue,
            image: imageStart,
            action: #selector(start))
        return button
    }()
    
    private lazy var buttonQuizOfFlagsDetails: UIButton = {
        let button = setButton(
            color: .systemBlue,
            image: imageQuizOfFlagsDetails,
            action: #selector(quizOfFlagsDetails))
        return button
    }()
    
    private lazy var buttonBack: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrowshape.backward"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .blueBlackSea
        button.layer.cornerRadius = 12.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var imageStart: UIImageView = {
        let imageView = setImage(
            image: "play",
            color: .white,
            size: 24)
        return imageView
    }()
    
    private lazy var imageMenu: UIImageView = {
        let imageView = setImage(
            image: "globe.desk",
            color: .blueMiddlePersian,
            size: 80)
        return imageView
    }()
    
    private lazy var imageQuizOfFlags: UIImageView = {
        let imageView = setImage(
            image: "filemenu.and.selection",
            color: .white,
            size: 45)
        return imageView
    }()
    
    private lazy var imageQuizOfFlagsDetails: UIImageView = {
        let imageView = setImage(
            image: "questionmark",
            color: .white,
            size: 20)
        return imageView
    }()
    
    private lazy var imageBack: UIImageView = {
        let imageView = setImage(
            image: "arrowshape.backward",
            color: .white,
            size: 28)
        return imageView
    }()
    
    private lazy var labelStart: UILabel = {
        let label = setLabel(
            title: "Начать",
            size: 23,
            style: "mr_fontick",
            color: .white,
            alignment: .center)
        return label
    }()
    
    private lazy var labelQuizOfFlags: UILabel = {
        let label = setLabel(
            title: "Викторина флагов",
            size: 24,
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
            color: .white,
            alignment: .center)
        return label
    }()
    
    private var heightTopPanel: NSLayoutConstraint!
    private var timer: Timer!
    
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
        view.backgroundColor = UIColor.blueBlackSea
        setupSubviews(subviews: viewMiddlePanel, viewTopPanel, labelMenuCountries,
                      labelMenuQuiz, imageMenu, viewQuizOfFlags, labelGameMode,
                      on: view)
        settingDefault = StorageManager.shared.fetchSetting()
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    private func removeSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            subview.removeFromSuperview()
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
    
    private func setOpacity(subviews: UIView..., duration: CGFloat, opacity: Float) {
        subviews.forEach { subview in
            UIView.animate(withDuration: duration) {
                subview.layer.opacity = opacity
            }
        }
    }
    
    private func setOpacity(subviews: UIView..., opacity: Float) {
        subviews.forEach { subview in
            subview.layer.opacity = opacity
        }
    }
    
    private func changeConstraints(subviews: NSLayoutConstraint...,
                                   change size: CGFloat, duration: CGFloat) {
        subviews.forEach { subview in
            UIView.animate(withDuration: duration) {
                subview.constant = size
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func start() {
        let quizOfFlagsVC = QuizOfFlagsViewController()
        quizOfFlagsVC.setting = settingDefault
        navigationController?.pushViewController(quizOfFlagsVC, animated: true)
    }
    /*
    private func addSubviews() {
        setupSubviews(subviews: buttonBack, on: view)
        setOpacity(subviews: buttonBack, opacity: 0)
        setupBarButton()
        setupConstraintForAddSubviews()
        setOpacity(subviews: buttonBack, duration: 0.5, opacity: 1)
    }
    */
    
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
        imageView.tintColor = color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
// MARK: - Setup stack view
extension MenuViewController {
    private func setupStackView(buttonFirst: UIButton, buttonSecond: UIButton) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [buttonFirst, buttonSecond])
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Setup view
extension MenuViewController {
    private func setupView(color: UIColor, radius: CGFloat, image: UIImageView? = nil,
                           label: UILabel? = nil, stackView: UIStackView? = nil) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = radius
        view.translatesAutoresizingMaskIntoConstraints = false
        if let image = image, let label = label, let stackView = stackView {
            setupSubviews(subviews: image, label, stackView, on: view)
        }
        return view
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
// MARK: - Set constraints
extension MenuViewController {
    private func setConstraints() {
        heightTopPanel = viewTopPanel.heightAnchor.constraint(equalToConstant: 200)
        
        NSLayoutConstraint.activate([
            viewMiddlePanel.topAnchor.constraint(equalTo: view.topAnchor),
            viewMiddlePanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewMiddlePanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewMiddlePanel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -130)
        ])
        
        NSLayoutConstraint.activate([
            viewTopPanel.topAnchor.constraint(equalTo: view.topAnchor, constant: -45),
            viewTopPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewTopPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heightTopPanel
        ])
        
        NSLayoutConstraint.activate([
            labelMenuCountries.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            labelMenuCountries.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            labelMenuCountries.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        NSLayoutConstraint.activate([
            labelMenuQuiz.topAnchor.constraint(equalTo: labelMenuCountries.topAnchor, constant: 45),
            labelMenuQuiz.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 240),
            labelMenuQuiz.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            imageMenu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageMenu.topAnchor.constraint(equalTo: labelMenuQuiz.bottomAnchor, constant: 25)
        ])
        
        NSLayoutConstraint.activate([
            viewQuizOfFlags.topAnchor.constraint(equalTo: imageMenu.bottomAnchor, constant: 25),
            viewQuizOfFlags.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        setupSize(subview: viewQuizOfFlags, width: view.frame.width - 60, height: 90)
        
        NSLayoutConstraint.activate([
            imageQuizOfFlags.centerYAnchor.constraint(equalTo: viewQuizOfFlags.centerYAnchor),
            imageQuizOfFlags.leadingAnchor.constraint(equalTo: viewQuizOfFlags.leadingAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            labelQuizOfFlags.topAnchor.constraint(equalTo: viewQuizOfFlags.topAnchor, constant: 15),
            labelQuizOfFlags.leadingAnchor.constraint(equalTo: imageQuizOfFlags.trailingAnchor, constant: 15)
        ])
        
        NSLayoutConstraint.activate([
            stackViewQuizOfFlags.topAnchor.constraint(equalTo: labelQuizOfFlags.bottomAnchor, constant: 5),
            stackViewQuizOfFlags.centerXAnchor.constraint(equalTo: labelQuizOfFlags.centerXAnchor)
        ])
        setupSize(subview: stackViewQuizOfFlags, width: 165, height: 30)
        
        NSLayoutConstraint.activate([
            imageStart.centerXAnchor.constraint(equalTo: buttonQuizOfFlags.centerXAnchor),
            imageStart.centerYAnchor.constraint(equalTo: buttonQuizOfFlags.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageQuizOfFlagsDetails.centerXAnchor.constraint(equalTo: buttonQuizOfFlagsDetails.centerXAnchor),
            imageQuizOfFlagsDetails.centerYAnchor.constraint(equalTo: buttonQuizOfFlagsDetails.centerYAnchor)
        ])
        /*
        NSLayoutConstraint.activate([
            stackViewMenu.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackViewMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            stackViewMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        setupSquare(subview: buttonSettings, sizes: 50)
        
        NSLayoutConstraint.activate([
            imageStart.leadingAnchor.constraint(equalTo: buttonStart.leadingAnchor, constant: 20),
            imageStart.centerYAnchor.constraint(equalTo: buttonStart.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelStart.centerXAnchor.constraint(equalTo: buttonStart.centerXAnchor, constant: 15),
            labelStart.centerYAnchor.constraint(equalTo: buttonStart.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageSettings.centerXAnchor.constraint(equalTo: buttonSettings.centerXAnchor),
            imageSettings.centerYAnchor.constraint(equalTo: buttonSettings.centerYAnchor)
        ])
        */
        NSLayoutConstraint.activate([
            labelGameMode.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelGameMode.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            labelGameMode.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            labelGameMode.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
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
    
    private func setupConstraintForAddSubviews() {
        setupSize(subview: buttonBack, width: 80, height: 25)
        
//        NSLayoutConstraint.activate([
//            imageBack.centerXAnchor.constraint(equalTo: buttonBack.centerXAnchor),
//            imageBack.centerYAnchor.constraint(equalTo: buttonBack.centerYAnchor)
//        ])
    }
    
    private func fixConstraintsForButtonBySizeIphone() -> CGFloat {
        view.frame.height > 736 ? 60 : 20
    }
}
