//
//  QuestionnaireViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 11.04.2024.
//

import UIKit

protocol QuestionnaireViewModelProtocol {
    var countQuestions: Int { get }
    var currentQuestion: Int { get }
    var numberQuestion: Int { get }
    var time: Int { get }
    var background: UIColor { get }
    var height: CGFloat { get }
    var radius: CGFloat { get }
    var titleNumber: String { get }
    var titleQuiz: String { get }
    var titleDescription: String { get }
    var timer: Timer { get set }
    var countdown: Timer { get set }
    var lastQuestion: Bool { get }
    var isFlag: Bool { get }
    var isCountdown: Bool { get }
    var checkCurrentQuestion: Int { get }
    
    var answerFirst: Countries { get }
    var answerSecond: Countries { get }
    var answerThird: Countries { get }
    var answerFourth: Countries { get }
    
    var shapeLayer: CAShapeLayer { get }
    
    init(mode: Setting, game: Games)
    
    func setSubviews(subviews: UIView..., on subviewOther: UIView)
    func setOpacity(subviews: UIView..., opacity: Float, duration: CGFloat)
    func setFlash(subviews: UIView..., opacity: Float)
    func setEnabled(subviews: UIControl..., isEnabled: Bool)
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func isEnabledButtons(isOn: Bool)
    func question() -> UIView
    func setLabel(_ title: String, size: CGFloat, color: UIColor, and opacity: Float) -> UILabel
    func setLabel(_ title: String, size: CGFloat, and opacity: Float, tag: Int) -> UILabel
    func stackView(_ first: UIButton,_ second: UIButton,_ third: UIButton,_ fourth: UIButton) -> UIStackView
    func setCheckmark(tag: Int) -> UIImageView
    func setImage(image: Countries, tag: Int) -> UIImageView
    func setButton(button: UIButton, tag: Int)
    
    func action(_ button: UIButton,_ buttonBack: UIButton,_ buttonForward: UIButton)
    func progressView(_ progressView: UIProgressView)
    
    func getQuestions()
    func showLabelQuiz(_ label: UILabel, duration: CGFloat, opacity: Float)
    func moveSubviews(_ view: UIView)
    func moveBackSubviews(_ view: UIView)
    func animationSubviews(duration: CGFloat,_ view: UIView)
    func animationBackSubviews(_ view: UIView)
    func setCurrentQuestion(_ number: Int)
    func setNumberQuestion(_ number: Int)
    func setColorButtonsDisabled(_ tag: Int)
    func setCheckmarksDisabled(_ tag: Int)
    func setLabelsDisabled(_ tag: Int)
    func selectAnswerForLastQuestion(_ labelQuiz: UILabel,_ labelDescription: UILabel)
    
    func setCircleTimer(_ labelTimer: UILabel,_ view: UIView)
    func updateNumberQuestion(_ labelNumber: UILabel)
    func setTime()
    func runCircleTimer()
    func setTitleTimer(_ labelTimer: UILabel, completion: @escaping () -> Void)
    func setSeconds(_ time: Int)
    func setLastQuestion(_ isLast: Bool)
    func showFinishTitle(_ labelQuiz: UILabel,_ labelDescription: UILabel)
    func endGame(_ labelQuiz: UILabel,_ labelDescription: UILabel)
    func checkLastQuestionForShowTitle(_ labelQuiz: UILabel,_ labelDescription: UILabel)
    func checkTimeUp(completion: @escaping () -> Void)
    func buttonsBackForwardOnOff(_ buttonBack: UIButton,_ buttonForward: UIButton)
    func updateData(_ question: UIView,_ view: UIView)
    func setSelectedResponse()
    func stopTimer()
    func setTimeSpent()
    
    func setSquare(subview: UIView, sizes: CGFloat)
    func constraintsTimer(_ labelTimer: UILabel,_ view: UIView)
    func constraintsIssue(_ question: UIView,_ view: UIView)
    func progressView(_ progressView: UIProgressView, on issue: UIView,_ view: UIView)
    func constraintsButton(_ button: UIButton,_ question: UIView,_ view: UIView)
    func button(_ subview: UIStackView,to labelQuiz: UILabel,_ view: UIView)
    func constraintsOnButton(_ image: UIImageView,and label: UILabel,on button: UIButton)
    func imagesOnButton(_ checkmark: UIImageView, and image: UIImageView,on button: UIButton,_ view: UIView)
    func resultsViewController() -> ResultsViewModelProtocol
}

