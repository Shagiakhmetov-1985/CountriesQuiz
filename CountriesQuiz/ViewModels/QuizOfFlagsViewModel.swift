//
//  QuizOfFlagsViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 01.04.2024.
//

import UIKit

protocol QuizOfFlagsViewModelProtocol {
    var setting: Setting { get }
    var games: Games { get }
    var countQuestions: Int { get }
    var currentQuestion: Int { get }
    var seconds: Int { get }
    var background: UIColor { get }
    var radius: CGFloat { get }
    var heightStackView: CGFloat { get }
    var timer: Timer { get set }
    var spendTime: [CGFloat] { get set }
    var answerSelect: Bool { get set }
    var labelNumberQuiz: String { get }
    
    var data: (questions: [Countries], buttonFirst: [Countries],
               buttonSecond: [Countries], buttonThird: [Countries],
               buttonFourth: [Countries]) { get }
    var buttonFirst: String { get }
    var buttonSecond: String { get }
    var buttonThird: String { get }
    var buttonFourth: String { get }
    
    var correctAnswers: [Countries] { get }
    var incorrectAnswers: [Results] { get }
    
    var shapeLayer: CAShapeLayer { get }
    
    var imageFlagSpring: NSLayoutConstraint! { get set }
    var labelNameSpring: NSLayoutConstraint! { get set }
    var stackViewSpring: NSLayoutConstraint! { get set }
    
    var widthOfFlagFirst: NSLayoutConstraint! { get set}
    var widthOfFlagSecond: NSLayoutConstraint! { get set}
    var widthOfFlagThird: NSLayoutConstraint! { get set}
    var widthOfFlagFourth: NSLayoutConstraint! { get set}
    
    init(mode: Setting, game: Games)
    
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func setSubviews(subviews: UIView..., on subviewOther: UIView)
    func setNextCurrentQuestion(_ number: Int)
    func setOpacity(labels: UILabel..., opacity: Float)
    func setEnabled(controls: UIControl..., isEnabled: Bool)
    func setTitleTime()
    func setTitleTimer(_ labelTimer: UILabel, completion: @escaping () -> Void)
    
    func setCircleTimer(_ labelTimer: UILabel,_ view: UIView)
    func circularShadow(_ labelTimer: UILabel,_ view: UIView)
    func circular(_ strokeEnd: CGFloat,_ labelTimer: UILabel,_ view: UIView)
    func animationCircleTimeReset()
    func animationCircleCountdown()
    func stopAnimationCircleTimer()
    func checkSetCircularStrokeEnd()
    
    func isFlag() -> Bool
    func isCountdown() -> Bool
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
}

class QuizOfFlagsViewModel: QuizOfFlagsViewModelProtocol {
    var setting: Setting {
        mode
    }
    var games: Games {
        game
    }
    var countQuestions: Int {
        mode.countQuestions
    }
    var currentQuestion: Int {
        numberQuestion
    }
    var seconds: Int {
        setSeconds
    }
    var background: UIColor {
        game.background
    }
    var data: (questions: [Countries], buttonFirst: [Countries],
               buttonSecond: [Countries], buttonThird: [Countries],
               buttonFourth: [Countries]) = ([], [], [], [], [])
    var radius: CGFloat = 6
    var heightStackView: CGFloat = 235
    var timer = Timer()
    var spendTime: [CGFloat] = []
    var answerSelect = false
    var labelNumberQuiz: String {
        "\(currentQuestion + 1) / \(countQuestions)"
    }
    
    var buttonFirst: String {
        data.buttonFirst[currentQuestion].name
    }
    var buttonSecond: String {
        data.buttonSecond[currentQuestion].name
    }
    var buttonThird: String {
        data.buttonThird[currentQuestion].name
    }
    var buttonFourth: String {
        data.buttonFourth[currentQuestion].name
    }
    
    var correctAnswers: [Countries] = []
    var incorrectAnswers: [Results] = []
    
    let shapeLayer = CAShapeLayer()
    
