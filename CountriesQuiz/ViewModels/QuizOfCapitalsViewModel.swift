//
//  QuizOfCapitalsViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 23.04.2024.
//

import UIKit

protocol QuizOfCapitalsViewModelProtocol {
    var countQuestions: Int { get }
    var currentQuestion: Int { get }
    var question: String { get }
    var answerFirst: String { get }
    var answerSecond: String { get }
    var answerThird: String { get }
    var answerFourth: String { get }
    var background: UIColor { get }
    var data: (questions: [Countries], buttonFirst: [Countries],
               buttonSecond: [Countries], buttonThird: [Countries],
               buttonFourth: [Countries]) { get }
    var time: Int { get }
    var radius: CGFloat { get }
    var circleTimeElapsed: Int { get }
    var timer: Timer { get set }
    var labelNumberQuiz: String { get }
    var answerSelect: Bool { get }
    
    var imageFlagSpring: NSLayoutConstraint! { get set }
    var labelNameSpring: NSLayoutConstraint! { get set }
    var stackViewSpring: NSLayoutConstraint! { get set }
    var widthOfFlag: NSLayoutConstraint! { get set }
    
    init(mode: Setting, game: Games)
    
    func setSubviews(_ buttonOne: UIButton,_ buttonTwo: UIButton,
                     _ buttonThree: UIButton,_ buttonFour: UIButton,
                     _ image: UIImageView,_ label: UILabel)
    func setupSubviews(subviews: UIView..., on subviewOther: UIView)
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func setEnabled(controls: UIControl..., isEnabled: Bool)
    func setTitleTimer(_ labelTimer: UILabel, completion: @escaping () -> Void)
    func setNextCurrentQuestion(_ number: Int)
    func setCircleTime(_ labelTimer: UILabel,_ view: UIView)
    func checkSetCircularStrokeEnd()
    func animationCircleCountdown()
    func stopAnimationCircleTimer()
    func checkTimeSpent()
    
    func isFlag() -> Bool
    func isOneQuestion() -> Bool
    func isCountdown() -> Bool
    func checkWidthFlag(_ flag: String) -> CGFloat
    func widthButton(_ view: UIView) -> CGFloat
    func widthLabel(_ view: UIView) -> CGFloat
    
    func getQuestions()
    func setTime()
    func runMoveSubviews(_ view: UIView)
    func animationSubviews(duration: CGFloat,_ view: UIView)
    func updateProgressView(_ progressView: UIProgressView)
    func showDescription(_ labelQuiz: UILabel,_ labelDescription: UILabel)
    func animationShowQuizHideDescription(_ labelQuiz: UILabel,_ labelDescription: UILabel)
    func exitToGameType()
    func timeUp(_ labelQuiz: UILabel,_ labelDescription: UILabel)
    
    func runNextQuestion()
    func checkAnswer(button: UIButton, completion: @escaping () -> Void)
    func addIncorrectAnswer(_ tag: Int)
    func updateData(_ labelTimer: UILabel,_ view: UIView)
    
    func resultsViewController() -> ResultsViewModelProtocol
}

class QuizOfCapitalsViewModel: QuizOfCapitalsViewModelProtocol {
    var countQuestions: Int {
        mode.countQuestions
    }
    var currentQuestion = 0
    var question: String {
        isFlag() ? data.questions[currentQuestion].flag : data.questions[currentQuestion].name
    }
    var answerFirst: String {
        data.buttonFirst[currentQuestion].capitals
    }
    var answerSecond: String {
        data.buttonSecond[currentQuestion].capitals
    }
    var answerThird: String {
        data.buttonThird[currentQuestion].capitals
    }
    var answerFourth: String {
        data.buttonFourth[currentQuestion].capitals
    }
    var background: UIColor {
        game.background
    }
    var data: (questions: [Countries], buttonFirst: [Countries],
               buttonSecond: [Countries], buttonThird: [Countries],
               buttonFourth: [Countries]) = ([], [], [], [], [])
    var time: Int {
        isOneQuestion() ? oneQuestionTime : allQuestionsTime
    }
    var radius: CGFloat = 6
    var circleTimeElapsed: Int {
        isOneQuestion() ? oneQuestionTime : seconds / 10
    }
    var timer = Timer()
    var labelNumberQuiz: String {
        "\(currentQuestion + 1) / \(countQuestions)"
    }
    var answerSelect = false
    
