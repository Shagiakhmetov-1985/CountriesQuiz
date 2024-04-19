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
    var image: String { get }
    var name: String { get }
    var background: UIColor { get }
    var height: CGFloat { get }
    var radius: CGFloat { get }
    var timer: Timer { get set }
    var countdown: Timer { get set }
    var lastQuestion: Bool { get }
    
    var buttonFirstImage: String { get }
    var buttonSecondImage: String { get }
    var buttonThirdImage: String { get }
    var buttonFourthImage: String { get }
    var buttonFirstName: String { get }
    var buttonSecondName: String { get }
    var buttonThirdName: String { get }
    var buttonFourthName: String { get }
    
    var question: Countries { get }
    var answerFirst: Countries { get }
    var answerSecond: Countries { get }
    var answerThird: Countries { get }
    var answerFourth: Countries { get }
    
    var data: (questions: [Countries], buttonFirst: [Countries],
               buttonSecond: [Countries], buttonThird: [Countries],
               buttonFourth: [Countries]) { get }
    
    var shapeLayer: CAShapeLayer { get }
    
    var imageFlagSpring: NSLayoutConstraint! { get set }
    var labelNameSpring: NSLayoutConstraint! { get set }
    var stackViewSpring: NSLayoutConstraint! { get set }
    
    var widthOfFlagFirst: NSLayoutConstraint! { get set }
    var widthOfFlagSecond: NSLayoutConstraint! { get set }
    var widthOfFlagThird: NSLayoutConstraint! { get set }
    var widthOfFlagFourth: NSLayoutConstraint! { get set }
    
    init(mode: Setting, game: Games)
    
    func setButtons(_ buttonOne: UIButton,_ buttonTwo: UIButton,_ buttonThree: UIButton,_ buttonFour: UIButton)
    func setImages(_ imageOne: UIImageView,_ imageTwo: UIImageView,_ imageThree: UIImageView,_ imageFour: UIImageView)
    func setLabels(_ labelOne: UILabel,_ labelTwo: UILabel,_ labelThree: UILabel,_ labelFour: UILabel)
    func setSubviews(subviews: UIView..., on subviewOther: UIView)
    func setOpacity(subviews: UIView..., opacity: Float, duration: CGFloat)
    func setFlash(subviews: UIView..., opacity: Float)
    func setEnabled(subviews: UIControl..., isEnabled: Bool)
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func buttonsForAnswers(isOn: Bool)
    
    func setProgressView(_ progressView: UIProgressView)
    
    func isFlag() -> Bool
    func isCountdown() -> Bool
    func checkCurrentQuestion() -> Int
    func checkLastQuestion(_ buttonFirst: UIButton,_ buttonSecond: UIButton)
    func checkWidthFlag(_ flag: String) -> CGFloat
    func widthFlag(_ flag: String,_ view: UIView) -> CGFloat
    func setWidthAndCenterFlag(_ view: UIView) -> (CGFloat, CGFloat)
    func setHeight() -> CGFloat
    func setConstant(_ view: UIView) -> CGFloat
    func widthLabel(_ view: UIView) -> CGFloat
    
    func getQuestions()
    func showLabelQuiz(_ label: UILabel, duration: CGFloat, opacity: Float)
    func moveSubviews(_ view: UIView)
    func moveBackSubviews(_ view: UIView)
    func animationSubviews(duration: CGFloat,_ view: UIView)
    func animationBackSubviews(_ view: UIView)
    func setSelectButton(_ button: UIButton)
    func selectIsEnabled(_ tag: Int,_ isOn: Bool,_ currentQuestion: Int)
    func setCurrentQuestion(_ number: Int)
    func setNumberQuestion(_ number: Int)
    func checkCorrectAnswer(_ tag: Int)
    func setAppearenceButtons(_ button: UIButton,_ image: UIImageView,_ label: UILabel?)
    func setColorButtonsDisabled(_ tag: Int)
    func setImagesDisabled(_ tag: Int)
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
    func updateDataQuestion(_ imageFlag: UIImageView,_ labelCountry: UILabel,_ view: UIView)
    func setSelectedResponse()
    func stopTimer()
    func setTimeSpent()
    
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
    var image: String {
        data.questions[currentQuestion].flag
    }
    var name: String {
        data.questions[currentQuestion].name
    }
    var buttonFirstImage: String {
        data.buttonFirst[currentQuestion].flag
    }
    var buttonSecondImage: String {
        data.buttonSecond[currentQuestion].flag
    }
    var buttonThirdImage: String {
        data.buttonThird[currentQuestion].flag
    }
    var buttonFourthImage: String {
        data.buttonFourth[currentQuestion].flag
    }
    var buttonFirstName: String {
        data.buttonFirst[currentQuestion].name
    }
    var buttonSecondName: String {
        data.buttonSecond[currentQuestion].name
    }
    var buttonThirdName: String {
        data.buttonThird[currentQuestion].name
    }
    var buttonFourthName: String {
        data.buttonFourth[currentQuestion].name
    }
    var question: Countries {
        data.questions[numberQuestion]
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
        isFlag() ? 215 : 235
    }
    var radius: CGFloat = 6
    var timer = Timer()
    var countdown = Timer()
    var lastQuestion = false
    
    var data: (questions: [Countries], buttonFirst: [Countries],
               buttonSecond: [Countries], buttonThird: [Countries],
               buttonFourth: [Countries]) = ([], [], [], [], [])
    
    var shapeLayer = CAShapeLayer()
    
    var imageFlagSpring: NSLayoutConstraint!
    var labelNameSpring: NSLayoutConstraint!
    var stackViewSpring: NSLayoutConstraint!
    
    var widthOfFlagFirst: NSLayoutConstraint!
    var widthOfFlagSecond: NSLayoutConstraint!
    var widthOfFlagThird: NSLayoutConstraint!
    var widthOfFlagFourth: NSLayoutConstraint!
    
    let mode: Setting
    let game: Games
    
    private var seconds = 0
    
    private var correctAnswers: [Countries] = []
    private var incorrectAnswers: [Results] = []
    private var spendTime: [CGFloat] = []
    
    private var buttonFirst: UIButton!
    private var buttonSecond: UIButton!
    private var buttonThird: UIButton!
    private var buttonFourth: UIButton!
    
    private var imageFirst: UIImageView!
    private var imageSecond: UIImageView!
    private var imageThird: UIImageView!
    private var imageFourth: UIImageView!
    
    private var labelFirst: UILabel!
    private var labelSecond: UILabel!
    private var labelThird: UILabel!
    private var labelFourth: UILabel!
    
    required init(mode: Setting, game: Games) {
        self.mode = mode
        self.game = game
    }
    // MARK: - Set subviews
    func setButtons(_ buttonOne: UIButton, _ buttonTwo: UIButton, 
                    _ buttonThree: UIButton, _ buttonFour: UIButton) {
        buttonFirst = buttonOne
        buttonSecond = buttonTwo
        buttonThird = buttonThree
        buttonFourth = buttonFour
    }
    
    func setImages(_ imageOne: UIImageView, _ imageTwo: UIImageView, 
                   _ imageThree: UIImageView, _ imageFour: UIImageView) {
        imageFirst = imageOne
        imageSecond = imageTwo
        imageThird = imageThree
        imageFourth = imageFour
    }
    
    func setLabels(_ labelOne: UILabel, _ labelTwo: UILabel, 
                   _ labelThree: UILabel, _ labelFour: UILabel) {
        labelFirst = labelOne
        labelSecond = labelTwo
        labelThird = labelThree
        labelFourth = labelFour
    }
    
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
    // MARK: - Constants
    func isFlag() -> Bool {
        mode.flag ? true : false
    }
    
    func isCountdown() -> Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    
    func checkCurrentQuestion() -> Int {
        numberQuestion == currentQuestion ? currentQuestion : numberQuestion
    }
    
    func checkLastQuestion(_ buttonFirst: UIButton, _ buttonSecond: UIButton) {
        guard !(currentQuestion + 1 == countQuestions) else { return }
        setEnabled(subviews: buttonFirst, buttonSecond, isEnabled: false)
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
        default: return setWidthAndCenterFlag(view).0
        }
    }
    
    func setWidthAndCenterFlag(_ view: UIView) -> (CGFloat, CGFloat) {
        let buttonWidth = ((view.frame.width - 20) / 2) - 4
        let flagWidth = buttonWidth - 45
        let centerFlag = flagWidth / 2 + 5
        let constant = buttonWidth / 2 - centerFlag
        return (flagWidth, constant)
    }
    
    func setHeight() -> CGFloat {
        let buttonHeight = height / 2 - 4
        return buttonHeight - 10
    }
    
    func setConstant(_ view: UIView) -> CGFloat {
        view.frame.width / 2 - 27.5
    }
    
    func widthLabel(_ view: UIView) -> CGFloat {
        view.bounds.width - 105
    }
    // MARK: - Get countries for questions
    func getQuestions() {
        let randomCountries = getRandomCountries()
        let questions = getRandomQuestions(randomCountries: randomCountries)
        let choosingAnswers = getChoosingAnswers(questions: questions, randomCountries: randomCountries)
        let answers = getAnswers(choosingAnswers: choosingAnswers)
        data = (questions, answers.buttonFirst, answers.buttonSecond, answers.buttonThird, answers.buttonFourth)
    }
    // MARK: - Set progress view
    func setProgressView(_ progressView: UIProgressView) {
        let interval: Float = 1 / Float(countQuestions)
        let progress = progressView.progress + interval
        
        UIView.animate(withDuration: 0.5) {
            progressView.setProgress(progress, animated: true)
        }
    }
    // MARK: - Buttons for answers are enabled on / off
    func buttonsForAnswers(isOn: Bool) {
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
        if isFlag() {
            imageFlagSpring.constant += view.frame.width * pointX
        } else {
            labelNameSpring.constant += view.frame.width * pointX
        }
        stackViewSpring.constant += view.frame.width * pointX
    }
    
    func moveBackSubviews(_ view: UIView) {
        if isFlag() {
            imageFlagSpring.constant -= view.frame.width * 2
        } else {
            labelNameSpring.constant -= view.frame.width * 2
        }
        stackViewSpring.constant -= view.frame.width * 2
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
    
    func animationBackSubviews(_ view: UIView) {
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
    // MARK: - Set select answer
    func setSelectButton(_ button: UIButton) {
        guard !checkSelect(tag: button.tag) else { return }
        let question = checkCurrentQuestion()
        (1...4).forEach { tag in
            let isOn = tag == button.tag ? true : false
            selectIsEnabled(tag, isOn, question)
        }
    }
    
    func selectIsEnabled(_ tag: Int, _ isOn: Bool, _ currentQuestion: Int) {
        switch tag {
        case 1: data.buttonFirst[currentQuestion].select = isOn
        case 2: data.buttonSecond[currentQuestion].select = isOn
        case 3: data.buttonThird[currentQuestion].select = isOn
        default: data.buttonFourth[currentQuestion].select = isOn
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
        switch number {
        case 1: numberQuestion += number
        case 0: numberQuestion = number
        default: numberQuestion -= number
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
        labelNumber.text = "\(checkCurrentQuestion() + 1) / \(countQuestions)"
    }
    
    func updateDataQuestion(_ imageFlag: UIImageView, _ labelCountry: UILabel, _ view: UIView) {
        let number = checkCurrentQuestion()
        if isFlag() {
            let flag = data.questions[number].flag
            imageFlag.image = UIImage(named: flag)
            widthOfFlagFirst.constant = checkWidthFlag(flag)
            updateLabels()
        } else {
            labelCountry.text = data.questions[number].name
            updateImages()
            updateWidthFlag(view)
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
        seconds > 0 ? buttonsForAnswers(isOn: true) : completion()
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
    // MARK: - Check answer, select correct or incorrect answer by user
    func checkCorrectAnswer(_ tag: Int) {
        if checkAnswer(tag: tag) {
            addCorrectAnswer()
            deleteIncorrectAnswer()
        } else {
            addIncorrectAnswer(tag: tag)
            deleteCorrectAnswer()
        }
    }
    // MARK: - Set color buttons, images and labels when user press button of answer
    func setAppearenceButtons(_ button: UIButton, _ image: UIImageView, _ label: UILabel? = nil) {
        setButtonsSelect(button: button)
        setImagesSelect(image: image)
        if let label = label {
            setLabelsSelect(label: label)
        }
    }
    
    func setColorButtonsDisabled(_ tag: Int) {
        setColorButtonsDisabled(buttons: buttonFirst, buttonSecond, buttonThird, buttonFourth, tag: tag)
    }
    
    func setImagesDisabled(_ tag: Int) {
        setImagesDisabled(images: imageFirst, imageSecond, imageThird, imageFourth, tag: tag)
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
        spendTime.append(timeSpent)
    }
    // MARK: - Transition to ResuiltViewController
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
    // MARK: - Check answer, select correct or incorrect answer by user, countinue
    private func checkAnswer(tag: Int) -> Bool {
        switch tag {
        case 1: return question.flag == answerFirst.flag ? true : false
        case 2: return question.flag == answerSecond.flag ? true : false
        case 3: return question.flag == answerThird.flag ? true : false
        default: return question.flag == answerFourth.flag ? true : false
        }
    }
    
    private func addCorrectAnswer() {
        correctAnswers.append(question)
    }
    
    private func deleteIncorrectAnswer() {
        guard !incorrectAnswers.isEmpty else { return }
        let topics = incorrectAnswers.map({ $0.question })
        guard let index = topics.firstIndex(of: question) else { return }
        incorrectAnswers.remove(at: index)
    }
    
    private func addIncorrectAnswer(tag: Int) {
        incorrectAnswer(numberQuestion: numberQuestion + 1, tag: tag,
                        question: question,
                        buttonFirst: answerFirst,
                        buttonSecond: answerSecond,
                        buttonThird: answerThird,
                        buttonFourth: answerFourth,
                        timeUp: false)
    }
    
    private func deleteCorrectAnswer() {
        guard !correctAnswers.isEmpty else { return }
        guard let index = correctAnswers.firstIndex(of: question) else { return }
        correctAnswers.remove(at: index)
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
    
    private func setImagesSelect(image: UIImageView) {
        setImagesDisabled(image.tag)
        setImage(image: image, color: .greenHarlequin, symbol: "checkmark.circle.fill")
    }
    
    private func setImagesDisabled(images: UIImageView..., tag: Int) {
        images.forEach { image in
            if !(image.tag == tag) {
                setImage(image: image, color: .white, symbol: "circle")
            }
        }
    }
    
    private func setImage(image: UIImageView, color: UIColor, symbol: String) {
        UIView.animate(withDuration: 0.3) {
            let size = UIImage.SymbolConfiguration(pointSize: 30)
            image.tintColor = color
            image.image = UIImage(systemName: symbol, withConfiguration: size)
        }
    }
    
    private func setLabelsSelect(label: UILabel) {
        setLabelsDisabled(label.tag)
        setColorLabel(label: label, color: .greenHarlequin)
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
    private func updateLabels() {
        let number = checkCurrentQuestion()
        labelFirst.text = data.buttonFirst[number].name
        labelSecond.text = data.buttonSecond[number].name
        labelThird.text = data.buttonThird[number].name
        labelFourth.text = data.buttonFourth[number].name
    }
    
    private func updateImages() {
        let number = checkCurrentQuestion()
        imageFirst.image = UIImage(named: data.buttonFirst[number].flag)
        imageSecond.image = UIImage(named: data.buttonSecond[number].flag)
        imageThird.image = UIImage(named: data.buttonThird[number].flag)
        imageFourth.image = UIImage(named: data.buttonFourth[number].flag)
    }
    
    private func updateWidthFlag(_ view: UIView) {
        let number = checkCurrentQuestion()
        widthOfFlagFirst.constant = widthFlag(data.buttonFirst[number].flag, view)
        widthOfFlagSecond.constant = widthFlag(data.buttonSecond[number].flag, view)
        widthOfFlagThird.constant = widthFlag(data.buttonThird[number].flag, view)
        widthOfFlagFourth.constant = widthFlag(data.buttonFourth[number].flag, view)
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
        case 1: setAppearenceButtons(buttonFirst, imageFirst, isFlag() ? labelFirst : nil)
        case 2: setAppearenceButtons(buttonSecond, imageSecond, isFlag() ? labelSecond : nil)
        case 3: setAppearenceButtons(buttonThird, imageThird, isFlag() ? labelThird : nil)
        default: setAppearenceButtons(buttonFourth, imageFourth, isFlag() ? labelFourth : nil)
        }
    }
}
