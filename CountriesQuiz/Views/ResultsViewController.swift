//
//  ResultsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 25.01.2023.
//

import UIKit

protocol ResultsViewControllerDelegate {
    func dataToResults(favourites: [Favorites])
}

class ResultsViewController: UIViewController, ResultsViewControllerDelegate {
    private lazy var imageColor: UIImageView = {
        setImage(image: "circle.fill", size: 60, color: viewModel.game.background, addView: imageCircle)
    }()
    
    private lazy var imageCircle: UIImageView = {
        setImage(image: "circle.fill", size: 60, color: .white.withAlphaComponent(0.8), addView: imageGameType)
    }()
    
    private lazy var imageGameType: UIImageView = {
        setImage(image: viewModel.game.image, size: 36, color: viewModel.game.background)
    }()
    
    private lazy var labelResults: UILabel = {
        setLabel(title: "Результаты", style: "echorevival", size: 38, color: viewModel.game.swap)
    }()
    
    private lazy var stackViewResults: UIStackView = {
        setStackView(first: labelResults, second: imageColor, distribution: .fill)
    }()
    
    private lazy var imageCheckmark: UIImageView = {
        setImage(image: "checkmark", size: 21, color: viewModel.game.swap)
    }()
    
    private lazy var imageMultiply: UIImageView = {
        setImage(image: "multiply", size: 21, color: viewModel.game.swap)
    }()
    
    private lazy var imageClock: UIImageView = {
        setImage(image: viewModel.imageTimeSpend, size: 21, color: viewModel.game.swap)
    }()
    
    private lazy var imageQuestionmark: UIImageView = {
        setImage(image: "questionmark.bubble", size: 21, color: viewModel.game.swap)
    }()
    
    private lazy var stackViewImages: UIStackView = {
        setStackView(first: imageCheckmark, second: imageMultiply, third: imageClock, fourth: imageQuestionmark)
    }()
    
    private lazy var viewDescription: UIView = {
        let view = UIView()
        view.backgroundColor = .skyGrayLight.withAlphaComponent(0.6)
        view.layer.cornerRadius = 22
        view.translatesAutoresizingMaskIntoConstraints = false
        viewModel.setupSubviews(subviews: imageDescription, labelDescription, buttonDescription, on: view)
        return view
    }()
    
    private lazy var imageDescription: UIImageView = {
        setImage(image: "seal.fill", size: 70, color: viewModel.game.background, addView: labelPercent)
    }()
    