class QuestionnaireViewModel: QuestionnaireViewModelProtocol {
    var countQuestions: Int {
        mode.countQuestions
    }
    var currentQuestion = 0
    var numberQuestion = 0
    var time: Int {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
    }
    var answerFirst: Countries {
        data.buttonFirst[numberQuestion]
    }
    var answerSecond: Countries {
        data.buttonSecond[numberQuestion]
    }
    var answerThird: Countries {
        data.buttonThird[numberQuestion]
    }
    var answerFourth: Countries {
        data.buttonFourth[numberQuestion]
    }
    var background: UIColor {
        game.background
    }
    var height: CGFloat {
        isFlag ? 215 : 235
    }
    var radius: CGFloat = 6
    var titleNumber: String {
        "0 / \(countQuestions)"
    }
    var titleQuiz = "Выберите правильные ответы"
    var titleDescription = "Коснитесь экрана, чтобы завершить"
    var timer = Timer()
    var countdown = Timer()
    var lastQuestion = false
    var isFlag: Bool {
        mode.flag ? true : false
    }
    var isCountdown: Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    var checkCurrentQuestion: Int {
        numberQuestion == currentQuestion ? currentQuestion : numberQuestion
    }
    
    var shapeLayer = CAShapeLayer()
    
    private var data: (questions: [Countries], buttonFirst: [Countries],
                       buttonSecond: [Countries], buttonThird: [Countries],
                       buttonFourth: [Countries]) = ([], [], [], [], [])
    
    private var issueSpring: NSLayoutConstraint!
    private var stackViewSpring: NSLayoutConstraint!
    
    private var widthOfFlagFirst: NSLayoutConstraint!
    private var widthOfFlagSecond: NSLayoutConstraint!
    private var widthOfFlagThird: NSLayoutConstraint!
    private var widthOfFlagFourth: NSLayoutConstraint!
    
    private let mode: Setting
    private let game: Games
    
    private var seconds = 0
    
    private var correctAnswers: [Corrects] = []
    private var incorrectAnswers: [Results] = []
    private var timeSpend: [CGFloat] = []
    private var answeredQuestions = 0
    private var item: Countries {
        data.questions[numberQuestion]
    }
    private var issue: String {
        isFlag ? item.flag : item.name
    }
    private var responseFirst: Countries {
        data.buttonFirst[checkCurrentQuestion]
    }
    private var responseSecond: Countries {
        data.buttonSecond[checkCurrentQuestion]
    }
    private var responseThird: Countries {
        data.buttonThird[checkCurrentQuestion]
    }
    private var responseFourth: Countries {
        data.buttonFourth[checkCurrentQuestion]
    }
    
    private var buttonFirst: UIButton!
    private var buttonSecond: UIButton!
    private var buttonThird: UIButton!
    private var buttonFourth: UIButton!
    
    private var checkmarkFirst: UIImageView!
    private var checkmarkSecond: UIImageView!
    private var checkmarkThird: UIImageView!
    private var checkmarkFourth: UIImageView!
    
    private var imageFirst: UIImageView!
    private var imageSecond: UIImageView!
    private var imageThird: UIImageView!
    private var imageFourth: UIImageView!
    
    private var labelFirst: UILabel!
    private var labelSecond: UILabel!
    private var labelThird: UILabel!
    private var labelFourth: UILabel!
    
    private var progressView: UIProgressView!
    
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
    
    func setOpacity(subviews: UIView..., opacity: Float, duration: CGFloat) {
        UIView.animate(withDuration: duration) {
            subviews.forEach { subview in
                subview.layer.opacity = opacity
            }
        }
    }
    
