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
    var titleTimeSpend: String { get }
    var imageTimeSpend: String { get }
    var numberTimeSpend: String { get }
    var rightAnswers: Int { get }
    var wrongAnswers: Int { get }
    
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
    
    func circleCorrectAnswers(_ view: UIView, completion: @escaping (CGFloat) -> Void)
    func circleIncorrectAnswers(_ view: UIView)
    
    func constraintsView(subview: UIView, layout: NSLayoutYAxisAnchor,
                         constant: CGFloat, leading: CGFloat,
                         trailing: CGFloat, height: CGFloat,
                         labelFirst: UILabel, image: UIImageView,
                         labelSecond: UILabel,_ view: UIView)
    func setupCenterSubview(_ subview: UIView, on subviewOther: UIView)
    
    func incorrectAnswersViewController() -> IncorrectAnswersViewModelProtocol
}

class ResultsViewModel: ResultsViewModelProtocol {
    var time: Int {
        isOneQuestion() ? oneQuestionTime() : allQuestionsTime()
    }
    var radiusView: CGFloat = 10
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
        let correctAnswers = CGFloat(correctAnswers.count)
        let percent = correctAnswers / CGFloat(mode.countQuestions) * 100
        return stringWithoutNull(count: percent) + "%"
    }
    
    func percentIncorrectAnswers() -> String {
        let incorrectAnswers = CGFloat(incorrectAnswers.count)
        let percent = incorrectAnswers / CGFloat(mode.countQuestions) * 100
        return stringWithoutNull(count: percent) + "%"
    }
    
    func percentCheckMode() -> CGFloat {
        isOneQuestion() ? checkGameType() : timeSpend()
    }
    // MARK: - Set circles
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
        setCircle(color: .redTangerineTango, strokeEnd: 0, start: start,
                  value: 1, duration: 0.75, view: view)
    }
    // MARK: - Transition to IncorrectAnswersViewController
    func incorrectAnswersViewController() -> IncorrectAnswersViewModelProtocol {
        IncorrectAnswersViewModel(mode: mode, game: game, results: incorrectAnswers)
    }
    // MARK: - Constraints
    func constraintsView(subview: UIView, layout: NSLayoutYAxisAnchor, 
                         constant: CGFloat, leading: CGFloat,
                         trailing: CGFloat, height: CGFloat,
                         labelFirst: UILabel, image: UIImageView, 
                         labelSecond: UILabel, _ view: UIView) {
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: layout, constant: constant),
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing),
            subview.heightAnchor.constraint(equalToConstant: height)
        ])
        
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
    private func setCircle(color: UIColor, strokeEnd: CGFloat, start: CGFloat,
                           value: Float, duration: CGFloat, view: UIView) {
        let center = CGPoint(x: view.frame.width / 2, y: 240)
        let endAngle = CGFloat.pi / 2
        let startAngle = 2 * CGFloat.pi + endAngle - start * 2 * CGFloat.pi
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: 75,
            startAngle: -startAngle,
            endAngle: -endAngle,
            clockwise: true)
        
        let trackShape = CAShapeLayer()
        trackShape.path = circularPath.cgPath
        trackShape.lineWidth = 20
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.strokeEnd = strokeEnd
        trackShape.strokeColor = color.cgColor
        trackShape.lineCap = CAShapeLayerLineCap.butt
        view.layer.addSublayer(trackShape)
        
        animateCircle(shape: trackShape, value: value, duration: duration)
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
