//
//  QuizOfFlagsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 09.01.2023.
//

import UIKit

protocol QuizOfFlagsViewControllerInput: AnyObject {
    func dataToQuizOfFlag(setting: Setting)
}

class QuizOfFlagsViewController: UIViewController, QuizOfFlagsViewControllerInput {
    private lazy var buttonback: UIButton = {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "multiply", withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        button.translatesAutoresizingMaskIntoConstraints = true
        button.addTarget(self, action: #selector(backToGameType), for: .touchUpInside)
        return button
    }()
    
    private lazy var labelTimer: UILabel = {
        viewModel.setLabel("\(viewModel.time)", size: 35, and: 1)
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
        viewModel.setLabel(viewModel.textNumber, size: 23, and: 1)
    }()
    
    private lazy var labelQuiz: UILabel = {
        viewModel.setLabel(viewModel.textQuiz, size: 23, and: 0)
    }()
    
    private lazy var labelDescription: UILabel = {
        viewModel.setLabel(viewModel.textDescription, size: 19, and: 0)
    }()
    
    private lazy var buttonFirst: UIButton = {
        if viewModel.isFlag {
            setButton(title: viewModel.buttonFirst, tag: 1)
        } else {
            setButton(image: viewModel.buttonFirst, tag: 1)
        }
    }()
    
    private lazy var buttonSecond: UIButton = {
        if viewModel.isFlag {
            setButton(title: viewModel.buttonSecond, tag: 2)
        } else {
            setButton(image: viewModel.buttonSecond, tag: 2)
        }
    }()
    
    private lazy var buttonThird: UIButton = {
        if viewModel.isFlag {
            setButton(title: viewModel.buttonThird, tag: 3)
        } else {
            setButton(image: viewModel.buttonThird, tag: 3)
        }
    }()
    
    private lazy var buttonFourth: UIButton = {
        if viewModel.isFlag {
            setButton(title: viewModel.buttonFourth, tag: 4)
        } else {
            setButton(image: viewModel.buttonFourth, tag: 4)
        }
    }()
    
    private lazy var stackView: UIStackView = {
        viewModel.stackView(buttonFirst, buttonSecond, buttonThird, buttonFourth)
    }()
    
    var viewModel: QuizOfFlagsViewModelProtocol!
    weak var delegateInput: GameTypeViewControllerInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupDesign()
        setupSubviews()
        setupConstraints()
        setupBarButton()
        viewModel.runMoveSubviews(view)
        startGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard viewModel.isCountdown else { return }
        viewModel.setCircleTimer(labelTimer, view)
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
                resultsVC.delegateQuizOfFlag = self
                navigationController?.pushViewController(resultsVC, animated: true)
            }
        }
    }
    // MARK: - QuizOfFlagsViewControllerInput
    func dataToQuizOfFlag(setting: Setting) {
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
    
    private func setupSubviews() {
        viewModel.isCountdown ? subviewsWithTimer() : subviewsWithoutTimer()
    }
    
    private func subviewsWithTimer() {
        viewModel.setSubviews(subviews: labelTimer, question, progressView,
                              labelNumber, labelQuiz, labelDescription,
                              stackView, on: view)
    }
    
    private func subviewsWithoutTimer() {
        viewModel.setSubviews(subviews: question, progressView, labelNumber,
                              labelQuiz, labelDescription, stackView, on: view)
    }
    
    private func setupBarButton() {
        viewModel.setBarButton(buttonback, navigationItem)
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
        viewModel.animationSubviews(time, view)
        viewModel.checkSetCircularStrokeEnd()
        viewModel.timer = runTimer(time: time, action: #selector(isEnabledButton), repeats: false)
    }
    // MARK: - Enable subviews
    @objc private func isEnabledButton() {
        viewModel.timer.invalidate()
        viewModel.setEnabled(controls: buttonFirst, buttonSecond, buttonThird, buttonFourth, isEnabled: true)
        viewModel.updateProgressView(progressView)
        labelNumber.text = viewModel.labelNumber
        
        guard viewModel.isCountdown else { return }
        viewModel.setTitleTime()
        viewModel.animationCircleCountdown()
        runTimer()
    }
    // MARK: - Run timer
    private func runTimer() {
        viewModel.timer = runTimer(time: 0.1, action: #selector(timerTitle), repeats: true)
    }
    
    @objc private func timerTitle() {
        viewModel.setTitleTimer(labelTimer) {
            self.timeUp()
        }
    }
    
    private func timeUp() {
        viewModel.answerSelect.toggle()
        viewModel.addIncorrectAnswer(0)
        
        if !viewModel.isOneQuestion {
            viewModel.setNextCurrentQuestion(viewModel.countQuestions - 1)
        }
        viewModel.showDescription(labelQuiz, labelDescription)
        animationColorDisableButton()
    }
    // MARK: - Buttons back
    @objc private func backToGameType() {
        viewModel.timer.invalidate()
        viewModel.setSeconds(0)
        viewModel.setNextCurrentQuestion(0)
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Button action when user select answer
    @objc private func buttonPress(button: UIButton) {
        viewModel.timer.invalidate()
        viewModel.answerSelect.toggle()
        viewModel.addAnsweredQuestion()
        
        animationColorButtons(button: button)
        viewModel.showDescription(labelQuiz, labelDescription)
        
        guard viewModel.isCountdown else { return }
        viewModel.stopAnimationCircleTimer()
        viewModel.checkTimeSpent(viewModel.shapeLayer)
    }
    
    private func animationColorDisableButton() {
        if viewModel.isFlag {
            viewModel.disableButtonFlag(0, buttonFirst, buttonSecond, buttonThird, buttonFourth) {
                self.delay()
            }
        } else {
            viewModel.disableButtonLabel(0, buttonFirst, buttonSecond, buttonThird, buttonFourth) {
                self.delay()
            }
        }
    }
    
    private func animationColorButtons(button: UIButton) {
        if viewModel.isFlag {
            viewModel.checkAnswerFlag(button.tag, button)
            viewModel.disableButtonFlag(button.tag, buttonFirst, buttonSecond, buttonThird, buttonFourth) {
                self.delay()
            }
        } else {
            viewModel.checkAnswerLabel(button.tag, button)
            viewModel.disableButtonLabel(button.tag, buttonFirst, buttonSecond, buttonThird, buttonFourth) {
                self.delay()
            }
        }
    }
    
    private func delay() {
        guard viewModel.currentQuestion + 1 < viewModel.countQuestions else { return }
        viewModel.timer = runTimer(time: 3, action: #selector(hideSubviews), repeats: false)
    }
    // MARK: - Run next question
    @objc private func hideSubviews() {
        viewModel.timer.invalidate()
        viewModel.answerSelect.toggle()
        viewModel.animationSubviews(0.25, view)
        viewModel.timer = runTimer(time: 0.25, action: #selector(nextQuestion), repeats: false)
    }
    
    @objc private func nextQuestion() {
        viewModel.timer.invalidate()
        viewModel.setNextCurrentQuestion(1)
        
        viewModel.runMoveSubviews(view)
        updateData()
        viewModel.animationShowQuizHideDescription(labelQuiz, labelDescription)
        viewModel.resetColorButtons(buttonFirst, buttonSecond, buttonThird, buttonFourth)
        startGame()
    }
    // MARK: - Refresh data for next question
    private func updateData() {
        viewModel.updateData(question, view, buttonFirst, buttonSecond, buttonThird, buttonFourth)
        guard viewModel.isCountdown else { return }
        viewModel.resetTimer(labelTimer, view)
    }
}
// MARK: - Setup button
extension QuizOfFlagsViewController {
    private func setButton(title: Countries, tag: Int) -> UIButton {
        let button = Button(type: .system)
        button.setTitle(title.name, for: .normal)
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
        return button
    }
    
    private func setButton(image: Countries, tag: Int) -> UIButton {
        let imageView = viewModel.setImage(image, tag: tag)
        let button = Button(type: .custom)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.isEnabled = false
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        viewModel.setSubviews(subviews: imageView, on: button)
        viewModel.setConstraints(imageView, on: button, and: image, view)
        return button
    }
}
// MARK: - Setup constraints
extension QuizOfFlagsViewController {
    private func setupConstraints() {
        viewModel.setSquare(subview: buttonback, sizes: 40)
        
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
        
        viewModel.buttons(stackView, to: labelQuiz, view)
    }
}
