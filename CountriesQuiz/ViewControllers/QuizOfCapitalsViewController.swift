//
//  QuizOfCapitalsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 18.10.2023.
//

import UIKit

class QuizOfCapitalsViewController: UIViewController {
    private lazy var buttonBack: UIButton = {
        setButton(action: #selector(exitToTypeGame))
    }()
    
    private lazy var labelTimer: UILabel = {
        setLabel(title: "\(oneQuestionSeconds())", size: 35)
    }()
    
    private lazy var imageFlag: UIImageView = {
        setImage(image: questions.questions[currentQuestion].flag)
    }()
    
    private lazy var labelCountry: UILabel = {
        setLabel(title: questions.questions[currentQuestion].name, size: 32)
    }()
    
    private lazy var progressView: UIProgressView = {
        setProgressView()
    }()
    
    private lazy var labelNumber: UILabel = {
        setLabel(title: "0 / \(mode.countQuestions)", size: 23)
    }()
    
    private lazy var labelQuiz: UILabel = {
        setLabel(title: "Выберите правильный ответ", size: 23)
    }()
    
    private lazy var labelDescription: UILabel = {
        setLabel(title: "Коснитесь экрана, чтобы продолжить", 
                 size: 19,
                 opacity: 0)
    }()
    
    private lazy var buttonFirst: UIButton = {
        setButton(title: questions.buttonFirst[currentQuestion].name,
                  tag: 1,
                  action: #selector(buttonPress))
    }()
    
    private lazy var buttonSecond: UIButton = {
        setButton(title: questions.buttonSecond[currentQuestion].name,
                  tag: 2,
                  action: #selector(buttonPress))
    }()
    
    private lazy var buttonThird: UIButton = {
        setButton(title: questions.buttonThird[currentQuestion].name,
                  tag: 3,
                  action: #selector(buttonPress))
    }()
    
    private lazy var buttonFourth: UIButton = {
        setButton(title: questions.buttonFourth[currentQuestion].name,
                  tag: 4,
                  action: #selector(buttonPress))
    }()
    
    private lazy var stackViewFlag: UIStackView = {
        setStackView(buttonFirst: buttonFirst, 
                     buttonSecond: buttonSecond,
                     buttonThird: buttonThird, 
                     buttonFourth: buttonFourth)
    }()
    
    var mode: Setting!
    var game: Games!
    
    private var imageFlagSpring: NSLayoutConstraint!
    private var labelNameSpring: NSLayoutConstraint!
    private var stackViewSpring: NSLayoutConstraint!
    
    private var widthOfFlag: NSLayoutConstraint!
    
    private var timerFirst = Timer()
    private var timerSecond = Timer()
    private let shapeLayer = CAShapeLayer()
    
    private var currentQuestion = 0
    private var seconds = 0
    private var spendTime: [CGFloat] = []
    private var questions = Countries.getQuestions()
    private var answerSelect = false
    
    private let correctAnswers: [Countries] = []
    private let incorrectAnswers: [Results] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupBarButton()
        setupSubviews()
        setupConstraints()
    }
    // MARK: - General methods
    private func setupDesign() {
        view.backgroundColor = game.background
        navigationItem.hidesBackButton = true
    }
    
    private func setupBarButton() {
        let barButton = UIBarButtonItem(customView: buttonBack)
        navigationItem.leftBarButtonItem = barButton
    }
    
    private func setupSubviews() {
        setupSubviews(subviews: labelTimer, imageFlag, progressView, labelNumber,
                      labelQuiz, labelDescription, stackViewFlag,
                      on: view)
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    private func checkFlag() -> Bool {
        mode.flag ? true : false
    }
    // MARK: - Time for label, seconds and circle timer
    private func checkSeconds() {
        if !oneQuestionCheck(), currentQuestion < 1 {
            seconds = oneQuestionSeconds() * 10
        } else if oneQuestionCheck() {
            seconds = oneQuestionSeconds() * 10
        }
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
    
    private func checkCircleTimeElapsed() -> Int {
        let timer: Int
        if oneQuestionCheck() {
            timer = mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
        } else {
            timer = seconds / 10
        }
        return timer
    }
    
    private func oneQuestionCheck() -> Bool {
        mode.timeElapsed.questionSelect.oneQuestion ? true : false
    }
    // MARK: - Opacity, hidden and enable subviews and run timer
    private func setOpacity(labels: UILabel..., opacity: Float) {
        labels.forEach { label in
            label.layer.opacity = opacity
        }
    }
    
    private func setHidden(views: UIView..., isHidden: Bool) {
        views.forEach { view in
            view.isHidden = isHidden
        }
    }
    
    private func setEnabled(controls: UIControl..., isEnabled: Bool) {
        controls.forEach { control in
            control.isEnabled = isEnabled
        }
    }
    
    private func runTimer(time: CGFloat, action: Selector, repeats: Bool) -> Timer {
        Timer.scheduledTimer(timeInterval: time, target: self, selector: action,
                             userInfo: nil, repeats: repeats)
    }
    // MARK: - Move flag and buttons
    private func setupMoveSubviews() {
        let pointX: CGFloat = currentQuestion > 0 ? 2 : 1
        if checkFlag() {
            imageFlagSpring.constant += view.bounds.width * pointX
        } else {
            labelNameSpring.constant += view.bounds.width * pointX
        }
        stackViewSpring.constant += view.bounds.width * pointX
    }
    // MARK: - Animation move subviews
    private func animationSubviews() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            if self.checkFlag() {
                self.imageFlagSpring.constant -= self.view.bounds.width
            } else {
                self.labelNameSpring.constant -= self.view.bounds.width
            }
            self.stackViewSpring.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }
    }
    // MARK: - Animation label description and label number
    private func showDescription() {
        if currentQuestion == questions.questions.count - 1 {
            let red = UIColor.lightPurplePink
            labelDescription.text = "Коснитесь экрана, чтобы завершить"
            labelDescription.textColor = red
        }
        
        animationShowLabelDescription()
    }
    
    private func animationHideLabelDescription() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
            self.labelQuiz.layer.opacity = 1
        }
        
        labelDescription.layer.opacity = 0
    }
    
    private func animationShowLabelDescription() {
        UIView.animate(withDuration: 0.5, animations: {
            self.labelQuiz.layer.opacity = 0
        })
        
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.labelDescription.layer.opacity = 1
        })
    }
    // MARK: - Button back
    @objc private func exitToTypeGame() {
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Button action when user select answer
    @objc private func buttonPress(button: UIButton) {
        
    }
}
// MARK: - Setup buttons
extension QuizOfCapitalsViewController {
    private func setButton(action: Selector) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "multiply", withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        button.translatesAutoresizingMaskIntoConstraints = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setButton(title: String, tag: Int, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.blueBlackSea, for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont(name: "mr_fontick", size: 23)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.isEnabled = false
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
// MARK: - Setup labels
extension QuizOfCapitalsViewController {
    private func setLabel(title: String, size: CGFloat, opacity: Float? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.opacity = opacity ?? 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup image
extension QuizOfCapitalsViewController {
    private func setImage(image: String) -> UIImageView {
        let image = UIImage(named: image)
        let imageView = UIImageView(image: image)
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
// MARK: - Setup progress view
extension QuizOfCapitalsViewController {
    private func setProgressView() -> UIProgressView {
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
// MARK: - Setup stack view
extension QuizOfCapitalsViewController {
    private func setStackView(buttonFirst: UIButton, buttonSecond: UIButton,
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
// MARK: - Setup circle timer
extension QuizOfCapitalsViewController {
    private func circularShadow() {
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
    
    private func circular(strokeEnd: CGFloat) {
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
        let timer = checkCircleTimeElapsed()
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
    
    private func stopAnimationCircleTimer() {
        let oneQuestionTime = oneQuestionSeconds() * 10
        let time = CGFloat(seconds) / CGFloat(oneQuestionTime)
        let result = round(100 * time) / 100
        shapeLayer.removeAnimation(forKey: "animation")
        shapeLayer.strokeEnd = result
    }
}
// MARK: - Setup constraints
extension QuizOfCapitalsViewController {
    private func setupConstraints() {
        setupSquare(button: buttonBack, sizes: 40)
        
        constraintsFlag()
        constraintsProgressViewFlag()
        
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
            labelDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelDescription.centerYAnchor.constraint(equalTo: labelQuiz.centerYAnchor)
        ])
        
        constraintsButtonsFlag()
    }
    
    private func setupSquare(button: UIButton, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: sizes),
            button.widthAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    private func constraintsFlag() {
        let flag = questions.questions[currentQuestion].flag
        widthOfFlag = imageFlag.widthAnchor.constraint(equalToConstant: checkWidthFlag(flag: flag))
        
        imageFlagSpring = NSLayoutConstraint(
            item: imageFlag, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(imageFlagSpring)
        NSLayoutConstraint.activate([
            imageFlag.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            widthOfFlag,
            imageFlag.heightAnchor.constraint(equalToConstant: 168)
        ])
    }
    
    private func constraintsProgressViewFlag() {
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: imageFlag.bottomAnchor, constant: 30),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.heightAnchor.constraint(equalToConstant: radius() * 2)
        ])
    }
    
    private func constraintsButtonsFlag() {
        stackViewSpring = NSLayoutConstraint(
            item: stackViewFlag, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(stackViewSpring)
        NSLayoutConstraint.activate([
            stackViewFlag.topAnchor.constraint(equalTo: labelQuiz.bottomAnchor, constant: 25),
            stackViewFlag.widthAnchor.constraint(equalToConstant: setupConstraintFlag()),
            stackViewFlag.heightAnchor.constraint(equalToConstant: 215)
        ])
    }
    
    private func radius() -> CGFloat {
        6
    }
    
    private func checkWidthFlag(flag: String) -> CGFloat {
        switch flag {
        case "nepal", "vatican city", "switzerland": return 168
        default: return 280
        }
    }
    
    private func setupConstraintFlag() -> CGFloat {
        view.bounds.width - 40
    }
}
