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
        setLabel(
            title: "Результаты",
            style: "echorevival",
            size: 38,
            color: .blueBlackSea)
    }()
    
    private lazy var buttonDetails: UIButton = {
        let color: UIColor = viewModel.incorrectAnswers.count > 0 ? .blueBlackSea : .grayStone
        let size = UIImage.SymbolConfiguration(pointSize: 26)
        let image = UIImage(systemName: "lightbulb", withConfiguration: size)
        let button = Button(type: .custom)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = color
        button.layer.cornerRadius = 12
        button.layer.shadowOpacity = 0.4
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = viewModel.incorrectAnswers.count > 0 ? true : false
        button.addTarget(self, action: #selector(showIncorrectAnswers), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackViewDetails: UIStackView = {
        setupStackView(subviewFirst: labelResults, subviewSecond: buttonDetails)
    }()
    
    private lazy var viewCorrectAnswers: UIView = {
        setView(
            color: .greenHarlequin,
            labelFirst: labelCorrectCount,
            image: imageCorrectAnswers,
            labelSecond: labelCorrectTitle,
            radius: 20)
    }()
    
    private lazy var labelCorrectCount: UILabel = {
        setLabel(
            title: "\(viewModel.correctAnswers.count)",
            style: "mr_fontick",
            size: 35,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var imageCorrectAnswers: UIImageView = {
        setImage(image: "checkmark", size: 26)
    }()
    
    private lazy var labelCorrectTitle: UILabel = {
        setLabel(
            title: "Правильные ответы",
            style: "mr_fontick",
            size: 20,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var viewIncorrectAnswers: UIView = {
        setView(
            color: .redTangerineTango,
            labelFirst: labelIncorrectCount,
            image: imageIncorrectAnswers,
            labelSecond: labelIncorrectTitle,
            radius: 20)
    }()
    
    private lazy var labelIncorrectCount: UILabel = {
        setLabel(
            title: "\(viewModel.incorrectAnswers.count)",
            style: "mr_fontick",
            size: 35,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var imageIncorrectAnswers: UIImageView = {
        setImage(image: "multiply", size: 26)
    }()
    
    private lazy var labelIncorrectTitle: UILabel = {
        setLabel(
            title: "Неправильные ответы",
            style: "mr_fontick",
            size: 20,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var viewTimeSpend: UIView = {
        setView(
            color: .blueMiddlePersian,
            labelFirst: labelNumberTimeSpend,
            image: imageTimeSpend,
            labelSecond: labelTimeSpend,
            radius: 20)
    }()
    
    private lazy var labelNumberTimeSpend: UILabel = {
        setLabel(
            title: viewModel.numberTimeSpend,
            style: "mr_fontick",
            size: 35,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var imageTimeSpend: UIImageView = {
        setImage(image: viewModel.imageTimeSpend, size: 26)
    }()
    
    private lazy var labelTimeSpend: UILabel = {
        setLabel(
            title: viewModel.titleTimeSpend,
            style: "mr_fontick",
            size: 20,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var imageInfinity: UIImageView = {
        setImage(image: "infinity", size: 35)
    }()
    
    private lazy var viewCountQuestions: UIView = {
        setView(
            color: .gummigut,
            labelFirst: labelCountQuestions,
            image: imageCountQuestions,
            labelSecond: labelCountTitle,
            radius: 20)
    }()
    
    private lazy var labelCountQuestions: UILabel = {
        setLabel(
            title: "\(viewModel.mode.countQuestions)",
            style: "mr_fontick",
            size: 35,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var imageCountQuestions: UIImageView = {
        setImage(image: "questionmark.bubble", size: 26)
    }()
    
    private lazy var labelCountTitle: UILabel = {
        setLabel(
            title: "Количество вопросов",
            style: "mr_fontick",
            size: 20,
            color: .white,
            alignment: .center)
    }()
    
    private lazy var viewPercentCorrect: UIView = {
        setView(color: .greenHarlequin, radius: viewModel.radiusView)
    }()
    
    private lazy var labelPercentCorrect: UILabel = {
        setLabel(
            title: viewModel.percentCorrectAnswers(),
            style: "mr_fontick",
            size: 26,
            color: .blueBlackSea)
    }()
    
    private lazy var stackViewCorrect: UIStackView = {
        setupStackView(
            subviewFirst: viewPercentCorrect,
            subviewSecond: labelPercentCorrect,
            spacing: 12,
            opacity: 0)
    }()
    
    private lazy var viewPercentIncorrect: UIView = {
        setView(color: .redTangerineTango, radius: viewModel.radiusView)
    }()
    
    private lazy var labelPercentIncorrect: UILabel = {
        setLabel(
            title: viewModel.percentIncorrectAnswers(),
            style: "mr_fontick",
            size: 26,
            color: .blueBlackSea)
    }()
    
    private lazy var stackViewIncorrect: UIStackView = {
        setupStackView(
            subviewFirst: viewPercentIncorrect,
            subviewSecond: labelPercentIncorrect,
            spacing: 12,
            opacity: 0)
    }()
    
    private lazy var viewPercentTimeSpend: UIView = {
        setView(color: .blueMiddlePersian, radius: viewModel.radiusView)
    }()
    
    private lazy var labelPercentTimeSpend: UILabel = {
        setLabel(
            title: viewModel.percentTimeSpend,
            style: "mr_fontick",
            size: 26,
            color: .blueBlackSea)
    }()
    
    private lazy var stackViewTimeSpend: UIStackView = {
        setupStackView(
            subviewFirst: viewPercentTimeSpend,
            subviewSecond: labelPercentTimeSpend,
            spacing: 12,
            opacity: 0)
    }()
    
    private lazy var stackViews: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [stackViewCorrect, stackViewIncorrect, stackViewTimeSpend])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var buttonComplete: UIButton = {
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
    }()
    
    var viewModel: ResultsViewModelProtocol!
    
    weak var delegateQuizOfFlag: QuizOfFlagsViewControllerInput!
    weak var delegateQuestionnaire: QuestionnaireViewControllerInput!
    weak var delegateQuizOfCapitals: QuizOfCapitalsViewControllerInput!
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
        imageInfinity.isHidden = viewModel.isTime() ? true : false
    }
    
    private func setupSubviews() {
        viewModel.setupSubviews(subviews: stackViewDetails, viewCorrectAnswers,
                                viewIncorrectAnswers, viewTimeSpend,
                                viewCountQuestions, imageInfinity, stackViews,
                                buttonComplete,
                                on: view)
    }
    
    private func runTimer(interval: CGFloat, action: Selector) -> Timer {
        Timer.scheduledTimer(timeInterval: interval, target: self,
                             selector: action, userInfo: nil, repeats: false)
    }
    // MARK: - Set circles animate
    private func setupTimer() {
        viewModel.timer = runTimer(interval: 0.3, action: #selector(circleCorrectAnswers))
    }
    
    @objc private func circleCorrectAnswers() {
        viewModel.timer.invalidate()
        let delay = 0.75
        let delayTimer = delay + 0.3
        let correctAnswers = Float(viewModel.correctAnswers.count)
        let value = correctAnswers / Float(viewModel.mode.countQuestions)
        setCircle(color: .greenHarlequin.withAlphaComponent(0.3), radius: 80, strokeEnd: 1)
        setCircle(color: .greenHarlequin, radius: 80, strokeEnd: 0, value: value, duration: delay)
        viewModel.showAnimate(stackView: stackViewCorrect)
        
        viewModel.timer = runTimer(interval: delayTimer, action: #selector(circleIncorrectAnswers))
    }
    
    @objc private func circleIncorrectAnswers() {
        viewModel.timer.invalidate()
        let delay = 0.75
        let delayTimer = delay + 0.3
        let incorrectAnswers = Float(viewModel.incorrectAnswers.count)
        let value = incorrectAnswers / Float(viewModel.mode.countQuestions)
        setCircle(color: .redTangerineTango.withAlphaComponent(0.3), radius: 61, strokeEnd: 1)
        setCircle(color: .redTangerineTango, radius: 61, strokeEnd: 0, value: value, duration: delay)
        viewModel.showAnimate(stackView: stackViewIncorrect)
        
        viewModel.timer = runTimer(interval: delayTimer, action: #selector(circleSpentTime))
    }
    
    @objc private func circleSpentTime() {
        viewModel.timer.invalidate()
        let delay = 0.75
        let value = viewModel.circleTime / 100
        setCircle(color: .blueMiddlePersian.withAlphaComponent(0.3), radius: 42, strokeEnd: 1)
        setCircle(color: .blueMiddlePersian, radius: 42, strokeEnd: 0, value: value, duration: delay)
        viewModel.showAnimate(stackView: stackViewTimeSpend)
    }
    // MARK: - Press exit button
    @objc private func exitToMenu() {
        switch viewModel.game.gameType {
        case .quizOfFlag: delegateQuizOfFlag.dataToQuizOfFlag(setting: viewModel.mode)
        case .questionnaire: delegateQuestionnaire.dataToQuestionnaire(setting: viewModel.mode)
        default: delegateQuizOfCapitals.dataToQuizOfCapitals(setting: viewModel.mode)
        }
    }
    // MARK: - Show incorrect answers
    @objc private func showIncorrectAnswers() {
        let incorrectAnswersVC = IncorrectAnswersViewController()
        let navigationVC = UINavigationController(rootViewController: incorrectAnswersVC)
        incorrectAnswersVC.mode = viewModel.mode
        incorrectAnswersVC.game = viewModel.game
        incorrectAnswersVC.results = viewModel.incorrectAnswers
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
            viewModel.setupSubviews(subviews: labelFirst, image, labelSecond, on: view)
        }
        return view
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
    private func setupStackView(subviewFirst: UIView, subviewSecond: UIView,
                                spacing: CGFloat? = nil, opacity: Float? = nil) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [subviewFirst, subviewSecond])
        stackView.spacing = spacing ?? 0
        stackView.layer.opacity = opacity ?? 1
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
        
        setupSquare(subview: viewPercentCorrect, sizes: viewModel.radiusView * 2)
        setupSquare(subview: viewPercentIncorrect, sizes: viewModel.radiusView * 2)
        setupSquare(subview: viewPercentTimeSpend, sizes: viewModel.radiusView * 2)
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
