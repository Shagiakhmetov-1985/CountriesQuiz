//
//  RatioViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 04.07.2024.
//

import UIKit

protocol RatioViewModelProtocol {
    var title: String { get }
    var titleCorrect: String { get }
    var titleIncorrect: String { get }
    var titleTimeSpend: String { get }
    var titleAnswered: String { get }
    var radius: CGFloat { get }
    var dataCorrect: String { get }
    var progressCorrect: Float { get }
    var dataIncorrect: String { get }
    var progressIncorrect: Float { get }
    var imageTimeSpend: String { get }
    var dataTimeSpend: String { get }
    var progressTimeSpend: Float { get }
    var dataAnswered: String { get }
    var progressAnswered: Float { get }
    var isTime: Bool { get }
    
    init(mode: Setting, game: Games, correctAnswers: [Countries],
         incorrectAnswers: [Results], timeSpend: [CGFloat], answeredQuestions: Int)
    
    func setupSubviews(subviews: UIView..., on subviewOther: UIView)
    func setBarButton(_ button: UIButton,_ navigationItem: UINavigationItem)
    func setSquare(subview: UIView, sizes: CGFloat)
    func constraintsPanel(button: UIButton, label: UILabel, on subview: UIView)
    func setCircles(_ subview: UIView,_ view: UIView)
    func setProgressCircles(_ subview: UIView,_ view: UIView)
    func setupCenterSubview(_ subview: UIView, on subviewOther: UIView)
    func constraints(image: UIImageView, layout: NSLayoutYAxisAnchor, constant: CGFloat,
                     title: UILabel, count: UILabel, progressView: UIProgressView,
                     view: UIView)
    func setInsteadSubview(_ subview: UIView, on subviewOther: UIView)
}

class RatioViewModel: RatioViewModelProtocol {
    var title: String = "Статистика"
    var titleCorrect: String = "Правильные"
    var titleIncorrect: String = "Неправильные"
    var titleTimeSpend: String {
        isTime ? "\(checkTitleTimeSpend())" : "Нет таймера"
    }
    var titleAnswered: String = "Отвеченные вопросы"
    var radius: CGFloat = 5
    var dataCorrect: String {
        "\(correctAnswers.count) | \(percentCorrect)"
    }
    var progressCorrect: Float {
        Float(valueCorrect)
    }
    var dataIncorrect: String {
        "\(incorrectAnswers.count) | \(percentIncorrect)"
    }
    var progressIncorrect: Float {
        Float(valueIncorrect)
    }
    var imageTimeSpend: String {
        isTime ? "\(checkImageTimeSpend())" : "clock.badge.xmark"
    }
    var dataTimeSpend: String {
        isTime ? "\(checkNumberTimeSpend()) | \(percentTimeSpend)" : " "
    }
    var progressTimeSpend: Float {
        Float(valueTime)
    }
    var dataAnswered: String {
        "\(answeredQuestions) | \(percentAnswered)"
    }
    var progressAnswered: Float {
        Float(valueAnsweredQuestions)
    }
    var isTime: Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    private var valueCorrect: CGFloat {
        CGFloat(correctAnswers.count) / CGFloat(mode.countQuestions)
    }
    private var valueIncorrect: CGFloat {
        CGFloat(incorrectAnswers.count) / CGFloat(mode.countQuestions)
    }
    private var valueTime: CGFloat {
        isOneQuestion ? checkGameType() : setTimeSpend()
    }
    private var valueAnsweredQuestions: CGFloat {
        CGFloat(answeredQuestions) / CGFloat(mode.countQuestions)
    }
    private var isOneQuestion: Bool {
        mode.timeElapsed.questionSelect.oneQuestion ? true : false
    }
    private var oneQuestionTime: Int {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
    }
    private var allQuestionsTime: Int {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
    }
    private var percentCorrect: String {
        stringWithoutNull(valueCorrect * 100) + "%"
    }
    private var percentIncorrect: String {
        stringWithoutNull(valueIncorrect * 100) + "%"
    }
    private var percentTimeSpend: String {
        stringWithoutNull(valueTime * 100) + "%"
    }
    private var percentAnswered: String {
        stringWithoutNull(valueAnsweredQuestions * 100) + "%"
    }
    
    private var mode: Setting
    private var game: Games
    private var correctAnswers: [Countries]
    private var incorrectAnswers: [Results]
    private var timeSpend: [CGFloat]
    private var answeredQuestions: Int
    
    required init(mode: Setting, game: Games, correctAnswers: [Countries], 
                  incorrectAnswers: [Results], timeSpend: [CGFloat], answeredQuestions: Int) {
        self.mode = mode
        self.game = game
        self.correctAnswers = correctAnswers
        self.incorrectAnswers = incorrectAnswers
        self.timeSpend = timeSpend
        self.answeredQuestions = answeredQuestions
    }
    