    var imageFlagSpring: NSLayoutConstraint!
    var labelNameSpring: NSLayoutConstraint!
    var stackViewSpring: NSLayoutConstraint!
    var widthOfFlag: NSLayoutConstraint!
    
    let mode: Setting
    let game: Games
    
    private var buttonFirst: UIButton!
    private var buttonSecond: UIButton!
    private var buttonThird: UIButton!
    private var buttonFourth: UIButton!
    private var imageFlag: UIImageView!
    private var labelCountry: UILabel!
    
    private let shapeLayer = CAShapeLayer()
    private var seconds = 0
    
    private var oneQuestionTime: Int {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
    }
    private var allQuestionsTime: Int {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
    }
    
    private var correctAnswers: [Countries] = []
    private var incorrectAnswers: [Results] = []
    private var spendTime: [CGFloat] = []
    
    required init(mode: Setting, game: Games) {
        self.mode = mode
        self.game = game
    }
    // MARK: - Set subviews
    func setSubviews(_ buttonOne: UIButton, _ buttonTwo: UIButton, 
                    _ buttonThree: UIButton, _ buttonFour: UIButton, 
                    _ image: UIImageView, _ label: UILabel) {
        buttonFirst = buttonOne
        buttonSecond = buttonTwo
        buttonThird = buttonThree
        buttonFourth = buttonFour
        imageFlag = image
        labelCountry = label
    }
    
    func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    func setBarButton(_ button: UIButton, _ navigationItem: UINavigationItem) {
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButton
    }
    
