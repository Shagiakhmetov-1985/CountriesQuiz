//
//  QuizOfCapitalsViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 23.04.2024.
//

import UIKit

protocol QuizOfCapitalsViewModelProtocol {
    var countQuestions: Int { get }
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
    var circleTimeElapsed: Int { get }
    
    var imageFlagSpring: NSLayoutConstraint! { get set }
    var labelNameSpring: NSLayoutConstraint! { get set }
    var stackViewSpring: NSLayoutConstraint! { get set }
    var widthOfFlag: NSLayoutConstraint! { get set }
    
    init(mode: Setting, game: Games)
    
    func setupSubviews(subviews: UIView..., on subviewOther: UIView)
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func setEnabled(controls: UIControl..., isEnabled: Bool)
    
    func isFlag() -> Bool
    func isOneQuestion() -> Bool
    func isCountdown() -> Bool
    
    func getQuestions()
    func setTime()
    func runMoveSubviews(_ view: UIView)
    func animationSubviews(duration: CGFloat,_ view: UIView)
    func showDescription(_ labelQuiz: UILabel,_ labelDescription: UILabel)
    func animationShowQuizHideDescription(_ labelQuiz: UILabel,_ labelDescription: UILabel)
}

class QuizOfCapitalsViewModel: QuizOfCapitalsViewModelProtocol {
    var countQuestions: Int {
        mode.countQuestions
    }
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
    var circleTimeElapsed: Int {
        isOneQuestion() ? oneQuestionTime : seconds / 10
    }
    
    let mode: Setting
    let game: Games
    
    private var currentQuestion = 0
    private var seconds = 0
    
    private var oneQuestionTime: Int {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
    }
    private var allQuestionsTime: Int {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
    }
    
    var imageFlagSpring: NSLayoutConstraint!
    var labelNameSpring: NSLayoutConstraint!
    var stackViewSpring: NSLayoutConstraint!
    var widthOfFlag: NSLayoutConstraint!
    
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
        if isOneQuestion(), currentQuestion < 1 {
            seconds = isOneQuestion() ? oneQuestionTime * 10 : allQuestionsTime * 10
        } else if isOneQuestion() {
            seconds = isOneQuestion() ? oneQuestionTime * 10 : allQuestionsTime * 10
        }
    }
    // MARK: - Animation label description and label number
    func showDescription(_ labelQuiz: UILabel, _ labelDescription: UILabel) {
        showDescription(labelQuiz)
        animationHideQuizShowDescription(labelQuiz, labelDescription)
    }
    
    func animationShowQuizHideDescription(_ labelQuiz: UILabel, _ labelDescription: UILabel) {
        setOpacity(subviews: labelQuiz, opacity: 1, duration: 1)
        guard labelDescription.layer.opacity == 1 else { return }
        setOpacity(subviews: labelDescription, opacity: 0, duration: 0)
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
}
