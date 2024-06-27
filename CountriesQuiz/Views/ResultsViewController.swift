//
//  ResultsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 25.01.2023.
//

import UIKit
// MARK: - Properties
class ResultsViewController: UIViewController {
    private lazy var viewResults: UIView = {
        setView(color: viewModel.game.background, radius: 25, isOnBottomCorners: true)
    }()
    
    private lazy var imageCircle: UIImageView = {
        setImage(image: "circle.fill", size: 60, color: .white.withAlphaComponent(0.8), imageType: imageGameType)
    }()
    
    private lazy var imageGameType: UIImageView = {
        setImage(image: viewModel.game.image, size: 36, color: viewModel.game.background)
    }()
    
    private lazy var labelResults: UILabel = {
        setLabel(title: "Результаты", style: "echorevival", size: 38, color: .white)
    }()
    
    private lazy var stackViewResults: UIStackView = {
        setStackView(first: labelResults, second: imageCircle, distribution: .fill)
    }()
    
    private lazy var buttonCircle: UIView = {
        setButton(color: .white, radius: 20, isEnabled: true, colorBorder: viewModel.game.background)
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
    
    private lazy var stackViewAnswers: UIStackView = {
        setStackView(
            first: buttonCorrectAnswers,
            second: buttonIncorrectAnswers,
            distribution: .fillEqually,
            axis: .vertical)
    }()
    
    private lazy var stackViewCircle: UIStackView = {
        setStackView(first: buttonCircle, second: stackViewAnswers, distribution: .fillEqually)
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
    
    private lazy var stackViewTime: UIStackView = {
        setStackView(first: viewTimeSpend, second: viewCountQuestions, distribution: .fillEqually)
    }()
    
    private lazy var viewComplete: UIView = {
        setView(color: viewModel.game.background, radius: 25, isOnTopCorners: true)
    }()
    
    private lazy var buttonComplete: UIButton = {
        let button = Button(type: .system)
        button.setTitle("Завершить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "mr_fontick", size: 25)
        button.backgroundColor = viewModel.game.background
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
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
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        imageInfinity.isHidden = viewModel.isTime() ? true : false
    }
    
    private func setupSubviews() {
        viewModel.setupSubviews(subviews: viewResults, stackViewResults,
                                stackViewCircle, stackViewTime, imageInfinity,
                                viewComplete, buttonComplete, on: view)
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
                         labelSecond: UILabel? = nil, radius: CGFloat,
                         isOnTopCorners: Bool? = nil,
                         isOnBottomCorners: Bool? = nil) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = radius
        view.layer.borderColor = viewModel.game.background.cgColor
        if isOnBottomCorners ?? false {
            view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        if isOnTopCorners ?? false {
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        if let labelFirst = labelFirst, let image = image, let labelSecond = labelSecond {
            viewModel.setupSubviews(subviews: labelFirst, image, labelSecond, on: view)
        }
        return view
    }
}
// MARK: - Setup button
extension ResultsViewController {
    private func setButton(color: UIColor, labelFirst: UILabel? = nil, image: UIImageView? = nil,
                           labelSecond: UILabel? = nil, radius: CGFloat, tag: Int? = nil,
                           isEnabled: Bool, colorBorder: UIColor? = nil) -> UIButton {
        let button = Button(type: .custom)
        button.backgroundColor = color
        button.layer.cornerRadius = radius
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        if let colorBorder = colorBorder {
            button.layer.borderWidth = 2
            button.layer.borderColor = colorBorder.cgColor
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = tag ?? 0
        button.isEnabled = isEnabled
        button.addTarget(self, action: #selector(showIncorrectAnswers), for: .touchUpInside)
        if let labelFirst = labelFirst, let image = image, let labelSecond = labelSecond {
            viewModel.setupSubviews(subviews: labelFirst, image, labelSecond, on: button)
        }
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
// MARK: - Setup images
extension ResultsViewController {
    private func setImage(image: String, size: CGFloat, color: UIColor? = nil,
                          imageType: UIImageView? = nil) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: size)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color ?? .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let imageType = imageType {
            viewModel.setupSubviews(subviews: imageType, on: imageView)
        }
        return imageView
    }
}
// MARK: - Setup stack views
extension ResultsViewController {
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
}
// MARK: - Setup constraints
extension ResultsViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            viewResults.topAnchor.constraint(equalTo: view.topAnchor),
            viewResults.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewResults.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewResults.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
        ])
        viewModel.setupCenterSubview(imageGameType, on: imageCircle)
        
        NSLayoutConstraint.activate([
            stackViewResults.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewResults.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackViewResults.bottomAnchor.constraint(equalTo: viewResults.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            stackViewCircle.topAnchor.constraint(equalTo: viewResults.bottomAnchor, constant: 10),
            stackViewCircle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackViewCircle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackViewCircle.heightAnchor.constraint(equalToConstant: 210)
        ])
        
        NSLayoutConstraint.activate([
            stackViewTime.topAnchor.constraint(equalTo: stackViewCircle.bottomAnchor, constant: 10),
            stackViewTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackViewTime.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackViewTime.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        viewModel.constraintsView(subview: buttonCorrectAnswers, labelFirst: labelCorrectCount,
                                  image: imageCorrectAnswers, labelSecond: labelCorrectTitle, view)
        viewModel.constraintsView(subview: buttonIncorrectAnswers, labelFirst: labelIncorrectCount,
                                  image: imageIncorrectAnswers, labelSecond: labelIncorrectTitle, view)
        viewModel.constraintsView(subview: viewTimeSpend, labelFirst: labelNumberTimeSpend,
                                  image: imageTimeSpend, labelSecond: labelTimeSpend, view)
        viewModel.constraintsView(subview: viewCountQuestions, labelFirst: labelCountQuestions,
                                  image: imageCountQuestions, labelSecond: labelCountTitle, view)
        
        viewModel.setupCenterSubview(imageInfinity, on: labelNumberTimeSpend)
        
        NSLayoutConstraint.activate([
            viewComplete.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewComplete.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewComplete.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewComplete.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            buttonComplete.topAnchor.constraint(equalTo: viewComplete.topAnchor, constant: 20),
            buttonComplete.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            buttonComplete.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            buttonComplete.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
