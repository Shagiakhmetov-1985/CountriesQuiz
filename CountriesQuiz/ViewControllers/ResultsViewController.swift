//
//  ResultsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 25.01.2023.
//

import UIKit
// MARK: - Properties
class ResultsViewController: UIViewController {
    private lazy var labelResults: UILabel = {
        let label = setLabel(
            title: "Результаты",
            style: "echorevival",
            size: 38,
            color: .blueBlackSea)
        return label
    }()
    
    private lazy var buttonDetails: UIButton = {
        let button = setButton(
            image: "lightbulb",
            color: incorrectAnswers.count > 0 ? .blueBlackSea : .grayStone,
            isEnabled: incorrectAnswers.count > 0 ? true : false,
            action: #selector(showIncorrectAnswers))
        return button
    }()
    
    private lazy var stackViewDetails: UIStackView = {
        let stackView = setupStackView(
            label: labelResults,
            button: buttonDetails)
        return stackView
    }()
    
    private lazy var viewCorrectAnswers: UIView = {
        let view = setView(
            color: .greenHarlequin,
            labelFirst: labelCorrectCount,
            image: imageCorrectAnswers,
            labelSecond: labelCorrectTitle,
            radius: 20)
        return view
    }()
    
    private lazy var labelCorrectCount: UILabel = {
        let label = setLabel(
            title: "\(correctAnswers.count)",
            style: "mr_fontick",
            size: 35,
            color: .white,
            alignment: .center)
        return label
    }()
    
    private lazy var imageCorrectAnswers: UIImageView = {
        let image = setImage(
            image: "checkmark",
            size: 26)
        return image
    }()
    
    private lazy var labelCorrectTitle: UILabel = {
        let label = setLabel(
            title: "Правильные ответы",
            style: "mr_fontick",
            size: 20,
            color: .white,
            alignment: .center)
        return label
    }()
    
    private lazy var viewIncorrectAnswers: UIView = {
        let view = setView(
            color: .redTangerineTango,
            labelFirst: labelIncorrectCount,
            image: imageIncorrectAnswers,
            labelSecond: labelIncorrectTitle,
            radius: 20)
        return view
    }()
    
    private lazy var labelIncorrectCount: UILabel = {
        let label = setLabel(
            title: "\(incorrectAnswers.count)",
            style: "mr_fontick",
            size: 35,
            color: .white,
            alignment: .center)
        return label
    }()
    
    private lazy var imageIncorrectAnswers: UIImageView = {
        let image = setImage(
            image: "multiply",
            size: 26)
        return image
    }()
    
    private lazy var labelIncorrectTitle: UILabel = {
        let label = setLabel(
            title: "Неправильные ответы",
            style: "mr_fontick",
            size: 20,
            color: .white,
            alignment: .center)
        return label
    }()
    
    private lazy var viewTimeSpend: UIView = {
        let view = setView(
            color: .blueMiddlePersian,
            labelFirst: labelNumberTimeSpend,
            image: imageTimeSpend,
            labelSecond: labelTimeSpend,
            radius: 20)
        return view
    }()
    
    private lazy var labelNumberTimeSpend: UILabel = {
        let label = setLabel(
            title: "\(numberTimeElapsedOnOff())",
            style: "mr_fontick",
            size: 35,
            color: .white,
            alignment: .center)
        return label
    }()
    
    private lazy var imageTimeSpend: UIImageView = {
        let image = setImage(
            image: "\(imageTimeElapsedOnOff())",
            size: 26)
        return image
    }()
    
    private lazy var labelTimeSpend: UILabel = {
        let label = setLabel(
            title: "\(labelTimeElapsedOnOff())",
            style: "mr_fontick",
            size: 20,
            color: .white,
            alignment: .center)
        return label
    }()
    
    private lazy var imageInfinity: UIImageView = {
        let imageView = setImage(
            image: "infinity",
            size: 35)
        return imageView
    }()
    
    private lazy var viewCountQuestions: UIView = {
        let view = setView(
            color: .gummigut,
            labelFirst: labelCountQuestions,
            image: imageCountQuestions,
            labelSecond: labelCountTitle,
            radius: 20)
        return view
    }()
    
    private lazy var labelCountQuestions: UILabel = {
        let label = setLabel(
            title: "\(mode.countQuestions)",
            style: "mr_fontick",
            size: 35,
            color: .white,
            alignment: .center)
        return label
    }()
    
    private lazy var imageCountQuestions: UIImageView = {
        let image = setImage(
            image: "questionmark.bubble",
            size: 26)
        return image
    }()
    
    private lazy var labelCountTitle: UILabel = {
        let label = setLabel(
            title: "Количество вопросов",
            style: "mr_fontick",
            size: 20,
            color: .white,
            alignment: .center)
        return label
    }()
    
    private lazy var viewPercentCorrect: UIView = {
        let view = setView(
            color: .greenHarlequin,
            radius: radiusView())
        return view
    }()
    
    private lazy var labelPercentCorrect: UILabel = {
        let label = setLabel(
            title: "\(percentCorrectAnswers())",
            style: "mr_fontick",
            size: 26,
            color: .blueBlackSea)
        return label
    }()
    
    private lazy var stackViewCorrect: UIStackView = {
        let stackView = setupStackView(
            view: viewPercentCorrect,
            label: labelPercentCorrect)
        return stackView
    }()
    
    private lazy var viewPercentIncorrect: UIView = {
        let view = setView(
            color: .redTangerineTango,
            radius: radiusView())
        return view
    }()
    
    private lazy var labelPercentIncorrect: UILabel = {
        let label = setLabel(
            title: "\(percentIncorrectAnswers())",
            style: "mr_fontick",
            size: 26,
            color: .blueBlackSea)
        return label
    }()
    
    private lazy var stackViewIncorrect: UIStackView = {
        let stackView = setupStackView(
            view: viewPercentIncorrect,
            label: labelPercentIncorrect)
        return stackView
    }()
    
    private lazy var viewPercentTimeSpend: UIView = {
        let view = setView(
            color: .blueMiddlePersian,
            radius: radiusView())
        return view
    }()
    
    private lazy var labelPercentTimeSpend: UILabel = {
        let label = setLabel(
            title: "\(percentTimeSpend())",
            style: "mr_fontick",
            size: 26,
            color: .blueBlackSea)
        return label
    }()
    
    private lazy var stackViewTimeSpend: UIStackView = {
        let stackView = setupStackView(
            view: viewPercentTimeSpend,
            label: labelPercentTimeSpend)
        return stackView
    }()
    
    private lazy var stackViews: UIStackView = {
        let stackView = setupStackView(
            stackViewFirst: stackViewCorrect,
            stackViewSecond: stackViewIncorrect,
            stackViewThird: stackViewTimeSpend)
        return stackView
    }()
    
    private lazy var buttonComplete: UIButton = {
        let button = setButtonComplete()
        return button
    }()
    
    var correctAnswers: [Countries]!
    var incorrectAnswers: [Results]!
    var mode: Setting!
    var game: Games!
    var spendTime: [CGFloat]!
    
    private var timer = Timer()
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupSubviews()
        setupTimer()
        setConstraints()
    }
    
