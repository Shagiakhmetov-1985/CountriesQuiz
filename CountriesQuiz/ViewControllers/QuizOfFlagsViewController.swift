//
//  QuizOfFlagsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 09.01.2023.
//

import UIKit

class QuizOfFlagsViewController: UIViewController {
    // MARK: - Setup subviews
    private lazy var buttonGameType: UIButton = {
        let button = setButton(
            image: "arrow.backward",
            action: #selector(backToGameType))
        return button
    }()
    
    private lazy var buttonBackMenu: UIButton = {
        let button = setButton(
            image: "multiply",
            action: #selector(backToMenu))
        return button
    }()
    
    private lazy var labelTimer: UILabel = {
        let label = setLabel(
            title: "\(oneQuestionSeconds())",
            size: 35,
            color: .white)
        return label
    }()
    
    private lazy var imageFlag: UIImageView = {
        var image = setImage(image: questions.questions[currentQuestion].flag)
        return image
    }()
    
    private lazy var labelCountry: UILabel = {
        let label = setLabel(
            title: "\(questions.questions[currentQuestion].name)",
            size: 32,
            color: .white,
            numberOfLines: 0,
            textAlignment: .center)
        return label
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = setProgressView(
            radius: radius(),
            color: .white,
            progress: 0)
        return progressView
    }()
    
    private lazy var labelNumberQuiz: UILabel = {
        let label = setLabel(
            title: "0 / \(mode.countQuestions)",
            size: 23,
            color: .white,
            textAlignment: .center)
        return label
    }()
    
    private lazy var labelQuiz: UILabel = {
        let label = setLabel(
            title: "Выберите правильный ответ",
            size: 23,
            color: .white,
            textAlignment: .center)
        return label
    }()
    
    private lazy var labelDescription: UILabel = {
        let label = setLabel(
            title: "Коснитесь экрана, чтобы продолжить",
            size: 19,
            color: .white,
            textAlignment: .center,
            opacity: 0)
        return label
    }()
    
    private lazy var buttonAnswerFirst: UIButton = {
        let button = checkFlag() ? setButton(
            title: questions.buttonFirst[currentQuestion].name,
            color: .white,
            isEnabled: false,
            tag: 1,
            action: #selector(buttonPress)) :
        setButton(
            image: imageFirst,
            color: .white,
            isEnabled: false,
            tag: 1,
            action: #selector(buttonPress))
        return button
    }()
    
    private lazy var imageFirst: UIImageView = {
        let imageView = setImage(
            image: questions.buttonFirst[currentQuestion].flag,
            radius: 8)
        return imageView
    }()
    
    private lazy var buttonAnswerSecond: UIButton = {
        let button = checkFlag() ? setButton(
            title: questions.buttonSecond[currentQuestion].name,
            color: .white,
            isEnabled: false,
            tag: 2,
            action: #selector(buttonPress)) :
        setButton(
            image: imageSecond,
            color: .white,
            isEnabled: false,
            tag: 2,
            action: #selector(buttonPress))
        return button
    }()
    
    private lazy var imageSecond: UIImageView = {
        let imageView = setImage(
            image: questions.buttonSecond[currentQuestion].flag,
            radius: 8)
        return imageView
    }()
    
    private lazy var buttonAnswerThird: UIButton = {
        let button = checkFlag() ? setButton(
            title: questions.buttonThird[currentQuestion].name,
            color: .white,
            isEnabled: false,
            tag: 3,
            action: #selector(buttonPress)) :
        setButton(
            image: imageThird,
            color: .white,
            isEnabled: false,
            tag: 3,
            action: #selector(buttonPress))
        return button
    }()
    
    private lazy var imageThird: UIImageView = {
        let imageView = setImage(
            image: questions.buttonThird[currentQuestion].flag,
            radius: 8)
        return imageView
    }()
    
    private lazy var buttonAnswerFourth: UIButton = {
        let button = checkFlag() ? setButton(
            title: questions.buttonFourth[currentQuestion].name,
            color: .white,
            isEnabled: false,
            tag: 4,
            action: #selector(buttonPress)) :
        setButton(
            image: imageFourth,
            color: .white,
            isEnabled: false,
            tag: 4,
            action: #selector(buttonPress))
        return button
    }()
    
    private lazy var imageFourth: UIImageView = {
        let imageView = setImage(
            image: questions.buttonFourth[currentQuestion].flag,
            radius: 8)
        return imageView
    }()
    
    private lazy var stackViewFlag: UIStackView = {
        let stackView = setStackViewButtons(
            buttonFirst: buttonAnswerFirst,
            buttonSecond: buttonAnswerSecond,
            buttonThird: buttonAnswerThird,
            buttonFourth: buttonAnswerFourth)
        return stackView
    }()
    
    private lazy var stackViewTop: UIStackView = {
        let stackView = setStackView(
            buttonFirst: buttonAnswerFirst,
            buttonSecond: buttonAnswerSecond)
        return stackView
    }()
    
    private lazy var stackViewBottom: UIStackView = {
        let stackView = setStackView(
            buttonFirst: buttonAnswerThird,
            buttonSecond: buttonAnswerFourth)
        return stackView
    }()
    
    private lazy var stackViewLabel: UIStackView = {
        let stackView = setStackView(
            stackViewTop: stackViewTop,
            stackViewBottom: stackViewBottom)
        return stackView
    }()
    
    var mode: Setting!
    var game: Games!
    
    private var imageFlagSpring: NSLayoutConstraint!
    private var labelNameSpring: NSLayoutConstraint!
    private var stackViewSpring: NSLayoutConstraint!
    
    private var timerFirst = Timer()
    private var timerSecond = Timer()
    private let shapeLayer = CAShapeLayer()
    
    private var currentQuestion = 0
    private var seconds = 0
    private var spendTime: [CGFloat] = []
    private var questions = Countries.getQuestions()
    private var answerSelect = false
    
    private var correctAnswers: [Countries] = []
    private var incorrectAnswers: [Results] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupSubviews()
        setConstraints()
        setupBarButton()
        setupMoveSubviews()
        startHideSubviews()
        startGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if mode.timeElapsed.timeElapsed {
            circularShadow()
            circular(strokeEnd: 0)
            animationTimeReset()
        }
    }
    // MARK: - General methods
    private func setupDesign() {
        view.backgroundColor = game.background
        navigationItem.hidesBackButton = true
    }
    
    private func setupSubviews() {
        if mode.timeElapsed.timeElapsed {
            checkFlag() ? subviewsWithTimerFlag() : subviewsWithTimerLabel()
        } else {
            checkFlag() ? subviewsWithoutTimerFlag() : subviewsWithoutTimerLabel()
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
        let leftBarButton = UIBarButtonItem(customView: buttonGameType)
        let rightBarButton = UIBarButtonItem(customView: buttonBackMenu)
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func checkFlag() -> Bool {
        mode.flag ? true : false
    }
    
    private func startHideSubviews() {
        setupOpacityLabels(labels: labelQuiz, opacity: 0)
    }
    // MARK: - Opacity, hidden and enable subviews
    private func setupOpacityLabels(labels: UILabel..., opacity: Float) {
        labels.forEach { label in
            label.layer.opacity = opacity
        }
    }
    
    private func setupHiddenSubviews(views: UIView..., isHidden: Bool) {
        views.forEach { view in
            view.isHidden = isHidden
        }
    }
    
    private func setupEnabledSubviews(controls: UIControl..., isEnabled: Bool) {
        controls.forEach { control in
            control.isEnabled = isEnabled
        }
    }
    
    private func runTimer(time: CGFloat, action: Selector, repeats: Bool) -> Timer {
        Timer.scheduledTimer(timeInterval: time, target: self, selector: action,
                             userInfo: nil, repeats: repeats)
    }
    // MARK: - Time for label, seconds and circle timer
    private func checkSeconds() {
        if !oneQuestionCheck(), currentQuestion < 1 {
            seconds = oneQuestionSeconds() * 10
        } else if oneQuestionCheck() {
            seconds = oneQuestionSeconds() * 10
        }
    }
    
    private func oneQuestionSeconds() -> Int {
        let seconds: Int
        if oneQuestionCheck() {
            seconds = mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
        } else {
            seconds = mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
        }
        return seconds
    }
    
    private func checkCircleTimeElapsed() -> Int {
        let timer: Int
        if oneQuestionCheck() {
            timer = mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
        } else {
            timer = seconds / 10
        }
        return timer
    }
    
    private func oneQuestionCheck() -> Bool {
        mode.timeElapsed.questionSelect.oneQuestion ? true : false
    }
    // MARK: - Move flag and buttons
    private func setupMoveSubviews() {
        let pointX: CGFloat = currentQuestion > 0 ? 2 : 1
        if checkFlag() {
            imageFlagSpring.constant += view.bounds.width * pointX
        } else {
            labelNameSpring.constant += view.bounds.width * pointX
        }
        stackViewSpring.constant += view.bounds.width * pointX
    }
    // MARK: - Animation move subviews
    private func animationSubviews() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            if self.checkFlag() {
                self.imageFlagSpring.constant -= self.view.bounds.width
            } else {
                self.labelNameSpring.constant -= self.view.bounds.width
            }
            self.stackViewSpring.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }
    }
    // MARK: - Animation label description and label number
    private func showDescription() {
        if currentQuestion == questions.questions.count - 1 {
            let red = UIColor.lightPurplePink
            labelDescription.text = "Коснитесь экрана, чтобы завершить"
            labelDescription.textColor = red
        }
        
        animationShowLabelDescription()
    }
    
    private func animationHideLabelDescription() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
            self.labelQuiz.layer.opacity = 1
        }
        
        labelDescription.layer.opacity = 0
    }
    
    private func animationShowLabelDescription() {
        UIView.animate(withDuration: 0.5, animations: {
            self.labelQuiz.layer.opacity = 0
        })
        
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.labelDescription.layer.opacity = 1
        })
    }
    // MARK: - Start game
    private func startGame() {
        timerFirst = runTimer(time: 1, action: #selector(showSubviews), repeats: false)
        timerSecond = runTimer(time: 1.5, action: #selector(isEnabledButton), repeats: false)
    }
    
    @objc private func showSubviews() {
        timerFirst.invalidate()
        
        setupHiddenSubviews(views: imageFlag, buttonAnswerFirst,
                            buttonAnswerSecond, buttonAnswerThird,
                            buttonAnswerFourth, isHidden: false)
        
        if currentQuestion < 1 {
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) { [self] in
                setupOpacityLabels(labels: labelQuiz, opacity: 1)
            }
        }
        
        animationSubviews()
        if oneQuestionCheck() && mode.timeElapsed.timeElapsed {
            shapeLayer.strokeEnd = 1
        } else if !oneQuestionCheck() && mode.timeElapsed.timeElapsed && currentQuestion < 1 {
            shapeLayer.strokeEnd = 1
        }
    }
    // MARK: - Enable subviews
    @objc private func isEnabledButton() {
        timerSecond.invalidate()
        setupEnabledSubviews(controls: buttonAnswerFirst, buttonAnswerSecond,
                             buttonAnswerThird, buttonAnswerFourth,
                             isEnabled: true)
        setProgressView()
        labelNumberQuiz.text = "\(currentQuestion + 1) / \(mode.countQuestions)"
        
        if mode.timeElapsed.timeElapsed {
            checkSeconds()
            animationTimeElapsed()
            runTimer()
        }
    }
    
    private func setProgressView() {
        let time = TimeInterval(mode.countQuestions)
        let interval = 1 / time
        let progress = progressView.progress + Float(interval)
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.setProgress(progress, animated: true)
        }
    }
    // MARK: - Run timer
    private func runTimer() {
        timerSecond = runTimer(time: 0.1, action: #selector(timeElapsedText), repeats: true)
    }
    
    @objc private func timeElapsedText() {
        seconds -= 1
        if seconds.isMultiple(of: 10) {
            let text = seconds / 10
            labelTimer.text = "\(text)"
        }
        
        if seconds == 0 {
            timerSecond.invalidate()
            timeUp()
        }
    }
    
    private func timeUp() {
        answerSelect.toggle()
        incorrectAnswerTimeUp()
        
        if !oneQuestionCheck() {
            currentQuestion = questions.questions.count - 1
        }
        
        showDescription()
        animationColorDisableButton()
    }
    // MARK: - Buttons back
    @objc private func backToGameType() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func backToMenu() {
        navigationController?.popToRootViewController(animated: true)
    }
    // MARK: - Button action when user select answer
    @objc private func buttonPress(button: UIButton) {
        timerFirst.invalidate()
        timerSecond.invalidate()
        answerSelect.toggle()
        
        animationColorButtons(button: button)
        showDescription()
        
        if mode.timeElapsed.timeElapsed {
            stopAnimationCircleTimer()
        }
        
        if oneQuestionCheck() {
            setTimeSpent()
        } else if !oneQuestionCheck(), currentQuestion + 1 == questions.questions.count {
            setTimeSpent()
        }
    }
    
    private func animationColorDisableButton() {
        if checkFlag() {
            disableButtonFlag(buttons: buttonAnswerFirst, buttonAnswerSecond,
                              buttonAnswerThird, buttonAnswerFourth, tag: 0)
        } else {
            disableButtonLabel(buttons: buttonAnswerFirst, buttonAnswerSecond,
                               buttonAnswerThird, buttonAnswerFourth, tag: 0)
        }
    }
    
    private func animationColorButtons(button: UIButton) {
        if checkFlag() {
            checkAnswerFlag(tag: button.tag, button: button)
            disableButtonFlag(buttons: buttonAnswerFirst, buttonAnswerSecond,
                              buttonAnswerThird, buttonAnswerFourth, tag: button.tag)
        } else {
            checkAnswerLabel(tag: button.tag, button: button)
            disableButtonLabel(buttons: buttonAnswerFirst, buttonAnswerSecond,
                               buttonAnswerThird, buttonAnswerFourth, tag: button.tag)
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
    
    private func setTimeSpent() {
        let circleTimeSpent = 1 - shapeLayer.strokeEnd
        let seconds = oneQuestionSeconds()
        let timeSpent = circleTimeSpent * CGFloat(seconds)
        spendTime.append(timeSpent)
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
        if currentQuestion + 1 < questions.questions.count {
            timerFirst = runTimer(time: 5, action: #selector(hideSubviews), repeats: false)
        }
    }
    // MARK: - Add correct or incorrect answers
    private func checkAnswer(tag: Int) -> Bool {
        switch tag {
        case 1:
            return questions.questions[currentQuestion] == questions.buttonFirst[currentQuestion] ? true : false
        case 2:
            return questions.questions[currentQuestion] == questions.buttonSecond[currentQuestion] ? true : false
        case 3:
            return questions.questions[currentQuestion] == questions.buttonThird[currentQuestion] ? true : false
        default:
            return questions.questions[currentQuestion] == questions.buttonFourth[currentQuestion] ? true : false
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
    private func showNewDataForNextQuestion() {
        if mode.timeElapsed.timeElapsed {
            resetTimer()
        }
        if checkFlag() {
            imageFlag.image = UIImage(named: questions.questions[currentQuestion].flag)
            refreshButtonsFlag()
        } else {
            labelCountry.text = questions.questions[currentQuestion].name
            refreshButtonsLabel()
        }
    }
    
    private func refreshButtonsFlag() {
        buttonAnswerFirst.setTitle(questions.buttonFirst[currentQuestion].name, for: .normal)
        buttonAnswerSecond.setTitle(questions.buttonSecond[currentQuestion].name, for: .normal)
        buttonAnswerThird.setTitle(questions.buttonThird[currentQuestion].name, for: .normal)
        buttonAnswerFourth.setTitle(questions.buttonFourth[currentQuestion].name, for: .normal)
    }
    
    private func refreshButtonsLabel() {
        imageFirst.image = UIImage(named: questions.buttonFirst[currentQuestion].flag)
        imageSecond.image = UIImage(named: questions.buttonSecond[currentQuestion].flag)
        imageThird.image = UIImage(named: questions.buttonThird[currentQuestion].flag)
        imageFourth.image = UIImage(named: questions.buttonFourth[currentQuestion].flag)
    }
    
    private func resetTimer() {
        if oneQuestionCheck() && seconds > 0 {
            resetNumberTimer()
            animationTimeReset()
        } else if oneQuestionCheck() && seconds == 0 {
            resetNumberTimer()
            circular(strokeEnd: 0)
            animationTimeReset()
        }
    }
    
    private func resetNumberTimer() {
        let seconds = mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
        labelTimer.text = "\(seconds)"
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
        timerFirst.invalidate()
        answerSelect.toggle()
        
        animationSubviews()
        timerFirst = runTimer(time: 1, action: #selector(nextQuestion), repeats: false)
    }
    
    @objc private func nextQuestion() {
        timerFirst.invalidate()
        
        currentQuestion += 1
        setupMoveSubviews()
        showNewDataForNextQuestion()
        animationHideLabelDescription()
        resetColorButton(buttons: buttonAnswerFirst, buttonAnswerSecond,
                         buttonAnswerThird, buttonAnswerFourth)
        startGame()
    }
}
// MARK: - Touch on the screen
extension QuizOfFlagsViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if answerSelect {
            if currentQuestion + 1 < questions.questions.count {
                hideSubviews()
            } else {
                let resultsVC = ResultsViewController()
                resultsVC.correctAnswers = correctAnswers
                resultsVC.incorrectAnswers = incorrectAnswers
                resultsVC.mode = mode
                resultsVC.game = game
                resultsVC.spendTime = spendTime
                navigationController?.pushViewController(resultsVC, animated: true)
            }
        }
    }
}
// MARK: - Setup button
extension QuizOfFlagsViewController {
    private func setButton(title: String, color: UIColor, isEnabled: Bool,
                           tag: Int, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.blueBlackSea, for: .normal)
        button.titleLabel?.font = UIFont(name: "mr_fontick", size: 23)
        button.backgroundColor = color
        button.layer.cornerRadius = 12
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.isEnabled = isEnabled
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setButton(image: UIView, color: UIColor, isEnabled: Bool,
                           tag: Int, action: Selector) -> UIButton {
        let button = Button(type: .custom)
        button.backgroundColor = color
        button.layer.cornerRadius = 12
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.isEnabled = isEnabled
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        setupSubviews(subviews: image, on: button)
        return button
    }
    
    private func setButton(image: String, action: Selector) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
// MARK: - Setup label
extension QuizOfFlagsViewController {
    private func setLabel(title: String, size: CGFloat, color: UIColor,
                          numberOfLines: Int? = nil,
                          textAlignment: NSTextAlignment? = nil,
                          opacity: Float? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = color
        label.numberOfLines = numberOfLines ?? 0
        label.textAlignment = textAlignment ?? .natural
        label.layer.opacity = opacity ?? 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup progress view
extension QuizOfFlagsViewController {
    private func setProgressView(radius: CGFloat, color: UIColor, progress: Float) -> UIProgressView {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = radius
        progressView.clipsToBounds = true
        progressView.progressTintColor = color
        progressView.trackTintColor = color.withAlphaComponent(0.3)
        progressView.progress = progress
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }
}
// MARK: - Setup stack views
extension QuizOfFlagsViewController {
    private func setStackView(progressView: UIProgressView, label: UILabel) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [progressView, label])
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackViewButtons(buttonFirst: UIButton,
                                     buttonSecond: UIButton,
                                     buttonThird: UIButton,
                                     buttonFourth: UIButton) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [buttonFirst, buttonSecond, buttonThird, buttonFourth])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackView(buttonFirst: UIButton, buttonSecond: UIButton) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [buttonFirst, buttonSecond])
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackView(stackViewTop: UIStackView,
                              stackViewBottom: UIStackView) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [stackViewTop, stackViewBottom])
        stackView.spacing = 8
        stackView.axis = .vertical
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
    
    private func animationTimeElapsed() {
        let timer = checkCircleTimeElapsed()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 0
        animation.duration = CFTimeInterval(timer)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
    
    private func animationTimeReset() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = CFTimeInterval(0.4)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
    
    private func stopAnimationCircleTimer() {
        let oneQuestionTime = oneQuestionSeconds() * 10
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
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = radius ?? 0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func setImage(image: String, color: UIColor, size: CGFloat) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: size)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
// MARK: - Setup constraints
extension QuizOfFlagsViewController {
    private func setConstraints() {
        if mode.timeElapsed.timeElapsed {
            constraintsTimer()
        }
        
        setupSquare(subview: buttonGameType, sizes: 40)
        setupSquare(subview: buttonBackMenu, sizes: 40)
        
        if checkFlag() {
            constraintsFlag()
            constraintsProgressViewFlag()
        } else {
            constraintsLabel()
            constraintsProgressViewLabel()
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
        
        if checkFlag() {
            constraintsButtonsFlag()
        } else {
            constraintsButtonsLabel()
        }
    }
    
    private func constraintsTimer() {
        NSLayoutConstraint.activate([
            labelTimer.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            labelTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func constraintsFlag() {
        imageFlagSpring = NSLayoutConstraint(
            item: imageFlag, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(imageFlagSpring)
        NSLayoutConstraint.activate([
            imageFlag.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            imageFlag.widthAnchor.constraint(equalToConstant: 300),
            imageFlag.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func constraintsLabel() {
        labelNameSpring = NSLayoutConstraint(
            item: labelCountry, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(labelNameSpring)
        NSLayoutConstraint.activate([
            labelCountry.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            labelCountry.widthAnchor.constraint(equalToConstant: setupConstraintLabel())
        ])
    }
    
    private func constraintsProgressViewFlag() {
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: imageFlag.bottomAnchor, constant: 30),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.heightAnchor.constraint(equalToConstant: radius() * 2)
        ])
    }
    
    private func constraintsProgressViewLabel() {
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140),
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
    
    private func constraintsButtonsFlag() {
        stackViewSpring = NSLayoutConstraint(
            item: stackViewFlag, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(stackViewSpring)
        NSLayoutConstraint.activate([
            stackViewFlag.topAnchor.constraint(equalTo: labelQuiz.bottomAnchor, constant: 25),
            stackViewFlag.widthAnchor.constraint(equalToConstant: setupConstraintFlag()),
            stackViewFlag.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func constraintsButtonsLabel() {
        stackViewSpring = NSLayoutConstraint(
            item: stackViewLabel, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(stackViewSpring)
        NSLayoutConstraint.activate([
            stackViewLabel.topAnchor.constraint(equalTo: labelQuiz.bottomAnchor, constant: 25),
            stackViewLabel.widthAnchor.constraint(equalToConstant: setupConstraintLabel()),
            stackViewLabel.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        setupImageButton(image: imageFirst, on: buttonAnswerFirst)
        setupImageButton(image: imageSecond, on: buttonAnswerSecond)
        setupImageButton(image: imageThird, on: buttonAnswerThird)
        setupImageButton(image: imageFourth, on: buttonAnswerFourth)
    }
    
    private func setupImageButton(image: UIView, on button: UIView) {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: button.topAnchor, constant: 5),
            image.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 5),
            image.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -5),
            image.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -5)
        ])
    }
    
    private func radius() -> CGFloat {
        6
    }
    
    private func setupConstraintFlag() -> CGFloat {
        view.bounds.width - 40
    }
    
    private func setupConstraintLabel() -> CGFloat {
        view.bounds.width - 20
    }
    
    private func width() -> CGFloat {
        view.frame.width / 2 + 10
    }
}
