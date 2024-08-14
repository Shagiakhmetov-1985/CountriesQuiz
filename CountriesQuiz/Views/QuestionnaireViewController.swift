//
//  QuestionnaireViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 29.08.2023.
//

import UIKit

protocol QuestionnaireViewControllerInput: AnyObject {
    func dataToQuestionnaire(setting: Setting)
}

class QuestionnaireViewController: UIViewController, QuestionnaireViewControllerInput {
    private lazy var buttonExit: UIButton = {
        setButton(image: "multiply", action: #selector(exitToGameType))
    }()
    
    private lazy var labelTimer: UILabel = {
        viewModel.setLabel("\(viewModel.time)", size: 35, color: .white, and: 1)
    }()
    
    private lazy var question: UIView = {
        viewModel.question()
    }()
    
    private lazy var buttonBack: UIButton = {
        setButton(
            image: "chevron.left",
            action: #selector(back),
            isEnabled: false,
            opacity: 0,
            tag: 1)
    }()
    
    private lazy var buttonForward: UIButton = {
        setButton(
            image: "chevron.right",
            action: #selector(forward),
            isEnabled: false,
            opacity: 0,
            tag: 2)
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = viewModel.radius
        progressView.clipsToBounds = true
        progressView.progressTintColor = .white
        progressView.trackTintColor = .white.withAlphaComponent(0.3)
        progressView.progress = 0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        viewModel.progressView(progressView)
        return progressView
    }()
    
    private lazy var labelNumber: UILabel = {
        viewModel.setLabel(viewModel.titleNumber, size: 23, color: .white, and: 1)
    }()
    
    private lazy var labelQuiz: UILabel = {
        viewModel.setLabel(viewModel.titleQuiz, size: 23, color: .white, and: 0)
    }()
    
    private lazy var labelDescription: UILabel = {
        viewModel.setLabel(viewModel.titleDescription, size: 19, color: .lightPurplePink, and: 0)
    }()
    
    private lazy var buttonFirst: UIButton = {
        if viewModel.isFlag {
            setButton(title: viewModel.answerFirst, tag: 1)
        } else {
            setButton(flag: viewModel.answerFirst, tag: 1)
        }
    }()
    
    private lazy var buttonSecond: UIButton = {
        if viewModel.isFlag {
            setButton(title: viewModel.answerSecond, tag: 2)
        } else {
            setButton(flag: viewModel.answerSecond, tag: 2)
        }
    }()
    
    private lazy var buttonThird: UIButton = {
        if viewModel.isFlag {
            setButton(title: viewModel.answerThird, tag: 3)
        } else {
            setButton(flag: viewModel.answerThird, tag: 3)
        }
    }()
    
    private lazy var buttonFourth: UIButton = {
        if viewModel.isFlag {
            setButton(title: viewModel.answerFourth, tag: 4)
        } else {
            setButton(flag: viewModel.answerFourth, tag: 4)
        }
    }()
    
    private lazy var stackView: UIStackView = {
        viewModel.stackView(buttonFirst, buttonSecond, buttonThird, buttonFourth)
    }()
    
    var viewModel: QuestionnaireViewModelProtocol!
    weak var delegateInput: GameTypeViewControllerInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupDesign()
        setupBarButton()
        setupSubviews()
        setupConstraints()
        viewModel.moveSubviews(view)
        startGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard viewModel.isCountdown else { return }
        viewModel.setCircleTimer(labelTimer, view)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard viewModel.lastQuestion, viewModel.numberQuestion == viewModel.currentQuestion else { return }
        viewModel.stopTimer()
        viewModel.setTimeSpent()
        resultsVC()
    }
    // MARK: - QuestionnaireViewControllerInput
    func dataToQuestionnaire(setting: Setting) {
        delegateInput.dataToGameType(setting: setting)
    }
    // MARK: - General methods
    private func setupData() {
        viewModel.getQuestions()
    }
    
    private func setupDesign() {
        view.backgroundColor = viewModel.background
        navigationItem.hidesBackButton = true
    }
    
    private func setupBarButton() {
        viewModel.setBarButton(buttonExit, navigationItem)
    }
    
    private func setupSubviews() {
        viewModel.isCountdown ? subviewsWithTimer() : subviewsWithoutTimer()
    }
    
    private func subviewsWithTimer() {
        viewModel.setSubviews(subviews: labelTimer, question, buttonBack,
                              buttonForward, progressView, labelNumber, labelQuiz,
                              labelDescription, stackView, on: view)
    }
    