    func setFlash(subviews: UIView..., opacity: Float) {
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            subviews.forEach { subview in
                subview.layer.opacity = opacity
            }
        })
    }
    
    func setEnabled(subviews: UIControl..., isEnabled: Bool) {
        subviews.forEach { subview in
            subview.isEnabled = isEnabled
        }
    }
    
    func setBarButton(_ button: UIButton, _ navigationItem: UINavigationItem) {
        let leftBarButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = leftBarButton
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
        label.numberOfLines = 0
        label.textAlignment = .center
        label.layer.opacity = opacity
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func setLabel(_ title: String, size: CGFloat, and opacity: Float, 
                  tag: Int) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.layer.opacity = opacity
        label.tag = tag
        label.translatesAutoresizingMaskIntoConstraints = false
        setLabel(label: label, tag: tag)
        return label
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
    
    func setCheckmark(tag: Int) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: 26)
        let image = UIImage(systemName: "circle", withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.tag = tag
        imageView.translatesAutoresizingMaskIntoConstraints = false
        setCheckmark(imageView: imageView, tag: tag)
        return imageView
    }
    
    func setImage(image: Countries, tag: Int) -> UIImageView {
        let image = UIImage(named: image.flag)
        let imageView = UIImageView(image: image)
        imageView.tag = tag
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        setImage(imageView: imageView, tag: tag)
        return imageView
    }
    
    func setButton(button: UIButton, tag: Int) {
        switch tag {
        case 1: buttonFirst = button
        case 2: buttonSecond = button
        case 3: buttonThird = button
        default: buttonFourth = button
        }
    }
    
    func progressView(_ subview: UIProgressView) {
        progressView = subview
    }
    // MARK: - Button action when user select answer
    func action(_ button: UIButton, _ buttonBack: UIButton, _ buttonForward: UIButton) {
        setSelectButton(button)
        checkCorrectAnswer(button.tag)
        setAppearenceButtons(button)
        isEnabledButtons(isOn: false)
        checkLastQuestion(buttonBack, buttonForward)
        
        guard numberQuestion == currentQuestion else { return }
        setProgressView(progressView)
        addAnsweredQuestion()
    }
    // MARK: - Get countries for questions
    func getQuestions() {
        let randomCountries = getRandomCountries()
        let questions = getRandomQuestions(randomCountries: randomCountries)
        let choosingAnswers = getChoosingAnswers(questions: questions, randomCountries: randomCountries)
        let answers = getAnswers(choosingAnswers: choosingAnswers)
        data = (questions, answers.buttonFirst, answers.buttonSecond, answers.buttonThird, answers.buttonFourth)
    }
    // MARK: - Buttons for answers are enabled on / off
    func isEnabledButtons(isOn: Bool) {
        setEnabled(subviews: buttonFirst, buttonSecond, buttonThird, buttonFourth, isEnabled: isOn)
    }
    // MARK: - Show label for questionnaire
    func showLabelQuiz(_ label: UILabel, duration: CGFloat, opacity: Float) {
        guard currentQuestion == 0 else { return }
        setOpacity(subviews: label, opacity: opacity, duration: duration)
    }
    // MARK: - Move subviews
    func moveSubviews(_ view: UIView) {
        let pointX: CGFloat = currentQuestion > 0 ? 2 : 1
        issueSpring.constant += view.frame.width * pointX
        stackViewSpring.constant += view.frame.width * pointX
    }
    
    func moveBackSubviews(_ view: UIView) {
        issueSpring.constant -= view.frame.width * 2
        stackViewSpring.constant -= view.frame.width * 2
    }
    // MARK: - Animation move subviews
    func animationSubviews(duration: CGFloat, _ view: UIView) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) { [self] in
            issueSpring.constant -= view.bounds.width
            stackViewSpring.constant -= view.bounds.width
            view.layoutIfNeeded()
        }
    }
    
    func animationBackSubviews(_ view: UIView) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) { [self] in
            issueSpring.constant += view.bounds.width
            stackViewSpring.constant += view.bounds.width
            view.layoutIfNeeded()
        }
    }
    // MARK: - Set current question / number question
    func setCurrentQuestion(_ number: Int) {
        if number == 1 {
            currentQuestion += number
        } else {
            currentQuestion = number
        }
    }
    
    func setNumberQuestion(_ number: Int) {
        if number == 0 {
            numberQuestion = number
        } else {
            numberQuestion += number
        }
    }
    // MARK: - Set circle time
    func setCircleTimer(_ labelTimer: UILabel, _ view: UIView) {
        circleShadow(labelTimer, view)
        circle(0, labelTimer, view)
        animationCircleTimeReset()
    }
    // MARK: - Refresh data for show next / previous question
    func updateNumberQuestion(_ labelNumber: UILabel) {
        labelNumber.text = "\(checkCurrentQuestion + 1) / \(countQuestions)"
    }
    
    func updateData(_ question: UIView, _ view: UIView) {
        if isFlag {
            updateDataFlag(question as! UIImageView)
        } else {
            updateDataLabel(question as! UILabel, view: view)
        }
    }
    // MARK: - Set title time
    func setTime() {
        seconds = time * 10
    }
    // MARK: - Run circle timer
    func runCircleTimer() {
        shapeLayer.strokeEnd = 1
        animationCircleCountdown()
    }
    // MARK: - Set seconds
    func setSeconds(_ time: Int) {
        if time == 1 {
            seconds -= time
        } else {
            seconds = time
        }
    }
    // MARK: - Set title from timer
    func setTitleTimer(_ labelTimer: UILabel, completion: @escaping () -> Void) {
        setSeconds(1)
        guard seconds.isMultiple(of: 10) else { return }
        let text = seconds / 10
        labelTimer.text = "\(text)"
        
        guard seconds == 0 else { return }
        countdown.invalidate()
        completion()
    }
    // MARK: - Set last question
    func setLastQuestion(_ isLast: Bool) {
        lastQuestion = isLast
    }
    // MARK: - End game
    func showFinishTitle(_ labelQuiz: UILabel, _ labelDescription: UILabel) {
        setOpacity(subviews: labelQuiz, opacity: 0, duration: 0.5)
        setFlash(subviews: labelDescription, opacity: 1)
    }
    
    func endGame(_ labelQuiz: UILabel, _ labelDescription: UILabel) {
        labelDescription.text = "Время вышло! Коснитесь экрана, чтобы завершить"
        showFinishTitle(labelQuiz, labelDescription)
        setLastQuestion(true)
    }
    
    func checkLastQuestionForShowTitle(_ labelQuiz: UILabel, _ labelDescription: UILabel) {
        guard lastQuestion, numberQuestion == currentQuestion else { return }
        showFinishTitle(labelQuiz, labelDescription)
    }
    
    func checkTimeUp(completion: @escaping () -> Void) {
        seconds > 0 ? isEnabledButtons(isOn: true) : completion()
    }
    
    func selectAnswerForLastQuestion(_ labelQuiz: UILabel, _ labelDescription: UILabel) {
        setLastQuestion(true)
        showFinishTitle(labelQuiz, labelDescription)
    }
    // MARK: - Set on / off buttons back and forward
    func buttonsBackForwardOnOff(_ buttonBack: UIButton, _ buttonForward: UIButton) {
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
    // MARK: - Set color buttons, images and labels when user press button of answer
    func setColorButtonsDisabled(_ tag: Int) {
        setColorButtonsDisabled(buttons: buttonFirst, buttonSecond, buttonThird, buttonFourth, tag: tag)
    }
    
    func setCheckmarksDisabled(_ tag: Int) {
        setCheckmarksDisabled(images: checkmarkFirst, checkmarkSecond, checkmarkThird, checkmarkFourth, tag: tag)
    }
    
    func setLabelsDisabled(_ tag: Int) {
        setLabelsDisabled(labels: labelFirst, labelSecond, labelThird, labelFourth, tag: tag)
    }
    // MARK: - Set selected button for next / previous question
    func setSelectedResponse() {
        checkSelected(selects: answerFirst.select, answerSecond.select, answerThird.select, answerFourth.select)
    }
    // MARK: - Stop timer when game came to end
    func stopTimer() {
        guard seconds > 0 else { return }
        countdown.invalidate()
        let time = time * 10
        let timeSpent = CGFloat(seconds) / CGFloat(time)
        let strokeEnd = round(timeSpent * 100) / 100
        shapeLayer.strokeEnd = strokeEnd
    }
    // MARK: - Set time spent
    func setTimeSpent() {
        guard seconds > 0 else { return }
        let circleTimeSpent = 1 - shapeLayer.strokeEnd
        let time = time
        let timeSpent = circleTimeSpent * CGFloat(time)
        timeSpend.append(timeSpent)
    }
    // MARK: - Constraints
    func setSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    func constraintsTimer(_ labelTimer: UILabel, _ view: UIView) {
        NSLayoutConstraint.activate([
            labelTimer.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            labelTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
    
    func constraintsButton(_ button: UIButton, _ question: UIView, _ view: UIView) {
        let layout = isFlag ? question.centerYAnchor : question.topAnchor
        let layoutYAxis = isFlag ? button.centerYAnchor : button.topAnchor
        let constant = button.tag == 1 ? -setConstant(view) : setConstant(view)
        NSLayoutConstraint.activate([
            layoutYAxis.constraint(equalTo: layout),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant)
        ])
        setSquare(subview: button, sizes: 40)
    }
    
    func button(_ subview: UIStackView, to labelQuiz: UILabel, _ view: UIView) {
        stackViewSpring = NSLayoutConstraint(
            item: subview,
            attribute: .centerX, relatedBy: .equal, toItem: view,
            attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(stackViewSpring)
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: labelQuiz.bottomAnchor, constant: 25),
            subview.widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            subview.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func constraintsOnButton(_ image: UIImageView, and label: UILabel, on button: UIButton) {
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 50),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20)
        ])
    }
    
    func imagesOnButton(_ checkmark: UIImageView, and image: UIImageView, 
                        on button: UIButton, _ view: UIView) {
        let flag = flag(button)
        NSLayoutConstraint.activate([
            checkmark.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            checkmark.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 5),
            layoutConstraint(button, image, flag, view),
            image.heightAnchor.constraint(equalToConstant: setHeight()),
            image.centerXAnchor.constraint(equalTo: button.centerXAnchor, constant: setCenter(view)),
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
    }
    // MARK: - Transition to ResuiltViewController
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
    // MARK: - Set circle timer, countinue
    private func circleShadow(_ labelTimer: UILabel, _ view: UIView) {
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
    
    private func circle(_ strokeEnd: CGFloat, _ labelTimer: UILabel, _ view: UIView) {
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
    
    private func animationCircleCountdown() {
        let timer = time
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 0
        animation.duration = CFTimeInterval(timer)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
    // MARK: - Set progress view
    private func setProgressView(_ progressView: UIProgressView) {
        let interval: Float = 1 / Float(countQuestions)
        let progress = progressView.progress + interval
        
        UIView.animate(withDuration: 0.5) {
            progressView.setProgress(progress, animated: true)
        }
    }
    // MARK: - Show or hide buttons back and forward
    private func buttonsBackForward(buttonBack: UIButton, buttonForward: UIButton,
                                    opacityBack: Float, opacityForward: Float,
                                    isEnabledBack: Bool, isEnabledForward: Bool) {
        setOpacity(subviews: buttonBack, opacity: opacityBack, duration: 0.3)
        setOpacity(subviews: buttonForward, opacity: opacityForward, duration: 0.3)
        setEnabled(subviews: buttonBack, isEnabled: isEnabledBack)
        setEnabled(subviews: buttonForward, isEnabled: isEnabledForward)
    }
    // MARK: - Set select answer, countinue
    private func checkSelect(tag: Int) -> Bool {
        switch tag {
        case 1: return answerFirst.select
        case 2: return answerSecond.select
        case 3: return answerThird.select
        default: return answerFourth.select
        }
    }
    // MARK: - Check answer, select correct or incorrect answer by user
    private func checkCorrectAnswer(_ tag: Int) {
        if checkAnswer(tag: tag) {
            addCorrectAnswer()
            deleteIncorrectAnswer()
        } else {
            addIncorrectAnswer(tag: tag)
            deleteCorrectAnswer()
        }
    }
    
    private func checkAnswer(tag: Int) -> Bool {
        switch tag {
        case 1: return item.flag == answerFirst.flag ? true : false
        case 2: return item.flag == answerSecond.flag ? true : false
        case 3: return item.flag == answerThird.flag ? true : false
        default: return item.flag == answerFourth.flag ? true : false
        }
    }
    
    private func deleteCorrectAnswer() {
        guard !correctAnswers.isEmpty else { return }
        let topics = correctAnswers.map({ $0.question })
        guard let index = topics.firstIndex(of: item) else { return }
        correctAnswers.remove(at: index)
    }
    
    private func addCorrectAnswer() {
        addCorrectAnswer(numberQuestion: numberQuestion + 1,
                         question: item,
                         buttonFirst: answerFirst,
                         buttonSecond: answerSecond,
                         buttonThird: answerThird,
                         buttonFourth: answerFourth)
    }
    
    private func deleteIncorrectAnswer() {
        guard !incorrectAnswers.isEmpty else { return }
        let topics = incorrectAnswers.map({ $0.question })
        guard let index = topics.firstIndex(of: item) else { return }
        incorrectAnswers.remove(at: index)
    }
    
    private func addIncorrectAnswer(tag: Int) {
        addIncorrectAnswer(numberQuestion: numberQuestion + 1, tag: tag,
                           question: item,
                           buttonFirst: answerFirst,
                           buttonSecond: answerSecond,
                           buttonThird: answerThird,
                           buttonFourth: answerFourth,
                           timeUp: false)
    }
    
    private func addCorrectAnswer(numberQuestion: Int, question: Countries,
                                  buttonFirst: Countries, buttonSecond: Countries,
                                  buttonThird: Countries, buttonFourth: Countries) {
        let answer = Corrects(currentQuestion: numberQuestion, question: question,
                              buttonFirst: buttonFirst, buttonSecond: buttonSecond,
                              buttonThird: buttonThird, buttonFourth: buttonFourth)
        correctAnswers.append(answer)
    }
    
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
    // MARK: - Set color buttons, images and labels when user press button of answer, countinue
    private func setAppearenceButtons(_ button: UIButton) {
        setButtonsSelect(button: button)
        setCheckmarksSelect(button: button)
        guard isFlag else { return }
        setLabelsSelect(button: button)
    }
    // MARK: - OnOff button back and forward
    private func checkLastQuestion(_ buttonBack: UIButton, _ buttonForward: UIButton) {
        guard !(currentQuestion + 1 == countQuestions) else { return }
        setEnabled(subviews: buttonBack, buttonForward, isEnabled: false)
    }
    // MARK: - Set select answer
    private func setSelectButton(_ button: UIButton) {
        guard !checkSelect(tag: button.tag) else { return }
        (1...4).forEach { tag in
            let isOn = tag == button.tag ? true : false
            selectIsEnabled(tag, isOn)
        }
    }
    
    private func selectIsEnabled(_ tag: Int, _ isOn: Bool) {
        switch tag {
        case 1: data.buttonFirst[checkCurrentQuestion].select = isOn
        case 2: data.buttonSecond[checkCurrentQuestion].select = isOn
        case 3: data.buttonThird[checkCurrentQuestion].select = isOn
        default: data.buttonFourth[checkCurrentQuestion].select = isOn
        }
    }
    // MARK: - Calc answered questions
    private func addAnsweredQuestion() {
        answeredQuestions += 1
    }
    // MARK: - Set animation color buttons, images and labels when user press button of answer
    private func setButtonsSelect(button: UIButton) {
        setColorButtonsDisabled(button.tag)
        setColorButton(button: button, color: .white)
    }
    
    private func setColorButtonsDisabled(buttons: UIButton..., tag: Int) {
        buttons.forEach { button in
            if !(button.tag == tag) {
                setColorButton(button: button, color: .clear)
            }
        }
    }
    
    private func setColorButton(button: UIButton, color: UIColor) {
        UIView.animate(withDuration: 0.3) {
            button.backgroundColor = color
        }
    }
    
    private func setCheckmarksSelect(button: UIButton) {
        setCheckmarksDisabled(button.tag)
        setImage(image: checkmark(button.tag), color: .greenHarlequin, 
                 symbol: "checkmark.circle.fill")
    }
    
    private func checkmark(_ tag: Int) -> UIImageView {
        switch tag {
        case 1: checkmarkFirst
        case 2: checkmarkSecond
        case 3: checkmarkThird
        default: checkmarkFourth
        }
    }
    
    private func setCheckmarksDisabled(images: UIImageView..., tag: Int) {
        images.forEach { image in
            if !(image.tag == tag) {
                setImage(image: image, color: .white, symbol: "circle")
            }
        }
    }
    
    private func setImage(image: UIImageView, color: UIColor, symbol: String) {
        UIView.animate(withDuration: 0.3) {
            let size = UIImage.SymbolConfiguration(pointSize: 26)
            image.tintColor = color
            image.image = UIImage(systemName: symbol, withConfiguration: size)
        }
    }
    
    private func setLabelsSelect(button: UIButton) {
        setLabelsDisabled(button.tag)
        setColorLabel(label: label(button.tag), color: .greenHarlequin)
    }
    
    private func label(_ tag: Int) -> UILabel {
        switch tag {
        case 1: labelFirst
        case 2: labelSecond
        case 3: labelThird
        default: labelFourth
        }
    }
    
    private func setLabelsDisabled(labels: UILabel..., tag: Int) {
        labels.forEach { label in
            if !(label.tag == tag) {
                setColorLabel(label: label, color: .white)
            }
        }
    }
    
    private func setColorLabel(label: UILabel, color: UIColor) {
        UIView.animate(withDuration: 0.3) {
            label.textColor = color
        }
    }
    // MARK: - Refresh data for show next question
    private func updateDataFlag(_ question: UIImageView) {
        question.image = UIImage(named: issue)
        widthOfFlagFirst.constant = checkWidthFlag(issue)
        updateLabels()
    }
    
    private func updateDataLabel(_ question: UILabel, view: UIView) {
        question.text = issue
        updateImages()
        updateWidthFlag(view)
    }
    
    private func updateLabels() {
        labelFirst.text = responseFirst.name
        labelSecond.text = responseSecond.name
        labelThird.text = responseThird.name
        labelFourth.text = responseFourth.name
    }
    
    private func updateImages() {
        imageFirst.image = UIImage(named: responseFirst.flag)
        imageSecond.image = UIImage(named: responseSecond.flag)
        imageThird.image = UIImage(named: responseThird.flag)
        imageFourth.image = UIImage(named: responseFourth.flag)
    }
    
    private func updateWidthFlag(_ view: UIView) {
        widthOfFlagFirst.constant = widthFlag(responseFirst.flag, view)
        widthOfFlagSecond.constant = widthFlag(responseSecond.flag, view)
        widthOfFlagThird.constant = widthFlag(responseThird.flag, view)
        widthOfFlagFourth.constant = widthFlag(responseFourth.flag, view)
    }
    // MARK: - Set selected button for next / previous question, countinue
    private func checkSelected(selects: Bool...) {
        var tag = 1
        selects.forEach { select in
            if select {
                setSelected(tag: tag)
            }
            tag += 1
        }
    }
    
    private func setSelected(tag: Int) {
        switch tag {
        case 1: setAppearenceButtons(buttonFirst)
        case 2: setAppearenceButtons(buttonSecond)
        case 3: setAppearenceButtons(buttonThird)
        default: setAppearenceButtons(buttonFourth)
        }
    }
    // MARK: - Constants, countinue
    private func layoutConstraint(_ button: UIButton, _ image: UIImageView,
                                  _ flag: String, _ view: UIView) -> NSLayoutConstraint {
        switch button.tag {
        case 1: 
            widthOfFlagFirst = image.widthAnchor.constraint(equalToConstant: widthFlag(flag, view))
            return widthOfFlagFirst
        case 2:
            widthOfFlagSecond = image.widthAnchor.constraint(equalToConstant: widthFlag(flag, view))
            return widthOfFlagSecond
        case 3:
            widthOfFlagThird = image.widthAnchor.constraint(equalToConstant: widthFlag(flag, view))
            return widthOfFlagThird
        default:
            widthOfFlagFourth = image.widthAnchor.constraint(equalToConstant: widthFlag(flag, view))
            return widthOfFlagFourth
        }
    }
    
    private func flag(_ button: UIButton) -> String {
        switch button.tag {
        case 1: answerFirst.flag
        case 2: answerSecond.flag
        case 3: answerThird.flag
        default: answerFourth.flag
        }
    }
}
// MARK: - Private methods, onstants
extension QuestionnaireViewModel {
    private func checkWidthFlag(_ flag: String) -> CGFloat {
        switch flag {
        case "nepal", "vatican city", "switzerland": return 168
        default: return 280
        }
    }
    
    private func widthFlag(_ flag: String, _ view: UIView) -> CGFloat {
        switch flag {
        case "nepal", "vatican city", "switzerland": return setHeight()
        default: return setWidth(view)
        }
    }
    
    private func setWidth(_ view: UIView) -> CGFloat {
        let buttonWidth = ((view.frame.width - 20) / 2) - 4
        return buttonWidth - 45
    }
    
    private func setHeight() -> CGFloat {
        let buttonHeight = height / 2 - 4
        return buttonHeight - 10
    }
    
    private func setCenter(_ view: UIView) -> CGFloat {
        let buttonWidth = ((view.frame.width - 20) / 2) - 4
        let flagWidth = buttonWidth - 45
        let centerFlag = flagWidth / 2 + 5
        return buttonWidth / 2 - centerFlag
    }
    
    private func setConstant(_ view: UIView) -> CGFloat {
        view.frame.width / 2 - 27.5
    }
    
    private func widthLabel(_ view: UIView) -> CGFloat {
        view.bounds.width - 105
    }
}
// MARK: - Private methods, constraints
extension QuestionnaireViewModel {
    private func setImageOnButton(_ checkmark: UIImageView, and image: UIImageView,
                                  on button: UIButton, _ layout: NSLayoutConstraint,
                                  _ view: UIView) {
        NSLayoutConstraint.activate([
            checkmark.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            checkmark.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 5),
            layout,
            image.heightAnchor.constraint(equalToConstant: setHeight()),
            image.centerXAnchor.constraint(equalTo: button.centerXAnchor, constant: setCenter(view)),
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
    }
    
    private func constraintsFlag(_ question: UIImageView, _ view: UIView) {
        widthOfFlagFirst = question.widthAnchor.constraint(equalToConstant: checkWidthFlag(issue))
        issueSpring = NSLayoutConstraint(
            item: question, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(issueSpring)
        NSLayoutConstraint.activate([
            question.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            widthOfFlagFirst,
            question.heightAnchor.constraint(equalToConstant: 168)
        ])
    }
    
    private func constraintsLabel(_ question: UILabel, _ view: UIView) {
        issueSpring = NSLayoutConstraint(
            item: question, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(issueSpring)
        NSLayoutConstraint.activate([
            question.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            question.widthAnchor.constraint(equalToConstant: widthLabel(view))
        ])
    }
}
// MARK: - Private methods, set subviews
extension QuestionnaireViewModel {
    private func setImage(image: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: image)
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func setCheckmark(imageView: UIImageView, tag: Int) {
        switch tag {
        case 1: checkmarkFirst = imageView
        case 2: checkmarkSecond = imageView
        case 3: checkmarkThird = imageView
        default: checkmarkFourth = imageView
        }
    }
    
    private func setImage(imageView: UIImageView, tag: Int) {
        switch tag {
        case 1: imageFirst = imageView
        case 2: imageSecond = imageView
        case 3: imageThird = imageView
        default: imageFourth = imageView
        }
    }
    
    private func setLabel(label: UILabel, tag: Int) {
        switch tag {
        case 1: labelFirst = label
        case 2: labelSecond = label
        case 3: labelThird = label
        default: labelFourth = label
        }
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
