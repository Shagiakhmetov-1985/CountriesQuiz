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
        setButton(action: #selector(exitToTypeGame))
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
        setButton(title: viewModel.answerFirst, tag: 1, action: #selector(buttonPress))
    }()
    
    private lazy var buttonSecond: UIButton = {
        setButton(title: viewModel.answerSecond, tag: 2, action: #selector(buttonPress))
    }()
    
    private lazy var buttonThird: UIButton = {
        setButton(title: viewModel.answerThird, tag: 3, action: #selector(buttonPress))
    }()
    
    private lazy var buttonFourth: UIButton = {
        setButton(title: viewModel.answerFourth, tag: 4, action: #selector(buttonPress))
    }()
    
    private lazy var stackViewFlag: UIStackView = {
        setStackView(buttonFirst: buttonFirst, 
                     buttonSecond: buttonSecond,
                     buttonThird: buttonThird, 
                     buttonFourth: buttonFourth)
    }()
    
    var viewModel: QuizOfCapitalsViewModelProtocol!
    weak var delegateInput: GameTypeViewControllerInput!
    
    private var timer = Timer()
    private let shapeLayer = CAShapeLayer()
    
    private var currentQuestion = 0
    private var seconds = 0
    private var spendTime: [CGFloat] = []
    private var questions: (questions: [Countries], buttonFirst: [Countries],
                            buttonSecond: [Countries], buttonThird: [Countries],
                            buttonFourth: [Countries])!
    private var answerSelect = false
    
    private var correctAnswers: [Countries] = []
    private var incorrectAnswers: [Results] = []
    
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
        circularShadow()
        circular(strokeEnd: 0)
        animationCircleTimeReset()
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
        let time: CGFloat = currentQuestion == 0 ? 1 : 0.25
        timer = runTimer(time: time, action: #selector(showSubviews), repeats: false)
    }
    
    @objc private func showSubviews() {
        timer.invalidate()
        let time: CGFloat = currentQuestion == 0 ? 0.5 : 0.25
        viewModel.animationShowQuizHideDescription(labelQuiz, labelDescription)
        viewModel.animationSubviews(duration: time, view)
        checkSetCircularStrokeEnd()
        timer = runTimer(time: time, action: #selector(isEnableButtons), repeats: false)
    }
    // MARK: - Enable buttons
    @objc private func isEnableButtons() {
        timer.invalidate()
        viewModel.setEnabled(controls: buttonFirst, buttonSecond, buttonThird, buttonFourth, isEnabled: true)
        updateProgressView()
        labelNumber.text = "\(currentQuestion + 1) / \(viewModel.countQuestions)"
        
        guard viewModel.isCountdown() else { return }
        viewModel.setTime()
        animationCircleCountdown()
        runTimer()
    }
    
    private func updateProgressView() {
        let time = TimeInterval(viewModel.countQuestions)
        let interval = 1 / time
        let progress = progressView.progress + Float(interval)
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.setProgress(progress, animated: true)
        }
    }
    // MARK: - Run timer
    @objc private func runTimer() {
        timer = runTimer(time: 0.1, action: #selector(timerTitle), repeats: true)
    }
    
    @objc private func timerTitle() {
        seconds -= 1
        guard seconds.isMultiple(of: 10) else { return }
        let text = seconds / 10
        labelTimer.text = "\(text)"
        
        guard seconds == 0 else { return }
        timer.invalidate()
        timeUp()
    }
    
    private func timeUp() {
        answerSelect.toggle()
        incorrectAnswerTimeUp()
        
        if !viewModel.isOneQuestion() {
            currentQuestion = viewModel.countQuestions - 1
        }
        viewModel.showDescription(labelQuiz, labelDescription)
        animationColorDisableButton()
    }
    // MARK: - Button back
    @objc private func exitToTypeGame() {
        timer.invalidate()
        seconds = 0
        currentQuestion = 0
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Button action when user select answer
    @objc private func buttonPress(button: UIButton) {
        timer.invalidate()
        answerSelect.toggle()
        
        animationColorButton(button: button)
        viewModel.showDescription(labelQuiz, labelDescription)
        
        guard viewModel.isCountdown() else { return }
        stopAnimationCircleTimer()
        checkTimeSpent()
    }
    
    private func animationColorDisableButton() {
        disableButton(buttons: buttonFirst, buttonSecond, buttonThird,
                      buttonFourth, tag: 0)
    }
    
    private func animationColorButton(button: UIButton) {
        checkButton(tag: button.tag, button: button)
        disableButton(buttons: buttonFirst, buttonSecond, buttonThird, 
                      buttonFourth, tag: button.tag)
    }
    
    private func checkButton(tag: Int, button: UIButton) {
        let green = UIColor.greenYellowBrilliant
        let red = UIColor.bismarkFuriozo
        let white = UIColor.white
        
        if checkAnswer(tag: tag) {
            setButtonColor(button: button, color: green, titleColor: white)
            correctAnswer()
        } else {
            setButtonColor(button: button, color: red, titleColor: white)
            incorrectAnswer(tag: tag)
        }
    }
    
    private func setButtonColor(button: UIButton, color: UIColor, titleColor: UIColor? = nil) {
        UIView.animate(withDuration: 0.3) { 
            button.backgroundColor = color
            button.layer.shadowColor = color.cgColor
            button.setTitleColor(titleColor, for: .normal)
        }
    }
    
    private func disableButton(buttons: UIButton..., tag: Int) {
        let gray = UIColor.grayLight
        let white = UIColor.white.withAlphaComponent(0.9)
        
        buttons.forEach { button in
            if !(button.tag == tag) {
                setButtonColor(button: button, color: white, titleColor: gray)
            }
            button.isEnabled = false
        }
        delay()
    }
    
    private func delay() {
        guard currentQuestion + 1 < viewModel.countQuestions else { return }
        timer = runTimer(time: 3, action: #selector(hideSubviews), repeats: false)
    }
    // MARK: - Time spent for every answer
    private func checkTimeSpent() {
        if viewModel.isOneQuestion() {
            setTimeSpent()
        } else if !viewModel.isOneQuestion(), currentQuestion + 1 == viewModel.countQuestions {
            setTimeSpent()
        }
    }
    
    private func setTimeSpent() {
        let circleTimeSpent = 1 - shapeLayer.strokeEnd
        let seconds = viewModel.time
        let timeSpent = circleTimeSpent * CGFloat(seconds)
        spendTime.append(timeSpent)
    }
    // MARK: - Add correct or incorrect answer
    private func checkAnswer(tag: Int) -> Bool {
        switch tag {
        case 1:
            return questions.questions[currentQuestion] == 
            questions.buttonFirst[currentQuestion] ? true : false
        case 2:
            return questions.questions[currentQuestion] == 
            questions.buttonSecond[currentQuestion] ? true : false
        case 3:
            return questions.questions[currentQuestion] == 
            questions.buttonThird[currentQuestion] ? true : false
        default:
            return questions.questions[currentQuestion] == 
            questions.buttonFourth[currentQuestion] ? true : false
        }
    }
    
    private func correctAnswer() {
        correctAnswers.append(questions.questions[currentQuestion])
    }
    
    private func incorrectAnswer(tag: Int) {
        incorrectAnswer(numberQuestion: currentQuestion + 1, tag: tag,
                        question: questions.questions[currentQuestion],
                        buttonFirst: questions.buttonFirst[currentQuestion],
                        buttonSecond: questions.buttonSecond[currentQuestion],
                        buttonThird: questions.buttonThird[currentQuestion],
                        buttonFourth: questions.buttonFourth[currentQuestion],
                        timeUp: false)
    }
    
    private func incorrectAnswerTimeUp() {
        incorrectAnswer(numberQuestion: currentQuestion, tag: 0,
                        question: questions.questions[currentQuestion],
                        buttonFirst: questions.buttonFirst[currentQuestion],
                        buttonSecond: questions.buttonSecond[currentQuestion],
                        buttonThird: questions.buttonThird[currentQuestion],
                        buttonFourth: questions.buttonFourth[currentQuestion],
                        timeUp: true)
    }
    
    private func incorrectAnswer(numberQuestion: Int, tag: Int, question: Countries,
                                 buttonFirst: Countries, buttonSecond: Countries,
                                 buttonThird: Countries, buttonFourth: Countries,
                                 timeUp: Bool) {
        let answer = Results(currentQuestion: numberQuestion, tag: tag,
                             question: question, buttonFirst: buttonFirst,
                             buttonSecond: buttonSecond, buttonThird: buttonThird,
                             buttonFourth: buttonFourth, timeUp: timeUp)
        incorrectAnswers.append(answer)
    }
    // MARK: - Update data for next question
    private func updateData() {
        viewModel.isFlag() ? updateImageFlag() : updateLabelCountry()
        updateTitleButtons()
        guard viewModel.isCountdown() else { return }
        resetTimer()
    }
    
    private func updateImageFlag() {
        let flag = questions.questions[currentQuestion].flag
        imageFlag.image = UIImage(named: flag)
        viewModel.widthOfFlag.constant = checkWidthFlag(flag: flag)
    }
    
    private func updateLabelCountry() {
        labelCountry.text = questions.questions[currentQuestion].name
    }
    
    private func updateTitleButtons() {
        buttonFirst.setTitle(questions.buttonFirst[currentQuestion].capitals, for: .normal)
        buttonSecond.setTitle(questions.buttonSecond[currentQuestion].capitals, for: .normal)
        buttonThird.setTitle(questions.buttonThird[currentQuestion].capitals, for: .normal)
        buttonFourth.setTitle(questions.buttonFourth[currentQuestion].capitals, for: .normal)
    }
    
    private func resetTimer() {
        if viewModel.isOneQuestion(), seconds > 0 {
            resetTitleAndCircleTimer()
        } else if viewModel.isOneQuestion(), seconds == 0 {
            circular(strokeEnd: 0)
            resetTitleAndCircleTimer()
        }
    }
    
    private func resetTitleAndCircleTimer() {
        resetTitleTimer()
        animationCircleTimeReset()
    }
    
    private func resetTitleTimer() {
        labelTimer.text = "\(viewModel.time)"
    }
    
    private func resetColorButton(buttons: UIButton...) {
        let white = UIColor.white
        let blue = UIColor.blueBlackSea
        buttons.forEach { button in
            setButtonColor(button: button, color: white, titleColor: blue)
        }
    }
    // MARK: - Run next question
    @objc private func hideSubviews() {
        timer.invalidate()
        answerSelect.toggle()
        viewModel.animationSubviews(duration: 0.25, view)
        timer = runTimer(time: 0.25, action: #selector(nextQuestion), repeats: false)
    }
    
    @objc private func nextQuestion() {
        timer.invalidate()
        currentQuestion += 1
        
        viewModel.runMoveSubviews(view)
        updateData()
        viewModel.animationShowQuizHideDescription(labelQuiz, labelDescription)
        resetColorButton(buttons: buttonFirst, buttonSecond, buttonThird, buttonFourth)
        startGame()
    }
}
// MARK: - Touch on the screen
extension QuizOfCapitalsViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if answerSelect {
            if currentQuestion + 1 < viewModel.countQuestions {
                hideSubviews()
            } else {
//                let resultsVC = ResultsViewController()
//                resultsVC.correctAnswers = correctAnswers
//                resultsVC.incorrectAnswers = incorrectAnswers
//                resultsVC.mode = mode
//                resultsVC.game = game
//                resultsVC.spendTime = spendTime
//                resultsVC.delegateQuizOfCapitals = self
//                navigationController?.pushViewController(resultsVC, animated: true)
            }
        }
    }
}
// MARK: - Setup buttons
extension QuizOfCapitalsViewController {
    private func setButton(action: Selector) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "multiply", withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        button.translatesAutoresizingMaskIntoConstraints = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setButton(title: String, tag: Int, action: Selector) -> UIButton {
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
        button.addTarget(self, action: action, for: .touchUpInside)
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
        progressView.layer.cornerRadius = radius()
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
// MARK: - Setup circle timer
extension QuizOfCapitalsViewController {
    private func circularShadow() {
        let center = CGPoint(x: labelTimer.center.x, y: labelTimer.center.y)
        let endAngle = CGFloat.pi / 2
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: 32,
            startAngle: -startAngle,
            endAngle: -endAngle,
            clockwise: true)
        
        let trackShape = CAShapeLayer()
        trackShape.path = circularPath.cgPath
        trackShape.lineWidth = 5
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.strokeColor = UIColor.white.withAlphaComponent(0.3).cgColor
        view.layer.addSublayer(trackShape)
    }
    
    private func circular(strokeEnd: CGFloat) {
        let center = CGPoint(x: labelTimer.center.x, y: labelTimer.center.y)
        let endAngle = CGFloat.pi / 2
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: 32,
            startAngle: -startAngle,
            endAngle: -endAngle,
            clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = strokeEnd
        shapeLayer.lineCap = CAShapeLayerLineCap.square
        shapeLayer.strokeColor = UIColor.white.cgColor
        view.layer.addSublayer(shapeLayer)
    }
    
    private func checkSetCircularStrokeEnd() {
        if viewModel.isOneQuestion(), viewModel.isCountdown() {
            shapeLayer.strokeEnd = 1
        } else if !viewModel.isOneQuestion(), viewModel.isCountdown(), currentQuestion < 1 {
            shapeLayer.strokeEnd = 1
        }
    }
    
    private func animationCircleCountdown() {
        let timer = viewModel.circleTimeElapsed
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 0
        animation.duration = CFTimeInterval(timer)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
    
    private func animationCircleTimeReset() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = CFTimeInterval(0.4)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
    
    private func stopAnimationCircleTimer() {
        let oneQuestionTime = viewModel.time * 10
        let time = CGFloat(seconds) / CGFloat(oneQuestionTime)
        let result = round(100 * time) / 100
        shapeLayer.removeAnimation(forKey: "animation")
        shapeLayer.strokeEnd = result
    }
}
// MARK: - Setup constraints
extension QuizOfCapitalsViewController {
    private func setupConstraints() {
        if viewModel.isCountdown() {
            constraintsTimer()
        }
        
        setupSquare(button: buttonBack, sizes: 40)
        
        if viewModel.isFlag() {
            constraintsFlag()
            constraintsProgressView(layout: imageFlag.bottomAnchor, constant: 30)
        } else {
            constraintsLabel()
            constraintsProgressView(layout: view.safeAreaLayoutGuide.topAnchor, constant: 140)
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
        
        constraintsButtons()
    }
    
    private func constraintsTimer() {
        NSLayoutConstraint.activate([
            labelTimer.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            labelTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupSquare(button: UIButton, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: sizes),
            button.widthAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    private func constraintsFlag() {
        let flag = questions.questions[currentQuestion].flag
        viewModel.widthOfFlag = imageFlag.widthAnchor.constraint(equalToConstant: checkWidthFlag(flag: flag))
        
        viewModel.imageFlagSpring = NSLayoutConstraint(
            item: imageFlag, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(viewModel.imageFlagSpring)
        NSLayoutConstraint.activate([
            imageFlag.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            viewModel.widthOfFlag,
            imageFlag.heightAnchor.constraint(equalToConstant: 168)
        ])
    }
    
    private func constraintsLabel() {
        viewModel.labelNameSpring = NSLayoutConstraint(
            item: labelCountry, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(viewModel.labelNameSpring)
        NSLayoutConstraint.activate([
            labelCountry.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            labelCountry.widthAnchor.constraint(equalToConstant: setWidthSubview())
        ])
    }
    
    private func constraintsProgressView(layout: NSLayoutYAxisAnchor, constant: CGFloat) {
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: layout, constant: constant),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.heightAnchor.constraint(equalToConstant: radius() * 2)
        ])
    }
    
    private func constraintsButtons() {
        viewModel.stackViewSpring = NSLayoutConstraint(
            item: stackViewFlag, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(viewModel.stackViewSpring)
        NSLayoutConstraint.activate([
            stackViewFlag.topAnchor.constraint(equalTo: labelQuiz.bottomAnchor, constant: 25),
            stackViewFlag.widthAnchor.constraint(equalToConstant: setWidthButtons()),
            stackViewFlag.heightAnchor.constraint(equalToConstant: 215)
        ])
    }
    
    private func radius() -> CGFloat {
        6
    }
    
    private func checkWidthFlag(flag: String) -> CGFloat {
        switch flag {
        case "nepal", "vatican city", "switzerland": return 168
        default: return 280
        }
    }
    
    private func setWidthButtons() -> CGFloat {
        view.bounds.width - 40
    }
    
    private func setWidthSubview() -> CGFloat {
        view.bounds.width - 20
    }
}
// MARK: - QuizOfCapitalsViewControllerInput
extension QuizOfCapitalsViewController: QuizOfCapitalsViewControllerInput {
    func dataToQuizOfCapitals(setting: Setting) {
        delegateInput.dataToGameType(setting: setting)
    }
}
