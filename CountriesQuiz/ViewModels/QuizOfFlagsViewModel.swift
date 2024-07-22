//
//  QuizOfFlagsViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 01.04.2024.
//

import UIKit

protocol QuizOfFlagsViewModelProtocol {
    var countQuestions: Int { get }
    var currentQuestion: Int { get }
    var background: UIColor { get }
    var radius: CGFloat { get }
    var heightStackView: CGFloat { get }
    var timer: Timer { get set }
    var answerSelect: Bool { get set }
    var labelNumber: String { get }
    var isFlag: Bool { get }
    var isCountdown: Bool { get }
    
    var buttonFirst: Countries { get }
    var buttonSecond: Countries { get }
    var buttonThird: Countries { get }
    var buttonFourth: Countries { get }
    
    var shapeLayer: CAShapeLayer { get }
    
    var imageFlagSpring: NSLayoutConstraint! { get set }
    var labelNameSpring: NSLayoutConstraint! { get set }
    var stackViewSpring: NSLayoutConstraint! { get set }
    
    var widthOfFlagFirst: NSLayoutConstraint! { get set }
    var widthOfFlagSecond: NSLayoutConstraint! { get set }
    var widthOfFlagThird: NSLayoutConstraint! { get set }
    var widthOfFlagFourth: NSLayoutConstraint! { get set }
    
    init(mode: Setting, game: Games)
    
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func setSubviews(subviews: UIView..., on subviewOther: UIView)
    func setNextCurrentQuestion(_ number: Int)
    func setOpacity(labels: UILabel..., opacity: Float)
    func setEnabled(controls: UIControl..., isEnabled: Bool)
    func setTitleTime()
    func setTitleTimer(_ labelTimer: UILabel, completion: @escaping () -> Void)
    func question() -> UIView
    func button(_ answer: Countries, action: Selector, and tag: Int) -> UIButton
    func stackView(_ first: UIButton,_ second: UIButton,_ third: UIButton,_ fourth: UIButton) -> UIStackView
    
    func setCircleTimer(_ labelTimer: UILabel,_ view: UIView)
    func circularShadow(_ labelTimer: UILabel,_ view: UIView)
    func circular(_ strokeEnd: CGFloat,_ labelTimer: UILabel,_ view: UIView)
    func animationCircleTimeReset()
    func animationCircleCountdown()
    func stopAnimationCircleTimer()
    func checkSetCircularStrokeEnd()
    
    func oneQuestionTime() -> Int
    func allQuestionsTime() -> Int
    func isOneQuestion() -> Bool
    func time() -> Int
    func setWidth(_ view: UIView) -> CGFloat
    func setHeight() -> CGFloat
    func checkWidthFlag(_ flag: String) -> CGFloat
    func widthFlag(_ flag: String,_ view: UIView) -> CGFloat
    func widthButtons(_ view: UIView) -> CGFloat
    
    func getQuestions()
    func runMoveSubviews(_ view: UIView)
    func animationSubviews(_ duration: CGFloat,_ view: UIView)
    func updateProgressView(_ progressView: UIProgressView)
    func showDescription(_ labelQuiz: UILabel,_ labelDescription: UILabel)
    func animationShowQuizHideDescription(_ labelQuiz: UILabel,_ labelDescription: UILabel)
    func animationHideQuizShowDescription(_ labelQuiz: UILabel,_ labelDescription: UILabel)
    func setSeconds(_ seconds: Int)
    func checkTimeSpent(_ shapeLayer: CAShapeLayer)
    func addAnsweredQuestion()
    
    func addCorrectAnswer()
    func addIncorrectAnswer(_ tag: Int)
    func checkAnswerFlag(_ tag: Int,_ button: UIButton)
    func checkAnswerLabel(_ tag: Int,_ button: UIButton)
    func disableButtonFlag(_ tag: Int,_ buttons: UIButton..., completion: @escaping () -> Void)
    func disableButtonLabel(_ tag: Int,_ buttons: UIButton..., completion: @escaping () -> Void)
    func setButtonColor(_ button: UIButton,_ color: UIColor,_ titleColor: UIColor?)
    
    func updateDataFlag(_ imageFlag: UIImageView,_ widthOfFlag: NSLayoutConstraint,_ buttons: UIButton...)
    func updateDataLabel(_ labelCountry: UILabel,_ view: UIView,_ images: UIImageView...,and widthOfFlags: NSLayoutConstraint...)
    func resetColorButtons(_ buttons: UIButton...)
    func resetTimer(_ labelTimer: UILabel,_ view: UIView)
    
