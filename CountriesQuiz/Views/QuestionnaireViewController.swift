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
        setupLabel(title: "\(viewModel.time)", size: 35)
    }()
    
    private lazy var imageFlag: UIImageView = {
        setupImage(image: viewModel.image)
    }()
    
    private lazy var labelCountry: UILabel = {
        setupLabel(title: viewModel.name, size: 32)
    }()
    
    private lazy var buttonBack: UIButton = {
        setButton(image: "chevron.left", action: #selector(back), isEnabled: false, opacity: 0)
    }()
    
    private lazy var buttonForward: UIButton = {
        setButton(image: "chevron.right", action: #selector(forward), isEnabled: false, opacity: 0)
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
        setupLabel(title: "0 / \(viewModel.countQuestions)", size: 23)
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
        viewModel.isFlag() ? setButton(
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
            title: viewModel.buttonFirstName,
            size: 23,
            tag: 1)
    }()
    
    private lazy var imageFirst: UIImageView = {
        setupImage(image: viewModel.buttonFirstImage, radius: 8)
    }()
    
    private lazy var buttonSecond: UIButton = {
        viewModel.isFlag() ? setButton(
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
            title: viewModel.buttonSecondName,
            size: 23,
            tag: 2)
    }()
    
    private lazy var imageSecond: UIImageView = {
        setupImage(image: viewModel.buttonSecondImage, radius: 8)
    }()
    
    private lazy var buttonThird: UIButton = {
        viewModel.isFlag() ? setButton(
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
            title: viewModel.buttonThirdName,
            size: 23,
            tag: 3)
    }()
    
    private lazy var imageThird: UIImageView = {
        setupImage(image: viewModel.buttonThirdImage, radius: 8)
    }()
    
    private lazy var buttonFourth: UIButton = {
        viewModel.isFlag() ? setButton(
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
            title: viewModel.buttonFourthName,
            size: 23,
            tag: 4)
    }()
    
    private lazy var imageFourth: UIImageView = {
        setupImage(image: viewModel.buttonFourthImage, radius: 8)
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
    
    var viewModel: QuestionnaireViewModelProtocol!
    weak var delegateInput: GameTypeViewControllerInput!
    
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
        viewModel.moveSubviews(view)
        startGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupCircles()
    }
    // MARK: - General methods
    private func setupData() {
        viewModel.getQuestions()
    }
    
    private func setupDesign() {
        view.backgroundColor = viewModel.background
        navigationItem.hidesBackButton = true
        viewModel.setButtons(buttonFirst, buttonSecond, buttonThird, buttonFourth)
    }
    
    private func setupBarButton() {
        viewModel.setBarButton(buttonExit, navigationItem)
    }
    
    private func setupSubviews() {
        if viewModel.isCountdown() {
            viewModel.isFlag() ? subviewsWithTimerFlag() : subviewsWithTimerLabel()
        } else {
            viewModel.isFlag() ? subviewsWithoutTimerFlag() : subviewsWithoutTimerLabel()
        }
    }
    
    private func subviewsWithTimerFlag() {
        viewModel.setSubviews(subviews: labelTimer, imageFlag, buttonBack,
                              buttonForward, progressView, labelNumber, labelQuiz,
                              labelDescription, stackViewFlag, on: view)
    }
    
    private func subviewsWithTimerLabel() {
        viewModel.setSubviews(subviews: labelTimer, labelCountry, buttonBack,
                              buttonForward, progressView, labelNumber, labelQuiz,
                              labelDescription, stackViewLabel, on: view)
    }
    
    private func subviewsWithoutTimerFlag() {
        viewModel.setSubviews(subviews: imageFlag, buttonBack, buttonForward,
                              progressView, labelNumber, labelQuiz, labelDescription,
                              stackViewFlag, on: view)
    }
    
    private func subviewsWithoutTimerLabel() {
        viewModel.setSubviews(subviews: labelCountry, buttonBack, buttonForward,
                              progressView, labelNumber, labelQuiz, labelDescription,
                              stackViewLabel, on: view)
    }
    
    private func runTimer(duration: CGFloat, action: Selector, repeats: Bool) -> Timer {
        Timer.scheduledTimer(timeInterval: duration, target: self,
                             selector: action, userInfo: nil, repeats: repeats)
    }
    
    private func setupCircles() {
        guard viewModel.isCountdown() else { return }
        circleShadow()
        circle(strokeEnd: 0)
        animationCircleTimeReset()
    }
    // MARK: - Run timer
    private func runTimer() {
        let timeMode = viewModel.time
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
        viewModel.setEnabled(subviews: buttonBack, buttonForward, buttonExit, isEnabled: false)
        viewModel.buttonsForAnswers(isOn: false)
        endGame()
    }
    
    private func endGame() {
        labelDescription.text = "Время вышло! Коснитесь экрана, чтобы завершить"
        showFinishLabel()
        lastQuestion = true
    }
    // MARK: - Animations label quiz and description
    private func labelAnimation(label: UILabel, duration: CGFloat, opacity: Float) {
        UIView.animate(withDuration: duration) { [self] in
            viewModel.setOpacity(subviews: label, opacity: opacity, duration: duration)
        }
    }
    
    private func labelDescriptionAnimation() {
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: { [self] in
            viewModel.setOpacity(subviews: labelDescription, opacity: 1, duration: 0)
        })
    }
    
    private func showFinishLabel() {
        labelAnimation(label: labelQuiz, duration: 0.5, opacity: 0)
        labelDescriptionAnimation()
    }
    // MARK: - Save data for select answer by user
    private func select(button: UIButton) {
        guard !checkSelect(tag: button.tag) else { return }
        
        let question = viewModel.checkCurrentQuestion()
        var tag = 0
        while tag < 4 {
            tag += 1
            if !(tag == button.tag) {
                viewModel.selectIsEnabled(tag, false, question)
            }
        }
        viewModel.selectIsEnabled(button.tag, true, question)
        checkCorrectAnswer(tag: button.tag)
    }
    
    private func checkSelect(tag: Int) -> Bool {
        switch tag {
        case 1: return viewModel.answerFirst.select
        case 2: return viewModel.answerSecond.select
        case 3: return viewModel.answerThird.select
        default: return viewModel.answerFourth.select
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
        if viewModel.isFlag() {
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
                            label: viewModel.isFlag() ? labelFirst : nil)
        case 2: setupSelect(button: buttonSecond, image: checkmarkSecond,
                            label: viewModel.isFlag() ? labelSecond : nil)
        case 3: setupSelect(button: buttonThird, image: checkmarkThird,
                            label: viewModel.isFlag() ? labelThird : nil)
        default: setupSelect(button: buttonFourth, image: checkmarkFourth,
                             label: viewModel.isFlag() ? labelFourth : nil)
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
        let number = viewModel.checkCurrentQuestion()
        if viewModel.isFlag() {
            let flag = questions.questions[number].flag
            imageFlag.image = UIImage(named: flag)
            viewModel.widthOfFlagFirst.constant = checkWidthFlag(flag: flag)
            updateLabels()
        } else {
            labelCountry.text = questions.questions[number].name
            updateImages()
            updateWidthFlag()
        }
    }
    
    private func updateNumberQuestion() {
        let number = viewModel.checkCurrentQuestion()
        labelNumber.text = "\(number + 1) / \(viewModel.countQuestions)"
    }
    
    private func updateLabels() {
        let number = viewModel.checkCurrentQuestion()
        labelFirst.text = questions.buttonFirst[number].name
        labelSecond.text = questions.buttonSecond[number].name
        labelThird.text = questions.buttonThird[number].name
        labelFourth.text = questions.buttonFourth[number].name
    }
    
    private func updateImages() {
        let number = viewModel.checkCurrentQuestion()
        imageFirst.image = UIImage(named: questions.buttonFirst[number].flag)
        imageSecond.image = UIImage(named: questions.buttonSecond[number].flag)
        imageThird.image = UIImage(named: questions.buttonThird[number].flag)
        imageFourth.image = UIImage(named: questions.buttonFourth[number].flag)
    }
    
    private func updateWidthFlag() {
        let number = viewModel.checkCurrentQuestion()
        viewModel.widthOfFlagFirst.constant = widthFlag(flag: questions.buttonFirst[number].flag)
        viewModel.widthOfFlagSecond.constant = widthFlag(flag: questions.buttonSecond[number].flag)
        viewModel.widthOfFlagThird.constant = widthFlag(flag: questions.buttonThird[number].flag)
        viewModel.widthOfFlagFourth.constant = widthFlag(flag: questions.buttonFourth[number].flag)
    }
    // MARK: - Show of hide buttons back and forward
    private func buttonsBackForward(buttonBack: UIButton, buttonForward: UIButton,
                                    opacityBack: Float, opacityForward: Float,
                                    isEnabledBack: Bool, isEnabledForward: Bool) {
        viewModel.setOpacity(subviews: buttonBack, opacity: opacityBack, duration: 0.3)
        viewModel.setOpacity(subviews: buttonForward, opacity: opacityForward, duration: 0.3)
        viewModel.setEnabled(subviews: buttonBack, isEnabled: isEnabledBack)
        viewModel.setEnabled(subviews: buttonForward, isEnabled: isEnabledForward)
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
        viewModel.buttonsForAnswers(isOn: false)
        viewModel.setEnabled(subviews: buttonBack, buttonForward, isEnabled: false)
        viewModel.animationBackSubviews(view)
        viewModel.timer = runTimer(duration: 0.25, action: #selector(updateBackQuestion), repeats: false)
    }
    
    @objc private func forward() {
        viewModel.buttonsForAnswers(isOn: false)
        viewModel.setEnabled(subviews: buttonBack, buttonForward, isEnabled: false)
        viewModel.animationSubviews(duration: 0.25, view)
        viewModel.timer = runTimer(duration: 0.25, action: #selector(updateQuestion), repeats: false)
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
        viewModel.buttonsForAnswers(isOn: true)
        updateNumberQuestion()
        
        runTimer()
        shapeLayer.strokeEnd = 1
        animationCircleCountdown()
    }
    // MARK: - Actions for press button
    @objc private func buttonPress(button: UIButton) {
        switch button {
        case buttonFirst: action(button: buttonFirst, image: checkmarkFirst,
                                 label: viewModel.isFlag() ? labelFirst : nil)
        case buttonSecond: action(button: buttonSecond, image: checkmarkSecond,
                                  label: viewModel.isFlag() ? labelSecond : nil)
        case buttonThird: action(button: buttonThird, image: checkmarkThird,
                                 label: viewModel.isFlag() ? labelThird : nil)
        default: action(button: buttonFourth, image: checkmarkFourth,
                        label: viewModel.isFlag() ? labelFourth : nil)
        }
        setupNextQuestion()
    }
    
    private func action(button: UIButton, image: UIImageView, label: UILabel? = nil) {
        select(button: button)
        setupSelect(button: button, image: image, label: label)
        
        viewModel.buttonsForAnswers(isOn: false)
        viewModel.checkLastQuestion(buttonBack, buttonForward)
        
        guard numberQuestion == currentQuestion else { return }
        viewModel.setProgressView(progressView)
    }
    // MARK: - Run for show next question
    private func setupNextQuestion() {
        if numberQuestion + 1 < viewModel.countQuestions {
            viewModel.timer = runTimer(duration: 0.7, action: #selector(hideQuestion), repeats: false)
        } else {
            finishQuestionnaire()
        }
    }
    
    @objc private func hideQuestion() {
        viewModel.timer.invalidate()
        viewModel.animationSubviews(duration: 0.25, view)
        viewModel.timer = runTimer(duration: 0.25, action: #selector(updateQuestion), repeats: false)
    }
    
    @objc private func updateQuestion() {
        viewModel.timer.invalidate()
        if numberQuestion == currentQuestion {
            currentQuestion += 1
            numberQuestion += 1
        } else {
            numberQuestion += 1
        }
        viewModel.moveSubviews(view)
        updateData()
        startGame()
    }
    
    @objc private func nextQuestion() {
        viewModel.timer.invalidate()
        buttonsForwardBackOnOff()
        checkFinish()
        seconds > 0 ? viewModel.buttonsForAnswers(isOn: true) : timeUp()
    }
    // MARK: - Show prevoius question
    @objc private func updateBackQuestion() {
        viewModel.timer.invalidate()
        numberQuestion -= 1
        if lastQuestion {
            labelAnimation(label: labelDescription, duration: 0, opacity: 0)
            labelAnimation(label: labelQuiz, duration: 1, opacity: 1)
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
        let time = viewModel.time * 10
        let timeSpent = CGFloat(seconds) / CGFloat(time)
        let strokeEnd = round(timeSpent * 100) / 100
        shapeLayer.strokeEnd = strokeEnd
    }
    
    private func checkTimeSpent() {
        guard seconds > 0 else { return }
        let circleTimeSpent = 1 - shapeLayer.strokeEnd
        let time = viewModel.time
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
        viewModel.setSubviews(subviews: checkmark, label, on: button)
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
        viewModel.setSubviews(subviews: checkmark, flag, on: button)
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
        let timer = viewModel.time
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
        
        if viewModel.isCountdown() {
            constraintsTimer()
        }
        
        if viewModel.isFlag() {
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
        
        viewModel.stackViewSpring = NSLayoutConstraint(
            item: checkStackView(),
            attribute: .centerX, relatedBy: .equal, toItem: view,
            attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(viewModel.stackViewSpring)
        NSLayoutConstraint.activate([
            checkStackView().topAnchor.constraint(equalTo: labelQuiz.bottomAnchor, constant: 25),
            checkStackView().widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            checkStackView().heightAnchor.constraint(equalToConstant: viewModel.height)
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
        viewModel.widthOfFlagFirst = imageFlag.widthAnchor.constraint(equalToConstant: checkWidthFlag(flag: flag))
        
        viewModel.imageFlagSpring = NSLayoutConstraint(
            item: imageFlag, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(viewModel.imageFlagSpring)
        NSLayoutConstraint.activate([
            imageFlag.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            viewModel.widthOfFlagFirst,
            imageFlag.heightAnchor.constraint(equalToConstant: 168)
        ])
    }
    
    private func constraintsQuestionLabel() {
        viewModel.labelNameSpring = NSLayoutConstraint(
            item: labelCountry, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(viewModel.labelNameSpring)
        NSLayoutConstraint.activate([
            labelCountry.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            labelCountry.widthAnchor.constraint(equalToConstant: setupConstraintLabel())
        ])
    }
    
    private func constraintsProgressView(layout: NSLayoutYAxisAnchor, constant: CGFloat) {
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: layout, constant: constant),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.heightAnchor.constraint(equalToConstant: viewModel.radius * 2)
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
        viewModel.isFlag() ? button.centerYAnchor : button.topAnchor
    }
    
    private func layoutConstraint() -> NSLayoutYAxisAnchor {
        viewModel.isFlag() ? imageFlag.centerYAnchor : labelCountry.topAnchor
    }
    
    private func constraintsOnButton() {
        if viewModel.isFlag() {
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
        viewModel.widthOfFlagFirst = image.widthAnchor.constraint(
            equalToConstant: widthFlag(flag: flag))
        setImageOnButton(checkmark: checkmark, image: image, button: button,
                         layout: viewModel.widthOfFlagFirst)
    }
    
    private func imagesOnButtonSecond(checkmark: UIImageView, image: UIImageView,
                                      button: UIButton, flag: String) {
        viewModel.widthOfFlagSecond = image.widthAnchor.constraint(
            equalToConstant: widthFlag(flag: flag))
        setImageOnButton(checkmark: checkmark, image: image, button: button,
                         layout: viewModel.widthOfFlagSecond)
    }
    
    private func imagesOnButtonThird(checkmark: UIImageView, image: UIImageView,
                                     button: UIButton, flag: String) {
        viewModel.widthOfFlagThird = image.widthAnchor.constraint(
            equalToConstant: widthFlag(flag: flag))
        setImageOnButton(checkmark: checkmark, image: image, button: button,
                         layout: viewModel.widthOfFlagThird)
    }
    
    private func imagesOnButtonFourth(checkmark: UIImageView, image: UIImageView,
                                      button: UIButton, flag: String) {
        viewModel.widthOfFlagFourth = image.widthAnchor.constraint(
            equalToConstant: widthFlag(flag: flag))
        setImageOnButton(checkmark: checkmark, image: image, button: button,
                         layout: viewModel.widthOfFlagFourth)
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
        viewModel.isFlag() ? stackViewFlag : stackViewLabel
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
        let buttonHeight = viewModel.height / 2 - 4
        return buttonHeight - 10
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
