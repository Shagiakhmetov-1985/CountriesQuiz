//
//  QuestionnaireViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 29.08.2023.
//

import UIKit

class QuestionnaireViewController: UIViewController {
    private lazy var buttonBack: UIButton = {
        let button = setButton(
            image: "multiply",
            action: #selector(backToGameType))
        return button
    }()
    
    private lazy var labelTimer: UILabel = {
        let label = setupLabel(
            title: "\(seconds())",
            size: 35)
        return label
    }()
    
    private lazy var imageFlag: UIImageView = {
        let image = setupImage(image: questions.questions[currentQuestion].flag)
        return image
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = setupProgressView()
        return progressView
    }()
    
    private lazy var labelNumber: UILabel = {
        let label = setupLabel(
            title: "1 / \(mode.countQuestions)",
            size: 23)
        return label
    }()
    
    private lazy var labelQuiz: UILabel = {
        let label = setupLabel(
            title: "Выберите правильные ответы",
            size: 23)
        return label
    }()
    
    private lazy var buttonFirst: UIButton = {
        let button = setButton(
            image: checkmarkFirst,
            label: labelFirst)
        return button
    }()
    
    private lazy var checkmarkFirst: UIImageView = {
        let checkmark = setupCheckmark(image: "circle")
        return checkmark
    }()
    
    private lazy var labelFirst: UILabel = {
        let label = setupLabel(
            title: questions.buttonFirst[currentQuestion].name,
            size: 23)
        return label
    }()
    
    private lazy var buttonSecond: UIButton = {
        let button = setButton(
            image: checkmarkSecond,
            label: labelSecond)
        return button
    }()
    
    private lazy var checkmarkSecond: UIImageView = {
        let checkmark = setupCheckmark(image: "circle")
        return checkmark
    }()
    
    private lazy var labelSecond: UILabel = {
        let label = setupLabel(
            title: questions.buttonSecond[currentQuestion].name,
            size: 23)
        return label
    }()
    
    private lazy var buttonThird: UIButton = {
        let button = setButton(
            image: checkmarkThird,
            label: labelThird)
        return button
    }()
    
    private lazy var checkmarkThird: UIImageView = {
        let checkmark = setupCheckmark(image: "circle")
        return checkmark
    }()
    
    private lazy var labelThird: UILabel = {
        let label = setupLabel(
            title: questions.buttonThird[currentQuestion].name,
            size: 23)
        return label
    }()
    
    private lazy var buttonFourth: UIButton = {
        let button = setButton(
            image: checkmarkFourth,
            label: labelFourth)
        return button
    }()
    
    private lazy var checkmarkFourth: UIImageView = {
        let checkmark = setupCheckmark(image: "circle")
        return checkmark
    }()
    
    private lazy var labelFourth: UILabel = {
        let label = setupLabel(
            title: questions.buttonFourth[currentQuestion].name,
            size: 23)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = setupStackView(
            buttonFirst: buttonFirst,
            buttonSecond: buttonSecond,
            buttonThird: buttonThird,
            buttonFourth: buttonFourth)
        return stackView
    }()
    
    var mode: Setting!
    var game: Games!
    
    private var timer = Timer()
    private let questions = Countries.getQuestions()
    private var shapeLayer = CAShapeLayer()
    
    private var currentQuestion = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupBarButton()
        setupSubviews()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupCircles()
    }
    
    private func setupDesign() {
        view.backgroundColor = game.background
        navigationItem.hidesBackButton = true
    }
    
