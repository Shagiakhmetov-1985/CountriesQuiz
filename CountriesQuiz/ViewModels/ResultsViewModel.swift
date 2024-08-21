//
//  ResultsViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 05.04.2024.
//

import UIKit

protocol ResultsViewModelProtocol {
    var time: Int { get }
    var radiusView: CGFloat { get }
    var radius: CGFloat { get }
    var titleTimeSpend: String { get }
    var imageTimeSpend: String { get }
    var numberTimeSpend: String { get }
    var rightAnswers: Int { get }
    var wrongAnswers: Int { get }
    var answeredQuestions: Int { get }
    var heading: String { get }
    var description: String { get }
    var percent: String { get }
    var favourites: [Favourites] { get }
    
    var mode: Setting { get }
    var game: Games { get }
    var correctAnswers: [Corrects] { get }
    var incorrectAnswers: [Incorrects] { get }
    
    init(mode: Setting, game: Games, correctAnswers: [Corrects],
         incorrectAnswers: [Incorrects], timeSpend: [CGFloat],
         answeredQuestions: Int, favourites: [Favourites])
    
    func isTime() -> Bool
    func isOneQuestion() -> Bool
    func oneQuestionTime() -> Int
    func allQuestionsTime() -> Int
    func width(_ view: UIView) -> CGFloat
    
    func setupSubviews(subviews: UIView..., on subviewOther: UIView)
    
    func percentCorrectAnswers() -> String
    func getRange(subString: String, fromString: String) -> NSRange
    func setFavourites(newFavourites: [Favourites])
    
    func constraintsView(view: UIView, image: UIImageView, label: UILabel, button: UIButton)
    func constraintsButton(subview: UIView, labelFirst: UILabel, image: UIImageView,
                           labelSecond: UILabel)
    func setupCenterSubview(_ subview: UIView, on subviewOther: UIView)
    
    func ratio() -> RatioViewModelProtocol
    func correctAnswersViewController() -> CorrectAnswersViewModelProtocol
    func incorrectAnswersViewController() -> IncorrectAnswersViewModelProtocol
}

class ResultsViewModel: ResultsViewModelProtocol {
    var time: Int {
        isOneQuestion() ? oneQuestionTime() : allQuestionsTime()
    }
    var radiusView: CGFloat = 10
    var radius: CGFloat = 15
    var titleTimeSpend: String {
        isTime() ? "\(checkTitleTimeSpend())" : "Обратный отсчет выключен"
    }
    var imageTimeSpend: String {
        isTime() ? "\(checkImageTimeSpend())" : "clock.badge.xmark"
    }
    var numberTimeSpend: String {
        isTime() ? "\(checkNumberTimeSpend())" : " "
    }
    var rightAnswers: Int {
        correctAnswers.count
    }
    var wrongAnswers: Int {
        incorrectAnswers.count
    }
    var heading: String = "Соотношение ответов"
    var description: String {
        """
        Соотношение ответов
        На все вопросы вы смогли ответить правильно точно на \(percentCorrectAnswers()).
        """
    }
    var percent: String {
        percentCorrectAnswers()
    }
    
    let mode: Setting
    let game: Games
    let correctAnswers: [Corrects]
    let incorrectAnswers: [Incorrects]
    var answeredQuestions: Int
    var favourites: [Favourites]
    private let timeSpend: [CGFloat]
    
    required init(mode: Setting, game: Games, correctAnswers: [Corrects],
                  incorrectAnswers: [Incorrects], timeSpend: [CGFloat],
                  answeredQuestions: Int, favourites: [Favourites]) {
        self.mode = mode
        self.game = game
        self.correctAnswers = correctAnswers
        self.incorrectAnswers = incorrectAnswers
        self.timeSpend = timeSpend
        self.answeredQuestions = answeredQuestions
        self.favourites = favourites
    }
    // MARK: - Constants
    func isTime() -> Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    
    func isOneQuestion() -> Bool {
        mode.timeElapsed.questionSelect.oneQuestion ? true : false
    }
    
    func oneQuestionTime() -> Int {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
    }
    
    func allQuestionsTime() -> Int {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
    }
    
