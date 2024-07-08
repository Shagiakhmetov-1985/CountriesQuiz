//
//  RatioViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 04.07.2024.
//

import UIKit

protocol RatioViewModelProtocol {
    var titlePanel: String { get }
    var valueCorrect: Float { get }
    var valueIncorrect: Float { get }
    var valueTime: Float { get }
    var isOneQuestion: Bool { get }
    var oneQuestionTime: Int { get }
    var allQuestionsTime: Int { get }
    
    var mode: Setting { get }
    var game: Games { get }
    var correctAnswers: [Countries] { get }
    var incorrectAnswers: [Results] { get }
    var spendTime: [CGFloat] { get }
    
    init(mode: Setting, game: Games, correctAnswers: [Countries],
         incorrectAnswers: [Results], timeSpend: [CGFloat])
    
    func setupSubviews(subviews: UIView..., on subviewOther: UIView)
    func setSquare(subview: UIView, sizes: CGFloat)
    func constraintsPanel(button: UIButton, label: UILabel, on subview: UIView)
    func setCircles(_ subview: UIView,_ view: UIView)
    func setProgressCircles(_ subview: UIView,_ view: UIView)
}

class RatioViewModel: RatioViewModelProtocol {
    var titlePanel: String = "Соотношение ответов"
    var valueCorrect: Float {
        Float(correctAnswers.count) / Float(mode.countQuestions)
    }
    var valueIncorrect: Float {
        Float(incorrectAnswers.count) / Float(mode.countQuestions)
    }
    var valueTime: Float {
        isOneQuestion ? checkGameType() : timeSpend()
    }
    var isOneQuestion: Bool {
        mode.timeElapsed.questionSelect.oneQuestion ? true : false
    }
    var oneQuestionTime: Int {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
    }
    var allQuestionsTime: Int {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
    }
    
    var mode: Setting
    var game: Games
    var correctAnswers: [Countries]
    var incorrectAnswers: [Results]
    var spendTime: [CGFloat]
    
    required init(mode: Setting, game: Games, correctAnswers: [Countries], 
                  incorrectAnswers: [Results], timeSpend: [CGFloat]) {
        self.mode = mode
        self.game = game
        self.correctAnswers = correctAnswers
        self.incorrectAnswers = incorrectAnswers
        self.spendTime = timeSpend
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
    // MARK: - Set circles
    func setCircles(_ subview: UIView, _ view: UIView) {
        setCircle(subview, color: .greenEmerald.withAlphaComponent(0.3), radius: 100, view: view)
        setCircle(subview, color: .bismarkFuriozo.withAlphaComponent(0.3), radius: 77, view: view)
        setCircle(subview, color: .blueMiddlePersian.withAlphaComponent(0.3), radius: 54, view: view)
        setCircle(subview, color: .gummigut.withAlphaComponent(0.3), radius: 31, view: view)
    }
    
    func setProgressCircles(_ subview: UIView, _ view: UIView) {
        setCircle(subview, color: .greenEmerald, radius: 100, strokeEnd: 0, value: valueCorrect, view: view)
        setCircle(subview, color: .bismarkFuriozo, radius: 77, strokeEnd: 0, value: valueIncorrect, view: view)
        setCircle(subview, color: .blueMiddlePersian, radius: 54, strokeEnd: 0, value: valueTime, view: view)
        setCircle(subview, color: .gummigut, radius: 31, strokeEnd: 0, value: <#T##Float?#>, view: <#T##UIView#>)
    }
}

extension RatioViewModel {
    // MARK: - Set custom circles
    private func setCircle(_ subview: UIView, color: UIColor, radius: CGFloat,
                           strokeEnd: CGFloat? = nil, value: Float? = nil, view: UIView) {
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
        
        if let value = value {
            animateCircle(shape: trackShape, value: value)
        }
    }
    
    private func animateCircle(shape: CAShapeLayer, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = value
        animation.duration = CFTimeInterval(0.75)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shape.add(animation, forKey: "animation")
    }
    // MARK: - Set value time
    private func checkGameType() -> Float {
        game.gameType == .questionnaire ? timeSpend() : averageTime()
    }
    
    private func timeSpend() -> Float {
        if spendTime.isEmpty {
            return 0
        } else {
            return Float(spendTime.first ?? 0) / Float(allQuestionsTime)
        }
    }
    
    private func averageTime() -> Float {
        let averageTime = Float(spendTime.reduce(0.0, +)) / Float(spendTime.count)
        return averageTime / Float(oneQuestionTime)
    }
}