    private func setupDesign() {
        view.backgroundColor = .skyCyanLight
        navigationItem.hidesBackButton = true
        imageInfinity.isHidden = timeElapsedCheck() ? true : false
    }
    
    private func setupSubviews() {
        setupSubviews(subviews: stackViewDetails, viewCorrectAnswers,
                      viewIncorrectAnswers, viewTimeSpend,
                      viewCountQuestions, imageInfinity, stackViews,
                      buttonComplete,
                      on: view)
        opacity(subviews: stackViewCorrect, stackViewIncorrect, stackViewTimeSpend,
                opacity: 0)
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    private func opacity(subviews: UIView..., opacity: Float) {
        subviews.forEach { subview in
            subview.layer.opacity = opacity
        }
    }
    
    private func runTimer(interval: CGFloat, action: Selector) -> Timer {
        Timer.scheduledTimer(timeInterval: interval, target: self,
                             selector: action, userInfo: nil, repeats: false)
    }
    
    private func setupTimer() {
        timer = runTimer(interval: 0.3, action: #selector(circleCorrectAnswers))
    }
    
    @objc private func circleCorrectAnswers() {
        timer.invalidate()
        let delay = 0.75
        let delayTimer = delay + 0.3
        let correctAnswers = Float(correctAnswers.count)
        let value = correctAnswers / Float(mode.countQuestions)
        setCircle(color: .greenHarlequin.withAlphaComponent(0.3), radius: 80, strokeEnd: 1)
        setCircle(color: .greenHarlequin, radius: 80, strokeEnd: 0, value: value, duration: delay)
        showAnimate(stackView: stackViewCorrect)
        
        timer = runTimer(interval: delayTimer, action: #selector(circleIncorrectAnswers))
    }
    
    @objc private func circleIncorrectAnswers() {
        timer.invalidate()
        let delay = 0.75
        let delayTimer = delay + 0.3
        let incorrectAnswers = Float(incorrectAnswers.count)
        let value = incorrectAnswers / Float(mode.countQuestions)
        setCircle(color: .redTangerineTango.withAlphaComponent(0.3), radius: 61, strokeEnd: 1)
        setCircle(color: .redTangerineTango, radius: 61, strokeEnd: 0, value: value, duration: delay)
        showAnimate(stackView: stackViewIncorrect)
        
        timer = runTimer(interval: delayTimer, action: #selector(circleSpentTime))
    }
    
    @objc private func circleSpentTime() {
        timer.invalidate()
        let delay = 0.75
        let value = checkCircleTime() / 100
        setCircle(color: .blueMiddlePersian.withAlphaComponent(0.3), radius: 42, strokeEnd: 1)
        setCircle(color: .blueMiddlePersian, radius: 42, strokeEnd: 0, value: value, duration: delay)
        showAnimate(stackView: stackViewTimeSpend)
    }
    
    private func showAnimate(stackView: UIStackView) {
        UIView.animate(withDuration: 1) {
            self.opacity(subviews: stackView, opacity: 1)
        }
    }
    
    private func checkCircleTime() -> Float {
        roundf(Float(percentTimeCheck() * 100)) / 100
    }
    
    private func oneQuestionSeconds() -> Int {
        let seconds: Int
        if oneQuestionCheck() {
            seconds = mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
        } else {
            seconds = mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
        }
        return seconds
    }
    
    private func oneQuestionCheck() -> Bool {
        mode.timeElapsed.questionSelect.oneQuestion ? true : false
    }
    
    private func timeElapsedCheck() -> Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    
    private func labelTimeElapsedOnOff() -> String {
        timeElapsedCheck() ? "\(labelCheckTimeSpend())" : "Обратный отсчет выключен"
    }
    
    private func labelCheckTimeSpend() -> String {
        oneQuestionCheck() ? labelQuestionnaireTimeSpend() : labelCheckAllQuestions()
    }
    
    private func labelQuestionnaireTimeSpend() -> String {
        game.gameType == .questionnaire ? labelCheckAllQuestions() : "Среднее время на вопрос"
    }
    
    private func labelCheckAllQuestions() -> String {
        spendTime.isEmpty ? "Вы не успели ответить за это время" :
        "Потраченное время на все вопросы"
    }
    
    private func imageTimeElapsedOnOff() -> String {
        timeElapsedCheck() ? "\(imageCheckTimeSpend())" : "clock.badge.xmark"
    }
    
    private func imageCheckTimeSpend() -> String {
        oneQuestionCheck() ? "timer" : imageCheckAllQuestions()
    }
    
    private func imageCheckAllQuestions() -> String {
        spendTime.isEmpty ? "clock" : "timer"
    }
    
    private func numberTimeElapsedOnOff() -> String {
        timeElapsedCheck() ? "\(numberCheckTimeSpend())" : " "
    }
    
    private func numberCheckTimeSpend() -> String {
        var text: String
        if oneQuestionCheck() {
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
    
    private func percentCorrectAnswers() -> String {
        let correctAnswers = CGFloat(correctAnswers.count)
        let percent = correctAnswers / CGFloat(mode.countQuestions) * 100
        return stringWithoutNull(count: percent) + "%"
    }
    
    private func percentIncorrectAnswers() -> String {
        let incorrectAnswers = CGFloat(incorrectAnswers.count)
        let percent = incorrectAnswers / CGFloat(mode.countQuestions) * 100
        return stringWithoutNull(count: percent) + "%"
    }
    
    private func percentTimeSpend() -> String {
        timeElapsedCheck() ? stringWithoutNull(count: percentTimeCheck()) + "%" : " "
    }
    
    private func percentTimeCheck() -> CGFloat {
        oneQuestionCheck() ? checkGameType() : timeSpend()
    }
    
    private func checkGameType() -> CGFloat {
        game.gameType == .questionnaire ? questionnaireTime() : averageTime()
    }
    
    private func questionnaireTime() -> CGFloat {
        var seconds: CGFloat
        if spendTime.isEmpty {
            seconds = 0
        } else {
            let time = mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
            let timeSpent = spendTime.first ?? 0
            seconds = timeSpent / CGFloat(time) * 100
        }
        return seconds
    }
    
    private func averageTime() -> CGFloat {
        let averageTime = spendTime.reduce(0.0, +) / CGFloat(spendTime.count)
        return averageTime / CGFloat(oneQuestionSeconds()) * 100
    }
    
    private func timeSpend() -> CGFloat {
        var seconds: CGFloat
        if spendTime.isEmpty {
            seconds = 0
        } else {
            let timeSpent = spendTime.first ?? 0
            seconds = timeSpent / CGFloat(oneQuestionSeconds()) * 100
        }
        return seconds
    }
    
    private func string(seconds: CGFloat) -> String {
        String(format: "%.2f", seconds)
    }
    
    private func round(count: CGFloat) -> String {
        String(format: "%.1f", count)
    }
    
    private func stringWithoutNull(count: CGFloat) -> String {
        String(format: "%.0f", count)
    }
    
    @objc private func exitToMenu() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func showIncorrectAnswers() {
        let incorrectAnswersVC = IncorrectAnswersViewController()
        let navigationVC = UINavigationController(rootViewController: incorrectAnswersVC)
        incorrectAnswersVC.mode = mode
        incorrectAnswersVC.game = game
        incorrectAnswersVC.results = incorrectAnswers
        navigationVC.modalPresentationStyle = .custom
        present(navigationVC, animated: true)
    }
}
// MARK: - Setup view
extension ResultsViewController {
    private func setView(color: UIColor, labelFirst: UILabel? = nil, image: UIImageView? = nil,
                         labelSecond: UILabel? = nil, radius: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = radius
        view.translatesAutoresizingMaskIntoConstraints = false
        if let labelFirst = labelFirst, let image = image, let labelSecond = labelSecond {
            setupSubviews(subviews: labelFirst, image, labelSecond, on: view)
        }
        return view
    }
}
// MARK: - Setup button
extension ResultsViewController {
    private func setButton(image: String, color: UIColor, isEnabled: Bool,
                           action: Selector) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 26)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = Button(type: .custom)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = color
        button.layer.cornerRadius = 12
        button.layer.shadowOpacity = 0.4
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = isEnabled
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setButtonComplete() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Завершить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "mr_fontick", size: 25)
        button.backgroundColor = .blueBlackSea
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.blueBlackSea.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(exitToMenu), for: .touchUpInside)
        return button
    }
}
// MARK: - Setup label
extension ResultsViewController {
    private func setLabel(title: String, style: String, size: CGFloat,
                          color: UIColor, alignment: NSTextAlignment? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: style, size: size)
        label.textColor = color
        label.numberOfLines = 0
        label.textAlignment = alignment ?? .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup stack views
extension ResultsViewController {
    private func setupStackView(label: UILabel, button: UIButton) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [label, button])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setupStackView(view: UIView, label: UILabel) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [view, label])
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setupStackView(stackViewFirst: UIStackView,
                                stackViewSecond: UIStackView,
                                stackViewThird: UIStackView) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [stackViewFirst, stackViewSecond, stackViewThird])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Setup images
extension ResultsViewController {
    private func setImage(image: String, size: CGFloat) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: size)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
// MARK: - Setup circle shapes
extension ResultsViewController {
    private func setCircle(color: UIColor, radius: CGFloat, strokeEnd: CGFloat,
                           value: Float? = nil, duration: CGFloat? = nil) {
        let center = CGPoint(x: view.frame.width / 3, y: 230)
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
        trackShape.lineWidth = 16
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
// MARK: - Setup constraints
extension ResultsViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackViewDetails.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackViewDetails.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewDetails.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        setupSquare(subview: buttonDetails, sizes: 40)
        
        constraintsView(subview: viewCorrectAnswers, layout: view.topAnchor,
                        constant: 335, leading: 20, trailing: -widthHalf(),
                        height: 110, labelFirst: labelCorrectCount,
                        image: imageCorrectAnswers, labelSecond: labelCorrectTitle)
        constraintsView(subview: viewIncorrectAnswers, layout: viewCorrectAnswers.bottomAnchor,
                        constant: 20, leading: 20, trailing: -widthHalf(),
                        height: 110, labelFirst: labelIncorrectCount,
                        image: imageIncorrectAnswers, labelSecond: labelIncorrectTitle)
        constraintsView(subview: viewTimeSpend, layout: view.topAnchor,
                        constant: 335, leading: widthHalf(), trailing: -20,
                        height: 120, labelFirst: labelNumberTimeSpend,
                        image: imageTimeSpend, labelSecond: labelTimeSpend)
        constraintsView(subview: viewCountQuestions, layout: viewTimeSpend.bottomAnchor,
                        constant: 20, leading: widthHalf(), trailing: -20,
                        height: 100, labelFirst: labelCountQuestions,
                        image: imageCountQuestions, labelSecond: labelCountTitle)
        
        setupCenterSubview(subview: imageInfinity, on: labelNumberTimeSpend)
        
        setupSquare(subview: viewPercentCorrect, sizes: radiusView() * 2)
        setupSquare(subview: viewPercentIncorrect, sizes: radiusView() * 2)
        setupSquare(subview: viewPercentTimeSpend, sizes: radiusView() * 2)
        NSLayoutConstraint.activate([
            stackViews.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 230),
            stackViews.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width / 1.5),
            stackViews.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            buttonComplete.topAnchor.constraint(equalTo: viewCountQuestions.bottomAnchor, constant: 40),
            buttonComplete.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonComplete.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonComplete.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    private func widthHalf() -> CGFloat {
        view.frame.width / 2 + 10
    }
    
    private func constraintsView(subview: UIView, layout: NSLayoutYAxisAnchor,
                                 constant: CGFloat, leading: CGFloat,
                                 trailing: CGFloat, height: CGFloat,
                                 labelFirst: UILabel, image: UIImageView,
                                 labelSecond: UILabel) {
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
    
    private func radiusView() -> CGFloat {
        10
    }
    
    private func setupSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    private func setupCenterSubview(subview: UIView, on subviewOther: UIView) {
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: subviewOther.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: subviewOther.centerYAnchor)
        ])
    }
}