    func width(_ view: UIView) -> CGFloat {
        view.frame.width / 2 + 10
    }
    // MARK: - Set subviews
    func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    // MARK: - Percent titles
    func percentCorrectAnswers() -> String {
        let percent = CGFloat(rightAnswers) / CGFloat(mode.countQuestions) * 100
        return stringWithoutNull(count: percent) + "%"
    }
    // MARK: - Transition to RatioViewController
    func ratio() -> RatioViewModelProtocol {
        RatioViewModel(mode: mode, game: game, correctAnswers: correctAnswers,
                       incorrectAnswers: incorrectAnswers, timeSpend: timeSpend, 
                       answeredQuestions: answeredQuestions)
    }
    // MARK: - Transition to CorrectAnswersViewController
    func correctAnswersViewController() -> CorrectAnswersViewModelProtocol {
        CorrectAnswersViewModel(mode: mode, game: game, correctAnswers: correctAnswers)
    }
    // MARK: - Transition to IncorrectAnswersViewController
    func incorrectAnswersViewController() -> IncorrectAnswersViewModelProtocol {
        IncorrectAnswersViewModel(mode: mode, game: game, results: incorrectAnswers,
                                  favourites: favourites)
    }
    // MARK: - Constraints
    func constraintsView(view: UIView, image: UIImageView, label: UILabel, button: UIButton) {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 5),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            button.topAnchor.constraint(equalTo: label.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 5)
        ])
    }
    
    func constraintsButton(subview: UIView, labelFirst: UILabel, image: UIImageView,
                           labelSecond: UILabel) {
        NSLayoutConstraint.activate([
            labelFirst.topAnchor.constraint(equalTo: subview.topAnchor, constant: 10),
            labelFirst.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 5),
            labelFirst.trailingAnchor.constraint(equalTo: image.leadingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            image.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -20),
            image.centerYAnchor.constraint(equalTo: labelFirst.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelSecond.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 10),
            labelSecond.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -10),
            labelSecond.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: -10)
        ])
    }
    
    func setupCenterSubview(_ subview: UIView, on subviewOther: UIView) {
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: subviewOther.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: subviewOther.centerYAnchor)
        ])
    }
    // MARK: - Get word from text description
    func getRange(subString: String, fromString: String) -> NSRange {
        let linkRange = fromString.range(of: subString)!
        let start = fromString.distance(from: fromString.startIndex, to: linkRange.lowerBound)
        let end = fromString.distance(from: fromString.startIndex, to: linkRange.upperBound)
        let range = NSMakeRange(start, end - start)
        return range
    }
    
    func setFavourites(newFavourites: [Favourites]) {
        favourites = newFavourites
    }
    
    // MARK: - Constants, countinue
    private func checkTitleTimeSpend() -> String {
        isOneQuestion() ? isQuestionnaire() : titleAllQuestions()
    }
    
    private func isQuestionnaire() -> String {
        game.gameType == .questionnaire ? titleAllQuestions() : "Среднее время на вопрос"
    }
    
    private func titleAllQuestions() -> String {
        timeSpend.isEmpty ? "Вы не успели ответить за это время" :
        "Потраченное время на все вопросы"
    }
    
    private func checkImageTimeSpend() -> String {
        isOneQuestion() ? "timer" : imageAllQuestions()
    }
    
    private func imageAllQuestions() -> String {
        timeSpend.isEmpty ? "clock" : "timer"
    }
    
    private func checkNumberTimeSpend() -> String {
        var text: String
        if isOneQuestion() {
            let averageTime = timeSpend.reduce(0.0, +) / CGFloat(timeSpend.count)
            text = "\(string(seconds: averageTime))"
        } else {
            text = numberCheckAllQuestions()
        }
        return text
    }
    
    private func numberCheckAllQuestions() -> String {
        var text: String
        if timeSpend.isEmpty {
            text = "0"
        } else {
            let spendTime = timeSpend.first ?? 0
            text = "\(string(seconds: spendTime))"
        }
        return text
    }
    // MARK: - Number format
    private func string(seconds: CGFloat) -> String {
        String(format: "%.2f", seconds)
    }
    
    private func stringWithoutNull(count: CGFloat) -> String {
        String(format: "%.0f", count)
    }
    // MARK: - Set circles
    private func setCircle(_ subview: UIView, color: UIColor, strokeEnd: CGFloat,
                           value: Float? = nil, duration: CGFloat? = nil, view: UIView) {
        let center = CGPoint(x: subview.center.x, y: subview.center.y)
        let endAngle = CGFloat.pi / 2
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: 45,
            startAngle: -startAngle,
            endAngle: -endAngle,
            clockwise: true)
        
        let trackShape = CAShapeLayer()
        trackShape.path = circularPath.cgPath
        trackShape.lineWidth = 13
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.strokeEnd = strokeEnd
        trackShape.strokeColor = color.cgColor
        trackShape.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackShape)
        
        if let value = value, let duration = duration {
            animateCircle(shape: trackShape, value: value, duration: duration)
        }
    }
    
    private func animateCircle(shape: CAShapeLayer, value: Float, duration: CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = value
        animation.duration = CFTimeInterval(duration)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shape.add(animation, forKey: "animation")
    }
}
