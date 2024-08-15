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
    var answerFirst: Countries { get }
    var answerSecond: Countries { get }
    var answerThird: Countries { get }
    var answerFourth: Countries { get }
    var background: UIColor { get }
    var isFlag: Bool { get }
    var isOneQuestion: Bool { get }
    var isCountdown: Bool { get }
    var time: Int { get }
    var radius: CGFloat { get }
    var circleTimeElapsed: Int { get }
    var timer: Timer { get set }
    var titleNumberNil: String { get }
    var titleNumber: String { get }
    var titleQuiz: String { get }
    var titleDescription: String { get }
    var answerSelect: Bool { get }
    
    init(mode: Setting, game: Games)
    
    func setupSubviews(subviews: UIView..., on subviewOther: UIView)
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func question() -> UIView
    func setLabel(_ title: String, size: CGFloat, color: UIColor, and opacity: Float) -> UILabel
    func setStackView(_ first: UIButton,_ second: UIButton,_ third: UIButton,_ fourth: UIButton) -> UIStackView
    func setButton(_ button: UIButton, tag: Int)
    
    func setEnabled(controls: UIControl..., isEnabled: Bool)
    func setTitleTimer(_ labelTimer: UILabel, completion: @escaping () -> Void)
    func setNextCurrentQuestion(_ number: Int)
    func setCircleTime(_ labelTimer: UILabel,_ view: UIView)
    func checkSetCircularStrokeEnd()
    func animationCircleCountdown()
    func stopAnimationCircleTimer()
    func checkTimeSpent()
    func addAnsweredQuestion()
    
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
    func updateData(_ question: UIView,_ labelTimer: UILabel,_ view: UIView)
    
    func constraintsTimer(_ labelTimer: UILabel,_ view: UIView)
    func setSquare(button: UIButton, sizes: CGFloat)
    func constraintsIssue(_ question: UIView,_ view: UIView)
    func progressView(_ progressView: UIProgressView, on issue: UIView,_ view: UIView)
    func constraintsButtons(_ stackViewFlag: UIStackView,to labelQuiz: UILabel,_ view: UIView)
    func resultsViewController() -> ResultsViewModelProtocol
}

class QuizOfCapitalsViewModel: QuizOfCapitalsViewModelProtocol {
    var countQuestions: Int {
        mode.countQuestions
    }
    var currentQuestion = 0
    var answerFirst: Countries {
        data.buttonFirst[currentQuestion]
    }
    var answerSecond: Countries {
        data.buttonSecond[currentQuestion]
    }
    var answerThird: Countries {
        data.buttonThird[currentQuestion]
    }
    var answerFourth: Countries {
        data.buttonFourth[currentQuestion]
    }
    var background: UIColor {
        game.background
    }
    var isFlag: Bool {
        mode.flag ? true : false
    }
    var time: Int {
        isOneQuestion ? oneQuestionTime : allQuestionsTime
    }
    var isOneQuestion: Bool {
        mode.timeElapsed.questionSelect.oneQuestion ? true : false
    }
    var isCountdown: Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    var radius: CGFloat = 6
    var circleTimeElapsed: Int {
        isOneQuestion ? oneQuestionTime : seconds / 10
    }
    var timer = Timer()
    var titleNumberNil: String {
        "0 / \(countQuestions)"
    }
    var titleNumber: String {
        "\(currentQuestion + 1) / \(countQuestions)"
    }
    var titleQuiz = "Выберите правильный ответ"
    var titleDescription = "Коснитесь экрана, чтобы продолжить"
    var answerSelect = false
    
    private var issueSpring: NSLayoutConstraint!
    private var stackViewSpring: NSLayoutConstraint!
    private var widthOfFlag: NSLayoutConstraint!
    
    private let mode: Setting
    private let game: Games
    
    private var buttonFirst: UIButton!
    private var buttonSecond: UIButton!
    private var buttonThird: UIButton!
    private var buttonFourth: UIButton!
    
    private let shapeLayer = CAShapeLayer()
    private var seconds = 0
    
    private var oneQuestionTime: Int {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
    }
    private var allQuestionsTime: Int {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
    }
    private var item: Countries {
        data.questions[currentQuestion]
    }
    private var issue: String {
        isFlag ? item.flag : item.name
    }
    
    private var data: (questions: [Countries], buttonFirst: [Countries],
                       buttonSecond: [Countries], buttonThird: [Countries],
                       buttonFourth: [Countries]) = ([], [], [], [], [])
    private var correctAnswers: [Corrects] = []
    private var incorrectAnswers: [Incorrects] = []
    private var timeSpend: [CGFloat] = []
    private var answeredQuestions = 0
    