    private func subviewsWithoutTimer() {
        viewModel.setSubviews(subviews: question, buttonBack, buttonForward,
                              progressView, labelNumber, labelQuiz,
                              labelDescription, stackView, on: view)
    }
    
    private func runTimer(duration: CGFloat, action: Selector, repeats: Bool) -> Timer {
        Timer.scheduledTimer(timeInterval: duration, target: self,
                             selector: action, userInfo: nil, repeats: repeats)
    }
    // MARK: - Start game
    private func startGame() {
        let time = viewModel.currentQuestion > 0 ? 0.1 : 1
        viewModel.timer = runTimer(duration: time, action: #selector(showSubviews), repeats: false)
    }
    
    @objc private func showSubviews() {
        viewModel.timer.invalidate()
        viewModel.showLabelQuiz(labelQuiz, duration: 1, opacity: 1)
        let duration = viewModel.currentQuestion == 0 ? 0.5 : 0.25
        let action = viewModel.currentQuestion == 0 ? #selector(isEnabledSubviews) : #selector(nextQuestion)
        viewModel.animationSubviews(duration: duration, view)
        viewModel.timer = runTimer(duration: duration, action: action, repeats: false)
    }
    
    @objc private func isEnabledSubviews() {
        viewModel.timer.invalidate()
        viewModel.isEnabledButtons(isOn: true)
        viewModel.updateNumberQuestion(labelNumber)
        
        viewModel.setTime()
        viewModel.runCircleTimer()
        viewModel.countdown = runTimer(duration: 0.1, action: #selector(runCountdown), repeats: true)
    }
    
    @objc private func nextQuestion() {
        viewModel.timer.invalidate()
        viewModel.buttonsBackForwardOnOff(buttonBack, buttonForward)
        viewModel.checkLastQuestionForShowTitle(labelQuiz, labelDescription)
        viewModel.checkTimeUp {
            self.timeUp()
        }
    }
    // MARK: - Run timer
    @objc private func runCountdown() {
        viewModel.setTitleTimer(labelTimer) {
            self.timeUp()
        }
    }
    
    private func timeUp() {
        viewModel.setEnabled(subviews: buttonBack, buttonForward, buttonExit, isEnabled: false)
        viewModel.isEnabledButtons(isOn: false)
        viewModel.endGame(labelQuiz, labelDescription)
    }
    // MARK: - Business logic
    @objc private func exitToGameType() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func back() {
        viewModel.isEnabledButtons(isOn: false)
        viewModel.setEnabled(subviews: buttonBack, buttonForward, isEnabled: false)
        viewModel.animationBackSubviews(view)
        viewModel.timer = runTimer(duration: 0.25, action: #selector(updateBackQuestion), repeats: false)
    }
    
    @objc private func forward() {
        viewModel.isEnabledButtons(isOn: false)
        viewModel.setEnabled(subviews: buttonBack, buttonForward, isEnabled: false)
        viewModel.animationSubviews(duration: 0.25, view)
        viewModel.timer = runTimer(duration: 0.25, action: #selector(updateQuestion), repeats: false)
    }
    // MARK: - Actions for press button
    @objc private func buttonPress(button: UIButton) {
        switch button {
        case buttonFirst: viewModel.action(buttonFirst, buttonBack, buttonForward)
        case buttonSecond: viewModel.action(buttonSecond, buttonBack, buttonForward)
        case buttonThird: viewModel.action(buttonThird, buttonBack, buttonForward)
        default: viewModel.action(buttonFourth, buttonBack, buttonForward)
        }
        setupNextQuestion()
    }
    // MARK: - Run for show next question
    private func setupNextQuestion() {
        if viewModel.numberQuestion + 1 < viewModel.countQuestions {
            viewModel.timer = runTimer(duration: 0.7, action: #selector(hideQuestion), repeats: false)
        } else {
            viewModel.selectAnswerForLastQuestion(labelQuiz, labelDescription)
        }
    }
    
    @objc private func hideQuestion() {
        viewModel.timer.invalidate()
        viewModel.animationSubviews(duration: 0.25, view)
        viewModel.timer = runTimer(duration: 0.25, action: #selector(updateQuestion), repeats: false)
    }
    
    @objc private func updateQuestion() {
        viewModel.timer.invalidate()
        if viewModel.numberQuestion == viewModel.currentQuestion {
            viewModel.setCurrentQuestion(1)
            viewModel.setNumberQuestion(1)
        } else {
            viewModel.setNumberQuestion(1)
        }
        viewModel.moveSubviews(view)
        updateData()
        startGame()
    }
    // MARK: - Show prevoius question
    @objc private func updateBackQuestion() {
        viewModel.timer.invalidate()
        viewModel.setNumberQuestion(-1)
        if viewModel.lastQuestion {
            viewModel.setOpacity(subviews: labelDescription, opacity: 0, duration: 0)
            viewModel.setOpacity(subviews: labelQuiz, opacity: 1, duration: 1)
        }
        viewModel.moveBackSubviews(view)
        updateData()
        viewModel.timer = runTimer(duration: 0.1, action: #selector(showBackQuestion), repeats: false)
    }
    
    @objc private func showBackQuestion() {
        viewModel.timer.invalidate()
        viewModel.animationBackSubviews(view)
        viewModel.timer = runTimer(duration: 0.25, action: #selector(nextQuestion), repeats: false)
    }
    // MARK: - Refresh data for show next question
    private func updateData() {
        viewModel.updateData(question, view)
        viewModel.updateNumberQuestion(labelNumber)
        
        viewModel.setColorButtonsDisabled(0)
        viewModel.setCheckmarksDisabled(0)
        if viewModel.isFlag {
            viewModel.setLabelsDisabled(0)
        }
        
        viewModel.setSelectedResponse()
    }
}
// MARK: - Touches began
extension QuestionnaireViewController {
    private func resultsVC() {
        let resultsViewModel = viewModel.resultsViewController()
        let resultsVC = ResultsViewController()
        resultsVC.viewModel = resultsViewModel
        resultsVC.delegateQuestionnaire = self
        navigationController?.pushViewController(resultsVC, animated: true)
    }
}
// MARK: - Setup buttons
extension QuestionnaireViewController {
    private func setButton(image: String, action: Selector, isEnabled: Bool? = nil, 
                           opacity: Float? = nil, tag: Int? = nil) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        button.isEnabled = isEnabled ?? true
        button.layer.opacity = opacity ?? 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = tag ?? 0
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setButton(title: Countries, tag: Int) -> UIButton {
        let checkmark = viewModel.setCheckmark(tag: tag)
        let label = viewModel.setLabel(title.name, size: 23, and: 1, tag: tag)
        let button = UIButton(type: .custom)
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 12
        button.tag = tag
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        viewModel.setSubviews(subviews: checkmark, label, on: button)
        viewModel.setButton(button: button, tag: tag)
        viewModel.constraintsOnButton(checkmark, and: label, on: button)
        return button
    }
    
    private func setButton(flag: Countries, tag: Int) -> UIButton {
        let checkmark = viewModel.setCheckmark(tag: tag)
        let flag = viewModel.setImage(image: flag, tag: tag)
        let button = UIButton(type: .custom)
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 12
        button.tag = tag
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        viewModel.setSubviews(subviews: checkmark, flag, on: button)
        viewModel.setButton(button: button, tag: tag)
        viewModel.imagesOnButton(checkmark, and: flag, on: button, view)
        return button
    }
}
// MARK: - Setup stack view
extension QuestionnaireViewController {
    private func setupStackView(buttonFirst: UIButton, buttonSecond: UIButton) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [buttonFirst, buttonSecond])
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Setup constraints
extension QuestionnaireViewController {
    private func setupConstraints() {
        viewModel.setSquare(subview: buttonExit, sizes: 40)
        
        if viewModel.isCountdown {
            viewModel.constraintsTimer(labelTimer, view)
        }
        viewModel.constraintsIssue(question, view)
        
        viewModel.progressView(progressView, on: question, view)
        viewModel.constraintsButton(buttonBack, question, view)
        viewModel.constraintsButton(buttonForward, question, view)
        
        NSLayoutConstraint.activate([
            labelNumber.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            labelNumber.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 20),
            labelNumber.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelNumber.widthAnchor.constraint(equalToConstant: 85)
        ])
        
        NSLayoutConstraint.activate([
            labelQuiz.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 25),
            labelQuiz.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelQuiz.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            labelDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelDescription.centerYAnchor.constraint(equalTo: labelQuiz.centerYAnchor),
            labelDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        viewModel.button(stackView, to: labelQuiz, view)
    }
}