    private func setupBarButton() {
        let leftBarButton = UIBarButtonItem(customView: buttonBack)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func setupSubviews() {
        if mode.timeElapsed.timeElapsed {
            setupSubviews(subviews: labelTimer, imageFlag, progressView,
                          labelNumber, labelQuiz, stackView, on: view)
        } else {
            setupSubviews(subviews: imageFlag, progressView, labelNumber,
                          labelQuiz, stackView, on: view)
        }
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    private func setupCircles() {
        circleShadow()
        circle(strokeEnd: 0)
        animationTimeReset()
    }
    
    @objc private func backToGameType() {
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - Setup buttons
extension QuestionnaireViewController {
    private func setButton(image: String, action: Selector) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setButton(image: UIImageView, label: UILabel) -> UIButton {
        let button = UIButton(type: .custom)
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        setupSubviews(subviews: image, label, on: button)
        return button
    }
}
// MARK: - Setup label
extension QuestionnaireViewController {
    private func setupLabel(title: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func seconds() -> Int {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
    }
}
// MARK: - Setup circle timer
extension QuestionnaireViewController {
    private func circleShadow() {
        let center = CGPoint(x: labelTimer.center.x, y: labelTimer.center.y)
        let endAngle = CGFloat.pi / 2
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: 32,
            startAngle: -startAngle,
            endAngle: -endAngle,
            clockwise: true)
        
        let trackShape = CAShapeLayer()
        trackShape.path = circularPath.cgPath
        trackShape.lineWidth = 5
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.strokeColor = UIColor.white.withAlphaComponent(0.3).cgColor
        view.layer.addSublayer(trackShape)
    }
    
    private func circle(strokeEnd: CGFloat) {
        let center = CGPoint(x: labelTimer.center.x, y: labelTimer.center.y)
        let endAngle = CGFloat.pi / 2
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: 32,
            startAngle: -startAngle,
            endAngle: -endAngle,
            clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = strokeEnd
        shapeLayer.lineCap = CAShapeLayerLineCap.square
        shapeLayer.strokeColor = UIColor.white.cgColor
        view.layer.addSublayer(shapeLayer)
    }
    
    private func animationTimeElapsed() {
        let timer = seconds()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 0
        animation.duration = CFTimeInterval(timer)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
    
    private func animationTimeReset() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = CFTimeInterval(0.4)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
}
// MARK: - Setup progress view
extension QuestionnaireViewController {
    private func setupProgressView() -> UIProgressView {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = radius()
        progressView.clipsToBounds = true
        progressView.progressTintColor = .white
        progressView.trackTintColor = .white.withAlphaComponent(0.3)
        progressView.progress = 0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }
}
// MARK: - Setup image view
extension QuestionnaireViewController {
    private func setupImage(image: String) -> UIImageView {
        let image = UIImage(named: image)
        let imageView = UIImageView()
        imageView.image = image
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func setupCheckmark(image: String) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
// MARK: - Setup stack view
extension QuestionnaireViewController {
    private func setupStackView(buttonFirst: UIButton, buttonSecond: UIButton,
                                buttonThird: UIButton, buttonFourth: UIButton) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [buttonFirst, buttonSecond, buttonThird, buttonFourth])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Setup constraints
extension QuestionnaireViewController {
    private func setupConstraints() {
        setupSquare(subview: buttonBack, sizes: 40)
        
        if mode.timeElapsed.timeElapsed {
            constraintsTimer()
        }
        
        NSLayoutConstraint.activate([
            imageFlag.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            imageFlag.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageFlag.widthAnchor.constraint(equalToConstant: 300),
            imageFlag.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        constraintsProgressView(layout: imageFlag.bottomAnchor, constant: 30)
        
        NSLayoutConstraint.activate([
            labelNumber.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            labelNumber.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 20),
            labelNumber.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelNumber.widthAnchor.constraint(equalToConstant: 85)
        ])
        
        NSLayoutConstraint.activate([
            labelQuiz.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 25),
            labelQuiz.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelQuiz.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: labelQuiz.bottomAnchor, constant: 25),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            stackView.heightAnchor.constraint(equalToConstant: 215)
        ])
        constraintsOnButton(image: checkmarkFirst, label: labelFirst, button: buttonFirst)
        constraintsOnButton(image: checkmarkSecond, label: labelSecond, button: buttonSecond)
        constraintsOnButton(image: checkmarkThird, label: labelThird, button: buttonThird)
        constraintsOnButton(image: checkmarkFourth, label: labelFourth, button: buttonFourth)
    }
    
    private func constraintsTimer() {
        NSLayoutConstraint.activate([
            labelTimer.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            labelTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func constraintsProgressView(layout: NSLayoutYAxisAnchor, constant: CGFloat) {
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: layout, constant: constant),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.heightAnchor.constraint(equalToConstant: radius() * 2)
        ])
    }
    
    private func setupSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    private func constraintsOnButton(image: UIImageView, label: UILabel,
                                     button: UIButton) {
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20)
        ])
    }
    
    private func radius() -> CGFloat {
        6
    }
}