    required init(mode: Setting, game: Games) {
        self.mode = mode
        self.game = game
    }
    // MARK: - Set subviews
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
    
    func question() -> UIView {
        if isFlag {
            setImage(image: issue)
        } else {
            setLabel(issue, size: 32, color: .white, and: 1)
        }
    }
    
    func setLabel(_ title: String, size: CGFloat, color: UIColor, 
                  and opacity: Float) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = color
        label.textAlignment = .center
        label.layer.opacity = opacity
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setStackView(_ first: UIButton, _ second: UIButton, 
                      _ third: UIButton, _ fourth: UIButton) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [first, second, third, fourth])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    func setButton(_ button: UIButton, tag: Int) {
        switch tag {
        case 1: buttonFirst = button
        case 2: buttonSecond = button
        case 3: buttonThird = button
        default: buttonFourth = button
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
    // MARK: - Move subviews
    func runMoveSubviews(_ view: UIView) {
        let pointX: CGFloat = currentQuestion > 0 ? 2 : 1
        issueSpring.constant += view.bounds.width * pointX
        stackViewSpring.constant += view.bounds.width * pointX
    }
    // MARK: - Animation move subviews
    func animationSubviews(duration: CGFloat, _ view: UIView) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) { [self] in
            issueSpring.constant -= view.bounds.width
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
        if !isOneQuestion, currentQuestion < 1 {
            setCountdownSeconds(time * 10)
        } else if isOneQuestion {
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
        if isOneQuestion, isCountdown {
            shapeLayer.strokeEnd = 1
        } else if !isOneQuestion, isCountdown, currentQuestion < 1 {
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
        if isOneQuestion {
            setTimeSpent()
        } else if !isOneQuestion, currentQuestion + 1 == countQuestions {
            setTimeSpent()
        }
    }
    // MARK: - Calc answered questions
    func addAnsweredQuestion() {
        answeredQuestions += 1
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
    
    // MARK: - Time up
    func timeUp(_ labelQuiz: UILabel, _ labelDescription: UILabel) {
        answerSelect.toggle()
        addIncorrectAnswer(0)
        showDescription(labelQuiz, labelDescription)
        disableButton(buttons: buttonFirst, buttonSecond, buttonThird, buttonFourth, tag: 0)
        setEnabled(controls: buttonFirst, buttonSecond, buttonThird, buttonFourth, isEnabled: false)
        guard !isOneQuestion else { return }
        currentQuestion = countQuestions
    }
    // MARK: - Run next question
    func runNextQuestion() {
        timer.invalidate()
        answerSelect.toggle()
    }
    // MARK: - Update data for next question
    func updateData(_ question: UIView, _ labelTimer: UILabel, _ view: UIView) {
        isFlag ? updateFlag(image(question)) : updateName(label(question))
        updateTitleButtons()
        resetButtons(buttonFirst, buttonSecond, buttonThird, buttonFourth)
        guard isCountdown else { return }
        resetTimer(labelTimer: labelTimer, view: view)
    }
    // MARK: - Constraints
    func constraintsTimer(_ labelTimer: UILabel, _ view: UIView) {
        NSLayoutConstraint.activate([
            labelTimer.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            labelTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setSquare(button: UIButton, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: sizes),
            button.widthAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    func constraintsIssue(_ question: UIView, _ view: UIView) {
        if isFlag {
            constraintsFlag(question as! UIImageView, view)
        } else {
            constraintsLabel(question as! UILabel, view)
        }
    }
    
    func progressView(_ progressView: UIProgressView, on issue: UIView, _ view: UIView) {
        let layout = isFlag ? issue.bottomAnchor : view.safeAreaLayoutGuide.topAnchor
        let constant: CGFloat = isFlag ? 30 : 140
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: layout, constant: constant),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.heightAnchor.constraint(equalToConstant: radius * 2)
        ])
    }
    
    func constraintsButtons(_ stackViewFlag: UIStackView, to labelQuiz: UILabel, 
                            _ view: UIView) {
        stackViewSpring = NSLayoutConstraint(
            item: stackViewFlag, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(stackViewSpring)
        NSLayoutConstraint.activate([
            stackViewFlag.topAnchor.constraint(equalTo: labelQuiz.bottomAnchor, constant: 25),
            stackViewFlag.widthAnchor.constraint(equalToConstant: widthButton(view)),
            stackViewFlag.heightAnchor.constraint(equalToConstant: 215)
        ])
    }
    // MARK: - Transition to ResultsViewController
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
        timeSpend.append(timeSpent)
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
    
    private func addCorrectAnswer() {
        let answer = Corrects(currentQuestion: currentQuestion + 1, question: item,
                              buttonFirst: answerFirst, buttonSecond: answerSecond,
                              buttonThird: answerThird, buttonFourth: answerFourth)
        correctAnswers.append(answer)
    }
    
    private func addIncorrectAnswer(_ tag: Int) {
        let setTag = tag == 0 ? 0 : tag
        let timeUp = tag == 0 ? true : false
        let answer = Incorrects(currentQuestion: currentQuestion + 1, tag: setTag,
                                question: item, buttonFirst: answerFirst,
                                buttonSecond: answerSecond, buttonThird: answerThird,
                                buttonFourth: answerFourth, isFlag: isFlag, timeUp: timeUp)
        incorrectAnswers.append(answer)
    }
    // MARK: - Check correct or incorrect answer from select user
    private func checkAnswer(tag: Int) -> Bool {
        switch tag {
        case 1: return item == answerFirst ? true : false
        case 2: return item == answerSecond ? true : false
        case 3: return item == answerThird ? true : false
        default: return item == answerFourth ? true : false
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
        let white = UIColor.whiteAlpha
        
        buttons.forEach { button in
            if !(button.tag == tag) {
                setButtonColor(button: button, color: white, titleColor: gray)
            }
        }
    }
    // MARK: - Add correct / incorrect answer after select from user, countinue
//    private func addCorrectAnswer(numberQuestion: Int, question: Countries,
//                                  buttonFirst: Countries, buttonSecond: Countries,
//                                  buttonThird: Countries, buttonFourth: Countries) {
//        let answer = Corrects(currentQuestion: numberQuestion, question: question,
//                              buttonFirst: buttonFirst, buttonSecond: buttonSecond,
//                              buttonThird: buttonThird, buttonFourth: buttonFourth)
//        correctAnswers.append(answer)
//    }
    // MARK: - Update data for next question, countinue
    private func image(_ question: UIView) -> UIImageView {
        question as! UIImageView
    }
    
    private func label(_ question: UIView) -> UILabel {
        question as! UILabel
    }
    
    private func updateFlag(_ image: UIImageView) {
        image.image = UIImage(named: issue)
        widthOfFlag.constant = checkWidthFlag(issue)
    }
    
    private func updateName(_ label: UILabel) {
        label.text = issue
    }
    
    private func updateTitleButtons() {
        buttonFirst.setTitle(answerFirst.capitals, for: .normal)
        buttonSecond.setTitle(answerSecond.capitals, for: .normal)
        buttonThird.setTitle(answerThird.capitals, for: .normal)
        buttonFourth.setTitle(answerFourth.capitals, for: .normal)
    }
    // MARK: - Reset title timer and color buttons
    private func resetTimer(labelTimer: UILabel, view: UIView) {
        if isOneQuestion, seconds > 0 {
            resetTitleAndCircleTimer(labelTimer: labelTimer)
        } else if isOneQuestion, seconds == 0 {
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
// MARK: - Private methods, constants
extension QuizOfCapitalsViewModel {
    private func checkWidthFlag(_ flag: String) -> CGFloat {
        switch flag {
        case "nepal", "vatican city", "switzerland": return 168
        default: return 280
        }
    }
    
    private func widthButton(_ view: UIView) -> CGFloat {
        view.bounds.width - 40
    }
    
    private func widthLabel(_ view: UIView) -> CGFloat {
        view.bounds.width - 20
    }
}
// MARK: - Private methods, constraints
extension QuizOfCapitalsViewModel {
    func constraintsFlag(_ image: UIImageView, _ view: UIView) {
        widthOfFlag = image.widthAnchor.constraint(equalToConstant: checkWidthFlag(issue))
        issueSpring = NSLayoutConstraint(
            item: image, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(issueSpring)
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65),
            widthOfFlag,
            image.heightAnchor.constraint(equalToConstant: 168)
        ])
    }
    
    func constraintsLabel(_ label: UILabel, _ view: UIView) {
        issueSpring = NSLayoutConstraint(
            item: label, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(issueSpring)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65),
            label.widthAnchor.constraint(equalToConstant: widthLabel(view))
        ])
    }
}
// MARK: - Private methods, subviews
extension QuizOfCapitalsViewModel {
    private func setImage(image: String) -> UIImageView {
        let image = UIImage(named: image)
        let imageView = UIImageView(image: image)
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