    var imageFlagSpring: NSLayoutConstraint!
    var labelNameSpring: NSLayoutConstraint!
    var stackViewSpring: NSLayoutConstraint!
    
    var widthOfFlagFirst: NSLayoutConstraint!
    var widthOfFlagSecond: NSLayoutConstraint!
    var widthOfFlagThird: NSLayoutConstraint!
    var widthOfFlagFourth: NSLayoutConstraint!
    
    let mode: Setting
    let game: Games
    private var setSeconds = 0
    private var numberQuestion = 0
    
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
            numberQuestion += number
        } else {
            numberQuestion = number
        }
    }
    // MARK: - Set seconds
    func setSeconds(_ seconds: Int) {
        if seconds == 1 {
            setSeconds -= seconds
        } else {
            setSeconds = seconds
        }
    }
    // MARK: - Constants
    func isFlag() -> Bool {
        mode.flag ? true : false
    }
    
    func isCountdown() -> Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    
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
        isFlag() ? view.bounds.width - 40 : view.bounds.width - 20
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
        if isFlag() {
            imageFlagSpring.constant += view.bounds.width * pointX
        } else {
            labelNameSpring.constant += view.bounds.width * pointX
        }
        stackViewSpring.constant += view.bounds.width * pointX
    }
    // MARK: - Animation move subviews
    func animationSubviews(_ duration: CGFloat, _ view: UIView) {
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
        correctAnswers.append(data.questions[currentQuestion])
    }
    // MARK: - Add incorrect answer after select from user
    func addIncorrectAnswer(_ tag: Int) {
        let setTag = tag == 0 ? 0 : tag
        let timeUp = tag == 0 ? true : false
        incorrectAnswer(numberQuestion: currentQuestion + 1, tag: setTag,
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
            isFlag() ? setButtonColor(button, white, blue) : setButtonColor(button, white)
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
        if isOneQuestion() && isCountdown() {
            shapeLayer.strokeEnd = 1
        } else if !isOneQuestion() && isCountdown() && currentQuestion < 1 {
            shapeLayer.strokeEnd = 1
        }
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
        spendTime.append(timeSpent)
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
    // MARK: - Add incorrect answer after select from user, countinue
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
    // MARK: - Refresh data for next question, countinue
    private func updateButtonsFlag(buttons: [UIButton]) {
        var counter = 0
        buttons.forEach { button in
            switch counter {
            case 0: button.setTitle(data.buttonFirst[currentQuestion].name, for: .normal)
            case 1: button.setTitle(data.buttonSecond[currentQuestion].name, for: .normal)
            case 2: button.setTitle(data.buttonThird[currentQuestion].name, for: .normal)
            default: button.setTitle(data.buttonFourth[currentQuestion].name, for: .normal)
            }
            counter += 1
        }
    }
    
    private func updateButtonsLabel(images: [UIImageView]) {
        var counter = 0
        images.forEach { image in
            switch counter {
            case 0: image.image = UIImage(named: data.buttonFirst[currentQuestion].flag)
            case 1: image.image = UIImage(named: data.buttonSecond[currentQuestion].flag)
            case 2: image.image = UIImage(named: data.buttonThird[currentQuestion].flag)
            default: image.image = UIImage(named: data.buttonFourth[currentQuestion].flag)
            }
            counter += 1
        }
    }
    
    private func updateWidthFlags(widthFlags: [NSLayoutConstraint], view: UIView) {
        var counter = 0
        widthFlags.forEach { width in
            switch counter {
            case 0: width.constant = widthFlag(data.buttonFirst[currentQuestion].flag, view)
            case 1: width.constant = widthFlag(data.buttonSecond[currentQuestion].flag, view)
            case 2: width.constant = widthFlag(data.buttonThird[currentQuestion].flag, view)
            default: width.constant = widthFlag(data.buttonFourth[currentQuestion].flag, view)
            }
            counter += 1
        }
    }
    // MARK: - Time for label, seconds and circle timer
    private func checkCircleCountdown() -> Int {
        isOneQuestion() ? oneQuestionTime() : seconds / 10
    }
}
