//
//  GameTypeViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 03.08.2023.
//

import UIKit

protocol PopUpDescriptionDelegate {
    func closeView()
}

class GameTypeViewController: UIViewController {
    private lazy var viewGameType: UIView = {
        setupView(color: .white.withAlphaComponent(0.8), radius: diameter() / 2)
    }()
    
    private lazy var imageGameType: UIImageView = {
        setupImage(image: "\(game.image)", color: game.background, size: 60)
    }()
    
    private lazy var labelGameName: UILabel = {
        setupLabel(title: "\(game.name)", size: 30)
    }()
    
    private lazy var buttonBack: UIButton = {
        setupButton(image: "multiply", action: #selector(backToMenu))
    }()
    
    private lazy var buttonHelp: UIButton = {
        setupButton(image: "questionmark", action: #selector(showDescription))
    }()
    
    private lazy var labelDescription: UILabel = {
        setupLabel(title: "\(game.description)", size: 19, alignment: .left)
    }()
    
    private lazy var labelBulletsList: UILabel = {
        bulletsList(list: bulletsListGameType())
    }()
    
    private lazy var imageFirstSwap: UIImageView = {
        setupImage(image: "flag", color: .white, size: 25)
    }()
    
    private lazy var viewFirstSwap: UIView = {
        setupView(color: game.swap, radius: 12, addSubview: imageFirstSwap)
    }()
    
    private lazy var labelFirstSwap: UILabel = {
        setupLabel(
            title: "Режим флага",
            size: 24,
            alignment: .left)
    }()
    
    private lazy var labelFirstDescriptionSwap: UILabel = {
        setupLabel(
            title: "В качестве вопроса задается флаг страны и пользователь должен выбрать ответ наименования страны.",
            size: 19,
            alignment: .left)
    }()
    
    private lazy var stackViewFirst: UIStackView = {
        setupStackView(labelTop: labelFirstSwap, labelBottom: labelFirstDescriptionSwap)
    }()
    
    private lazy var stackViewFirstSwap: UIStackView = {
        setupStackView(view: viewFirstSwap, stackView: stackViewFirst)
    }()
    
    private lazy var imageSecondSwap: UIImageView = {
        setupImage(image: "building", color: .white, size: 25)
    }()
    
    private lazy var viewSecondSwap: UIView = {
        setupView(color: game.swap, radius: 12, addSubview: imageSecondSwap)
    }()
    
    private lazy var labelSecondSwap: UILabel = {
        setupLabel(
            title: "Режим наименования",
            size: 24,
            alignment: .left)
    }()
    
    private lazy var labelSecondDescriptionSwap: UILabel = {
        setupLabel(
            title: "В качестве вопроса задается наименование страны и пользователь должен выбрать ответ флага страны.",
            size: 19,
            alignment: .left)
    }()
    
    private lazy var stackViewSecond: UIStackView = {
        setupStackView(labelTop: labelSecondSwap, labelBottom: labelSecondDescriptionSwap)
    }()
    
    private lazy var stackViewSecondSwap: UIStackView = {
        setupStackView(view: viewSecondSwap, stackView: stackViewSecond)
    }()
    
    private lazy var viewDescription: UIView = {
        let view = setupView(color: .clear)
        setupSubviews(subviews: labelDescription, labelBulletsList, 
                      stackViewFirstSwap, stackViewSecondSwap, on: view)
        settingLabel(label: labelBulletsList, size: 19)
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = game.background
        scrollView.layer.cornerRadius = 15
        scrollView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        setupSubviews(subviews: viewDescription, on: scrollView)
        return scrollView
    }()
    
    private lazy var viewHelp: UIView = {
        let view = PopUpDescription()
        view.backgroundColor = game.swap
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        setupSubviews(subviews: scrollView, on: view)
        return view
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var buttonStart: UIButton = {
        setupButton(image: "play", color: game.play, action: #selector(startGame))
    }()
    
    private lazy var buttonFavoutites: UIButton = {
        setupButton(image: "star", color: game.favourite, action: #selector(favourites))
    }()
    
    private lazy var buttonSwap: UIButton = {
        setupButton(
            image: mode.flag ? "flag" : "building",
            color: game.swap,
            action: #selector(swap))
    }()
    
    private lazy var stackViewButtons: UIStackView = {
        setupStackView(
            buttonFirst: buttonStart,
            buttonSecond: buttonFavoutites,
            buttonThird: buttonSwap)
    }()
    
    private lazy var buttonCountQuestions: UIButton = {
        setupButton(
            color: game.swap,
            labelFirst: labelCountQuestion,
            labelSecond: labelCount,
            tag: 1,
            action: #selector(changeSetting))
    }()
    
    private lazy var labelCountQuestion: UILabel = {
        setupLabel(title: "\(mode.countQuestions)", size: 60)
    }()
    
    private lazy var labelCount: UILabel = {
        setupLabel(title: "Количество вопросов", size: 17)
    }()
    
    private lazy var buttonContinents: UIButton = {
        setupButton(
            color: game.swap,
            labelFirst: labelContinents,
            labelSecond: labelContinentsDescription,
            tag: 2,
            action: #selector(changeSetting))
    }()
    
    private lazy var labelContinents: UILabel = {
        setupLabel(title: "\(comma())", size: 30)
    }()
    
    private lazy var labelContinentsDescription: UILabel = {
        setupLabel(title: "Континенты", size: 17)
    }()
    
    private lazy var buttonCountdown: UIButton = {
        setupButton(
            color: game.swap,
            labelFirst: labelCountdown,
            labelSecond: labelCountdownDesription,
            tag: 3,
            action: #selector(changeSetting))
    }()
    
    private lazy var labelCountdown: UILabel = {
        setupLabel(title: mode.timeElapsed.timeElapsed ? "Да" : "Нет", size: 60)
    }()
    
    private lazy var labelCountdownDesription: UILabel = {
        setupLabel(title: "Обратный отсчёт", size: 17)
    }()
    
    private lazy var buttonTime: UIButton = {
        setupButton(
            color: game.swap,
            labelFirst: labelTime,
            labelSecond: labelTimeDesription,
            image: imageInfinity,
            tag: 4,
            action: #selector(changeSetting))
    }()
    
    private lazy var labelTime: UILabel = {
        setupLabel(title: "\(timeElapsedOnOff())", size: 60)
    }()
    
    private lazy var labelTimeDesription: UILabel = {
        setupLabel(title: "\(checkTimeElapsedDescription())", size: 17)
    }()
    
    private lazy var imageInfinity: UIImageView = {
        setupImage(image: "infinity", color: .white, size: 60)
    }()
    
    var mode: Setting!
    var game: Games!
    var tag: Int!
    
    typealias ParagraphData = (bullet: String, paragraph: String)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupSubviews()
        setupBarButton()
        setupConstraints()
    }
    // MARK: - General methods
    private func setupDesign() {
        view.backgroundColor = game.background
        imageInfinity.isHidden = mode.timeElapsed.timeElapsed ? true : false
    }
    
    private func setupSubviews() {
        setupSubviews(subviews: viewGameType, imageGameType, labelGameName,
                      stackViewButtons, buttonCountQuestions, buttonContinents,
                      buttonCountdown, buttonTime, visualEffectView,
                      on: view)
    }
    
    private func setupBarButton() {
        let leftBarButton = UIBarButtonItem(customView: buttonBack)
        let rightBarButton = UIBarButtonItem(customView: buttonHelp)
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    private func buttonsOnOff(bool: Bool) {
        let opacity: Float = bool ? 1 : 0
        isEnabled(buttons: buttonBack, buttonHelp, bool: bool)
        setupOpacityButtons(buttons: buttonBack, buttonHelp, opacity: opacity)
    }
    
    private func isEnabled(buttons: UIButton..., bool: Bool) {
        buttons.forEach { button in
            button.isEnabled = bool
        }
    }
    
    private func setupOpacityButtons(buttons: UIButton..., opacity: Float) {
        buttons.forEach { button in
            UIView.animate(withDuration: 0.5) {
                button.layer.opacity = opacity
            }
        }
    }
    
    @objc private func backToMenu() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func showDescription() {
        setupSubviews(subviews: viewHelp, on: view)
        setupConstraintsViewHelp()
        buttonsOnOff(bool: false)
        
        viewHelp.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        viewHelp.alpha = 0
        UIView.animate(withDuration: 0.5) { [self] in
            visualEffectView.alpha = 1
            viewHelp.alpha = 1
            viewHelp.transform = CGAffineTransform.identity
        }
    }
    // MARK: - Start game, favourites and swap
    @objc private func startGame() {
        switch tag {
        case 0: quizOfFlagsViewController()
        case 1: questionnaireViewController()
        default: quizOfCapitalsViewController()
        }
    }
    
    private func quizOfFlagsViewController() {
        let startGameVC = QuizOfFlagsViewController()
        startGameVC.mode = mode
        startGameVC.game = game
        navigationController?.pushViewController(startGameVC, animated: true)
    }
    
    private func questionnaireViewController() {
        let startGameVC = QuestionnaireViewController()
        startGameVC.mode = mode
        startGameVC.game = game
        navigationController?.pushViewController(startGameVC, animated: true)
    }
    
    private func quizOfCapitalsViewController() {
        let startGameVC = QuizOfCapitalsViewController()
        startGameVC.mode = mode
        startGameVC.game = game
        navigationController?.pushViewController(startGameVC, animated: true)
    }
    
    @objc private func favourites() {
        
    }
    
    @objc private func swap() {
        if mode.flag {
            let size = UIImage.SymbolConfiguration(pointSize: 20)
            let image = UIImage(systemName: "building", withConfiguration: size)
            buttonSwap.setImage(image, for: .normal)
        } else {
            let size = UIImage.SymbolConfiguration(pointSize: 20)
            let image = UIImage(systemName: "flag", withConfiguration: size)
            buttonSwap.setImage(image, for: .normal)
        }
        mode.flag.toggle()
        StorageManager.shared.saveSetting(setting: mode)
    }
    // MARK: - Buttons for change setting
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
        "\(checkTimeGameType())" :
        "\(mode.timeElapsed.questionSelect.questionTime.allQuestionsTime)"
    }
    
    private func checkTimeGameType() -> String {
        game.gameType == .questionnaire ?
        "\(mode.timeElapsed.questionSelect.questionTime.allQuestionsTime)" :
        "\(mode.timeElapsed.questionSelect.questionTime.oneQuestionTime)"
    }
    
    private func checkTimeElapsedDescription() -> String {
        mode.timeElapsed.questionSelect.oneQuestion ?
        "\(checkTitleGameType())" : "Время всех вопросов"
    }
    
    private func checkTitleGameType() -> String {
        game.gameType == .questionnaire ? "Время всех вопросов" : "Время одного вопроса"
    }
    
    @objc private func changeSetting() {
        
    }
}
// MARK: - Setup views
extension GameTypeViewController {
    private func setupView(color: UIColor, radius: CGFloat? = nil,
                           addSubview: UIView? = nil) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = radius ?? 0
        view.translatesAutoresizingMaskIntoConstraints = false
        if let image = addSubview {
            setupSubviews(subviews: image, on: view)
        }
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
    private func setupLabel(title: String, size: CGFloat,
                            alignment: NSTextAlignment? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = UIFont(name: "Gill Sans", size: size)
        label.textAlignment = alignment ?? .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func settingLabel(label: UILabel, size: CGFloat) {
        label.textColor = .white
        label.font = UIFont(name: "Gill Sans", size: size)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func bulletsListGameType() -> [String] {
        switch tag {
        case 0: return GameType.shared.bulletsQuizOfFlags
        case 1: return GameType.shared.bulletsQuestionnaire
        case 2: return GameType.shared.bulletsQuizOfMaps
        case 3: return GameType.shared.bulletsScrabble
        default: return GameType.shared.bulletsQuizOfCapitals
        }
    }
    
    private func bulletsList(list: [String]) -> UILabel {
        let label = UILabel()
        let paragraphDataPairs: [ParagraphData] = bullets(list: list)
        let stringAttributes: [NSAttributedString.Key: Any] = [.font: label.font!]
        let bulletedAttributedString = makeBulletedAttributedString(
            paragraphDataPairs: paragraphDataPairs,
            attributes: stringAttributes)
        label.attributedText = bulletedAttributedString
        return label
    }
    
    private func bullets(list: [String]) -> [ParagraphData] {
        var paragraphData: [ParagraphData] = []
        list.forEach { text in
            let pair = ("➤ ", "\(text)")
            paragraphData.append(pair)
        }
        return paragraphData
    }
    
    private func makeBulletedAttributedString(
        paragraphDataPairs: [ParagraphData],
        attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let fullAttributedString = NSMutableAttributedString()
            paragraphDataPairs.forEach { paragraphData in
                let attributedString = makeBulletString(
                    bullet: paragraphData.bullet,
                    content: paragraphData.paragraph,
                    attributes: attributes)
                fullAttributedString.append(attributedString)
            }
        return fullAttributedString
    }
    
    private func makeBulletString(bullet: String, content: String,
                                  attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let formattedString: String = "\(bullet)\(content)\n"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(
            string: formattedString,
            attributes: attributes)
        
        let headerIndent = (bullet as NSString).size(withAttributes: attributes).width + 6
        attributedString.addAttributes([.paragraphStyle: makeParagraphStyle(headIndent: headerIndent)],
                                       range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    private func makeParagraphStyle(headIndent: CGFloat) -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = headIndent
        return paragraphStyle
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
    
    private func setupButton(image: String, color: UIColor, action: Selector,
                             isEnabled: Bool? = nil) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = Button(type: .system)
        button.backgroundColor = color
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = isEnabled ?? true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setupButton(color: UIColor, labelFirst: UILabel,
                             labelSecond: UILabel, image: UIImageView? = nil,
                             tag: Int, action: Selector) -> UIButton {
        let button = Button(type: .custom)
        button.backgroundColor = color
        button.layer.cornerRadius = 20
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        button.tag = tag
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
    
    private func setupStackView(labelTop: UIView, labelBottom: UILabel) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [labelTop, labelBottom])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setupStackView(view: UIView, stackView: UIStackView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [view, stackView])
        stackView.spacing = 10
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Setup constraints
extension GameTypeViewController {
    private func setupConstraints() {
        setupSquare(subviews: buttonBack, buttonHelp, sizes: 40)
        
        NSLayoutConstraint.activate([
            viewGameType.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30),
            viewGameType.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        setupSquare(subviews: viewGameType, sizes: diameter())
        setupCenterSubview(subview: imageGameType, on: viewGameType)
        
        NSLayoutConstraint.activate([
            labelGameName.topAnchor.constraint(equalTo: viewGameType.bottomAnchor, constant: 10),
            labelGameName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackViewButtons.topAnchor.constraint(equalTo: labelGameName.bottomAnchor, constant: 15),
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
        
        setupConstraintsButton(button: buttonCountdown,
                               layout: buttonCountQuestions.bottomAnchor,
                               leading: 20, trailing: -halfWidth(), height: 150)
        setupConstraintsLabel(label: labelCountdown, button: buttonCountdown, constant: -25)
        setupConstraintsLabel(label: labelCountdownDesription, button: buttonCountdown, constant: 35)
        
        setupConstraintsButton(button: buttonTime,
                               layout: buttonContinents.bottomAnchor,
                               leading: halfWidth(), trailing: -20, height: 120)
        setupConstraintsLabel(label: labelTime, button: buttonTime, constant: -25)
        setupConstraintsLabel(label: labelTimeDesription, button: buttonTime, constant: 30)
        NSLayoutConstraint.activate([
            imageInfinity.centerXAnchor.constraint(equalTo: buttonTime.centerXAnchor),
            imageInfinity.centerYAnchor.constraint(equalTo: buttonTime.centerYAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
    
    private func setupConstraintsViewHelp() {
        NSLayoutConstraint.activate([
            viewHelp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewHelp.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewHelp.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            viewHelp.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: viewHelp.topAnchor, constant: 63.75),
            scrollView.leadingAnchor.constraint(equalTo: viewHelp.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: viewHelp.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: viewHelp.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            viewDescription.topAnchor.constraint(equalTo: scrollView.topAnchor),
            viewDescription.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            viewDescription.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            viewDescription.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            viewDescription.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            viewDescription.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1.35)
        ])
        
        NSLayoutConstraint.activate([
            labelDescription.topAnchor.constraint(equalTo: viewDescription.topAnchor, constant: 15),
            labelDescription.leadingAnchor.constraint(equalTo: viewDescription.leadingAnchor, constant: 15),
            labelDescription.trailingAnchor.constraint(equalTo: viewDescription.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            labelBulletsList.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 19),
            labelBulletsList.leadingAnchor.constraint(equalTo: viewDescription.leadingAnchor, constant: 15),
            labelBulletsList.trailingAnchor.constraint(equalTo: viewDescription.trailingAnchor, constant: -15)
        ])
        
        setupCenterSubview(subview: imageFirstSwap, on: viewFirstSwap)
        setupSquare(subviews: viewFirstSwap, sizes: 40)
        
        NSLayoutConstraint.activate([
            stackViewFirstSwap.topAnchor.constraint(equalTo: labelBulletsList.bottomAnchor),
            stackViewFirstSwap.leadingAnchor.constraint(equalTo: viewDescription.leadingAnchor, constant: 15),
            stackViewFirstSwap.trailingAnchor.constraint(equalTo: viewDescription.trailingAnchor, constant: -15)
        ])
        
        setupCenterSubview(subview: imageSecondSwap, on: viewSecondSwap)
        setupSquare(subviews: viewSecondSwap, sizes: 40)
        
        NSLayoutConstraint.activate([
            stackViewSecondSwap.topAnchor.constraint(equalTo: stackViewFirstSwap.bottomAnchor),
            stackViewSecondSwap.leadingAnchor.constraint(equalTo: viewDescription.leadingAnchor, constant: 15),
            stackViewSecondSwap.trailingAnchor.constraint(equalTo: viewDescription.trailingAnchor, constant: -15)
        ])
    }
    
    private func setupSquare(subviews: UIView..., sizes: CGFloat) {
        subviews.forEach { subview in
            NSLayoutConstraint.activate([
                subview.widthAnchor.constraint(equalToConstant: sizes),
                subview.heightAnchor.constraint(equalToConstant: sizes)
            ])
        }
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
// MARK: - PopupDescriptionDelegate
extension GameTypeViewController: PopUpDescriptionDelegate {
    func closeView() {
        buttonsOnOff(bool: true)
        UIView.animate(withDuration: 0.5) { [self] in
            visualEffectView.alpha = 0
            viewHelp.alpha = 0
            viewHelp.transform = CGAffineTransform.init(scaleX: 0.6, y: 0.6)
        } completion: { [self] _ in
            viewHelp.removeFromSuperview()
        }
    }
}
