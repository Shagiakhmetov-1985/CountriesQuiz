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

class QuestionnaireViewController: UIViewController {
    private lazy var buttonExit: UIButton = {
        setButton(image: "multiply", action: #selector(exitToGameType))
    }()
    
    private lazy var labelTimer: UILabel = {
        setupLabel(title: "\(allQuestionTime())", size: 35)
    }()
    
    private lazy var imageFlag: UIImageView = {
        setupImage(image: questions.questions[currentQuestion].flag)
    }()
    
    private lazy var labelCountry: UILabel = {
        setupLabel(title: questions.questions[currentQuestion].name, size: 32)
    }()
    
    private lazy var buttonBack: UIButton = {
        setButton(image: "chevron.left", action: #selector(back), isEnabled: false, opacity: 0)
    }()
    
    private lazy var buttonForward: UIButton = {
        setButton(image: "chevron.right", action: #selector(forward), isEnabled: false, opacity: 0)
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
    
    private lazy var labelNumber: UILabel = {
        setupLabel(title: "0 / \(mode.countQuestions)", size: 23)
    }()
    
    private lazy var labelQuiz: UILabel = {
        setupLabel(title: "Выберите правильные ответы", size: 23, opacity: 0)
    }()
    
    private lazy var labelDescription: UILabel = {
        setupLabel(
            title: "Коснитесь экрана, чтобы завершить",
            size: 19,
            color: .lightPurplePink,
            opacity: 0)
    }()
    
    private lazy var buttonFirst: UIButton = {
        isFlag() ? setButton(
            checkmark: checkmarkFirst,
            label: labelFirst,
            tag: 1,
            action: #selector(buttonPress)) :
        setButton(
            checkmark: checkmarkFirst,
            flag: imageFirst,
            tag: 1,
            action: #selector(buttonPress))
    }()
    
    private lazy var checkmarkFirst: UIImageView = {
        setupCheckmark(image: "circle", tag: 1)
    }()
    
    private lazy var labelFirst: UILabel = {
        setupLabel(
            title: questions.buttonFirst[currentQuestion].name,
            size: 23,
            tag: 1)
    }()
    
    private lazy var imageFirst: UIImageView = {
        setupImage(image: questions.buttonFirst[currentQuestion].flag, radius: 8)
    }()
    
    private lazy var buttonSecond: UIButton = {
        isFlag() ? setButton(
            checkmark: checkmarkSecond,
            label: labelSecond,
            tag: 2,
            action: #selector(buttonPress)) :
        setButton(
            checkmark: checkmarkSecond,
            flag: imageSecond,
            tag: 2,
            action: #selector(buttonPress))
    }()
    
    private lazy var checkmarkSecond: UIImageView = {
        setupCheckmark(image: "circle", tag: 2)
    }()
    
    private lazy var labelSecond: UILabel = {
        setupLabel(
            title: questions.buttonSecond[currentQuestion].name,
            size: 23,
            tag: 2)
    }()
    
    private lazy var imageSecond: UIImageView = {
        setupImage(image: questions.buttonSecond[currentQuestion].flag, radius: 8)
    }()
    
    private lazy var buttonThird: UIButton = {
        isFlag() ? setButton(
            checkmark: checkmarkThird,
            label: labelThird,
            tag: 3,
            action: #selector(buttonPress)) :
        setButton(
            checkmark: checkmarkThird,
            flag: imageThird,
            tag: 3,
            action: #selector(buttonPress))
    }()
    
    private lazy var checkmarkThird: UIImageView = {
        setupCheckmark(image: "circle", tag: 3)
    }()
    
    private lazy var labelThird: UILabel = {
        setupLabel(
            title: questions.buttonThird[currentQuestion].name,
            size: 23,
            tag: 3)
    }()
    
    private lazy var imageThird: UIImageView = {
        setupImage(image: questions.buttonThird[currentQuestion].flag, radius: 8)
    }()
    
    private lazy var buttonFourth: UIButton = {
        isFlag() ? setButton(
            checkmark: checkmarkFourth,
            label: labelFourth,
            tag: 4,
            action: #selector(buttonPress)) :
        setButton(
            checkmark: checkmarkFourth,
            flag: imageFourth,
            tag: 4,
            action: #selector(buttonPress))
    }()
    
    private lazy var checkmarkFourth: UIImageView = {
        setupCheckmark(image: "circle", tag: 4)
    }()
    
    private lazy var labelFourth: UILabel = {
        setupLabel(
            title: questions.buttonFourth[currentQuestion].name,
            size: 23,
            tag: 4)
    }()
    
    private lazy var imageFourth: UIImageView = {
        setupImage(image: questions.buttonFourth[currentQuestion].flag, radius: 8)
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
        setupStackView(buttonFirst: buttonFirst, buttonSecond: buttonSecond)
    }()
    
    private lazy var stackViewBottom: UIStackView = {
        setupStackView(buttonFirst: buttonThird, buttonSecond: buttonFourth)
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
    private var countdown = Timer()
    private var questions: (questions: [Countries], buttonFirst: [Countries],
                            buttonSecond: [Countries], buttonThird: [Countries],
                            buttonFourth: [Countries])!
    private var shapeLayer = CAShapeLayer()
    private var lastQuestion = false
    
    private var currentQuestion = 0
    private var numberQuestion = 0
    private var seconds = 0
    
    private var correctAnswers: [Countries] = []
    private var incorrectAnswers: [Results] = []
    private var spendTime: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupDesign()
        setupBarButton()
        setupSubviews()
        setupConstraints()
        moveSubviews()
        startGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupCircles()
    }
    // MARK: - General methods
    private func setupData() {
        questions = Countries.getQuestions(mode: mode)
    }
    
    private func setupDesign() {
        view.backgroundColor = game.background
        navigationItem.hidesBackButton = true
    }
    
    private func setupBarButton() {
        let leftBarButton = UIBarButtonItem(customView: buttonExit)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func setupSubviews() {
        if isCountdown() {
            isFlag() ? subviewsWithTimerFlag() : subviewsWithTimerLabel()
        } else {
            isFlag() ? subviewsWithoutTimerFlag() : subviewsWithoutTimerLabel()
        }
    }
    
    private func subviewsWithTimerFlag() {
        setupSubviews(subviews: labelTimer, imageFlag, buttonBack,
                      buttonForward, progressView, labelNumber, labelQuiz,
                      labelDescription, stackViewFlag, on: view)
    }
    
    private func subviewsWithTimerLabel() {
        setupSubviews(subviews: labelTimer, labelCountry, buttonBack,
                      buttonForward, progressView, labelNumber, labelQuiz,
                      labelDescription, stackViewLabel, on: view)
    }
    
    private func subviewsWithoutTimerFlag() {
        setupSubviews(subviews: imageFlag, buttonBack, buttonForward,
                      progressView, labelNumber, labelQuiz, labelDescription,
                      stackViewFlag, on: view)
    }
    
    private func subviewsWithoutTimerLabel() {
        setupSubviews(subviews: labelCountry, buttonBack, buttonForward,
                      progressView, labelNumber, labelQuiz, labelDescription,
                      stackViewLabel, on: view)
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    private func setupOpacity(subviews: UIView..., opacity: Float) {
        subviews.forEach { subview in
            subview.layer.opacity = opacity
        }
    }
    
    private func setupIsEnabled(subviews: UIControl..., isEnabled: Bool) {
        subviews.forEach { subview in
            subview.isEnabled = isEnabled
        }
    }
    
    private func isCountdown() -> Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    
    private func isFlag() -> Bool {
        mode.flag ? true : false
    }
    
    private func allQuestionTime() -> Int {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
    }
    
    private func runTimer(duration: CGFloat, action: Selector, repeats: Bool) -> Timer {
        Timer.scheduledTimer(timeInterval: duration, target: self,
                             selector: action, userInfo: nil, repeats: repeats)
    }
    
    private func buttonsIsEnabled(bool: Bool) {
        setupIsEnabled(subviews: buttonFirst, buttonSecond,
                       buttonThird, buttonFourth, isEnabled: bool)
    }
    
    private func checkLastQuestion() {
        guard !(currentQuestion + 1 == mode.countQuestions) else { return }
        setupIsEnabled(subviews: buttonBack, buttonForward, isEnabled: false)
    }
    
    private func checkCurrentQuestion() -> Int {
        numberQuestion == currentQuestion ? currentQuestion : numberQuestion
    }
    
    private func setProgressView() {
        let interval: Float = 1 / Float(mode.countQuestions)
        let progress = progressView.progress + interval
        
        UIView.animate(withDuration: 0.5) { 
            self.progressView.setProgress(progress, animated: true)
        }
    }
    
    private func setupCircles() {
        guard isCountdown() else { return }
        circleShadow()
        circle(strokeEnd: 0)
        animationCircleTimeReset()
    }
    // MARK: - Run timer
    private func runTimer() {
        let timeMode = allQuestionTime()
        seconds = timeMode * 10
        countdown = runTimer(duration: 0.1, action: #selector(runCountdown), repeats: true)
    }
    
    @objc private func runCountdown() {
        seconds -= 1
        
        guard seconds.isMultiple(of: 10) else { return }
        let text = seconds / 10
        labelTimer.text = "\(text)"
        
        guard seconds == 0 else { return }
        timeUp()
    }
    
    private func timeUp() {
        countdown.invalidate()
        setupIsEnabled(subviews: buttonBack, buttonForward, buttonExit, isEnabled: false)
        buttonsIsEnabled(bool: false)
        endGame()
    }
    
    private func endGame() {
        labelDescription.text = "Время вышло! Коснитесь экрана, чтобы завершить"
        showFinishLabel()
        lastQuestion = true
    }
    // MARK: - Move flags and buttons
    private func moveSubviews() {
        let pointX: CGFloat = currentQuestion > 0 ? 2 : 1
        if isFlag() {
            imageFlagSpring.constant += view.frame.width * pointX
        } else {
            labelNameSpring.constant += view.frame.width * pointX
        }
        stackViewSpring.constant += view.frame.width * pointX
    }
    
    private func moveBackSubviews() {
        if isFlag() {
            imageFlagSpring.constant -= view.frame.width * 2
        } else {
            labelNameSpring.constant -= view.frame.width * 2
        }
        stackViewSpring.constant -= view.frame.width * 2
    }
    // MARK: - Animations label quiz and description
    private func labelAnimation(label: UILabel, duration: CGFloat, opacity: Float) {
        UIView.animate(withDuration: duration) { [self] in
            setupOpacity(subviews: label, opacity: opacity)
        }
    }
    
    private func labelDescriptionAnimation() {
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: { [self] in
            setupOpacity(subviews: labelDescription, opacity: 1)
        })
    }
    
    private func showFinishLabel() {
        labelAnimation(label: labelQuiz, duration: 0.5, opacity: 0)
        labelDescriptionAnimation()
    }
    // MARK: - Animations flags and buttons
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
    
    private func animationBackSubviews() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) { [self] in
            if isFlag() {
                imageFlagSpring.constant += view.bounds.width
            } else {
                labelNameSpring.constant += view.bounds.width
            }
            stackViewSpring.constant += view.bounds.width
            view.layoutIfNeeded()
        }
    }
    // MARK: - Save data for select answer by user
    private func select(button: UIButton) {
        guard !checkSelect(tag: button.tag) else { return }
        
        let question = checkCurrentQuestion()
        var tag = 0
        while tag < 4 {
            tag += 1
            if !(tag == button.tag) {
                selectIsEnabled(tag: tag, bool: false, currentQuestion: question)
            }
        }
        selectIsEnabled(tag: button.tag, bool: true, currentQuestion: question)
        checkCorrectAnswer(tag: button.tag)
    }
    
    private func checkSelect(tag: Int) -> Bool {
        switch tag {
        case 1: return questions.buttonFirst[numberQuestion].select
        case 2: return questions.buttonSecond[numberQuestion].select
        case 3: return questions.buttonThird[numberQuestion].select
        default: return questions.buttonFourth[numberQuestion].select
        }
    }
    
    private func selectIsEnabled(tag: Int, bool: Bool, currentQuestion: Int) {
        switch tag {
        case 1: questions.buttonFirst[currentQuestion].select = bool
        case 2: questions.buttonSecond[currentQuestion].select = bool
        case 3: questions.buttonThird[currentQuestion].select = bool
        default: questions.buttonFourth[currentQuestion].select = bool
        }
    }
    // MARK: - Animations buttons when user press button
    private func buttonSelect(button: UIButton) {
        let tag = button.tag
        setupButtonsDisabled(tag: tag)
        buttonIsEnabled(button: button, color: .white)
    }
    
    private func imageSelect(image: UIImageView) {
        let tag = image.tag
        setupCheckmarksDisabled(tag: tag)
        imageIsEnabled(image: image, color: .greenHarlequin, symbol: "checkmark.circle.fill")
    }
    
    private func labelSelect(label: UILabel) {
        let tag = label.tag
        setupLabelsDisabled(tag: tag)
        labelIsEnabled(label: label, color: .greenHarlequin)
    }
    
    private func setupButtonsDisabled(tag: Int) {
        selectButtonsDisabled(buttons: buttonFirst, buttonSecond,
                              buttonThird, buttonFourth, tag: tag)
    }
    
    private func selectButtonsDisabled(buttons: UIButton..., tag: Int) {
        buttons.forEach { button in
            if !(button.tag == tag) {
                buttonIsEnabled(button: button, color: .clear)
            }
        }
    }
    
    private func setupCheckmarksDisabled(tag: Int) {
        selectImagesDisabled(images: checkmarkFirst, checkmarkSecond,
                             checkmarkThird, checkmarkFourth, tag: tag)
    }
    
    private func selectImagesDisabled(images: UIImageView..., tag: Int) {
        images.forEach { image in
            if !(image.tag == tag) {
                imageIsEnabled(image: image, color: .white, symbol: "circle")
            }
        }
    }
    
    private func setupLabelsDisabled(tag: Int) {
        selectLabelsDisabled(labels: labelFirst, labelSecond,
                             labelThird, labelFourth, tag: tag)
    }
    
    private func selectLabelsDisabled(labels: UILabel..., tag: Int) {
        labels.forEach { label in
            if !(label.tag == tag) {
                labelIsEnabled(label: label, color: .white)
            }
        }
    }
    
    private func buttonIsEnabled(button: UIButton, color: UIColor) {
        UIView.animate(withDuration: 0.3) {
            button.backgroundColor = color
        }
    }
    
    private func imageIsEnabled(image: UIImageView, color: UIColor, symbol: String) {
        UIView.animate(withDuration: 0.3) {
            let size = UIImage.SymbolConfiguration(pointSize: 30)
            image.tintColor = color
            image.image = UIImage(systemName: symbol, withConfiguration: size)
        }
    }
    
    private func labelIsEnabled(label: UILabel, color: UIColor) {
        UIView.animate(withDuration: 0.3) {
            label.textColor = color
        }
    }
    // MARK: - Refresh data for show next question
    private func updateData() {
        updateDataFlagLabel()
        updateNumberQuestion()
        
        setupCheckmarksDisabled(tag: 0)
        setupButtonsDisabled(tag: 0)
        if isFlag() {
            setupLabelsDisabled(tag: 0)
        }
        
        checkSelect(selects: questions.buttonFirst[numberQuestion].select,
                    questions.buttonSecond[numberQuestion].select,
                    questions.buttonThird[numberQuestion].select,
                    questions.buttonFourth[numberQuestion].select)
    }
    
    private func checkSelect(selects: Bool...) {
        var tag = 1
        selects.forEach { select in
            if select {
                tagSelect(tag: tag)
            }
            tag += 1
        }
    }
    
    private func tagSelect(tag: Int) {
        switch tag {
        case 1: setupSelect(button: buttonFirst, image: checkmarkFirst,
                            label: isFlag() ? labelFirst : nil)
        case 2: setupSelect(button: buttonSecond, image: checkmarkSecond,
                            label: isFlag() ? labelSecond : nil)
        case 3: setupSelect(button: buttonThird, image: checkmarkThird,
                            label: isFlag() ? labelThird : nil)
        default: setupSelect(button: buttonFourth, image: checkmarkFourth,
                             label: isFlag() ? labelFourth : nil)
        }
    }
    
    private func setupSelect(button: UIButton, image: UIImageView, label: UILabel? = nil) {
        buttonSelect(button: button)
        imageSelect(image: image)
        if let label = label {
            labelSelect(label: label)
        }
    }
    
    private func updateDataFlagLabel() {
        let number = checkCurrentQuestion()
        if isFlag() {
            let flag = questions.questions[number].flag
            imageFlag.image = UIImage(named: flag)
            widthOfFlagFirst.constant = checkWidthFlag(flag: flag)
            updateLabels()
        } else {
            labelCountry.text = questions.questions[number].name
            updateImages()
            updateWidthFlag()
        }
    }
    
    private func updateNumberQuestion() {
        let number = checkCurrentQuestion()
        labelNumber.text = "\(number + 1) / \(mode.countQuestions)"
    }
    
    private func updateLabels() {
        let number = checkCurrentQuestion()
        labelFirst.text = questions.buttonFirst[number].name
        labelSecond.text = questions.buttonSecond[number].name
        labelThird.text = questions.buttonThird[number].name
        labelFourth.text = questions.buttonFourth[number].name
    }
    
    private func updateImages() {
        let number = checkCurrentQuestion()
        imageFirst.image = UIImage(named: questions.buttonFirst[number].flag)
        imageSecond.image = UIImage(named: questions.buttonSecond[number].flag)
        imageThird.image = UIImage(named: questions.buttonThird[number].flag)
        imageFourth.image = UIImage(named: questions.buttonFourth[number].flag)
    }
    
    private func updateWidthFlag() {
        let number = checkCurrentQuestion()
        widthOfFlagFirst.constant = widthFlag(flag: questions.buttonFirst[number].flag)
        widthOfFlagSecond.constant = widthFlag(flag: questions.buttonSecond[number].flag)
        widthOfFlagThird.constant = widthFlag(flag: questions.buttonThird[number].flag)
        widthOfFlagFourth.constant = widthFlag(flag: questions.buttonFourth[number].flag)
    }
    // MARK: - Show of hide buttons back and forward
    private func buttonsBackForward(buttonBack: UIButton, buttonForward: UIButton,
                                    opacityBack: Float, opacityForward: Float,
                                    isEnabledBack: Bool, isEnabledForward: Bool) {
        UIView.animate(withDuration: 0.3) { [self] in
            setupOpacity(subviews: buttonBack, opacity: opacityBack)
            setupOpacity(subviews: buttonForward, opacity: opacityForward)
        }
        setupIsEnabled(subviews: buttonBack, isEnabled: isEnabledBack)
        setupIsEnabled(subviews: buttonForward, isEnabled: isEnabledForward)
    }
    // MARK: - Check answer, select correct or incorrect answer by user
    private func checkCorrectAnswer(tag: Int) {
        if checkAnswer(tag: tag) {
            correctAnswer()
            deleteIncorrectAnswer()
        } else {
            incorrectAnswer(tag: tag)
            deleteCorrectAnswer()
        }
    }
    
    private func checkAnswer(tag: Int) -> Bool {
        switch tag {
        case 1:
            return questions.questions[numberQuestion].flag ==
            questions.buttonFirst[numberQuestion].flag ? true : false
        case 2:
            return questions.questions[numberQuestion].flag ==
            questions.buttonSecond[numberQuestion].flag ? true : false
        case 3:
            return questions.questions[numberQuestion].flag ==
            questions.buttonThird[numberQuestion].flag ? true : false
        default:
            return questions.questions[numberQuestion].flag ==
            questions.buttonFourth[numberQuestion].flag ? true : false
        }
    }
    
    private func deleteCorrectAnswer() {
        guard !correctAnswers.isEmpty else { return }
        let question = questions.questions[numberQuestion]
        guard let index = correctAnswers.firstIndex(of: question) else { return }
        correctAnswers.remove(at: index)
    }
    
    private func correctAnswer() {
        correctAnswers.append(questions.questions[numberQuestion])
    }
    
    private func deleteIncorrectAnswer() {
        guard !incorrectAnswers.isEmpty else { return }
        let topics = incorrectAnswers.map({ $0.question })
        let question = questions.questions[numberQuestion]
        guard let index = topics.firstIndex(of: question) else { return }
        incorrectAnswers.remove(at: index)
    }
    
    private func incorrectAnswer(tag: Int) {
        incorrectAnswer(numberQuestion: numberQuestion + 1, tag: tag,
                        question: questions.questions[numberQuestion],
                        buttonFirst: questions.buttonFirst[numberQuestion],
                        buttonSecond: questions.buttonSecond[numberQuestion],
                        buttonThird: questions.buttonThird[numberQuestion],
                        buttonFourth: questions.buttonFourth[numberQuestion],
                        timeUp: false)
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
    // MARK: - Business logic
    @objc private func exitToGameType() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func back() {
        buttonsIsEnabled(bool: false)
        setupIsEnabled(subviews: buttonBack, buttonForward, isEnabled: false)
        animationBackSubviews()
        timer = runTimer(duration: 0.25, action: #selector(updateBackQuestion), repeats: false)
    }
    
    @objc private func forward() {
        buttonsIsEnabled(bool: false)
        setupIsEnabled(subviews: buttonBack, buttonForward, isEnabled: false)
        runAnimationSubviews()
    }
    // MARK: - Start game
    private func startGame() {
        let time = currentQuestion > 0 ? 0.1 : 1
        timer = runTimer(duration: time, action: #selector(showSubviews), repeats: false)
    }
    
    @objc private func showSubviews() {
        timer.invalidate()
        showLabelQuiz()
        let duration = currentQuestion == 0 ? 0.5 : 0.25
        let action = checkAction()
        animationSubviews(duration: duration)
        timer = runTimer(duration: duration, action: action, repeats: false)
    }
    
    private func showLabelQuiz() {
        guard currentQuestion == 0 else { return }
        labelAnimation(label: labelQuiz, duration: 1, opacity: 1)
    }
    
    private func checkAction() -> Selector {
        currentQuestion == 0 ? #selector(isEnabledSubviews) : #selector(nextQuestion)
    }
    
    @objc private func isEnabledSubviews() {
        timer.invalidate()
        buttonsIsEnabled(bool: true)
        updateNumberQuestion()
        
        runTimer()
        shapeLayer.strokeEnd = 1
        animationCircleCountdown()
    }
    // MARK: - Actions for press button
    @objc private func buttonPress(button: UIButton) {
        switch button {
        case buttonFirst: action(button: buttonFirst, image: checkmarkFirst,
                                 label: isFlag() ? labelFirst : nil)
        case buttonSecond: action(button: buttonSecond, image: checkmarkSecond,
                                  label: isFlag() ? labelSecond : nil)
        case buttonThird: action(button: buttonThird, image: checkmarkThird,
                                 label: isFlag() ? labelThird : nil)
        default: action(button: buttonFourth, image: checkmarkFourth,
                        label: isFlag() ? labelFourth : nil)
        }
        setupNextQuestion()
    }
    
    private func action(button: UIButton, image: UIImageView, label: UILabel? = nil) {
        select(button: button)
        setupSelect(button: button, image: image, label: label)
        
        buttonsIsEnabled(bool: false)
        checkLastQuestion()
        
        guard numberQuestion == currentQuestion else { return }
        setProgressView()
    }
    // MARK: - Run for show next question
    private func setupNextQuestion() {
        if numberQuestion + 1 < mode.countQuestions {
            timer = runTimer(duration: 0.7, action: #selector(hideQuestion), repeats: false)
        } else {
            finishQuestionnaire()
        }
    }
    
    @objc private func hideQuestion() {
        timer.invalidate()
        runAnimationSubviews()
    }
    
    private func runAnimationSubviews() {
        animationSubviews(duration: 0.25)
        timer = runTimer(duration: 0.25, action: #selector(updateQuestion), repeats: false)
    }
    
    @objc private func updateQuestion() {
        timer.invalidate()
        if numberQuestion == currentQuestion {
            currentQuestion += 1
            numberQuestion += 1
        } else {
            numberQuestion += 1
        }
        moveSubviews()
        updateData()
        startGame()
    }
    
    @objc private func nextQuestion() {
        timer.invalidate()
        buttonsForwardBackOnOff()
        checkFinish()
        seconds > 0 ? buttonsIsEnabled(bool: true) : timeUp()
    }
    // MARK: - Show prevoius question
    @objc private func updateBackQuestion() {
        timer.invalidate()
        numberQuestion -= 1
        if lastQuestion {
            labelAnimation(label: labelDescription, duration: 0, opacity: 0)
            labelAnimation(label: labelQuiz, duration: 1, opacity: 1)
        }
        moveBackSubviews()
        updateData()
        timer = runTimer(duration: 0.1, action: #selector(showBackQuestion), repeats: false)
    }
    
    @objc private func showBackQuestion() {
        timer.invalidate()
        animationBackSubviews()
        timer = runTimer(duration: 0.25, action: #selector(nextQuestion), repeats: false)
    }
    // MARK: - Show or hide buttons back and forward
    private func buttonsForwardBackOnOff() {
        if numberQuestion == currentQuestion {
            buttonsBackForward(buttonBack: buttonBack, buttonForward: buttonForward,
                               opacityBack: 1, opacityForward: 0,
                               isEnabledBack: true, isEnabledForward: false)
        } else if numberQuestion > 0, numberQuestion < currentQuestion {
            buttonsBackForward(buttonBack: buttonBack, buttonForward: buttonForward,
                               opacityBack: 1, opacityForward: 1,
                               isEnabledBack: true, isEnabledForward: true)
        } else {
            buttonsBackForward(buttonBack: buttonBack, buttonForward: buttonForward,
                               opacityBack: 0, opacityForward: 1,
                               isEnabledBack: false, isEnabledForward: true)
        }
    }
    // MARK: - Finish game
    private func checkFinish() {
        guard lastQuestion, numberQuestion == currentQuestion else { return }
        showFinishLabel()
    }
    
    private func finishQuestionnaire() {
        lastQuestion = true
        showFinishLabel()
    }
}
// MARK: - Touches began
extension QuestionnaireViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard lastQuestion, numberQuestion == currentQuestion else { return }
        stopTimer()
        checkTimeSpent()
        resultsVC()
    }
    
    private func stopTimer() {
        guard seconds > 0 else { return }
        countdown.invalidate()
        let time = mode.timeElapsed.questionSelect.questionTime.allQuestionsTime * 10
        let timeSpent = CGFloat(seconds) / CGFloat(time)
        let strokeEnd = round(timeSpent * 100) / 100
        shapeLayer.strokeEnd = strokeEnd
    }
    
    private func checkTimeSpent() {
        guard seconds > 0 else { return }
        let circleTimeSpent = 1 - shapeLayer.strokeEnd
        let time = mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
        let timeSpent = circleTimeSpent * CGFloat(time)
        spendTime.append(timeSpent)
    }
    
    private func resultsVC() {
//        let resultsVC = ResultsViewController()
//        resultsVC.mode = mode
//        resultsVC.game = game
//        resultsVC.correctAnswers = correctAnswers
//        resultsVC.incorrectAnswers = incorrectAnswers
//        resultsVC.spendTime = spendTime
//        resultsVC.delegateQuestionnaire = self
//        navigationController?.pushViewController(resultsVC, animated: true)
    }
}
// MARK: - Setup buttons
extension QuestionnaireViewController {
    private func setButton(image: String, action: Selector, isEnabled: Bool? = nil, 
                           opacity: Float? = nil) -> UIButton {
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
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setButton(checkmark: UIImageView, label: UILabel, tag: Int,
                           action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 12
        button.tag = tag
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        setupSubviews(subviews: checkmark, label, on: button)
        return button
    }
    
    private func setButton(checkmark: UIImageView, flag: UIImageView, tag: Int,
                           action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 12
        button.tag = tag
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        setupSubviews(subviews: checkmark, flag, on: button)
        return button
    }
}
// MARK: - Setup label
extension QuestionnaireViewController {
    private func setupLabel(title: String, size: CGFloat, color: UIColor? = nil,
                            tag: Int? = nil, opacity: Float? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textAlignment = .center
        label.textColor = color ?? .white
        label.numberOfLines = 0
        label.tag = tag ?? 0
        label.layer.opacity = opacity ?? 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup circle timer
extension QuestionnaireViewController {
    private func circleShadow() {
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
    
    private func circle(strokeEnd: CGFloat) {
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
    
    private func animationCircleCountdown() {
        let timer = allQuestionTime()
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
}
// MARK: - Setup image view
extension QuestionnaireViewController {
    private func setupImage(image: String, radius: CGFloat? = nil) -> UIImageView {
        let image = UIImage(named: image)
        let imageView = UIImageView(image: image)
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = radius ?? 0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func setupCheckmark(image: String, tag: Int) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.tag = tag
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        setupSquare(subview: buttonExit, sizes: 40)
        
        if isCountdown() {
            constraintsTimer()
        }
        
        if isFlag() {
            constraintsQuestionFlag()
            constraintsProgressView(layout: imageFlag.bottomAnchor, constant: 30)
        } else {
            constraintsQuestionLabel()
            constraintsProgressView(layout: view.safeAreaLayoutGuide.topAnchor,
                                    constant: 140)
        }
        
        constraintsButtons(button: buttonBack, constant: -setConstant())
        constraintsButtons(button: buttonForward, constant: setConstant())
        
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
        
        stackViewSpring = NSLayoutConstraint(
            item: checkStackView(),
            attribute: .centerX, relatedBy: .equal, toItem: view,
            attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(stackViewSpring)
        NSLayoutConstraint.activate([
            checkStackView().topAnchor.constraint(equalTo: labelQuiz.bottomAnchor, constant: 25),
            checkStackView().widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            checkStackView().heightAnchor.constraint(equalToConstant: height())
        ])
        constraintsOnButton()
    }
    
    private func constraintsTimer() {
        NSLayoutConstraint.activate([
            labelTimer.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            labelTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func constraintsQuestionFlag() {
        let flag = questions.questions[numberQuestion].flag
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
    
    private func constraintsQuestionLabel() {
        labelNameSpring = NSLayoutConstraint(
            item: labelCountry, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(labelNameSpring)
        NSLayoutConstraint.activate([
            labelCountry.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            labelCountry.widthAnchor.constraint(equalToConstant: setupConstraintLabel())
        ])
    }
    
    private func constraintsProgressView(layout: NSLayoutYAxisAnchor, constant: CGFloat) {
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
    
    private func constraintsButtons(button: UIButton, constant: CGFloat) {
        let layout = layoutConstraint()
        NSLayoutConstraint.activate([
            layoutYAxisAnchor(button: button).constraint(equalTo: layout),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant)
        ])
        setupSquare(subview: button, sizes: 40)
    }
    
    private func layoutYAxisAnchor(button: UIButton) -> NSLayoutYAxisAnchor {
        isFlag() ? button.centerYAnchor : button.topAnchor
    }
    
    private func layoutConstraint() -> NSLayoutYAxisAnchor {
        isFlag() ? imageFlag.centerYAnchor : labelCountry.topAnchor
    }
    
    private func constraintsOnButton() {
        if isFlag() {
            constraintsOnButton(image: checkmarkFirst, label: labelFirst, button: buttonFirst)
            constraintsOnButton(image: checkmarkSecond, label: labelSecond, button: buttonSecond)
            constraintsOnButton(image: checkmarkThird, label: labelThird, button: buttonThird)
            constraintsOnButton(image: checkmarkFourth, label: labelFourth, button: buttonFourth)
        } else {
            imagesOnButtonFirst(checkmark: checkmarkFirst, image: imageFirst,
                                button: buttonFirst, flag: questions.buttonFirst[numberQuestion].flag)
            imagesOnButtonSecond(checkmark: checkmarkSecond, image: imageSecond,
                                 button: buttonSecond, flag: questions.buttonSecond[numberQuestion].flag)
            imagesOnButtonThird(checkmark: checkmarkThird, image: imageThird,
                                button: buttonThird, flag: questions.buttonThird[numberQuestion].flag)
            imagesOnButtonFourth(checkmark: checkmarkFourth, image: imageFourth,
                                 button: buttonFourth, flag: questions.buttonFourth[numberQuestion].flag)
        }
    }
    
    private func constraintsOnButton(image: UIImageView, label: UILabel,
                                     button: UIButton) {
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20)
        ])
        setupSquare(subview: image, sizes: 30)
    }
    
    private func imagesOnButtonFirst(checkmark: UIImageView, image: UIImageView,
                                     button: UIButton, flag: String) {
        widthOfFlagFirst = image.widthAnchor.constraint(
            equalToConstant: widthFlag(flag: flag))
        setImageOnButton(checkmark: checkmark, image: image, button: button,
                         layout: widthOfFlagFirst)
    }
    
    private func imagesOnButtonSecond(checkmark: UIImageView, image: UIImageView,
                                      button: UIButton, flag: String) {
        widthOfFlagSecond = image.widthAnchor.constraint(
            equalToConstant: widthFlag(flag: flag))
        setImageOnButton(checkmark: checkmark, image: image, button: button,
                         layout: widthOfFlagSecond)
    }
    
    private func imagesOnButtonThird(checkmark: UIImageView, image: UIImageView,
                                     button: UIButton, flag: String) {
        widthOfFlagThird = image.widthAnchor.constraint(
            equalToConstant: widthFlag(flag: flag))
        setImageOnButton(checkmark: checkmark, image: image, button: button,
                         layout: widthOfFlagThird)
    }
    
    private func imagesOnButtonFourth(checkmark: UIImageView, image: UIImageView,
                                      button: UIButton, flag: String) {
        widthOfFlagFourth = image.widthAnchor.constraint(
            equalToConstant: widthFlag(flag: flag))
        setImageOnButton(checkmark: checkmark, image: image, button: button,
                         layout: widthOfFlagFourth)
    }
    
    private func setImageOnButton(checkmark: UIImageView, image: UIImageView,
                                  button: UIButton, layout: NSLayoutConstraint) {
        NSLayoutConstraint.activate([
            checkmark.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            checkmark.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 5),
            layout,
            image.heightAnchor.constraint(equalToConstant: setHeight()),
            image.centerXAnchor.constraint(equalTo: button.centerXAnchor, constant: setWidthAndCenterFlag().1),
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        setupSquare(subview: checkmark, sizes: 30)
    }
    
    private func checkStackView() -> UIStackView {
        isFlag() ? stackViewFlag : stackViewLabel
    }
    
    private func height() -> CGFloat {
        isFlag() ? 215 : 235
    }
    
    private func setupConstraintLabel() -> CGFloat {
        view.bounds.width - 105
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
        default: return setWidthAndCenterFlag().0
        }
    }
    
    private func setWidthAndCenterFlag() -> (CGFloat, CGFloat) {
        let buttonWidth = ((view.frame.width - 20) / 2) - 4
        let flagWidth = buttonWidth - 45
        let centerFlag = flagWidth / 2 + 5
        let constant = buttonWidth / 2 - centerFlag
        return (flagWidth, constant)
    }
    
    private func setHeight() -> CGFloat {
        let buttonHeight = height() / 2 - 4
        return buttonHeight - 10
    }
    
    private func radius() -> CGFloat {
        6
    }
    
    private func setConstant() -> CGFloat {
        view.frame.width / 2 - 27.5
    }
}
// MARK: - QuestionnaireViewControllerInput
extension QuestionnaireViewController: QuestionnaireViewControllerInput {
    func dataToQuestionnaire(setting: Setting) {
        delegateInput.dataToGameType(setting: setting)
    }
}
