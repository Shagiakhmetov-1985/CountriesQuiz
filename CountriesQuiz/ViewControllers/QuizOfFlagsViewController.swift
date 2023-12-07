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

class QuizOfFlagsViewController: UIViewController {
    // MARK: - Setup subviews
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
        setLabel(title: "\(time())", size: 35)
    }()
    
    private lazy var imageFlag: UIImageView = {
        setImage(image: questions.questions[currentQuestion].flag)
    }()
    
    private lazy var labelCountry: UILabel = {
        setLabel(title: "\(questions.questions[currentQuestion].name)", size: 32)
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = radius()
        progressView.clipsToBounds = true
        progressView.progressTintColor = .white
        progressView.trackTintColor = .white.withAlphaComponent(0.3)
        progressView.progress = 0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private lazy var labelNumberQuiz: UILabel = {
        setLabel(title: "0 / \(mode.countQuestions)", size: 23)
    }()
    
    private lazy var labelQuiz: UILabel = {
        setLabel(title: "Выберите правильный ответ", size: 23, opacity: 0)
    }()
    
    private lazy var labelDescription: UILabel = {
        setLabel(title: "Коснитесь экрана, чтобы продолжить", size: 19, opacity: 0)
    }()
    
    private lazy var buttonFirst: UIButton = {
        isFlag() ?
        setButton(title: questions.buttonFirst[currentQuestion].name, tag: 1) :
        setButton(addImage: imageFirst, tag: 1)
    }()
    
    private lazy var imageFirst: UIImageView = {
        setImage(image: questions.buttonFirst[currentQuestion].flag, radius: 8)
    }()
    
    private lazy var buttonSecond: UIButton = {
        isFlag() ?
        setButton(title: questions.buttonSecond[currentQuestion].name, tag: 2) :
        setButton(addImage: imageSecond, tag: 2)
    }()
    
    private lazy var imageSecond: UIImageView = {
        setImage(image: questions.buttonSecond[currentQuestion].flag, radius: 8)
    }()
    
    private lazy var buttonThird: UIButton = {
        isFlag() ?
        setButton(title: questions.buttonThird[currentQuestion].name, tag: 3) :
        setButton(addImage: imageThird, tag: 3)
    }()
    
    private lazy var imageThird: UIImageView = {
        setImage(image: questions.buttonThird[currentQuestion].flag, radius: 8)
    }()
    
    private lazy var buttonFourth: UIButton = {
        isFlag() ?
        setButton(title: questions.buttonFourth[currentQuestion].name, tag: 4) :
        setButton(addImage: imageFourth, tag: 4)
    }()
    
    private lazy var imageFourth: UIImageView = {
        setImage(image: questions.buttonFourth[currentQuestion].flag, radius: 8)
    }()
    
    private lazy var stackViewFlag: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [buttonFirst, buttonSecond, buttonThird, buttonFourth])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var stackViewTop: UIStackView = {
        setStackView(buttonFirst: buttonFirst, buttonSecond: buttonSecond)
    }()
    
    private lazy var stackViewBottom: UIStackView = {
        setStackView(buttonFirst: buttonThird, buttonSecond: buttonFourth)
    }()
    
    private lazy var stackViewLabel: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackViewTop, stackViewBottom])
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var mode: Setting!
    var game: Games!
    weak var delegateInput: GameTypeViewControllerInput!
    
    private var imageFlagSpring: NSLayoutConstraint!
    private var labelNameSpring: NSLayoutConstraint!
    private var stackViewSpring: NSLayoutConstraint!
    
    private var widthOfFlagFirst: NSLayoutConstraint!
    private var widthOfFlagSecond: NSLayoutConstraint!
    private var widthOfFlagThird: NSLayoutConstraint!
    private var widthOfFlagFourth: NSLayoutConstraint!
    
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
        setupSubviews()
        setupConstraints()
        setupBarButton()
        runMoveSubviews()
        startGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard isCountdown() else { return }
        circularShadow()
        circular(strokeEnd: 0)
        animationCircleTimeReset()
    }
    // MARK: - General methods
    private func setupData() {
        questions = Countries.getQuestions(mode: mode)
    }
    
    private func setupDesign() {
        view.backgroundColor = game.background
        navigationItem.hidesBackButton = true
    }
    
    private func setupSubviews() {
        if isCountdown() {
            isFlag() ? subviewsWithTimerFlag() : subviewsWithTimerLabel()
        } else {
            isFlag() ? subviewsWithoutTimerFlag() : subviewsWithoutTimerLabel()
        }
    }
    
    private func subviewsWithTimerFlag() {
        setupSubviews(subviews: labelTimer, imageFlag, progressView, labelNumberQuiz,
                      labelQuiz, labelDescription, stackViewFlag,
                      on: view)
    }
    
    private func subviewsWithTimerLabel() {
        setupSubviews(subviews: labelTimer, labelCountry, progressView, labelNumberQuiz,
                      labelQuiz, labelDescription, stackViewLabel,
                      on: view)
    }
    
    private func subviewsWithoutTimerFlag() {
        setupSubviews(subviews: imageFlag, progressView, labelNumberQuiz,
                      labelQuiz, labelDescription, stackViewFlag,
                      on: view)
    }
    
    private func subviewsWithoutTimerLabel() {
        setupSubviews(subviews: labelCountry, progressView, labelNumberQuiz,
                      labelQuiz, labelDescription, stackViewLabel,
                      on: view)
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    private func setupBarButton() {
        let leftBarButton = UIBarButtonItem(customView: buttonback)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func isFlag() -> Bool {
        mode.flag ? true : false
    }
    
    private func isCountdown() -> Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    
    private func oneQuestionTime() -> Int {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
    }
    
    private func allQuestionsTime() -> Int {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
    }
    // MARK: - Opacity, hidden and enable subviews
    private func setOpacity(labels: UILabel..., opacity: Float) {
        labels.forEach { label in
            label.layer.opacity = opacity
        }
    }
    
    private func setEnabled(controls: UIControl..., isEnabled: Bool) {
        controls.forEach { control in
            control.isEnabled = isEnabled
        }
    }
    
    private func runTimer(time: CGFloat, action: Selector, repeats: Bool) -> Timer {
        Timer.scheduledTimer(timeInterval: time, target: self, selector: action,
                             userInfo: nil, repeats: repeats)
    }
    // MARK: - Time for label, seconds and circle timer
    private func checkTime() {
        if !isOneQuestion(), currentQuestion < 1 {
            seconds = time() * 10
        } else if isOneQuestion() {
            seconds = time() * 10
        }
    }
    
    private func time() -> Int {
        isOneQuestion() ? oneQuestionTime() : allQuestionsTime()
    }
    
    private func checkCircleCountdown() -> Int {
        isOneQuestion() ? oneQuestionTime() : seconds / 10
    }
    
    private func isOneQuestion() -> Bool {
        mode.timeElapsed.questionSelect.oneQuestion ? true : false
    }
    // MARK: - Move flag and buttons
    private func runMoveSubviews() {
        let pointX: CGFloat = currentQuestion > 0 ? 2 : 1
        if isFlag() {
            imageFlagSpring.constant += view.bounds.width * pointX
        } else {
            labelNameSpring.constant += view.bounds.width * pointX
        }
        stackViewSpring.constant += view.bounds.width * pointX
    }
    // MARK: - Animation move subviews
    private func animationSubviews(duration: CGFloat) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) { [self] in
            if isFlag() {
                imageFlagSpring.constant -= view.bounds.width
            } else {
                labelNameSpring.constant -= view.bounds.width
            }
            stackViewSpring.constant -= view.bounds.width
            view.layoutIfNeeded()
        }
    }
    // MARK: - Animation label description and label number
    private func showDescription() {
        if currentQuestion == questions.questions.count - 1 {
            let red = UIColor.lightPurplePink
            labelDescription.text = "Коснитесь экрана, чтобы завершить"
            labelDescription.textColor = red
        }
        
        animationHideQuizShowDescription()
    }
    
    private func animationShowQuizHideDescription() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) { [self] in
            setOpacity(labels: labelQuiz, opacity: 1)
        }
        guard labelDescription.layer.opacity == 1 else { return }
        setOpacity(labels: labelDescription, opacity: 0)
    }
    
    private func animationHideQuizShowDescription() {
        UIView.animate(withDuration: 0.5, animations: { [self] in
            setOpacity(labels: labelQuiz, opacity: 0)
        })
        
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: { [self] in
            setOpacity(labels: labelDescription, opacity: 1)
        })
    }
    // MARK: - Start game
    private func startGame() {
        let time: CGFloat = currentQuestion == 0 ? 1 : 0.25
        timer = runTimer(time: time, action: #selector(showSubviews), repeats: false)
    }
    
    @objc private func showSubviews() {
        timer.invalidate()
        let time: CGFloat = currentQuestion == 0 ? 0.5 : 0.25
        animationShowQuizHideDescription()
        animationSubviews(duration: time)
        checkSetCircularStrokeEnd()
        timer = runTimer(time: time, action: #selector(isEnabledButton), repeats: false)
    }
    // MARK: - Enable subviews
    @objc private func isEnabledButton() {
        timer.invalidate()
        setEnabled(controls: buttonFirst, buttonSecond, buttonThird, buttonFourth, isEnabled: true)
        updateProgressView()
        labelNumberQuiz.text = "\(currentQuestion + 1) / \(mode.countQuestions)"
        
        guard isCountdown() else { return }
        checkTime()
        animationCircleCountdown()
        runTimer()
    }
    
    private func updateProgressView() {
        let time = TimeInterval(mode.countQuestions)
        let interval = 1 / time
        let progress = progressView.progress + Float(interval)
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.setProgress(progress, animated: true)
        }
    }
    // MARK: - Run timer
    private func runTimer() {
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
        
        if !isOneQuestion() {
            currentQuestion = questions.questions.count - 1
        }
        showDescription()
        animationColorDisableButton()
    }
    // MARK: - Buttons back
    @objc private func backToGameType() {
        timer.invalidate()
        seconds = 0
        currentQuestion = 0
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Button action when user select answer
    @objc private func buttonPress(button: UIButton) {
        timer.invalidate()
        answerSelect.toggle()
        
        animationColorButtons(button: button)
        showDescription()
        
        guard isCountdown() else { return }
        stopAnimationCircleTimer()
        checkTimeSpent()
    }
    
    private func animationColorDisableButton() {
        if isFlag() {
            disableButtonFlag(buttons: buttonFirst, buttonSecond,
                              buttonThird, buttonFourth, tag: 0)
        } else {
            disableButtonLabel(buttons: buttonFirst, buttonSecond,
                               buttonThird, buttonFourth, tag: 0)
        }
    }
    
    private func animationColorButtons(button: UIButton) {
        if isFlag() {
            checkAnswerFlag(tag: button.tag, button: button)
            disableButtonFlag(buttons: buttonFirst, buttonSecond,
                              buttonThird, buttonFourth, tag: button.tag)
        } else {
            checkAnswerLabel(tag: button.tag, button: button)
            disableButtonLabel(buttons: buttonFirst, buttonSecond,
                               buttonThird, buttonFourth, tag: button.tag)
        }
    }
    
    private func checkAnswerFlag(tag: Int, button: UIButton) {
        let green = UIColor.greenYellowBrilliant
        let red = UIColor.redTangerineTango
        let white = UIColor.white
        
        if checkAnswer(tag: tag) {
            setButtonColor(button: button, color: green, titleColor: white)
            correctAnswer()
        } else {
            setButtonColor(button: button, color: red, titleColor: white)
            incorrectAnswer(tag: tag)
        }
    }
    
    private func checkAnswerLabel(tag: Int, button: UIButton) {
        let green = UIColor.greenYellowBrilliant
        let red = UIColor.redTangerineTango
        
        if checkAnswer(tag: tag) {
            setButtonColor(button: button, color: green)
            correctAnswer()
        } else {
            setButtonColor(button: button, color: red)
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
    
    private func disableButtonFlag(buttons: UIButton..., tag: Int) {
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
    
    private func disableButtonLabel(buttons: UIButton..., tag: Int) {
        let gray = UIColor.skyGrayLight
        
        buttons.forEach { button in
            if !(button.tag == tag) {
                setButtonColor(button: button, color: gray)
            }
            button.isEnabled = false
        }
        delay()
    }
    
    private func delay() {
        guard currentQuestion + 1 < mode.countQuestions else { return }
        timer = runTimer(time: 3, action: #selector(hideSubviews), repeats: false)
    }
    // MARK: - Time spent for every answer
    private func checkTimeSpent() {
        if isOneQuestion() {
            setTimeSpent()
        } else if !isOneQuestion(), currentQuestion + 1 == questions.questions.count {
            setTimeSpent()
        }
    }
    
    private func setTimeSpent() {
        let circleTimeSpent = 1 - shapeLayer.strokeEnd
        let seconds = time()
        let timeSpent = circleTimeSpent * CGFloat(seconds)
        spendTime.append(timeSpent)
    }
    // MARK: - Add correct or incorrect answers
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
        incorrectAnswer(numberQuestion: currentQuestion + 1, tag: 0,
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
    // MARK: - Refresh data for next question
    private func updateData() {
        isFlag() ? updateDataFlag() : updateDataLabel()
        guard isCountdown() else { return }
        resetTimer()
    }
    
    private func updateDataFlag() {
        let flag = questions.questions[currentQuestion].flag
        imageFlag.image = UIImage(named: flag)
        updateButtonsFlag()
        widthOfFlagFirst.constant = checkWidthFlag(flag: flag)
    }
    
    private func updateDataLabel() {
        labelCountry.text = questions.questions[currentQuestion].name
        updateButtonsLabel()
        updateWidthFlags()
    }
    
    private func updateButtonsFlag() {
        buttonFirst.setTitle(questions.buttonFirst[currentQuestion].name, for: .normal)
        buttonSecond.setTitle(questions.buttonSecond[currentQuestion].name, for: .normal)
        buttonThird.setTitle(questions.buttonThird[currentQuestion].name, for: .normal)
        buttonFourth.setTitle(questions.buttonFourth[currentQuestion].name, for: .normal)
    }
    
    private func updateButtonsLabel() {
        imageFirst.image = UIImage(named: questions.buttonFirst[currentQuestion].flag)
        imageSecond.image = UIImage(named: questions.buttonSecond[currentQuestion].flag)
        imageThird.image = UIImage(named: questions.buttonThird[currentQuestion].flag)
        imageFourth.image = UIImage(named: questions.buttonFourth[currentQuestion].flag)
    }
    
    private func updateWidthFlags() {
        widthOfFlagFirst.constant = widthFlag(flag: questions.buttonFirst[currentQuestion].flag)
        widthOfFlagSecond.constant = widthFlag(flag: questions.buttonSecond[currentQuestion].flag)
        widthOfFlagThird.constant = widthFlag(flag: questions.buttonThird[currentQuestion].flag)
        widthOfFlagFourth.constant = widthFlag(flag: questions.buttonFourth[currentQuestion].flag)
    }
    
    private func resetTimer() {
        if isOneQuestion() && seconds > 0 {
            labelTimer.text = "\(oneQuestionTime())"
            animationCircleTimeReset()
        } else if isOneQuestion() && seconds == 0 {
            labelTimer.text = "\(oneQuestionTime())"
            circular(strokeEnd: 0)
            animationCircleTimeReset()
        }
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
        animationSubviews(duration: 0.25)
        timer = runTimer(time: 0.25, action: #selector(nextQuestion), repeats: false)
    }
    
    @objc private func nextQuestion() {
        timer.invalidate()
        currentQuestion += 1
        
        runMoveSubviews()
        updateData()
        animationShowQuizHideDescription()
        resetColorButton(buttons: buttonFirst, buttonSecond, buttonThird, buttonFourth)
        startGame()
    }
}
// MARK: - Touch on the screen
extension QuizOfFlagsViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if answerSelect {
            if currentQuestion + 1 < mode.countQuestions {
                hideSubviews()
            } else {
                let resultsVC = ResultsViewController()
                resultsVC.correctAnswers = correctAnswers
                resultsVC.incorrectAnswers = incorrectAnswers
                resultsVC.mode = mode
                resultsVC.game = game
                resultsVC.spendTime = spendTime
                resultsVC.delegateQuizOfFlag = self
                navigationController?.pushViewController(resultsVC, animated: true)
            }
        }
    }
}
// MARK: - Setup button
extension QuizOfFlagsViewController {
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
    
    private func setButton(addImage: UIView, tag: Int) -> UIButton {
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
        setupSubviews(subviews: addImage, on: button)
        return button
    }
}
// MARK: - Setup label
extension QuizOfFlagsViewController {
    private func setLabel(title: String, size: CGFloat, opacity: Float? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.layer.opacity = opacity ?? 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup stack views
extension QuizOfFlagsViewController {
    private func setStackView(buttonFirst: UIButton, buttonSecond: UIButton) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [buttonFirst, buttonSecond])
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Setup circle timer
extension QuizOfFlagsViewController {
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
        if isOneQuestion() && isCountdown() {
            shapeLayer.strokeEnd = 1
        } else if !isOneQuestion() && isCountdown() && currentQuestion < 1 {
            shapeLayer.strokeEnd = 1
        }
    }
    
    private func animationCircleCountdown() {
        let timer = checkCircleCountdown()
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
        let oneQuestionTime = time() * 10
        let time = CGFloat(seconds) / CGFloat(oneQuestionTime)
        let result = round(100 * time) / 100
        shapeLayer.removeAnimation(forKey: "animation")
        shapeLayer.strokeEnd = result
    }
}
// MARK: - Setup images
extension QuizOfFlagsViewController {
    private func setImage(image: String, radius: CGFloat? = nil) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: image)
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = radius ?? 0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
// MARK: - Setup constraints
extension QuizOfFlagsViewController {
    private func setupConstraints() {
        if isCountdown() {
            constraintsTimer()
        }
        setupSquare(subview: buttonback, sizes: 40)
        
        if isFlag() {
            constraintsFlag()
            progressView(layout: imageFlag.bottomAnchor, constant: 30)
        } else {
            constraintsLabel()
            progressView(layout: view.safeAreaLayoutGuide.topAnchor, constant: 140)
        }
        
        NSLayoutConstraint.activate([
            labelNumberQuiz.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            labelNumberQuiz.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 20),
            labelNumberQuiz.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelNumberQuiz.widthAnchor.constraint(equalToConstant: 85)
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
        
        isFlag() ? 
        buttons(subview: stackViewFlag, width: widthButtonFlag(), height: 215) :
        buttons(subview: stackViewLabel, width: widthButtonLabel(), height: heightStackView())
    }
    
    private func constraintsTimer() {
        NSLayoutConstraint.activate([
            labelTimer.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            labelTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func constraintsFlag() {
        let flag = questions.questions[currentQuestion].flag
        widthOfFlagFirst = imageFlag.widthAnchor.constraint(equalToConstant: checkWidthFlag(flag: flag))
        
        imageFlagSpring = NSLayoutConstraint(
            item: imageFlag, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(imageFlagSpring)
        NSLayoutConstraint.activate([
            imageFlag.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            widthOfFlagFirst,
            imageFlag.heightAnchor.constraint(equalToConstant: 168)
        ])
    }
    
    private func constraintsLabel() {
        labelNameSpring = NSLayoutConstraint(
            item: labelCountry, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(labelNameSpring)
        NSLayoutConstraint.activate([
            labelCountry.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            labelCountry.widthAnchor.constraint(equalToConstant: widthButtonLabel())
        ])
    }
    
    private func progressView(layout: NSLayoutYAxisAnchor, constant: CGFloat) {
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: layout, constant: constant),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.heightAnchor.constraint(equalToConstant: radius() * 2)
        ])
    }
    
    private func setupSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    private func buttons(subview: UIView, width: CGFloat, height: CGFloat) {
        stackViewSpring = NSLayoutConstraint(
            item: subview, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(stackViewSpring)
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: labelQuiz.bottomAnchor, constant: 25),
            subview.widthAnchor.constraint(equalToConstant: width),
            subview.heightAnchor.constraint(equalToConstant: height)
        ])
        guard !isFlag() else { return }
        setupImagesButtons()
    }
    
    private func setupImagesButtons() {
        setupImageButtonFirst(image: imageFirst, on: buttonFirst,
                         flag: questions.buttonFirst[currentQuestion].flag)
        setupImageButtonSecond(image: imageSecond, on: buttonSecond,
                         flag: questions.buttonSecond[currentQuestion].flag)
        setupImageButtonThird(image: imageThird, on: buttonThird,
                         flag: questions.buttonThird[currentQuestion].flag)
        setupImageButtonFourth(image: imageFourth, on: buttonFourth,
                         flag: questions.buttonFourth[currentQuestion].flag)
    }
    
    private func setupImageButtonFirst(image: UIImageView, on button: UIButton, flag: String) {
        widthOfFlagFirst = image.widthAnchor.constraint(
            equalToConstant: widthFlag(flag: flag))
        setImageOnButton(layout: widthOfFlagFirst, image: image, button: button)
    }
    
    private func setupImageButtonSecond(image: UIImageView, on button: UIView, flag: String) {
        widthOfFlagSecond = image.widthAnchor.constraint(
            equalToConstant: widthFlag(flag: flag))
        setImageOnButton(layout: widthOfFlagSecond, image: image, button: button)
    }
    
    private func setupImageButtonThird(image: UIImageView, on button: UIView, flag: String) {
        widthOfFlagThird = image.widthAnchor.constraint(
            equalToConstant: widthFlag(flag: flag))
        setImageOnButton(layout: widthOfFlagThird, image: image, button: button)
    }
    
    private func setupImageButtonFourth(image: UIImageView, on button: UIView, flag: String) {
        widthOfFlagFourth = image.widthAnchor.constraint(
            equalToConstant: widthFlag(flag: flag))
        setImageOnButton(layout: widthOfFlagFourth, image: image, button: button)
    }
    
    private func setImageOnButton(layout: NSLayoutConstraint, image: UIImageView, button: UIView) {
        NSLayoutConstraint.activate([
            layout,
            image.heightAnchor.constraint(equalToConstant: setHeight()),
            image.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
    }
    
    private func setWidth() -> CGFloat {
        let buttonWidth = ((view.frame.width - 20) / 2) - 4
        return buttonWidth - 10
    }
    
    private func setHeight() -> CGFloat {
        let buttonHeight = heightStackView() / 2 - 4
        return buttonHeight - 10
    }
    
    private func checkWidthFlag(flag: String) -> CGFloat {
        switch flag {
        case "nepal", "vatican city", "switzerland": return 168
        default: return 280
        }
    }
    
    private func widthFlag(flag: String) -> CGFloat {
        switch flag {
        case "nepal", "vatican city", "switzerland": return setHeight()
        default: return setWidth()
        }
    }
    
    private func radius() -> CGFloat {
        6
    }
    
    private func heightStackView() -> CGFloat {
        235
    }
    
    private func widthButtonFlag() -> CGFloat {
        view.bounds.width - 40
    }
    
    private func widthButtonLabel() -> CGFloat {
        view.bounds.width - 20
    }
    
    private func width() -> CGFloat {
        view.frame.width / 2 + 10
    }
}
// MARK: - QuizOfFlagsViewControllerInput
extension QuizOfFlagsViewController: QuizOfFlagsViewControllerInput {
    func dataToQuizOfFlag(setting: Setting) {
        delegateInput.dataToGameType(setting: setting)
    }
}
