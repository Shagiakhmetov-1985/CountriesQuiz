//
//  QuizOfCapitalsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 18.10.2023.
//

import UIKit

protocol QuizOfCapitalsViewControllerInput: AnyObject {
    func dataToQuizOfCapitals(setting: Setting)
}

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
        setLabel(title: "\(viewModel.time)", size: 35)
    }()
    
    private lazy var imageFlag: UIImageView = {
        setImage(image: viewModel.question)
    }()
    
    private lazy var labelCountry: UILabel = {
        setLabel(title: viewModel.question, size: 32)
    }()
    
    private lazy var progressView: UIProgressView = {
        setProgressView()
    }()
    
    private lazy var labelNumber: UILabel = {
        setLabel(title: "0 / \(viewModel.countQuestions)", size: 23)
    }()
    
    private lazy var labelQuiz: UILabel = {
        setLabel(title: "Выберите правильный ответ", size: 23, opacity: 0)
    }()
    
    private lazy var labelDescription: UILabel = {
        setLabel(title: "Коснитесь экрана, чтобы продолжить", size: 19, opacity: 0)
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
    
    private lazy var stackViewFlag: UIStackView = {
        setStackView(buttonFirst: buttonFirst, 
                     buttonSecond: buttonSecond,
                     buttonThird: buttonThird, 
                     buttonFourth: buttonFourth)
    }()
    
    var viewModel: QuizOfCapitalsViewModelProtocol!
    weak var delegateInput: GameTypeViewControllerInput!
    
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
        guard viewModel.isCountdown() else { return }
        viewModel.setCircleTime(labelTimer, view)
    }
    // MARK: - General methods
    private func setupData() {
        viewModel.getQuestions()
    }
    
    private func setupDesign() {
        view.backgroundColor = viewModel.background
        navigationItem.hidesBackButton = true
        viewModel.setSubviews(buttonFirst, buttonSecond, buttonThird, buttonFourth, imageFlag, labelCountry)
    }
    
    private func setupBarButton() {
        viewModel.setBarButton(buttonBack, navigationItem)
    }
    
    private func setupSubviews() {
        if viewModel.isCountdown() {
            viewModel.isFlag() ? subviewsWithTimerFlag() : subviewsWithTimerLabel()
        } else {
            viewModel.isFlag() ? subviewsWithoutTimerFlag() : subviewsWithoutTimerLabel()
        }
    }
    
    private func subviewsWithTimerFlag() {
        viewModel.setupSubviews(subviews: labelTimer, imageFlag, progressView, labelNumber,
                                labelQuiz, labelDescription, stackViewFlag, on: view)
    }
    
    private func subviewsWithTimerLabel() {
        viewModel.setupSubviews(subviews: labelTimer, labelCountry, progressView, labelNumber,
                                labelQuiz, labelDescription, stackViewFlag, on: view)
    }
    
    private func subviewsWithoutTimerFlag() {
        viewModel.setupSubviews(subviews: imageFlag, progressView, labelNumber, labelQuiz,
                                labelDescription, stackViewFlag, on: view)
    }
    
    private func subviewsWithoutTimerLabel() {
        viewModel.setupSubviews(subviews: labelCountry, progressView, labelNumber, labelQuiz,
                                labelDescription, stackViewFlag, on: view)
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
        labelNumber.text = viewModel.labelNumberQuiz
        
        guard viewModel.isCountdown() else { return }
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
        
        guard viewModel.isCountdown() else { return }
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
        
        viewModel.updateData(labelTimer, view)
        viewModel.animationShowQuizHideDescription(labelQuiz, labelDescription)
        startGame()
    }
}
// MARK: - Touch on the screen
extension QuizOfCapitalsViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if viewModel.answerSelect {
            if viewModel.currentQuestion + 1 < viewModel.countQuestions {
                hideSubviews()
            } else {
                let resultsViewModel = viewModel.resultsViewController()
                let resultsVC = ResultsViewController()
                resultsVC.viewModel = resultsViewModel
                resultsVC.delegateQuizOfCapitals = self
                navigationController?.pushViewController(resultsVC, animated: true)
            }
        }
    }
}
// MARK: - Setup buttons
extension QuizOfCapitalsViewController {
    private func setButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
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
}
// MARK: - Setup labels
extension QuizOfCapitalsViewController {
    private func setLabel(title: String, size: CGFloat, opacity: Float? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.opacity = opacity ?? 1
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup image
extension QuizOfCapitalsViewController {
    private func setImage(image: String) -> UIImageView {
        let image = UIImage(named: image)
        let imageView = UIImageView(image: image)
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
// MARK: - Setup progress view
extension QuizOfCapitalsViewController {
    private func setProgressView() -> UIProgressView {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = viewModel.radius
        progressView.clipsToBounds = true
        progressView.progressTintColor = .white
        progressView.trackTintColor = .white.withAlphaComponent(0.3)
        progressView.progress = 0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }
}
// MARK: - Setup stack view
extension QuizOfCapitalsViewController {
    private func setStackView(buttonFirst: UIButton, buttonSecond: UIButton,
                              buttonThird: UIButton, buttonFourth: UIButton) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [buttonFirst, buttonSecond, buttonThird, buttonFourth])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Setup constraints
extension QuizOfCapitalsViewController {
    private func setupConstraints() {
        if viewModel.isCountdown() {
            viewModel.constraintsTimer(labelTimer, view)
        }
        
        viewModel.setSquare(button: buttonBack, sizes: 40)
        
        if viewModel.isFlag() {
            viewModel.constraintsFlag(imageFlag, view)
            viewModel.progressView(progressView, imageFlag.bottomAnchor, constant: 30, view)
        } else {
            viewModel.constraintsLabel(labelCountry, view)
            viewModel.progressView(progressView, view.safeAreaLayoutGuide.topAnchor, constant: 140, view)
        }
        
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
        
        viewModel.constraintsButtons(stackViewFlag, to: labelQuiz, view)
    }
}
// MARK: - QuizOfCapitalsViewControllerInput
extension QuizOfCapitalsViewController: QuizOfCapitalsViewControllerInput {
    func dataToQuizOfCapitals(setting: Setting) {
        delegateInput.dataToGameType(setting: setting)
    }
}
