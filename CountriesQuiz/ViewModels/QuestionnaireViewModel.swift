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
    
    var imageFlagSpring: NSLayoutConstraint! { get set }
    var labelNameSpring: NSLayoutConstraint! { get set }
    var stackViewSpring: NSLayoutConstraint! { get set }
    
    var widthOfFlagFirst: NSLayoutConstraint! { get set }
    var widthOfFlagSecond: NSLayoutConstraint! { get set }
    var widthOfFlagThird: NSLayoutConstraint! { get set }
    var widthOfFlagFourth: NSLayoutConstraint! { get set }
    
    init(mode: Setting, game: Games)
    
    func setButtons(_ buttonOne: UIButton,_ buttonTwo: UIButton,_ buttonThree: UIButton,_ buttonFour: UIButton)
    func setSubviews(subviews: UIView..., on subviewOther: UIView)
    func setOpacity(subviews: UIView..., opacity: Float, duration: CGFloat)
    func setEnabled(subviews: UIControl..., isEnabled: Bool)
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func buttonsForAnswers(isOn: Bool)
    
    func setProgressView(_ progressView: UIProgressView)
    
    func isFlag() -> Bool
    func isCountdown() -> Bool
    func checkCurrentQuestion() -> Int
    func checkLastQuestion(_ buttonFirst: UIButton,_ buttonSecond: UIButton)
    
    func getQuestions()
    func showLabelQuiz(_ label: UILabel, duration: CGFloat, opacity: Float)
    func moveSubviews(_ view: UIView)
    func moveBackSubviews(_ view: UIView)
    func animationSubviews(duration: CGFloat,_ view: UIView)
    func animationBackSubviews(_ view: UIView)
    func selectIsEnabled(_ tag: Int,_ isOn: Bool,_ currentQuestion: Int)
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
    
    var data: (questions: [Countries], buttonFirst: [Countries],
               buttonSecond: [Countries], buttonThird: [Countries],
               buttonFourth: [Countries]) = ([], [], [], [], [])
    
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
    func selectIsEnabled(_ tag: Int, _ isOn: Bool, _ currentQuestion: Int) {
        switch tag {
        case 1: data.buttonFirst[currentQuestion].select = isOn
        case 2: data.buttonSecond[currentQuestion].select = isOn
        case 3: data.buttonThird[currentQuestion].select = isOn
        default: data.buttonFourth[currentQuestion].select = isOn
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
}