    func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    func setBarButton(_ button: UIButton, _ navigationItem: UINavigationItem) {
        let leftBarButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    // MARK: - Constraints
    func setSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    func constraintsPanel(button: UIButton, label: UILabel, on subview: UIView) {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: subview.topAnchor, constant: 12.5),
            button.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 12.5),
            label.centerXAnchor.constraint(equalTo: subview.centerXAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: subview.topAnchor, constant: 31.875)
        ])
    }
    
    func setupCenterSubview(_ subview: UIView, on subviewOther: UIView) {
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: subviewOther.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: subviewOther.centerYAnchor)
        ])
    }
    
    func constraints(image: UIImageView, layout: NSLayoutYAxisAnchor, constant: CGFloat,
                     title: UILabel, count: UILabel, progressView: UIProgressView,
                     view: UIView) {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: layout, constant: constant),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12.5),
            title.centerYAnchor.constraint(equalTo: image.centerYAnchor, constant: -17.5),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 82.5),
            count.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 20),
            count.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            count.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressView.centerYAnchor.constraint(equalTo: image.centerYAnchor, constant: 17.5),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 82.5),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressView.heightAnchor.constraint(equalToConstant: radius * 2)
        ])
    }
    
    func setInsteadSubview(_ subview: UIView, on subviewOther: UIView) {
        NSLayoutConstraint.activate([
            subview.trailingAnchor.constraint(equalTo: subviewOther.trailingAnchor),
            subview.centerYAnchor.constraint(equalTo: subviewOther.centerYAnchor)
        ])
    }
    
    // MARK: - Set circles
    func setCircles(_ subview: UIView, _ view: UIView) {
        setCircle(subview, color: .greenEmerald.withAlphaComponent(0.3), radius: 105, view: view)
        setCircle(subview, color: .bismarkFuriozo.withAlphaComponent(0.3), radius: 82, view: view)
        setCircle(subview, color: .blueMiddlePersian.withAlphaComponent(0.3), radius: 59, view: view)
        setCircle(subview, color: .gummigut.withAlphaComponent(0.3), radius: 36, view: view)
    }
    
    func setProgressCircles(_ subview: UIView, _ view: UIView) {
        setCircle(subview, color: .greenEmerald, radius: 105, strokeEnd: valueCorrect, view: view)
        setCircle(subview, color: .bismarkFuriozo, radius: 82, strokeEnd: valueIncorrect, view: view)
        setCircle(subview, color: .blueMiddlePersian, radius: 59, strokeEnd: valueTime, view: view)
        setCircle(subview, color: .gummigut, radius: 36, strokeEnd: valueAnsweredQuestions, view: view)
    }
}

extension RatioViewModel {
    // MARK: - Set custom circles
    private func setCircle(_ subview: UIView, color: UIColor, radius: CGFloat,
                           strokeEnd: CGFloat? = nil, view: UIView) {
        let center = CGPoint(x: subview.center.x, y: subview.center.y + 147.5)
        let endAngle = CGFloat.pi / 2
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -startAngle,
            endAngle: -endAngle,
            clockwise: true)
        
        let trackShape = CAShapeLayer()
        trackShape.path = circularPath.cgPath
        trackShape.lineWidth = 20
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.strokeEnd = strokeEnd ?? 1
        trackShape.strokeColor = color.cgColor
        trackShape.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackShape)
    }
    /*
    private func animateCircle(shape: CAShapeLayer, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = value
        animation.duration = CFTimeInterval(0.75)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shape.add(animation, forKey: "animation")
    }
     */
    // MARK: - Set value time
    private func checkGameType() -> CGFloat {
        game.gameType == .questionnaire ? setTimeSpend() : averageTime()
    }
    
    private func setTimeSpend() -> CGFloat {
        if timeSpend.isEmpty {
            return 0
        } else {
            let timeSpend = timeSpend.first ?? 0
            return timeSpend / CGFloat(allQuestionsTime)
        }
    }
    
    private func averageTime() -> CGFloat {
        let averageTime = timeSpend.reduce(0.0, +) / CGFloat(timeSpend.count)
        return averageTime / CGFloat(oneQuestionTime)
    }
    // MARK: - String format
    private func string(_ seconds: CGFloat) -> String {
        String(format: "%.2f", seconds)
    }
    
    private func stringWithoutNull(_ count: CGFloat) -> String {
        String(format: "%.0f", count)
    }
    // MARK: - Constants
    private func checkImageTimeSpend() -> String {
        isOneQuestion ? "timer" : imageAllQuestions()
    }
    
    private func imageAllQuestions() -> String {
        timeSpend.isEmpty ? "clock" : "timer"
    }
    
    private func checkTitleTimeSpend() -> String {
        isOneQuestion ? isQuestionnaire() : titleAllQuestions()
    }
    
    private func isQuestionnaire() -> String {
        game.gameType == .questionnaire ? titleAllQuestions() : "Среднее время"
    }
    
    private func titleAllQuestions() -> String {
        timeSpend.isEmpty ? "Время вышло" : "Потраченное время"
    }
    
    private func checkNumberTimeSpend() -> String {
        if isOneQuestion {
            let averageTime = timeSpend.reduce(0.0, +) / CGFloat(timeSpend.count)
            return "\(string(averageTime))"
        } else {
            return numberCheckAllQuestions()
        }
    }
    
    private func numberCheckAllQuestions() -> String {
        timeSpend.isEmpty ? "0" : "\(string(timeSpend.first ?? 0))"
    }
}
