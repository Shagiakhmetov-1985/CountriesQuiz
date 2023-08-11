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
    private lazy var labelMenu: UILabel = {
        let label = setLabel(
            title: "Countries Quiz",
            size: 40,
            style: "echorevival",
            color: .blueBlackSea)
        return label
    }()
    
    private lazy var buttonSettings: UIButton = {
        let button = setButton(
            color: .grayLight,
            image: imageSettings,
            action: #selector(setting))
        return button
    }()
    
    private lazy var imageSettings: UIImageView = {
        let imageView = setImage(
            image: "gear",
            color: .white,
            size: 26)
        return imageView
    }()
    
    private lazy var stackViewMenu: UIStackView = {
        let stackView = setupStackView(
            label: labelMenu,
            button: buttonSettings)
        return stackView
    }()
    
    private lazy var contentView: UIView = {
        let view = setupView(color: .white)
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    private lazy var buttonQuizOfFlags: UIButton = {
        let button = setButton(
            color: .cyanDark,
            image: imageFlag,
            label: labelQuizOfFlags,
            view: viewQuizOfFlags,
            imageGame: imageQuizOfFlags,
            action: #selector(gameType))
        return button
    }()
    
    private lazy var imageFlag: UIImageView = {
        let imageView = setImage(
            image: "flag",
            color: .white,
            size: 20)
        return imageView
    }()
    
    private lazy var labelQuizOfFlags: UILabel = {
        let label = setLabel(
            title: "Викторина флагов",
            size: 26,
            style: "Gill Sans",
            color: .white,
            alignment: .left)
        return label
    }()
    
    private lazy var viewQuizOfFlags: UIView = {
        let view = setupView(
            color: .white.withAlphaComponent(0.8),
            radius: radius())
        return view
    }()
    
    private lazy var imageQuizOfFlags: UIImageView = {
        let imageView = setImage(
            image: "filemenu.and.selection",
            color: .cyanDark,
            size: 60)
        return imageView
    }()
    
    private lazy var buttonQuestionnaire: UIButton = {
        let button = setButton(
            color: .greenHarlequin,
            image: imageCheckmark,
            label: labelQuestionnaire,
            view: viewQuestionnaire,
            imageGame: imageQuestionnaire,
            tag: 1,
            action: #selector(gameType))
        return button
    }()
    
    private lazy var imageCheckmark: UIImageView = {
        let imageView = setImage(
            image: "checkmark.circle.badge.questionmark",
            color: .white,
            size: 20)
        return imageView
    }()
    
    private lazy var labelQuestionnaire: UILabel = {
        let label = setLabel(
            title: "Опрос",
            size: 26,
            style: "Gill Sans",
            color: .white,
            alignment: .left)
        return label
    }()
    
    private lazy var viewQuestionnaire: UIView = {
        let view = setupView(
            color: .white.withAlphaComponent(0.8),
            radius: radius())
        return view
    }()
    
    private lazy var imageQuestionnaire: UIImageView = {
        let imageView = setImage(
            image: "checklist",
            color: .greenHarlequin,
            size: 60)
        return imageView
    }()
    
    private lazy var buttonQuizOfMaps: UIButton = {
        let button = setButton(
            color: .redYellowBrown,
            image: imageMap,
            label: labelQuizOfMaps,
            view: viewQuizOfMaps,
            imageGame: imageQuizOfMaps,
            tag: 2,
            action: #selector(gameType))
        return button
    }()
    
    private lazy var imageMap: UIImageView = {
        let imageView = setImage(
            image: "map",
            color: .white,
            size: 20)
        return imageView
    }()
    
    private lazy var labelQuizOfMaps: UILabel = {
        let label = setLabel(
            title: "Викторина карт",
            size: 26,
            style: "Gill Sans",
            color: .white,
            alignment: .left)
        return label
    }()
    
    private lazy var viewQuizOfMaps: UIView = {
        let view = setupView(
            color: .white.withAlphaComponent(0.8),
            radius: radius())
        return view
    }()
    
    private lazy var imageQuizOfMaps: UIImageView = {
        let imageView = setImage(
            image: "globe.desk",
            color: .redYellowBrown,
            size: 60)
        return imageView
    }()
    
    private lazy var buttonScrabble: UIButton = {
        let button = setButton(
            color: .indigo,
            image: imageText,
            label: labelScrabble,
            view: viewScrabble,
            imageGame: imageScrabble,
            tag: 3,
            action: #selector(gameType))
        return button
    }()
    
    private lazy var imageText: UIImageView = {
        let imageView = setImage(
            image: "textformat.abc",
            color: .white,
            size: 20)
        return imageView
    }()
    
    private lazy var labelScrabble: UILabel = {
        let label = setLabel(
            title: "Эрудит",
            size: 26,
            style: "Gill Sans",
            color: .white,
            alignment: .left)
        return label
    }()
    
    private lazy var viewScrabble: UIView = {
        let view = setupView(
            color: .white.withAlphaComponent(0.8),
            radius: radius())
        return view
    }()
    
    private lazy var imageScrabble: UIImageView = {
        let imageView = setImage(
            image: "a.square",
            color: .indigo,
            size: 60)
        return imageView
    }()
    
    private lazy var buttonQuizOfCapitals: UIButton = {
        let button = setButton(
            color: .redTangerineTango,
            image: imageHouse,
            label: labelQuizOfCapitals,
            view: viewQuizOfCapitals,
            imageGame: imageQuizOfCapitals,
            tag: 4,
            action: #selector(gameType))
        return button
    }()
    
    private lazy var imageHouse: UIImageView = {
        let imageView = setImage(
            image: "house.and.flag",
            color: .white,
            size: 20)
        return imageView
    }()
    
    private lazy var labelQuizOfCapitals: UILabel = {
        let label = setLabel(
            title: "Викторина столиц",
            size: 26,
            style: "Gill Sans",
            color: .white,
            alignment: .left)
        return label
    }()
    
    private lazy var viewQuizOfCapitals: UIView = {
        let view = setupView(
            color: .white.withAlphaComponent(0.8),
            radius: radius())
        return view
    }()
    
    private lazy var imageQuizOfCapitals: UIImageView = {
        let imageView = setImage(
            image: "building.2",
            color: .redTangerineTango,
            size: 60)
        return imageView
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
    
    private let games = Games.getGames()
    private var mode: Setting!
    private var transition = Transition()
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupSubviews()
        setupSubviewOnContentView()
        setupSubviewsOnScrollView()
        setupConstraints()
        gameMode()
    }
    
    // MARK: - Private methods
    private func setupDesign() {
        view.backgroundColor = .white
        mode = StorageManager.shared.fetchSetting()
    }
    
    private func setupSubviews() {
        setupSubviews(subviews: stackViewMenu, contentView, on: view)
    }
    
    private func setupSubviewOnContentView() {
        setupSubviews(subviews: scrollView, on: contentView)
    }
    
    private func setupSubviewsOnScrollView() {
        setupSubviews(subviews: buttonQuizOfFlags, buttonQuestionnaire,
                      buttonQuizOfMaps, buttonScrabble, buttonQuizOfCapitals,
                      on: scrollView)
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    private func gameMode() {
        let countQuestions = mode.countQuestions
        let continents = comma(continents: mode.allCountries, mode.americaContinent,
                               mode.europeContinent, mode.africaContinent,
                               mode.asiaContinent, mode.oceaniaContinent)
        let timeElapsed = mode.timeElapsed.timeElapsed ? "Да" : "Нет"
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
        guard mode.timeElapsed.timeElapsed else { return "" }
        let time = mode.timeElapsed.questionSelect.oneQuestion
        let questionTime = time ? "Время одного вопроса:" : "Время всех вопросов:"
        return "\(questionTime) \(checkQuestionTime(check: time))"
    }
    
    private func checkQuestionTime(check: Bool) -> String {
        check ?
        "\(mode.timeElapsed.questionSelect.questionTime.oneQuestionTime)" :
        "\(mode.timeElapsed.questionSelect.questionTime.allQuestionsTime)"
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
    
    @objc private func gameType(sender: UIButton) {
        let tag = sender.tag
        let gameTypeVC = GameTypeViewController()
        gameTypeVC.mode = mode
        gameTypeVC.game = games[tag]
        navigationController?.pushViewController(gameTypeVC, animated: true)
    }
    
    @objc private func setting() {
        let settingVC = SettingViewController()
        settingVC.modalPresentationStyle = .custom
        settingVC.transitioningDelegate = self
        settingVC.mode = mode
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
                           view: UIView? = nil, imageGame: UIView? = nil,
                           tag: Int? = nil, action: Selector) -> UIButton {
        let button = Button(type: .custom)
        button.backgroundColor = color
        button.layer.cornerRadius = 12
        button.layer.shadowOpacity = 0.4
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.tag = tag ?? 0
        button.translatesAutoresizingMaskIntoConstraints = false
        if let label = label, let view = view, let imageGame = imageGame {
            setupSubviews(subviews: image, label, view, imageGame, on: button)
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
    
    private func setupStackView(label: UILabel, button: UIButton) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [label, button])
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
    
    private func setupView(color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.frame.size = contentSize
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + 10)
    }
}
// MARK: - Delegate rewrite user defaults
extension MenuViewController: SettingViewControllerDelegate {
    func sendDataOfSetting(setting: Setting) {
        mode = setting
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
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackViewMenu.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackViewMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        setupSquare(subview: buttonSettings, sizes: 40)
        setupCenterSubview(subview: imageSettings, on: buttonSettings)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: stackViewMenu.bottomAnchor, constant: 10),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setConstraintsList(button: buttonQuizOfFlags, image: imageFlag,
                           label: labelQuizOfFlags, viewGame: viewQuizOfFlags,
                           imageGame: imageQuizOfFlags, layout: scrollView.topAnchor)
        setConstraintsList(button: buttonQuestionnaire, image: imageCheckmark,
                           label: labelQuestionnaire, viewGame: viewQuestionnaire,
                           imageGame: imageQuestionnaire, layout: buttonQuizOfFlags.bottomAnchor)
        setConstraintsList(button: buttonQuizOfMaps, image: imageMap,
                           label: labelQuizOfMaps, viewGame: viewQuizOfMaps,
                           imageGame: imageQuizOfMaps, layout: buttonQuestionnaire.bottomAnchor)
        setConstraintsList(button: buttonScrabble, image: imageText,
                           label: labelScrabble, viewGame: viewScrabble,
                           imageGame: imageScrabble, layout: buttonQuizOfMaps.bottomAnchor)
        setConstraintsList(button: buttonQuizOfCapitals, image: imageHouse,
                           label: labelQuizOfCapitals, viewGame: viewQuizOfCapitals,
                           imageGame: imageQuizOfCapitals, layout: buttonScrabble.bottomAnchor)
    }
    
    private func setConstraintsList(button: UIButton, image: UIImageView,
                                    label: UILabel, viewGame: UIView,
                                    imageGame: UIImageView, layout: NSLayoutYAxisAnchor) {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: layout, constant: 15),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: button.topAnchor, constant: 20),
            image.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 20),
            label.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            viewGame.topAnchor.constraint(equalTo: button.topAnchor, constant: 10),
            viewGame.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10)
        ])
        setupSquare(subview: viewGame, sizes: radius() * 2)
        setupCenterSubview(subview: imageGame, on: viewGame)
    }
    
    private func setupSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    private func setupCenterSubview(subview: UIView, on subviewOther: UIView) {
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: subviewOther.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: subviewOther.centerYAnchor)
        ])
    }
    
    private func radius() -> CGFloat {
        50
    }
    
    private func fixConstraintsForButtonBySizeIphone() -> CGFloat {
        view.frame.height > 736 ? 60 : 20
    }
}
