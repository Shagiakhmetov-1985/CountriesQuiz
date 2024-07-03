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
    var progressCorrect: Float { get }
    var progressIncorrect: Float { get }
    var heading: String { get }
    var description: String { get }
    var percent: String { get }
    
    var mode: Setting { get }
    var game: Games { get }
    var correctAnswers: [Countries] { get }
    var incorrectAnswers: [Results] { get }
    var spendTime: [CGFloat] { get }
    var percentTimeSpend: String { get }
    var circleTime: Float { get }
    var timer: Timer { get set }
    
    init(mode: Setting, game: Games, correctAnswers: [Countries],
         incorrectAnswers: [Results], spendTime: [CGFloat])
    
    func isTime() -> Bool
    func isOneQuestion() -> Bool
    func oneQuestionTime() -> Int
    func allQuestionsTime() -> Int
    func width(_ view: UIView) -> CGFloat
    
    func setupSubviews(subviews: UIView..., on subviewOther: UIView)
    func opacity(subviews: UIView..., opacity: Float)
    
    func percentCorrectAnswers() -> String
    func percentIncorrectAnswers() -> String
    func percentCheckMode() -> CGFloat
    func getRange(subString: String, fromString: String) -> NSRange
    
    func constraintsView(view: UIView, image: UIImageView, label: UILabel, button: UIButton)
    func constraintsButton(subview: UIView, labelFirst: UILabel, image: UIImageView,
                           labelSecond: UILabel)
    func setupCenterSubview(_ subview: UIView, on subviewOther: UIView)
    
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
    var percentTimeSpend: String {
        isTime() ? stringWithoutNull(count: percentCheckMode()) + "%" : " "
    }
    var circleTime: Float {
        roundf(Float(percentCheckMode() * 100)) / 100
    }
    var rightAnswers: Int {
        correctAnswers.count
    }
    var wrongAnswers: Int {
        incorrectAnswers.count
    }
    var progressCorrect: Float {
        Float(rightAnswers) / Float(mode.countQuestions)
    }
    var progressIncorrect: Float {
        Float(wrongAnswers) / Float(mode.countQuestions)
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
    var timer = Timer()
    
    let mode: Setting
    let game: Games
    let correctAnswers: [Countries]
    let incorrectAnswers: [Results]
    let spendTime: [CGFloat]
    
    required init(mode: Setting, game: Games, correctAnswers: [Countries], 
                  incorrectAnswers: [Results], spendTime: [CGFloat]) {
        self.mode = mode
        self.game = game
        self.correctAnswers = correctAnswers
        self.incorrectAnswers = incorrectAnswers
        self.spendTime = spendTime
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
    
    func opacity(subviews: UIView..., opacity: Float) {
        subviews.forEach { subview in
            subview.layer.opacity = opacity
        }
    }
    // MARK: - Percent titles
    func percentCorrectAnswers() -> String {
        let percent = CGFloat(rightAnswers) / CGFloat(mode.countQuestions) * 100
        return stringWithoutNull(count: percent) + "%"
    }
    
    func percentIncorrectAnswers() -> String {
        let percent = CGFloat(wrongAnswers) / CGFloat(mode.countQuestions) * 100
        return stringWithoutNull(count: percent) + "%"
    }
    
    func percentCheckMode() -> CGFloat {
        isOneQuestion() ? checkGameType() : timeSpend()
    }
    // MARK: - Set circles
    /*
    func setCircleShadow(_ viewFirst: UIView, _ viewSecond: UIView, _ view: UIView) {
        setCircle(viewFirst, color: .white.withAlphaComponent(0.3), strokeEnd: 1, view: view)
        setCircle(labelSecond, color: .white.withAlphaComponent(0.3), strokeEnd: 1, view: view)
    }
    
    func circleCorrectAnswers(_ view: UIView, completion: @escaping (CGFloat) -> Void) {
        timer.invalidate()
        let delay: CGFloat = 0.75
        let value = Float(correctAnswers.count) / Float(mode.countQuestions)
        setCircle(color: .greenHarlequin, strokeEnd: 0, start: 0, value: value,
                  duration: delay, view: view)
        completion(delay)
    }
    
    func circleIncorrectAnswers(_ view: UIView) {
        timer.invalidate()
        let start = CGFloat(correctAnswers.count) / CGFloat(mode.countQuestions)
        guard start != 1 else { return }
        setCircle(color: .redTangerineTango, strokeEnd: 0, start: start, value: 1,
                  duration: 0.75, view: view)
    }
     */
    // MARK: - Transition to IncorrectAnswersViewController
    func incorrectAnswersViewController() -> IncorrectAnswersViewModelProtocol {
        IncorrectAnswersViewModel(mode: mode, game: game, results: incorrectAnswers)
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
    // MARK: - Constants, countinue
    private func checkTitleTimeSpend() -> String {
        isOneQuestion() ? isQuestionnaire() : titleAllQuestions()
    }
    
    private func isQuestionnaire() -> String {
        game.gameType == .questionnaire ? titleAllQuestions() : "Среднее время на вопрос"
    }
    
    private func titleAllQuestions() -> String {
        spendTime.isEmpty ? "Вы не успели ответить за это время" :
        "Потраченное время на все вопросы"
    }
    
    private func checkImageTimeSpend() -> String {
        isOneQuestion() ? "timer" : imageAllQuestions()
    }
    
    private func imageAllQuestions() -> String {
        spendTime.isEmpty ? "clock" : "timer"
    }
    
    private func checkNumberTimeSpend() -> String {
        var text: String
        if isOneQuestion() {
            let averageTime = spendTime.reduce(0.0, +) / CGFloat(spendTime.count)
            text = "\(string(seconds: averageTime))"
        } else {
            text = numberCheckAllQuestions()
        }
        return text
    }
    
    private func numberCheckAllQuestions() -> String {
        var text: String
        if spendTime.isEmpty {
            text = "-"
        } else {
            let spendTime = spendTime.first ?? 0
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
    // MARK: - Percent titles, countinue
    private func checkGameType() -> CGFloat {
        game.gameType == .questionnaire ? questionnaireTime() : averageTime()
    }
    
    private func questionnaireTime() -> CGFloat {
        var seconds: CGFloat
        if spendTime.isEmpty {
            seconds = 0
        } else {
            let time = allQuestionsTime()
            let timeSpent = spendTime.first ?? 0
            seconds = timeSpent / CGFloat(time) * 100
        }
        return seconds
    }
    
    private func averageTime() -> CGFloat {
        let averageTime = spendTime.reduce(0.0, +) / CGFloat(spendTime.count)
        return averageTime / CGFloat(time) * 100
    }
    
    private func timeSpend() -> CGFloat {
        var seconds: CGFloat
        if spendTime.isEmpty {
            seconds = 0
        } else {
            let timeSpent = spendTime.first ?? 0
            seconds = timeSpent / CGFloat(time) * 100
        }
        return seconds
    }
    // MARK: - Animations
    private func showAnimate(stackView: UIStackView) {
        UIView.animate(withDuration: 1) {
            self.opacity(subviews: stackView, opacity: 1)
        }
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
