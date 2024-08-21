//
//  QuizOfCapitalsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 18.10.2023.
//

import UIKit

class QuizOfCapitalsViewController: UIViewController {
    private lazy var buttonBack: UIButton = {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "multiply", withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        button.translatesAutoresizingMaskIntoConstraints = true
        button.addTarget(self, action: #selector(exitToTypeGame), for: .touchUpInside)
        return button
    }()
    
    private lazy var labelTimer: UILabel = {
        viewModel.setLabel("\(viewModel.time)", size: 35, color: .white, and: 1)
    }()
    
    private lazy var question: UIView = {
        viewModel.question()
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = viewModel.radius
        progressView.clipsToBounds = true
        progressView.progressTintColor = .white
        progressView.trackTintColor = .white.withAlphaComponent(0.3)
        progressView.progress = 0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private lazy var labelNumber: UILabel = {
        viewModel.setLabel(viewModel.titleNumberNil, size: 23, color: .white, and: 1)
    }()
    
    private lazy var labelQuiz: UILabel = {
        viewModel.setLabel(viewModel.titleQuiz, size: 23, color: .white, and: 0)
    }()
    
    private lazy var labelDescription: UILabel = {
        viewModel.setLabel(viewModel.titleDescription, size: 19, color: .white, and: 0)
    }()
    
    private lazy var buttonFirst: UIButton = {
        setButton(title: viewModel.answerFirst, tag: 1)
    }()
    
    private lazy var buttonSecond: UIButton = {
        setButton(title: viewModel.answerSecond, tag: 2)
    }()
    
    private lazy var buttonThird: UIButton = {
        setButton(title: viewModel.answerThird, tag: 3)
    }()
    
    private lazy var buttonFourth: UIButton = {
        setButton(title: viewModel.answerFourth, tag: 4)
    }()
    
    private lazy var stackView: UIStackView = {
        viewModel.setStackView(buttonFirst, buttonSecond, buttonThird, buttonFourth)
    }()
    
    var viewModel: QuizOfCapitalsViewModelProtocol!
    weak var delegate: GameTypeViewControllerInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupDesign()
        setupBarButton()
        setupSubviews()
        setupConstraints()
        viewModel.runMoveSubviews(view)
        startGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard viewModel.isCountdown else { return }
        viewModel.setCircleTime(labelTimer, view)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if viewModel.answerSelect {
            if viewModel.currentQuestion + 1 < viewModel.countQuestions {
                hideSubviews()
            } else {
                let resultsViewModel = viewModel.resultsViewController()
                let resultsVC = ResultsViewController()
                resultsVC.viewModel = resultsViewModel
                navigationController?.pushViewController(resultsVC, animated: true)
            }
        }
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
        viewModel.setBarButton(buttonBack, navigationItem)
    }
    
    private func setupSubviews() {
        viewModel.isCountdown ? subviewsWithTimer() : subviewsWithoutTimer()
    }
    
    private func subviewsWithTimer() {
        viewModel.setupSubviews(subviews: labelTimer, question, progressView, labelNumber,
                                labelQuiz, labelDescription, stackView, on: view)
    }
    
    private func subviewsWithoutTimer() {
        viewModel.setupSubviews(subviews: question, progressView, labelNumber,
                                labelQuiz, labelDescription, stackView, on: view)
    }
    
    private func runTimer(time: CGFloat, action: Selector, repeats: Bool) -> Timer {
        Timer.scheduledTimer(timeInterval: time, target: self, selector: action,
                             userInfo: nil, repeats: repeats)
    }
    // MARK: - Start game
    private func startGame() {
        let time: CGFloat = viewModel.currentQuestion == 0 ? 1 : 0.25
        viewModel.timer = runTimer(time: time, action: #selector(showSubviews), repeats: false)
    }
    
    @objc private func showSubviews() {
        viewModel.timer.invalidate()
        let time: CGFloat = viewModel.currentQuestion == 0 ? 0.5 : 0.25
        viewModel.animationShowQuizHideDescription(labelQuiz, labelDescription)
        viewModel.animationSubviews(duration: time, view)
        viewModel.checkSetCircularStrokeEnd()
        viewModel.timer = runTimer(time: time, action: #selector(isEnableButtons), repeats: false)
    }
    // MARK: - Enable buttons
    @objc private func isEnableButtons() {
        viewModel.timer.invalidate()
        viewModel.setEnabled(controls: buttonFirst, buttonSecond, buttonThird, buttonFourth, isEnabled: true)
        viewModel.updateProgressView(progressView)
        labelNumber.text = viewModel.titleNumber
        
        guard viewModel.isCountdown else { return }
        viewModel.setTime()
        viewModel.animationCircleCountdown()
        runTimer()
    }
    // MARK: - Run timer
    @objc private func runTimer() {
        viewModel.timer = runTimer(time: 0.1, action: #selector(timerTitle), repeats: true)
    }
    
    @objc private func timerTitle() {
        viewModel.setTitleTimer(labelTimer) {
            self.timeUp()
        }
    }
    
    private func timeUp() {
        viewModel.timeUp(labelQuiz, labelDescription)
    }
    // MARK: - Button back
    @objc private func exitToTypeGame() {
        viewModel.exitToGameType()
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Button action when user select answer
    @objc private func buttonPress(button: UIButton) {
        viewModel.showDescription(labelQuiz, labelDescription)
        viewModel.addAnsweredQuestion()
        viewModel.checkAnswer(button: button) {
            self.delay()
        }
        
        guard viewModel.isCountdown else { return }
        viewModel.stopAnimationCircleTimer()
        viewModel.checkTimeSpent()
    }
    
    private func delay() {
        guard viewModel.currentQuestion + 1 < viewModel.countQuestions else { return }
        viewModel.timer = runTimer(time: 3, action: #selector(hideSubviews), repeats: false)
    }
    // MARK: - Run next question
    @objc private func hideSubviews() {
        viewModel.runNextQuestion()
        viewModel.animationSubviews(duration: 0.25, view)
        viewModel.timer = runTimer(time: 0.25, action: #selector(nextQuestion), repeats: false)
    }
    
    @objc private func nextQuestion() {
        viewModel.timer.invalidate()
        viewModel.setNextCurrentQuestion(1)
        viewModel.runMoveSubviews(view)
        
        viewModel.updateData(question, labelTimer, view)
        viewModel.animationShowQuizHideDescription(labelQuiz, labelDescription)
        startGame()
    }
}
// MARK: - Setup buttons
extension QuizOfCapitalsViewController {
    private func setButton(title: Countries, tag: Int) -> UIButton {
        let button = Button(type: .system)
        button.setTitle(title.capitals, for: .normal)
        button.setTitleColor(.blueBlackSea, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont(name: "mr_fontick", size: 23)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.isEnabled = false
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        viewModel.setButton(button, tag: tag)
        return button
    }
}
// MARK: - Setup constraints
extension QuizOfCapitalsViewController {
    private func setupConstraints() {
        viewModel.setSquare(button: buttonBack, sizes: 40)
        
        if viewModel.isCountdown {
            viewModel.constraintsTimer(labelTimer, view)
        }
        
        viewModel.constraintsIssue(question, view)
        viewModel.progressView(progressView, on: question, view)
        
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
            labelDescription.centerYAnchor.constraint(equalTo: labelQuiz.centerYAnchor)
        ])
        
        viewModel.constraintsButtons(stackView, to: labelQuiz, view)
    }
}