    func constraintsTimer(_ labelTimer: UILabel,_ view: UIView)
    func setSquare(subview: UIView, sizes: CGFloat)
    func constraintsFlag(_ imageFlag: UIImageView,_ view: UIView)
    func constraintsLabel(_ labelCountry: UILabel,_ view: UIView)
    func progressView(_ progressView: UIProgressView,_ layout: NSLayoutYAxisAnchor, constant: CGFloat,_ view: UIView)
    func buttons(_ subview: UIView, to labelQuiz: UILabel, _ width: CGFloat,_ height: CGFloat,_ view: UIView)
    func setImageButtonFirst(_ image: UIImageView, on button: UIButton,_ view: UIView)
    func setImageButtonSecond(_ image: UIImageView, on button: UIButton,_ view: UIView)
    func setImageButtonThird(_ image: UIImageView, on button: UIButton,_ view: UIView)
    func setImageButtonFourth(_ image: UIImageView, on button: UIButton,_ view: UIView)
    func resultsViewController() -> ResultsViewModelProtocol
}

class QuizOfFlagsViewModel: QuizOfFlagsViewModelProtocol {
    var countQuestions: Int {
        mode.countQuestions
    }
    var currentQuestion = 0
    var background: UIColor {
        game.background
    }
    var radius: CGFloat = 6
    var heightStackView: CGFloat = 235
    var timer = Timer()
    var answerSelect = false
    var labelNumber: String {
        "\(currentQuestion + 1) / \(countQuestions)"
    }
    var isFlag: Bool {
        mode.flag ? true : false
    }
    var isCountdown: Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    
    var buttonFirst: Countries {
        data.buttonFirst[currentQuestion]
    }
    var buttonSecond: Countries {
        data.buttonSecond[currentQuestion]
    }
    var buttonThird: Countries {
        data.buttonThird[currentQuestion]
    }
    var buttonFourth: Countries {
        data.buttonFourth[currentQuestion]
    }
    
    let shapeLayer = CAShapeLayer()
    
    var imageFlagSpring: NSLayoutConstraint!
    var labelNameSpring: NSLayoutConstraint!
    var stackViewSpring: NSLayoutConstraint!
    
    var widthOfFlagFirst: NSLayoutConstraint!
    var widthOfFlagSecond: NSLayoutConstraint!
    var widthOfFlagThird: NSLayoutConstraint!
    var widthOfFlagFourth: NSLayoutConstraint!
    
    private let mode: Setting
    private let game: Games
    
    private var correctAnswers: [Corrects] = []
    private var incorrectAnswers: [Results] = []
    
    private var data: (questions: [Countries], buttonFirst: [Countries],
                       buttonSecond: [Countries], buttonThird: [Countries],
                       buttonFourth: [Countries]) = ([], [], [], [], [])
    private var timeSpend: [CGFloat] = []
    private var seconds = 0
    private var answeredQuestions = 0
    private var issue: String {
        isFlag ? data.questions[currentQuestion].flag : data.questions[currentQuestion].name
    }
    