    func setEnabled(controls: UIControl..., isEnabled: Bool) {
        controls.forEach { control in
            control.isEnabled = isEnabled
        }
    }
    // MARK: - Set title from run timer
    func setTitleTimer(_ labelTimer: UILabel, completion: @escaping () -> Void) {
        setCountdownSeconds(1)
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
    // MARK: - Constants
    func isFlag() -> Bool {
        mode.flag ? true : false
    }
    func isOneQuestion() -> Bool {
        mode.timeElapsed.questionSelect.oneQuestion ? true : false
    }
    func isCountdown() -> Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    func checkWidthFlag(_ flag: String) -> CGFloat {
        switch flag {
        case "nepal", "vatican city", "switzerland": return 168
        default: return 280
        }
    }
    func widthButton(_ view: UIView) -> CGFloat {
        view.bounds.width - 40
    }
    func widthLabel(_ view: UIView) -> CGFloat {
        view.bounds.width - 20
    }
    // MARK: - Move subviews
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
    func animationSubviews(duration: CGFloat, _ view: UIView) {
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
    // MARK: - Get countries for questions
    func getQuestions() {
        let randomCountries = getRandomCountries()
        let questions = getRandomQuestions(randomCountries: randomCountries)
        let choosingAnswers = getChoosingAnswers(questions: questions, randomCountries: randomCountries)
        let answers = getAnswers(choosingAnswers: choosingAnswers)
        data = (questions, answers.buttonFirst, answers.buttonSecond, answers.buttonThird, answers.buttonFourth)
    }
    // MARK: - Set time
    func setTime() {
        if !isOneQuestion(), currentQuestion < 1 {
            setCountdownSeconds(time * 10)
        } else if isOneQuestion() {
            setCountdownSeconds(time * 10)
        }
    }
    // MARK: - Animation label description and label number
    func showDescription(_ labelQuiz: UILabel, _ labelDescription: UILabel) {
        showDescription(labelDescription)
        animationHideQuizShowDescription(labelQuiz, labelDescription)
    }
    
    func animationShowQuizHideDescription(_ labelQuiz: UILabel, _ labelDescription: UILabel) {
        setOpacity(subviews: labelQuiz, opacity: 1, duration: 1)
        guard labelDescription.layer.opacity == 1 else { return }
        setOpacity(subviews: labelDescription, opacity: 0, duration: 0)
    }
    // MARK: - Zeroing out data
    func exitToGameType() {
        timer.invalidate()
        setCountdownSeconds(0)
        setNextCurrentQuestion(0)
    }
    // MARK: - Set circle timer
    func setCircleTime(_ labelTimer: UILabel, _ view: UIView) {
        circularShadow(labelTimer, view)
        circular(strokeEnd: 0, labelTimer, view)
        animationCircleTimeReset()
    }
    
    func checkSetCircularStrokeEnd() {
        if isOneQuestion(), isCountdown() {
            shapeLayer.strokeEnd = 1
        } else if !isOneQuestion(), isCountdown(), currentQuestion < 1 {
            shapeLayer.strokeEnd = 1
        }
    }
    
    func animationCircleCountdown() {
        let timer = circleTimeElapsed
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 0
        animation.duration = CFTimeInterval(timer)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
    
    func stopAnimationCircleTimer() {
        let oneQuestionTime = time * 10
        let time = CGFloat(seconds) / CGFloat(oneQuestionTime)
        let result = round(100 * time) / 100
        shapeLayer.removeAnimation(forKey: "animation")
        shapeLayer.strokeEnd = result
    }
    
    func checkTimeSpent() {
        if isOneQuestion() {
            setTimeSpent()
        } else if !isOneQuestion(), currentQuestion + 1 == countQuestions {
            setTimeSpent()
        }
    }
    // MARK: - Check answer from select user
    func checkAnswer(button: UIButton, completion: @escaping () -> Void) {
        timer.invalidate()
        answerSelect.toggle()
        checkButton(tag: button.tag, button: button)
        disableButton(buttons: buttonFirst, buttonSecond, buttonThird, buttonFourth, tag: button.tag)
        setEnabled(controls: buttonFirst, buttonSecond, buttonThird, buttonFourth, isEnabled: false)
        completion()
    }
    
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
    // MARK: - Time up
    func timeUp(_ labelQuiz: UILabel, _ labelDescription: UILabel) {
        answerSelect.toggle()
        addIncorrectAnswer(0)
        showDescription(labelQuiz, labelDescription)
        disableButton(buttons: buttonFirst, buttonSecond, buttonThird, buttonFourth, tag: 0)
        setEnabled(controls: buttonFirst, buttonSecond, buttonThird, buttonFourth, isEnabled: false)
        guard !isOneQuestion() else { return }
        currentQuestion = countQuestions
    }
    // MARK: - Run next question
    func runNextQuestion() {
        timer.invalidate()
        answerSelect.toggle()
    }
    // MARK: - Update data for next question
    func updateData(_ labelTimer: UILabel,_ view: UIView) {
        isFlag() ? updateImageFlag() : updateLabelCountry()
        updateTitleButtons()
        resetButtons(buttonFirst, buttonSecond, buttonThird, buttonFourth)
        guard isCountdown() else { return }
        resetTimer(labelTimer: labelTimer, view: view)
    }
    // MARK: - Transition to ResultsViewController
    func resultsViewController() -> ResultsViewModelProtocol {
        ResultsViewModel(mode: mode, game: game, correctAnswers: correctAnswers,
                         incorrectAnswers: incorrectAnswers, spendTime: spendTime)
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
    // MARK: - Set animations subviews
    private func animationHideQuizShowDescription(_ labelQuiz: UILabel, _ labelDescription: UILabel) {
        setOpacity(subviews: labelQuiz, opacity: 0, duration: 0.5)
        setFlash(subviews: labelDescription, opacity: 1)
    }
    
    private func setOpacity(subviews: UIView..., opacity: Float, duration: CGFloat) {
        UIView.animate(withDuration: duration) {
            subviews.forEach { subview in
                subview.layer.opacity = opacity
            }
        }
    }
    
    private func setFlash(subviews: UIView..., opacity: Float) {
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            subviews.forEach { subview in
                subview.layer.opacity = opacity
            }
        })
    }
    // MARK: - Animation label description and label number, countinue
    private func showDescription(_ label: UILabel) {
        guard currentQuestion == countQuestions - 1 else { return }
        let red = UIColor.lightPurplePink
        label.text = "Коснитесь экрана, чтобы завершить"
        label.textColor = red
    }
    // MARK: - Set seconds
    private func setCountdownSeconds(_ time: Int) {
        if time == 1 {
            seconds -= time
        } else {
            seconds = time
        }
    }
    // MARK: - Add correct answer after select from user
    private func addCorrectAnswer() {
        correctAnswers.append(data.questions[currentQuestion])
    }
    // MARK: - Set circle timer, countinue
    private func circularShadow(_ labelTimer: UILabel, _ view: UIView) {
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
    
    private func circular(strokeEnd: CGFloat, _ labelTimer: UILabel, _ view: UIView) {
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
    
    private func animationCircleTimeReset() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = CFTimeInterval(0.4)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
    // MARK: - Time spent for every answer
    private func setTimeSpent() {
        let circleTimeSpent = 1 - shapeLayer.strokeEnd
        let seconds = time
        let timeSpent = circleTimeSpent * CGFloat(seconds)
        spendTime.append(timeSpent)
    }
    // MARK: - Check answer from select user, countinue
    private func checkButton(tag: Int, button: UIButton) {
        let green = UIColor.greenYellowBrilliant
        let red = UIColor.bismarkFuriozo
        let white = UIColor.white
        
        if checkAnswer(tag: tag) {
            setButtonColor(button: button, color: green, titleColor: white)
            addCorrectAnswer()
        } else {
            setButtonColor(button: button, color: red, titleColor: white)
            addIncorrectAnswer(tag)
        }
    }
    // MARK: - Check correct or incorrect answer from select user
    private func checkAnswer(tag: Int) -> Bool {
        switch tag {
        case 1: return data.questions[currentQuestion] == data.buttonFirst[currentQuestion] ? true : false
        case 2: return data.questions[currentQuestion] == data.buttonSecond[currentQuestion] ? true : false
        case 3: return data.questions[currentQuestion] == data.buttonThird[currentQuestion] ? true : false
        default: return data.questions[currentQuestion] == data.buttonFourth[currentQuestion] ? true : false
        }
    }
    // MARK: - Button animation from select user
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
        }
    }
    // MARK: - Add incorrect answer select from user
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
    // MARK: - Update data for next question, countinue
    private func updateImageFlag() {
        imageFlag.image = UIImage(named: question)
        widthOfFlag.constant = checkWidthFlag(question)
    }
    
    private func updateLabelCountry() {
        labelCountry.text = question
    }
    
    private func updateTitleButtons() {
        buttonFirst.setTitle(answerFirst, for: .normal)
        buttonSecond.setTitle(answerSecond, for: .normal)
        buttonThird.setTitle(answerThird, for: .normal)
        buttonFourth.setTitle(answerFourth, for: .normal)
    }
    // MARK: - Reset title timer and color buttons
    private func resetTimer(labelTimer: UILabel, view: UIView) {
        if isOneQuestion(), seconds > 0 {
            resetTitleAndCircleTimer(labelTimer: labelTimer)
        } else if isOneQuestion(), seconds == 0 {
            circular(strokeEnd: 0, labelTimer, view)
            resetTitleAndCircleTimer(labelTimer: labelTimer)
        }
    }
    
    private func resetTitleAndCircleTimer(labelTimer: UILabel) {
        labelTimer.text = "\(time)"
        animationCircleTimeReset()
    }
    
    private func resetButtons(_ buttons: UIButton...) {
        let white = UIColor.white
        let blue = UIColor.blueBlackSea
        buttons.forEach { button in
            setButtonColor(button: button, color: white, titleColor: blue)
        }
    }
}
