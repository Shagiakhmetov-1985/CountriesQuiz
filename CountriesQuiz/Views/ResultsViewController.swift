//
//  ResultsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 25.01.2023.
//

import UIKit
// MARK: - Properties
class ResultsViewController: UIViewController {
    private lazy var labelResults: UILabel = {
        setLabel(
            title: "Результаты",
            style: "echorevival",
            size: 38,
            color: .blueBlackSea)
    }()
    
    private lazy var imageCircle: UIImageView = {
        setImage(image: "circle.fill", size: 85, color: .white.withAlphaComponent(0.3))
    }()
    
    private lazy var imageGameType: UIImageView = {
        setImage(image: viewModel.game.image, size: 48, color: viewModel.game.background)
    }()
    
    private lazy var buttonCorrectAnswers: UIButton = {
        setButton(
            color: viewModel.rightAnswers > 0 ? .greenHarlequin : .grayStone,
            labelFirst: labelCorrectCount,
            image: imageCorrectAnswers,
            labelSecond: labelCorrectTitle,
            radius: 20,
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
            color: viewModel.wrongAnswers > 0 ? .redTangerineTango : .grayStone,
            labelFirst: labelIncorrectCount,
            image: imageIncorrectAnswers,
            labelSecond: labelIncorrectTitle,
            radius: 20,
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
    
    private lazy var viewTimeSpend: UIView = {
        setView(
            color: .blueMiddlePersian,
            labelFirst: labelNumberTimeSpend,
            image: imageTimeSpend,
            labelSecond: labelTimeSpend,
            radius: 20)
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
    
    private lazy var viewCountQuestions: UIView = {
        setView(
            color: .gummigut,
            labelFirst: labelCountQuestions,
            image: imageCountQuestions,
            labelSecond: labelCountTitle,
            radius: 20)
    }()
    
    private lazy var labelCountQuestions: UILabel = {
        setLabel(
            title: "\(viewModel.mode.countQuestions)",
            style: "mr_fontick",
            size: 35,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var imageCountQuestions: UIImageView = {
        setImage(image: "questionmark.bubble", size: 26)
    }()
    
    private lazy var labelCountTitle: UILabel = {
        setLabel(
            title: "Количество вопросов",
            style: "mr_fontick",
            size: 20,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var buttonComplete: UIButton = {
        let button = Button(type: .system)
        button.setTitle("Завершить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "mr_fontick", size: 25)
        button.backgroundColor = .blueBlackSea
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.blueBlackSea.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(exitToMenu), for: .touchUpInside)
        return button
    }()
    
    var viewModel: ResultsViewModelProtocol!
    
    weak var delegateQuizOfFlag: QuizOfFlagsViewControllerInput!
    weak var delegateQuestionnaire: QuestionnaireViewControllerInput!
    weak var delegateQuizOfCapitals: QuizOfCapitalsViewControllerInput!
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupSubviews()
        setupTimer()
        setConstraints()
    }
    
    private func setupDesign() {
        view.backgroundColor = .skyCyanLight
        navigationItem.hidesBackButton = true
        imageInfinity.isHidden = viewModel.isTime() ? true : false
    }
    
    private func setupSubviews() {
        viewModel.setupSubviews(subviews: labelResults, imageCircle, imageGameType,
                                buttonCorrectAnswers, buttonIncorrectAnswers,
                                viewTimeSpend, viewCountQuestions, imageInfinity,
                                buttonComplete, on: view)
    }
    
    private func runTimer(interval: CGFloat, action: Selector) -> Timer {
        Timer.scheduledTimer(timeInterval: interval, target: self,
                             selector: action, userInfo: nil, repeats: false)
    }
    // MARK: - Set circles animate
    private func setupTimer() {
        viewModel.timer = runTimer(interval: 0.3, action: #selector(circleCorrectAnswers))
    }
    
    @objc private func circleCorrectAnswers() {
        viewModel.circleCorrectAnswers(view) { [self] delay in
            viewModel.timer = runTimer(interval: delay, action: #selector(circleIncorrectAnswers))
        }
    }
    
    @objc private func circleIncorrectAnswers() {
        viewModel.circleIncorrectAnswers(view)
    }
    // MARK: - Press exit button
    @objc private func exitToMenu() {
        switch viewModel.game.gameType {
        case .quizOfFlag: delegateQuizOfFlag.dataToQuizOfFlag(setting: viewModel.mode)
        case .questionnaire: delegateQuestionnaire.dataToQuestionnaire(setting: viewModel.mode)
        default: delegateQuizOfCapitals.dataToQuizOfCapitals(setting: viewModel.mode)
        }
    }
    // MARK: - Show incorrect answers
    @objc private func showIncorrectAnswers() {
        let incorrectAnswers = viewModel.incorrectAnswersViewController()
        let incorrectAnswersVC = IncorrectAnswersViewController()
        let navigationVC = UINavigationController(rootViewController: incorrectAnswersVC)
        incorrectAnswersVC.viewModel = incorrectAnswers
        navigationVC.modalPresentationStyle = .custom
        present(navigationVC, animated: true)
    }
}
// MARK: - Setup view
extension ResultsViewController {
    private func setView(color: UIColor, labelFirst: UILabel? = nil, image: UIImageView? = nil,
                         labelSecond: UILabel? = nil, radius: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = radius
        view.translatesAutoresizingMaskIntoConstraints = false
        if let labelFirst = labelFirst, let image = image, let labelSecond = labelSecond {
            viewModel.setupSubviews(subviews: labelFirst, image, labelSecond, on: view)
        }
        return view
    }
}
// MARK: - Setup button
extension ResultsViewController {
    private func setButton(color: UIColor, labelFirst: UILabel, image: UIImageView, 
                           labelSecond: UILabel, radius: CGFloat, tag: Int,
                           isEnabled: Bool) -> UIButton {
        let button = Button(type: .custom)
        button.backgroundColor = color
        button.layer.cornerRadius = radius
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = tag
        button.isEnabled = isEnabled
        button.addTarget(self, action: #selector(showIncorrectAnswers), for: .touchUpInside)
        viewModel.setupSubviews(subviews: labelFirst, image, labelSecond, on: button)
        return button
    }
}
// MARK: - Setup label
extension ResultsViewController {
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
}
// MARK: - Setup stack views
extension ResultsViewController {
    private func setupStackView(subviewFirst: UIView, subviewSecond: UIView,
                                spacing: CGFloat? = nil, opacity: Float? = nil) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [subviewFirst, subviewSecond])
        stackView.spacing = spacing ?? 0
        stackView.layer.opacity = opacity ?? 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Setup images
extension ResultsViewController {
    private func setImage(image: String, size: CGFloat, color: UIColor? = nil) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: size)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color ?? .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
// MARK: - Setup constraints
extension ResultsViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            labelResults.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            labelResults.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelResults.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            imageCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageCircle.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 240)
        ])
        viewModel.setupCenterSubview(imageGameType, on: imageCircle)
        
        viewModel.constraintsView(subview: buttonCorrectAnswers, layout: view.topAnchor,
                                  constant: 345, leading: 20, trailing: -viewModel.width(view),
                                  height: 110, labelFirst: labelCorrectCount,
                                  image: imageCorrectAnswers, labelSecond: labelCorrectTitle, view)
        viewModel.constraintsView(subview: buttonIncorrectAnswers, layout: view.topAnchor,
                                  constant: 345, leading: viewModel.width(view), trailing: -20,
                                  height: 110, labelFirst: labelIncorrectCount,
                                  image: imageIncorrectAnswers, labelSecond: labelIncorrectTitle, view)
        viewModel.constraintsView(subview: viewTimeSpend, layout: buttonCorrectAnswers.bottomAnchor,
                                  constant: 20, leading: 20, trailing: -viewModel.width(view),
                                  height: 110, labelFirst: labelNumberTimeSpend,
                                  image: imageTimeSpend, labelSecond: labelTimeSpend, view)
        viewModel.constraintsView(subview: viewCountQuestions, layout: buttonIncorrectAnswers.bottomAnchor,
                                  constant: 20, leading: viewModel.width(view), trailing: -20,
                                  height: 110, labelFirst: labelCountQuestions,
                                  image: imageCountQuestions, labelSecond: labelCountTitle, view)
        
        viewModel.setupCenterSubview(imageInfinity, on: labelNumberTimeSpend)
        
        NSLayoutConstraint.activate([
            buttonComplete.topAnchor.constraint(equalTo: viewCountQuestions.bottomAnchor, constant: 40),
            buttonComplete.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonComplete.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonComplete.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
