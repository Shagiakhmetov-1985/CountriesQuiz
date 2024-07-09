//
//  RatioViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 04.07.2024.
//

import UIKit

protocol RatioViewModelProtocol {
    var titlePanel: String { get }
    var radius: CGFloat { get }
    var countCorrect: String { get }
    var percentCorrect: String { get }
    var progressCorrect: Float { get }
    
    init(mode: Setting, game: Games, correctAnswers: [Countries],
         incorrectAnswers: [Results], timeSpend: [CGFloat], answeredQuestions: Int)
    
    func setupSubviews(subviews: UIView..., on subviewOther: UIView)
    func setSquare(subview: UIView, sizes: CGFloat)
    func constraintsPanel(button: UIButton, label: UILabel, on subview: UIView)
    func setCircles(_ subview: UIView,_ view: UIView)
    func setProgressCircles(_ subview: UIView,_ view: UIView)
    func setupCenterSubview(_ subview: UIView, on subviewOther: UIView)
    func constraintsView(image: UIImageView, title: UILabel, count: UILabel, percent: UILabel,
                         progressView: UIProgressView, on view: UIView)
}

class RatioViewModel: RatioViewModelProtocol {
    var titlePanel: String = "Соотношение ответов"
    var radius: CGFloat = 5
    var countCorrect: String {
        "\(correctAnswers.count)"
    }
    var percentCorrect: String {
        stringWithoutNull(valueCorrect * 100) + "%"
    }
    var progressCorrect: Float {
        Float(valueCorrect)
    }
    private var valueCorrect: CGFloat {
        CGFloat(correctAnswers.count) / CGFloat(mode.countQuestions)
    }
    private var valueIncorrect: CGFloat {
        CGFloat(incorrectAnswers.count) / CGFloat(mode.countQuestions)
    }
    private var valueTime: CGFloat {
        isOneQuestion ? checkGameType() : timeSpend()
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
    
    private var mode: Setting
    private var game: Games
    private var correctAnswers: [Countries]
    private var incorrectAnswers: [Results]
    private var spendTime: [CGFloat]
    private var answeredQuestions: Int
    
    required init(mode: Setting, game: Games, correctAnswers: [Countries], 
                  incorrectAnswers: [Results], timeSpend: [CGFloat], answeredQuestions: Int) {
        self.mode = mode
        self.game = game
        self.correctAnswers = correctAnswers
        self.incorrectAnswers = incorrectAnswers
        self.spendTime = timeSpend
        self.answeredQuestions = answeredQuestions
    }
    
    func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
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
    
    func constraintsView(image: UIImageView, title: UILabel, count: UILabel, 
                         percent: UILabel, progressView: UIProgressView, on view: UIView) {
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            title.topAnchor.constraint(equalTo: image.topAnchor),
            title.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            count.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            count.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            percent.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            percent.leadingAnchor.constraint(equalTo: count.trailingAnchor, constant: 40),
            percent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            progressView.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -5),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            progressView.heightAnchor.constraint(equalToConstant: radius * 2)
        ])
    }
    // MARK: - Set circles
    func setCircles(_ subview: UIView, _ view: UIView) {
        setCircle(subview, color: .greenEmerald.withAlphaComponent(0.3), radius: 100, view: view)
        setCircle(subview, color: .bismarkFuriozo.withAlphaComponent(0.3), radius: 77, view: view)
        setCircle(subview, color: .blueMiddlePersian.withAlphaComponent(0.3), radius: 54, view: view)
        setCircle(subview, color: .gummigut.withAlphaComponent(0.3), radius: 31, view: view)
    }
    
    func setProgressCircles(_ subview: UIView, _ view: UIView) {
        setCircle(subview, color: .greenEmerald, radius: 100, strokeEnd: valueCorrect, view: view)
        setCircle(subview, color: .bismarkFuriozo, radius: 77, strokeEnd: valueIncorrect, view: view)
        setCircle(subview, color: .blueMiddlePersian, radius: 54, strokeEnd: valueTime, view: view)
        setCircle(subview, color: .gummigut, radius: 31, strokeEnd: valueAnsweredQuestions, view: view)
    }
}

extension RatioViewModel {
    // MARK: - Set custom circles
    private func setCircle(_ subview: UIView, color: UIColor, radius: CGFloat,
                           strokeEnd: CGFloat? = nil, view: UIView) {
        let center = CGPoint(x: subview.center.x, y: subview.center.y)
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
        game.gameType == .questionnaire ? timeSpend() : averageTime()
    }
    
    private func timeSpend() -> CGFloat {
        if spendTime.isEmpty {
            return 0
        } else {
            return spendTime.first ?? 0 / CGFloat(allQuestionsTime)
        }
    }
    
    private func averageTime() -> CGFloat {
        let averageTime = spendTime.reduce(0.0, +) / CGFloat(spendTime.count)
        return averageTime / CGFloat(oneQuestionTime)
    }
    // MARK: - String format
    private func stringWithoutNull(_ count: CGFloat) -> String {
        String(format: "%.0f", count)
    }
}
