//
//  MenuViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 01.12.2022.
//

import UIKit
// MARK: - Protocol of delegate rewrite user defaults
protocol SettingViewControllerDelegate {
    func dataToMenuFromSetting(setting: Setting)
}

protocol GameTypeViewControllerDelegate {
    func dataToMenuFromGameType(setting: Setting)
}

protocol MenuViewControllerInput: AnyObject {
    func dataToMenu(setting: Setting)
}
// MARK: - Private properties
class MenuViewController: UIViewController {
    private lazy var labelMenu: UILabel = {
        setLabel(title: "Countries Quiz", size: 40, style: "echorevival", color: .blueBlackSea)
    }()
    
    private lazy var buttonSettings: UIButton = {
        setButton(color: .blueMiddlePersian, image: imageSettings, action: #selector(setting))
    }()
    
    private lazy var imageSettings: UIImageView = {
        setImage(image: "gear", color: .white, size: 26)
    }()
    
    private lazy var stackViewMenu: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelMenu, buttonSettings])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame.size = contentSize
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        return scrollView
    }()
    
    private lazy var buttonQuizOfFlags: UIButton = {
        setButton(
            color: .cyanDark,
            image: imageFlag,
            label: labelQuizOfFlags,
            circle: circleQuizOfFlag,
            imageGame: imageQuizOfFlags,
            action: #selector(gameType))
    }()
    
    private lazy var imageFlag: UIImageView = {
        setImage(image: "flag", color: .white, size: 20)
    }()
    
    private lazy var labelQuizOfFlags: UILabel = {
        setLabel(
            title: "Викторина флагов",
            size: 26,
            style: "Gill Sans",
            color: .white,
            alignment: .left)
    }()
    
    private lazy var circleQuizOfFlag: UIImageView = {
        setImage(image: "circle.fill", color: .white.withAlphaComponent(0.8), size: 100)
    }()
    
    private lazy var imageQuizOfFlags: UIImageView = {
        setImage(image: "filemenu.and.selection", color: .cyanDark, size: 60)
    }()
    
    private lazy var buttonQuestionnaire: UIButton = {
        setButton(
            color: .greenHarlequin,
            image: imageCheckmark,
            label: labelQuestionnaire,
            circle: circleQuestionnare,
            imageGame: imageQuestionnaire,
            tag: 1,
            action: #selector(gameType))
    }()
    
    private lazy var imageCheckmark: UIImageView = {
        setImage(image: "checkmark.circle.badge.questionmark", color: .white, size: 20)
    }()
    
    private lazy var labelQuestionnaire: UILabel = {
        setLabel(
            title: "Опрос",
            size: 26,
            style: "Gill Sans",
            color: .white,
            alignment: .left)
    }()
    
    private lazy var circleQuestionnare: UIImageView = {
        setImage(image: "circle.fill", color: .white.withAlphaComponent(0.8), size: 100)
    }()
    
    private lazy var imageQuestionnaire: UIImageView = {
        setImage(image: "checklist", color: .greenHarlequin, size: 60)
    }()
    
    private lazy var buttonQuizOfMaps: UIButton = {
        setButton(
            color: .redYellowBrown,
            image: imageMap,
            label: labelQuizOfMaps,
            circle: circleQuizOfMaps,
            imageGame: imageQuizOfMaps,
            tag: 2,
            action: #selector(gameType))
    }()
    
    private lazy var imageMap: UIImageView = {
        setImage(image: "map", color: .white, size: 20)
    }()
    
    private lazy var labelQuizOfMaps: UILabel = {
        setLabel(
            title: "Викторина карт",
            size: 26,
            style: "Gill Sans",
            color: .white,
            alignment: .left)
    }()
    
    private lazy var circleQuizOfMaps: UIImageView = {
        setImage(image: "circle.fill", color: .white.withAlphaComponent(0.8), size: 100)
    }()
    
    private lazy var imageQuizOfMaps: UIImageView = {
        setImage(image: "globe.desk", color: .redYellowBrown, size: 60)
    }()
    
    private lazy var buttonScrabble: UIButton = {
        setButton(
            color: .indigo,
            image: imageText,
            label: labelScrabble,
            circle: circleScrabble,
            imageGame: imageScrabble,
            tag: 3,
            action: #selector(gameType))
    }()
    
    private lazy var imageText: UIImageView = {
        setImage(image: "textformat.abc", color: .white, size: 20)
    }()
    
    private lazy var labelScrabble: UILabel = {
        setLabel(
            title: "Эрудит",
            size: 26,
            style: "Gill Sans",
            color: .white,
            alignment: .left)
    }()
    
    private lazy var circleScrabble: UIImageView = {
        setImage(image: "circle.fill", color: .white.withAlphaComponent(0.8), size: 100)
    }()
    
    private lazy var imageScrabble: UIImageView = {
        setImage(image: "a.square", color: .indigo, size: 60)
    }()
    
    private lazy var buttonQuizOfCapitals: UIButton = {
        setButton(
            color: .redTangerineTango,
            image: imageHouse,
            label: labelQuizOfCapitals,
            circle: circleQuizOfCapitals,
            imageGame: imageQuizOfCapitals,
            tag: 4,
            action: #selector(gameType))
    }()
    
    private lazy var imageHouse: UIImageView = {
        setImage(image: "house.and.flag", color: .white, size: 20)
    }()
    
    private lazy var labelQuizOfCapitals: UILabel = {
        setLabel(
            title: "Викторина столиц",
            size: 26,
            style: "Gill Sans",
            color: .white,
            alignment: .left)
    }()
    
    private lazy var circleQuizOfCapitals: UIImageView = {
        setImage(image: "circle.fill", color: .white.withAlphaComponent(0.8), size: 100)
    }()
    
    private lazy var imageQuizOfCapitals: UIImageView = {
        setImage(image: "building.2", color: .redTangerineTango, size: 60)
    }()
    
    private let viewModel = MenuViewModel()
    
    private var games = [Games]()
    private var mode: Setting!
    private var transition = Transition()
    
    private var contentSize: CGSize {
        viewModel.size(view: view)
    }
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupSubviews()
        setupSubviewOnContentView()
        setupSubviewsOnScrollView()
        setupConstraints()
    }
    
    // MARK: - General methods
    private func setupDesign() {
        view.backgroundColor = .white
        games = viewModel.getGames()
        mode = viewModel.fetchSetting()
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
    // MARK: - Button activate. Press game type, setting
    @objc private func gameType(sender: UIButton) {
        let tag = sender.tag
        let gameTypeViewModel = GameTypeViewModel(mode: mode, game: games[tag], tag: tag)
        let gameTypeVC = GameTypeViewController(gameTypeViewModel)
        gameTypeVC.delegate = self
        gameTypeVC.delegateInput = self
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
                          alignment: NSTextAlignment? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: style, size: size)
        label.textColor = color
        label.textAlignment = alignment ?? .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup button
extension MenuViewController {
    private func setButton(color: UIColor, image: UIView, label: UILabel? = nil,
                           circle: UIView? = nil, imageGame: UIView? = nil,
                           tag: Int? = nil, action: Selector) -> UIButton {
        let button = Button(type: .custom)
        button.backgroundColor = color
        button.layer.cornerRadius = 12
        button.layer.shadowOpacity = 0.4
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.tag = tag ?? 0
        button.translatesAutoresizingMaskIntoConstraints = false
        if let label = label, let circle = circle, let imageGame = imageGame {
            setupSubviews(subviews: image, label, circle, imageGame, on: button)
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
// MARK: - Delegates for send data
extension MenuViewController: SettingViewControllerDelegate,
                              GameTypeViewControllerDelegate,
                              MenuViewControllerInput {
    func dataToMenu(setting: Setting) {
        navigationController?.popToRootViewController(animated: true)
        mode = setting
    }
    
    func dataToMenuFromGameType(setting: Setting) {
        mode = setting
    }
    
    func dataToMenuFromSetting(setting: Setting) {
        mode = setting
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
                           label: labelQuizOfFlags, circle: circleQuizOfFlag,
                           imageGame: imageQuizOfFlags,
                           layout: scrollView.topAnchor)
        setConstraintsList(button: buttonQuestionnaire, image: imageCheckmark,
                           label: labelQuestionnaire, circle: circleQuestionnare,
                           imageGame: imageQuestionnaire,
                           layout: buttonQuizOfFlags.bottomAnchor)
        setConstraintsList(button: buttonQuizOfMaps, image: imageMap,
                           label: labelQuizOfMaps, circle: circleQuizOfMaps,
                           imageGame: imageQuizOfMaps,
                           layout: buttonQuestionnaire.bottomAnchor)
        setConstraintsList(button: buttonScrabble, image: imageText,
                           label: labelScrabble, circle: circleScrabble,
                           imageGame: imageScrabble,
                           layout: buttonQuizOfMaps.bottomAnchor)
        setConstraintsList(button: buttonQuizOfCapitals, image: imageHouse,
                           label: labelQuizOfCapitals, circle: circleQuizOfCapitals,
                           imageGame: imageQuizOfCapitals,
                           layout: buttonScrabble.bottomAnchor)
    }
    
    private func setConstraintsList(button: UIButton, image: UIImageView,
                                    label: UILabel, circle: UIImageView,
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
            circle.topAnchor.constraint(equalTo: button.topAnchor),
            circle.trailingAnchor.constraint(equalTo: button.trailingAnchor)
        ])
        setupCenterSubview(subview: imageGame, on: circle)
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
}