    private lazy var labelPercent: UILabel = {
        setLabel(
            title: viewModel.percentCorrectAnswers(),
            style: "Gill Sans",
            size: 28,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var labelDescription: UILabel = {
        let text = viewModel.description
        let label = setLabel(title: text, style: "GillSans", size: 21, color: .black)
        let attribited = NSMutableAttributedString(string: text)
        attribited.addAttributes([
            NSAttributedString.Key.font: UIFont(name: "GillSans-SemiBold", size: 22) ?? ""
        ], range: viewModel.getRange(subString: viewModel.heading, fromString: text))
        attribited.addAttributes([
            NSAttributedString.Key.foregroundColor: viewModel.game.favorite
        ], range: viewModel.getRange(subString: viewModel.percent, fromString: text))
        label.attributedText = attribited
        return label
    }()
    
    private lazy var buttonDescription: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подробнее", for: .normal)
        button.setTitleColor(viewModel.game.background, for: .normal)
        button.titleLabel?.font = UIFont(name: "GillSans-SemiBold", size: 21)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(showRatio), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonCorrectAnswers: UIButton = {
        setButton(
            color: viewModel.rightAnswers > 0 ? .greenEmerald : .grayStone,
            action: #selector(showCorrectAnswers),
            labelFirst: labelCorrectCount,
            image: imageCorrectAnswers,
            labelSecond: labelCorrectTitle,
            tag: 1,
            isEnabled: viewModel.rightAnswers > 0 ? true : false)
    }()
    
    private lazy var labelCorrectCount: UILabel = {
        setLabel(
            title: "\(viewModel.correctAnswers.count)",
            style: "mr_fontick",
            size: 35,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var imageCorrectAnswers: UIImageView = {
        setImage(image: "checkmark", size: 26)
    }()
    
    private lazy var labelCorrectTitle: UILabel = {
        setLabel(
            title: "Правильные ответы",
            style: "mr_fontick",
            size: 20,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var buttonIncorrectAnswers: UIButton = {
        setButton(
            color: viewModel.wrongAnswers > 0 ? .bismarkFuriozo : .grayStone,
            action: #selector(showIncorrectAnswers),
            labelFirst: labelIncorrectCount,
            image: imageIncorrectAnswers,
            labelSecond: labelIncorrectTitle,
            tag: 2,
            isEnabled: viewModel.wrongAnswers > 0 ? true : false)
    }()
    
    private lazy var labelIncorrectCount: UILabel = {
        setLabel(
            title: "\(viewModel.incorrectAnswers.count)",
            style: "mr_fontick",
            size: 35,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var imageIncorrectAnswers: UIImageView = {
        setImage(image: "multiply", size: 26)
    }()
    
    private lazy var labelIncorrectTitle: UILabel = {
        setLabel(
            title: "Неправильные ответы",
            style: "mr_fontick",
            size: 20,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var stackViewAnswers: UIStackView = {
        setStackView(
            first: buttonCorrectAnswers,
            second: buttonIncorrectAnswers,
            distribution: .fillEqually)
    }()
    
    private lazy var buttonTimeSpend: UIButton = {
        setButton(
            color: .blueMiddlePersian,
            action: #selector(showIncorrectAnswers),
            labelFirst: labelNumberTimeSpend,
            image: imageTimeSpend,
            labelSecond: labelTimeSpend,
            tag: 3)
    }()
    
    private lazy var labelNumberTimeSpend: UILabel = {
        setLabel(
            title: viewModel.numberTimeSpend,
            style: "mr_fontick",
            size: 35,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var imageTimeSpend: UIImageView = {
        setImage(image: viewModel.imageTimeSpend, size: 26)
    }()
    
    private lazy var labelTimeSpend: UILabel = {
        setLabel(
            title: viewModel.titleTimeSpend,
            style: "mr_fontick",
            size: 20,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var imageInfinity: UIImageView = {
        setImage(image: "infinity", size: 35)
    }()
    
    private lazy var buttonAnsweredQuestions: UIButton = {
        setButton(
            color: .gummigut,
            action: #selector(showIncorrectAnswers),
            labelFirst: labelAnsweredQuestions,
            image: imageAnsweredQuestions,
            labelSecond: labelAnsweredTitle,
            tag: 4)
    }()
    
    private lazy var labelAnsweredQuestions: UILabel = {
        setLabel(
            title: "\(viewModel.answeredQuestions)",
            style: "mr_fontick",
            size: 35,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var imageAnsweredQuestions: UIImageView = {
        setImage(image: "questionmark.bubble", size: 26)
    }()
    
    private lazy var labelAnsweredTitle: UILabel = {
        setLabel(
            title: "Количество отвеченных вопросов",
            style: "mr_fontick",
            size: 20,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var stackViewTime: UIStackView = {
        setStackView(first: buttonTimeSpend, second: buttonAnsweredQuestions, distribution: .fillEqually)
    }()
    
    private lazy var buttonComplete: UIButton = {
        let button = Button(type: .system)
        button.setTitle("Завершить", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "mr_fontick", size: 25)
        button.backgroundColor = viewModel.game.background
        button.layer.cornerRadius = 12
        button.layer.shadowColor = viewModel.game.background.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(exitToMenu), for: .touchUpInside)
        return button
    }()
    
    var viewModel: ResultsViewModelProtocol!
    weak var delegate: ViewControllerInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupSubviews()
        setConstraints()
    }
    
    func dataToResults(favourites: [Favorites]) {
        viewModel.setFavorites(newFavorites: favourites)
    }
    
    private func setupDesign() {
        view.backgroundColor = UIColor.white
        navigationItem.hidesBackButton = true
        imageInfinity.isHidden = viewModel.isTime() ? true : false
    }
    
    private func setupSubviews() {
        viewModel.setupSubviews(subviews: stackViewResults, stackViewImages,
                                viewDescription, stackViewAnswers, stackViewTime,
                                imageInfinity, buttonComplete, on: view)
    }
    // MARK: - Press done button
    @objc private func exitToMenu() {
        delegate.dataToMenu(setting: viewModel.mode, favourites: viewModel.favorites)
    }
    // MARK: - Show ratio
    @objc private func showRatio() {
        let ratio = viewModel.ratio()
        let ratioVC = RatioViewController()
        let navigationVC = UINavigationController(rootViewController: ratioVC)
        ratioVC.viewModel = ratio
        navigationVC.modalPresentationStyle = .fullScreen
        present(navigationVC, animated: true)
    }
    // MARK: - Show correct answers
    @objc private func showCorrectAnswers() {
        let correctAnswers = viewModel.correctAnswersViewController()
        let correctAnswersVC = CorrectAnswersViewController()
        let navigationVC = UINavigationController(rootViewController: correctAnswersVC)
        correctAnswersVC.viewModel = correctAnswers
        navigationVC.modalPresentationStyle = .custom
        present(navigationVC, animated: true)
    }
    // MARK: - Show incorrect answers
    @objc private func showIncorrectAnswers() {
        let incorrectAnswers = viewModel.incorrectAnswersViewController()
        let incorrectAnswersVC = IncorrectAnswersViewController()
        let navigationVC = UINavigationController(rootViewController: incorrectAnswersVC)
        incorrectAnswersVC.viewModel = incorrectAnswers
        incorrectAnswersVC.delegate = self
        navigationVC.modalPresentationStyle = .custom
        present(navigationVC, animated: true)
    }
}
// MARK: - Setup subviews
extension ResultsViewController {
    private func setButton(color: UIColor, action: Selector, labelFirst: UILabel,
                           image: UIImageView, labelSecond: UILabel, tag: Int,
                           isEnabled: Bool? = nil) -> UIButton {
        let button = Button(type: .custom)
        button.backgroundColor = color
        button.layer.cornerRadius = 22
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = tag
        button.isEnabled = isEnabled ?? true
        button.addTarget(self, action: action, for: .touchUpInside)
        viewModel.setupSubviews(subviews: labelFirst, image, labelSecond, on: button)
        return button
    }
    
    private func setLabel(title: String, style: String, size: CGFloat,
                          color: UIColor, alignment: NSTextAlignment? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: style, size: size)
        label.textColor = color
        label.numberOfLines = 0
        label.textAlignment = alignment ?? .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func setImage(image: String, size: CGFloat, color: UIColor? = nil,
                          addView: UIView? = nil) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: size)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color ?? .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let addView = addView {
            viewModel.setupSubviews(subviews: addView, on: imageView)
        }
        return imageView
    }
    
    private func setStackView(first: UIView, second: UIView,
                              distribution: UIStackView.Distribution,
                              axis: NSLayoutConstraint.Axis? = nil) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [first, second])
        stackView.spacing = 10
        stackView.distribution = distribution
        stackView.axis = axis ?? .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackView(first: UIView, second: UIView, third: UIView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [first, second, third])
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackView(first: UIView, second: UIView, third: UIView, fourth: UIView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [first, second, third, fourth])
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setProgress(progress: Float) -> UIProgressView {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = viewModel.radius
        progressView.clipsToBounds = true
        progressView.progressTintColor = .white
        progressView.trackTintColor = .white.withAlphaComponent(0.3)
        progressView.progress = progress
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }
}
// MARK: - Setup constraints
extension ResultsViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackViewResults.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10),
            stackViewResults.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewResults.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        viewModel.setupCenterSubview(imageCircle, on: imageColor)
        viewModel.setupCenterSubview(imageGameType, on: imageCircle)
        
        NSLayoutConstraint.activate([
            stackViewImages.topAnchor.constraint(equalTo: stackViewResults.bottomAnchor, constant: -15),
            stackViewImages.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            viewDescription.topAnchor.constraint(equalTo: stackViewImages.bottomAnchor, constant: 20),
            viewDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            viewDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            viewDescription.heightAnchor.constraint(equalToConstant: 150)
        ])
        viewModel.setupCenterSubview(labelPercent, on: imageDescription)
        viewModel.constraintsView(view: viewDescription, image: imageDescription,
                                  label: labelDescription, button: buttonDescription)
        
        NSLayoutConstraint.activate([
            stackViewAnswers.topAnchor.constraint(equalTo: viewDescription.bottomAnchor, constant: 10),
            stackViewAnswers.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewAnswers.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackViewAnswers.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            stackViewTime.topAnchor.constraint(equalTo: stackViewAnswers.bottomAnchor, constant: 10),
            stackViewTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewTime.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackViewTime.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        viewModel.constraintsButton(subview: buttonCorrectAnswers, labelFirst: labelCorrectCount,
                                    image: imageCorrectAnswers, labelSecond: labelCorrectTitle)
        viewModel.constraintsButton(subview: buttonIncorrectAnswers, labelFirst: labelIncorrectCount,
                                    image: imageIncorrectAnswers, labelSecond: labelIncorrectTitle)
        viewModel.constraintsButton(subview: buttonTimeSpend, labelFirst: labelNumberTimeSpend,
                                    image: imageTimeSpend, labelSecond: labelTimeSpend)
        viewModel.constraintsButton(subview: buttonAnsweredQuestions, labelFirst: labelAnsweredQuestions,
                                    image: imageAnsweredQuestions, labelSecond: labelAnsweredTitle)
        
        viewModel.setupCenterSubview(imageInfinity, on: labelNumberTimeSpend)
        
        NSLayoutConstraint.activate([
            buttonComplete.topAnchor.constraint(equalTo: stackViewTime.bottomAnchor, constant: 25),
            buttonComplete.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonComplete.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonComplete.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
