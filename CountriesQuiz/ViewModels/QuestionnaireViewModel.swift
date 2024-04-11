//
//  QuestionnaireViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 11.04.2024.
//

import UIKit

protocol QuestionnaireViewModelProtocol {
    var countQuestions: Int { get }
    var time: Int { get }
    var image: String { get }
    var name: String { get }
    var buttonFirstImage: String { get }
    var buttonSecondImage: String { get }
    var buttonThirdImage: String { get }
    var buttonFourthImage: String { get }
    var buttonFirstName: String { get }
    var buttonSecondName: String { get }
    var buttonThirdName: String { get }
    var buttonFourthName: String { get }
    var background: UIColor { get }
    var height: CGFloat { get }
    var radius: CGFloat { get }
    
    var data: (questions: [Countries], buttonFirst: [Countries],
               buttonSecond: [Countries], buttonThird: [Countries],
               buttonFourth: [Countries]) { get }
    
    init(mode: Setting, game: Games)
    
    func setSubviews(subviews: UIView..., on subviewOther: UIView)
    func setOpacity(subviews: UIView..., opacity: Float)
    func setEnabled(subviews: UIControl..., isEnabled: Bool)
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    
    func setProgressView(_ progressView: UIProgressView)
    
    func isFlag() -> Bool
    func isCountdown() -> Bool
    func checkCurrentQuestion() -> Int
    func checkLastQuestion(_ buttonFirst: UIButton,_ buttonSecond: UIButton)
    
    func getQuestions()
}

class QuestionnaireViewModel: QuestionnaireViewModelProtocol {
    var countQuestions: Int {
        mode.countQuestions
    }
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
    var background: UIColor {
        game.background
    }
    var height: CGFloat {
        isFlag() ? 215 : 235
    }
    var radius: CGFloat = 6
    
    var data: (questions: [Countries], buttonFirst: [Countries],
               buttonSecond: [Countries], buttonThird: [Countries],
               buttonFourth: [Countries]) = ([], [], [], [], [])
    
    let mode: Setting
    let game: Games
    
    private var currentQuestion = 0
    private var numberQuestion = 0
    private var correctAnswers: [Countries] = []
    private var incorrectAnswers: [Results] = []
    private var spendTime: [CGFloat] = []
    
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
    
    func setOpacity(subviews: UIView..., opacity: Float) {
        subviews.forEach { subview in
            subview.layer.opacity = opacity
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