    required init(mode: Setting, game: Games) {
        self.mode = mode
        self.game = game
    }
    // MARK: - Set subviews
    func setSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    func setBarButton(_ button: UIButton, _ navigationItem: UINavigationItem) {
        let leftBarButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func question() -> UIView {
        isFlag ? setImage(image: issue) : setLabel(title: issue)
    }
    
    func button(_ answer: Countries, action: Selector, and tag: Int) -> UIButton {
        if isFlag {
            return setButton(title: answer.name, tag: tag, action: action)
        } else {
            let image = setImage(image: answer.flag)
            return setButton(addImage: image, tag: tag, action: action, and: answer)
        }
    }
    
    func stackView(_ first: UIButton, _ second: UIButton, _ third: UIButton, 
                   _ fourth: UIButton) -> UIStackView {
        if isFlag {
            return setStackView(first, second, third, fourth)
        } else {
            let stackViewOne = setStackView(first, second)
            let stackViewTwo = setStackView(third, fourth)
            return setStackView(stackViewOne, stackViewTwo, axis: .vertical)
        }
    }
    // MARK: - Set opacity and enable subviews
    func setOpacity(labels: UILabel..., opacity: Float) {
        labels.forEach { label in
            label.layer.opacity = opacity
        }
    }
    
    func setEnabled(controls: UIControl..., isEnabled: Bool) {
        controls.forEach { control in
            control.isEnabled = isEnabled
        }
    }
    // MARK: - Set title time for label
    func setTitleTime() {
        if !isOneQuestion(), currentQuestion < 1 {
            setSeconds(time() * 10)
        } else if isOneQuestion() {
            setSeconds(time() * 10)
        }
    }
    // MARK: - Set title from run timer
    func setTitleTimer(_ labelTimer: UILabel, completion: @escaping () -> Void) {
        setSeconds(1)
        guard seconds.isMultiple(of: 10) else { return }
        let text = seconds / 10
        labelTimer.text = "\(text)"
        
        guard seconds == 0 else { return }
        timer.invalidate()
        completion()
    }
    // MARK: - Set next current question
    func setNextCurrentQuestion(_ number: Int) {
        if number == 1 {
            currentQuestion += number
        } else {
            currentQuestion = number
        }
    }
    // MARK: - Set seconds
    func setSeconds(_ time: Int) {
        if time == 1 {
            seconds -= time
        } else {
            seconds = time
        }
    }
    // MARK: - Constants
    func oneQuestionTime() -> Int {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
    }
    
    func allQuestionsTime() -> Int {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
    }
    
    func isOneQuestion() -> Bool {
        mode.timeElapsed.questionSelect.oneQuestion ? true : false
    }
    
    func time() -> Int {
        isOneQuestion() ? oneQuestionTime() : allQuestionsTime()
    }
    
    func setWidth(_ view: UIView) -> CGFloat {
        let buttonWidth = ((view.frame.width - 20) / 2) - 4
        return buttonWidth - 10
    }
    
    func setHeight() -> CGFloat {
        let buttonHeight = heightStackView / 2 - 4
        return buttonHeight - 10
    }
    
    func checkWidthFlag(_ flag: String) -> CGFloat {
        switch flag {
        case "nepal", "vatican city", "switzerland": return 168
        default: return 280
        }
    }
    
    func widthFlag(_ flag: String, _ view: UIView) -> CGFloat {
        switch flag {
        case "nepal", "vatican city", "switzerland": return setHeight()
        default: return setWidth(view)
        }
    }
    
    func widthButtons(_ view: UIView) -> CGFloat {
        isFlag ? view.bounds.width - 40 : view.bounds.width - 20
    }
    // MARK: - Get countries for questions
    func getQuestions() {
        let randomCountries = getRandomCountries()
        let questions = getRandomQuestions(randomCountries: randomCountries)
        let choosingAnswers = getChoosingAnswers(questions: questions, randomCountries: randomCountries)
        let answers = getAnswers(choosingAnswers: choosingAnswers)
        data = (questions, answers.buttonFirst, answers.buttonSecond, answers.buttonThird, answers.buttonFourth)
    }
    // MARK: - Move image / label and buttons
    func runMoveSubviews(_ view: UIView) {
        let pointX: CGFloat = currentQuestion > 0 ? 2 : 1
        if isFlag {
            imageFlagSpring.constant += view.bounds.width * pointX
        } else {
            labelNameSpring.constant += view.bounds.width * pointX
        }
        stackViewSpring.constant += view.bounds.width * pointX
    }
    // MARK: - Animation move subviews
    func animationSubviews(_ duration: CGFloat, _ view: UIView) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) { [self] in
            if isFlag {
                imageFlagSpring.constant -= view.bounds.width
            } else {
                labelNameSpring.constant -= view.bounds.width
            }
            stackViewSpring.constant -= view.bounds.width
            view.layoutIfNeeded()
        }
    }
    // MARK: - Update progress view
    func updateProgressView(_ progressView: UIProgressView) {
        let time = TimeInterval(countQuestions)
        let interval = 1 / time
        let progress = progressView.progress + Float(interval)
        
        UIView.animate(withDuration: 0.5) {
            progressView.setProgress(progress, animated: true)
        }
    }
    // MARK: - Animation label description and label number
    func showDescription(_ labelQuiz: UILabel, _ labelDescription: UILabel) {
        showDescription(labelDescription)
        animationHideQuizShowDescription(labelQuiz, labelDescription)
    }
    
    func animationShowQuizHideDescription(_ labelQuiz: UILabel, _ labelDescription: UILabel) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) { [self] in
            setOpacity(labels: labelQuiz, opacity: 1)
        }
        guard labelDescription.layer.opacity == 1 else { return }
        setOpacity(labels: labelDescription, opacity: 0)
    }
    
    func animationHideQuizShowDescription(_ labelQuiz: UILabel, _ labelDescription: UILabel) {
        UIView.animate(withDuration: 0.5, animations: { [self] in
            setOpacity(labels: labelQuiz, opacity: 0)
        })
        
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: { [self] in
            setOpacity(labels: labelDescription, opacity: 1)
        })
    }
    // MARK: - Time spent for every answer
    func checkTimeSpent(_ shapeLayer: CAShapeLayer) {
        if isOneQuestion() {
            setTimeSpent(shapeLayer)
        } else if !isOneQuestion(), currentQuestion + 1 == countQuestions {
            setTimeSpent(shapeLayer)
        }
    }
    // MARK: - Add correct answer after select from user
    func addCorrectAnswer() {
        addCorrectAnswer(numberQuestion: currentQuestion + 1,
                         question: data.questions[currentQuestion],
                         buttonFirst: data.buttonFirst[currentQuestion],
                         buttonSecond: data.buttonSecond[currentQuestion],
                         buttonThird: data.buttonThird[currentQuestion],
                         buttonFourth: data.buttonFourth[currentQuestion])
    }
    // MARK: - Add incorrect answer after select from user
    func addIncorrectAnswer(_ tag: Int) {
        let setTag = tag == 0 ? 0 : tag
        let timeUp = tag == 0 ? true : false
        addIncorrectAnswer(numberQuestion: currentQuestion + 1, tag: setTag,
                           question: data.questions[currentQuestion],
                           buttonFirst: data.buttonFirst[currentQuestion],
                           buttonSecond: data.buttonSecond[currentQuestion],
                           buttonThird: data.buttonThird[currentQuestion],
                           buttonFourth: data.buttonFourth[currentQuestion],
                           timeUp: timeUp)
    }
    // MARK: - Set color for buttons after select from user
    func setButtonColor(_ button: UIButton, _ color: UIColor, _ titleColor: UIColor? = nil) {
        UIView.animate(withDuration: 0.3) {
            button.backgroundColor = color
            button.layer.shadowColor = color.cgColor
            button.setTitleColor(titleColor, for: .normal)
        }
    }
    // MARK: - Animations of color buttons when user selected answer
    func checkAnswerFlag(_ tag: Int, _ button: UIButton) {
        let green = UIColor.greenYellowBrilliant
        let red = UIColor.redTangerineTango
        let white = UIColor.white
        
        if checkAnswer(tag) {
            setButtonColor(button, green, white)
            addCorrectAnswer()
        } else {
            setButtonColor(button, red, white)
            addIncorrectAnswer(tag)
        }
    }
    
    func checkAnswerLabel(_ tag: Int, _ button: UIButton) {
        let green = UIColor.greenYellowBrilliant
        let red = UIColor.redTangerineTango
        
        if checkAnswer(tag) {
            setButtonColor(button, green)
            addCorrectAnswer()
        } else {
            setButtonColor(button, red)
            addIncorrectAnswer(tag)
        }
    }
    
    func disableButtonFlag(_ tag: Int, _ buttons: UIButton..., completion: @escaping () -> Void) {
        let gray = UIColor.grayLight
        let white = UIColor.white.withAlphaComponent(0.9)
        
        buttons.forEach { button in
            if !(button.tag == tag) {
                setButtonColor(button, white, gray)
            }
            button.isEnabled = false
        }
        completion()
    }
    
    func disableButtonLabel(_ tag: Int, _ buttons: UIButton..., completion: @escaping () -> Void) {
        let gray = UIColor.skyGrayLight
        
        buttons.forEach { button in
            if !(button.tag == tag) {
                setButtonColor(button, gray)
            }
            button.isEnabled = false
        }
        completion()
    }
    // MARK: - Refresh data for next question
    func updateDataFlag(_ imageFlag: UIImageView, _ widthOfFlag: NSLayoutConstraint, _ buttons: UIButton...) {
        let flag = data.questions[currentQuestion].flag
        imageFlag.image = UIImage(named: flag)
        updateButtonsFlag(buttons: buttons)
        widthOfFlag.constant = checkWidthFlag(flag)
    }
    
    func updateDataLabel(_ labelCountry: UILabel, _ view: UIView, 
                         _ images: UIImageView..., and widthOfFlags: NSLayoutConstraint...) {
        labelCountry.text = data.questions[currentQuestion].name
        updateButtonsLabel(images: images)
        updateWidthFlags(widthFlags: widthOfFlags, view: view)
    }
    
    func resetTimer(_ labelTimer: UILabel, _ view: UIView) {
        if isOneQuestion() && seconds > 0 {
            labelTimer.text = "\(oneQuestionTime())"
            animationCircleTimeReset()
        } else if isOneQuestion() && seconds == 0 {
            labelTimer.text = "\(oneQuestionTime())"
            circular(0, labelTimer, view)
            animationCircleTimeReset()
        }
    }
    // MARK: - Refresh color buttons for next question
    func resetColorButtons(_ buttons: UIButton...) {
        let white = UIColor.white
        let blue = UIColor.blueBlackSea
        buttons.forEach { button in
            isFlag ? setButtonColor(button, white, blue) : setButtonColor(button, white)
        }
    }
    // MARK: - Set circle timer
    func setCircleTimer(_ labelTimer: UILabel, _ view: UIView) {
        circularShadow(labelTimer, view)
        circular(0, labelTimer, view)
        animationCircleTimeReset()
    }
    
    func circularShadow(_ labelTimer: UILabel, _ view: UIView) {
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
    
    func circular(_ strokeEnd: CGFloat, _ labelTimer: UILabel, _ view: UIView) {
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
    
    func animationCircleTimeReset() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = CFTimeInterval(0.4)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
    
    func animationCircleCountdown() {
        let timer = checkCircleCountdown()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 0
        animation.duration = CFTimeInterval(timer)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
    
    func stopAnimationCircleTimer() {
        let oneQuestionTime = time() * 10
        let time = CGFloat(seconds) / CGFloat(oneQuestionTime)
        let result = round(100 * time) / 100
        shapeLayer.removeAnimation(forKey: "animation")
        shapeLayer.strokeEnd = result
    }
    
    func checkSetCircularStrokeEnd() {
        if isOneQuestion() && isCountdown {
            shapeLayer.strokeEnd = 1
        } else if !isOneQuestion() && isCountdown && currentQuestion < 1 {
            shapeLayer.strokeEnd = 1
        }
    }
    // MARK: - Constraints
    func constraintsTimer(_ labelTimer: UILabel, _ view: UIView) {
        NSLayoutConstraint.activate([
            labelTimer.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            labelTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    func constraintsFlag(_ imageFlag: UIImageView, _ view: UIView) {
        let flag = data.questions[currentQuestion].flag
        widthOfFlagFirst = imageFlag.widthAnchor.constraint(equalToConstant: checkWidthFlag(flag))
        
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
    
    func constraintsLabel(_ labelCountry: UILabel, _ view: UIView) {
        labelNameSpring = NSLayoutConstraint(
            item: labelCountry, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(labelNameSpring)
        NSLayoutConstraint.activate([
            labelCountry.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            labelCountry.widthAnchor.constraint(equalToConstant: widthButtons(view))
        ])
    }
    
    func progressView(_ progressView: UIProgressView, _ layout: NSLayoutYAxisAnchor,
                      constant: CGFloat, _ view: UIView) {
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: layout, constant: constant),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.heightAnchor.constraint(equalToConstant: radius * 2)
        ])
    }
    
    func buttons(_ subview: UIView, to labelQuiz: UILabel, _ width: CGFloat,
                 _ height: CGFloat, _ view: UIView) {
        stackViewSpring = NSLayoutConstraint(
            item: subview, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(stackViewSpring)
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: labelQuiz.bottomAnchor, constant: 25),
            subview.widthAnchor.constraint(equalToConstant: width),
            subview.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func setImageButtonFirst(_ image: UIImageView, on button: UIButton, _ view: UIView) {
        let flag = data.buttonFirst[currentQuestion].flag
        widthOfFlagFirst = image.widthAnchor.constraint(
            equalToConstant: widthFlag(flag, view))
        setImageOnButton(layout: widthOfFlagFirst, image: image, button: button)
    }
    
    func setImageButtonSecond(_ image: UIImageView, on button: UIButton, _ view: UIView) {
        let flag = data.buttonSecond[currentQuestion].flag
        widthOfFlagSecond = image.widthAnchor.constraint(
            equalToConstant: widthFlag(flag, view))
        setImageOnButton(layout: widthOfFlagSecond, image: image, button: button)
    }
    
    func setImageButtonThird(_ image: UIImageView, on button: UIButton, _ view: UIView) {
        let flag = data.buttonThird[currentQuestion].flag
        widthOfFlagThird = image.widthAnchor.constraint(
            equalToConstant: widthFlag(flag, view))
        setImageOnButton(layout: widthOfFlagThird, image: image, button: button)
    }
    
    func setImageButtonFourth(_ image: UIImageView, on button: UIButton, _ view: UIView) {
        let flag = data.buttonFourth[currentQuestion].flag
        widthOfFlagFourth = image.widthAnchor.constraint(
            equalToConstant: widthFlag(flag, view))
        setImageOnButton(layout: widthOfFlagFourth, image: image, button: button)
    }
    // MARK: - Calc answered questions
    func addAnsweredQuestion() {
        answeredQuestions += 1
    }
    // MARK: - Transition to ResultViewController
    func resultsViewController() -> ResultsViewModelProtocol {
        ResultsViewModel(mode: mode, game: game, correctAnswers: correctAnswers,
                         incorrectAnswers: incorrectAnswers, timeSpend: timeSpend,
                         answeredQuestions: answeredQuestions)
    }
    // MARK: - Get countries for questions, countinue
    private func getRandomCountries() -> [Countries] {
        checkContinents(continents: mode.allCountries, mode.americaContinent,
                        mode.europeContinent, mode.africaContinent, mode.asiaContinent,
                        mode.oceaniaContinent)
    }
    
    private func checkContinents(continents: Bool...) -> [Countries] {
        var counter = 0
        var countries: [Countries] = []
        continents.forEach { continent in
            if continent {
                countries += addCountries(counter: counter)
            }
            counter += 1
        }
        return countries.shuffled()
    }
    
    private func addCountries(counter: Int) -> [Countries] {
        switch counter {
        case 0: getCountries()
        case 1: getAmericanContinent()
        case 2: getEuropeanContinent()
        case 3: getAfricanContinent()
        case 4: getAsianContinent()
        default: getOceanContinent()
        }
    }
    
    private func getCountries() -> [Countries] {
        var countries: [Countries] = []
        
        let flags = FlagsOfCountries.shared.images
        let names = FlagsOfCountries.shared.countries
        let capitals = FlagsOfCountries.shared.capitals
        let iterationCount = min(flags.count, names.count, capitals.count)
        
        for index in 0..<iterationCount {
            let information = Countries(
                flag: flags[index],
                name: names[index],
                capitals: capitals[index],
                select: false
            )
            countries.append(information)
        }
        
        return countries
    }
    
    private func getAmericanContinent() -> [Countries] {
        var countries: [Countries] = []
        
        let flags = FlagsOfCountries.shared.imagesOfAmericanContinent
        let names = FlagsOfCountries.shared.countriesOfAmericanContinent
        let capitals = FlagsOfCountries.shared.capitalsOfAmericanContinent
        let iterationCount = min(flags.count, names.count)
        
        for index in 0..<iterationCount {
            let information = Countries(
                flag: flags[index],
                name: names[index],
                capitals: capitals[index],
                select: false
            )
            countries.append(information)
        }
        
        return countries
    }
    
    private func getEuropeanContinent() -> [Countries] {
        var countries: [Countries] = []
        
        let flags = FlagsOfCountries.shared.imagesOfEuropeanContinent
        let names = FlagsOfCountries.shared.countriesOfEuropeanContinent
        let capitals = FlagsOfCountries.shared.capitalsOfEuropeanContinent
        let iterationCount = min(flags.count, names.count)
        
        for index in 0..<iterationCount {
            let information = Countries(
                flag: flags[index],
                name: names[index],
                capitals: capitals[index],
                select: false
            )
            countries.append(information)
        }
        
        return countries
    }
    
    private func getAfricanContinent() -> [Countries] {
        var countries: [Countries] = []
        
        let flags = FlagsOfCountries.shared.imagesOfAfricanContinent
        let names = FlagsOfCountries.shared.countriesOfAfricanContinent
        let capitals = FlagsOfCountries.shared.capitalsOfAfricanContinent
        let iterationCount = min(flags.count, names.count)
        
        for index in 0..<iterationCount {
            let information = Countries(
                flag: flags[index],
                name: names[index],
                capitals: capitals[index],
                select: false
            )
            countries.append(information)
        }
        
        return countries
    }
    
    private func getAsianContinent() -> [Countries] {
        var countries: [Countries] = []
        
        let flags = FlagsOfCountries.shared.imagesOfAsianContinent
        let names = FlagsOfCountries.shared.countriesOfAsianContinent
        let capitals = FlagsOfCountries.shared.capitalsOfAsianContinent
        let iterationCount = min(flags.count, names.count)
        
        for index in 0..<iterationCount {
            let information = Countries(
                flag: flags[index],
                name: names[index],
                capitals: capitals[index],
                select: false
            )
            countries.append(information)
        }
        
        return countries
    }
    
    private func getOceanContinent() -> [Countries] {
        var countries: [Countries] = []
        
        let flags = FlagsOfCountries.shared.imagesOfOceanContinent
        let names = FlagsOfCountries.shared.countriesOfOceanContinent
        let capitals = FlagsOfCountries.shared.capitalsOfOceanContinent
        let iterationCount = min(flags.count, names.count)
        
        for index in 0..<iterationCount {
            let information = Countries(
                flag: flags[index],
                name: names[index],
                capitals: capitals[index],
                select: false
            )
            countries.append(information)
        }
        
        return countries
    }
    
    private func getRandomQuestions(randomCountries: [Countries]) -> [Countries] {
        var getRandomQuestions: [Countries] = []
        
        for index in 0..<countQuestions {
            getRandomQuestions.append(randomCountries[index])
        }
        
        return getRandomQuestions
    }
    
    private func getChoosingAnswers(questions: [Countries], randomCountries: [Countries]) -> [Countries] {
        var choosingAnswers: [Countries] = []
        
        for index in 0..<questions.count {
            let answers = answers(randomCountries: randomCountries, index: index)
            let incorrectAnswers = incorrectAnswers(answers: answers)
            let fourAnswers = sum(correctAnswer: questions[index], incorrectAnswers: incorrectAnswers)
            choosingAnswers += fourAnswers
        }
        
        return choosingAnswers
    }
    
    private func answers(randomCountries: [Countries], index: Int) -> [Countries] {
        var answers = randomCountries
        answers.remove(at: index)
        return answers
    }
    
    private func incorrectAnswers(answers: [Countries]) -> [Countries] {
        var incorrectAnswers: [Countries] = []
        var answers = answers
        var counter = 0
        
        while(counter < 3) {
            let index = Int.random(in: 0..<answers.count)
            let incorrectAnswer = answers[index]
            incorrectAnswers.append(incorrectAnswer)
            answers.remove(at: index)
            counter += 1
        }
        
        return incorrectAnswers
    }
    
    private func sum(correctAnswer: Countries, incorrectAnswers: [Countries]) -> [Countries] {
        var answers = incorrectAnswers
        answers.append(correctAnswer)
        return answers.shuffled()
    }
    
    private func getAnswers(choosingAnswers: [Countries]) -> (buttonFirst: [Countries],
                                                              buttonSecond: [Countries],
                                                              buttonThird: [Countries],
                                                              buttonFourth: [Countries]) {
        var first: [Countries] = []
        var second: [Countries] = []
        var third: [Countries] = []
        var fourth: [Countries] = []
        var counter = 0
        
        choosingAnswers.forEach { answer in
            switch counter {
            case 0: first.append(answer)
            case 1: second.append(answer)
            case 2: third.append(answer)
            default: fourth.append(answer)
            }
            counter += counter == 3 ? -3 : 1
        }
        
        return (first, second, third, fourth)
    }
    // MARK: - Animation label description and label number, countinue
    private func showDescription(_ label: UILabel) {
        guard currentQuestion == countQuestions - 1 else { return }
        let red = UIColor.lightPurplePink
        label.text = "Коснитесь экрана, чтобы завершить"
        label.textColor = red
    }
    // MARK: - Set time spent for every answer
    private func setTimeSpent(_ shapeLayer: CAShapeLayer) {
        let circleTimeSpent = 1 - shapeLayer.strokeEnd
        let seconds = time()
        let timeSpent = circleTimeSpent * CGFloat(seconds)
        timeSpend.append(timeSpent)
    }
    // MARK: - Check correct or incorrect answer from select user
    private func checkAnswer(_ tag: Int) -> Bool {
        switch tag {
        case 1: return data.questions[currentQuestion] == data.buttonFirst[currentQuestion] ? true : false
        case 2: return data.questions[currentQuestion] == data.buttonSecond[currentQuestion] ? true : false
        case 3: return data.questions[currentQuestion] == data.buttonThird[currentQuestion] ? true : false
        default: return data.questions[currentQuestion] == data.buttonFourth[currentQuestion] ? true : false
        }
    }
    // MARK: - Add correct answer after select from user, countinue
    private func addCorrectAnswer(numberQuestion: Int, question: Countries, 
                               buttonFirst: Countries, buttonSecond: Countries, 
                               buttonThird: Countries, buttonFourth: Countries) {
        let answer = Corrects(currentQuestion: numberQuestion, question: question,
                              buttonFirst: buttonFirst, buttonSecond: buttonSecond,
                              buttonThird: buttonThird, buttonFourth: buttonFourth)
        correctAnswers.append(answer)
    }
    // MARK: - Add incorrect answer after select from user, countinue
    private func addIncorrectAnswer(numberQuestion: Int, tag: Int, question: Countries,
                                 buttonFirst: Countries, buttonSecond: Countries,
                                 buttonThird: Countries, buttonFourth: Countries,
                                 timeUp: Bool) {
        let answer = Results(currentQuestion: numberQuestion, tag: tag,
                             question: question, buttonFirst: buttonFirst,
                             buttonSecond: buttonSecond, buttonThird: buttonThird,
                             buttonFourth: buttonFourth, timeUp: timeUp)
        incorrectAnswers.append(answer)
    }
    // MARK: - Refresh data for next question, countinue
    private func updateButtonsFlag(buttons: [UIButton]) {
        var counter = 0
        buttons.forEach { button in
            switch counter {
            case 0: button.setTitle(buttonFirst.name, for: .normal)
            case 1: button.setTitle(buttonSecond.name, for: .normal)
            case 2: button.setTitle(buttonThird.name, for: .normal)
            default: button.setTitle(buttonFourth.name, for: .normal)
            }
            counter += 1
        }
    }
    
    private func updateButtonsLabel(images: [UIImageView]) {
        var counter = 0
        images.forEach { image in
            switch counter {
            case 0: image.image = UIImage(named: buttonFirst.flag)
            case 1: image.image = UIImage(named: buttonSecond.flag)
            case 2: image.image = UIImage(named: buttonThird.flag)
            default: image.image = UIImage(named: buttonFourth.flag)
            }
            counter += 1
        }
    }
    
    private func updateWidthFlags(widthFlags: [NSLayoutConstraint], view: UIView) {
        var counter = 0
        widthFlags.forEach { width in
            switch counter {
            case 0: width.constant = widthFlag(buttonFirst.flag, view)
            case 1: width.constant = widthFlag(buttonSecond.flag, view)
            case 2: width.constant = widthFlag(buttonThird.flag, view)
            default: width.constant = widthFlag(buttonFourth.flag, view)
            }
            counter += 1
        }
    }
    // MARK: - Time for label, seconds and circle timer
    private func checkCircleCountdown() -> Int {
        isOneQuestion() ? oneQuestionTime() : seconds / 10
    }
    // MARK: - Constraints, countinue
    private func setConstraints(image: UIImageView, on button: UIButton,
                                and answer: Countries) {
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: setHeight()),
            image.widthAnchor.constraint(equalToConstant: <#T##CGFloat#>)
        ])
    }
    /*
    private func layoutConstraint(_ answer: Countries, image: UIImageView) -> NSLayoutConstraint {
        switch answer {
        case answer == buttonFirst: widthOfFlagFirst = image.widthAnchor.constraint(equalToConstant: widthFlag(flag, view))
        }
    }
    */
    private func setImageOnButton(layout: NSLayoutConstraint, image: UIImageView, button: UIView) {
        NSLayoutConstraint.activate([
            layout,
            image.heightAnchor.constraint(equalToConstant: setHeight()),
            image.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
    }
}
// MARK: - Private methods, set subviews
extension QuizOfFlagsViewModel {
    private func setImage(image: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: image)
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = isFlag ? 0 : 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func setLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: 32)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func setButton(title: String, tag: Int, action: Selector) -> UIButton {
        let button = Button(type: .system)
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
    
    private func setButton(addImage: UIImageView, tag: Int, action: Selector,
                           and answer: Countries) -> UIButton {
        let button = Button(type: .custom)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.isEnabled = false
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        setSubviews(subviews: addImage, on: button)
        setConstraints(image: addImage, on: button, and: answer)
        return button
    }
    
    private func setStackView(_ first: UIView, _ second: UIView,
                              _ third: UIView, _ fourth: UIView) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [first, second, third, fourth])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackView(_ first: UIView, _ second: UIView,
                              axis: NSLayoutConstraint.Axis? = nil) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [first, second])
        stackView.axis = axis ?? .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
