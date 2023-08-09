//
//  QuizOfFlagsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 09.01.2023.
//

import UIKit

class QuizOfFlagsViewController: UIViewController {
    // MARK: - Setup subviews
    private lazy var buttonGameType: UIButton = {
        let button = setButton(
            image: "arrow.backward",
            action: #selector(backToGameType))
        return button
    }()
    
    private lazy var buttonBackMenu: UIButton = {
        let button = setButton(
            image: "multiply",
            action: #selector(backToMenu))
        return button
    }()
    
    private lazy var labelTimer: UILabel = {
        let label = setLabel(
            title: "\(oneQuestionSeconds())",
            size: 35,
            style: "mr_fontick",
            color: .black)
        return label
    }()
    
    private lazy var imageFlag: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: questions.questions[currentQuestion].flag)
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.black.cgColor
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = setProgressView(
            radius: radius(),
            progressColor: .blueMiddlePersian,
            trackColor: .blueMiddlePersian.withAlphaComponent(0.3),
            progress: 0)
        return progressView
    }()
    
    private lazy var labelNumberQuiz: UILabel = {
        let label = setLabel(
            title: "\(currentQuestion + 1) / \(mode.countQuestions)",
            size: 26,
            style: "mr_fontick",
            color: .blueMiddlePersian,
            textAlignment: .center)
        return label
    }()
    
    private lazy var labelQuiz: UILabel = {
        let label = setLabel(
            title: "Выберите правильный ответ",
            size: 23,
            style: "mr_fontick",
            color: .blueBlackSea,
            textAlignment: .center)
        return label
    }()
    /*
    private lazy var labelDescription: UILabel = {
        let label = setLabel(
            title: "Коснитесь экрана, чтобы продолжить",
            size: size(),
            style: "mr_fontick",
            color: UIColor.cyanLight,
            colorOfShadow: UIColor.shadowBlueLight.cgColor,
            radiusOfShadow: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2,
            textAlignment: .center,
            opacity: 0)
        return label
    }()
    */
    private lazy var buttonAnswerFirst: UIButton = {
        let button = setButton(
            title: questions.buttonFirst[currentQuestion].name,
            color: .blueBlackSea,
            isEnabled: false,
            tag: 1,
            action: #selector(buttonPress))
        return button
    }()
    
    private lazy var buttonAnswerSecond: UIButton = {
        let button = setButton(
            title: questions.buttonSecond[currentQuestion].name,
            color: .blueBlackSea,
            isEnabled: false,
            tag: 2,
            action: #selector(buttonPress))
        return button
    }()
    
    private lazy var buttonAnswerThird: UIButton = {
        let button = setButton(
            title: questions.buttonThird[currentQuestion].name,
            color: .blueBlackSea,
            isEnabled: false,
            tag: 3,
            action: #selector(buttonPress))
        return button
    }()
    
    private lazy var buttonAnswerFourth: UIButton = {
        let button = setButton(
            title: questions.buttonFourth[currentQuestion].name,
            color: .blueBlackSea,
            isEnabled: false,
            tag: 4,
            action: #selector(buttonPress))
        return button
    }()
    
    private lazy var stackViewButtons: UIStackView = {
        let stackView = setStackViewButtons(
            buttonFirst: buttonAnswerFirst,
            buttonSecond: buttonAnswerSecond,
            buttonThird: buttonAnswerThird,
            buttonFourth: buttonAnswerFourth)
        return stackView
    }()
    
    var mode: Setting!
    
    private var imageFlagSpring: NSLayoutConstraint!
    private var stackViewSpring: NSLayoutConstraint!
    
    private var timerFirst = Timer()
    private var timerSecond = Timer()
    private let shapeLayer = CAShapeLayer()
    
    private var currentQuestion = 0
    private var seconds = 0
    private var spendTime: [Float] = []
    private var questions = Countries.getQuestions()
    private var answerSelect = false
    
    private var results: [Results] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupSubviews()
        setConstraints()
        setupBarButton()
        setupMoveSubviews()
        startHideSubviews()
        startGame()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        circularShadow()
        circular()
    }
    
    private func setupDesign() {
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
    }
    
    private func setupSubviews() {
        if mode.timeElapsed.timeElapsed {
            setupSubviewsWithTimer()
        } else {
            setupSubviewsWithoutTimer()
        }
    }
    
    private func setupSubviewsWithTimer() {
        setupSubviews(subviews: labelTimer, imageFlag, progressView, labelNumberQuiz,
                      labelQuiz, stackViewButtons,
                      on: view)
    }
    
    private func setupSubviewsWithoutTimer() {
        setupSubviews(subviews: imageFlag, progressView, labelNumberQuiz,
                      labelQuiz, stackViewButtons,
                      on: view)
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setupBarButton() {
        let leftBarButton = UIBarButtonItem(customView: buttonGameType)
        let rightBarButton = UIBarButtonItem(customView: buttonBackMenu)
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
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
        trackShape.strokeColor = UIColor.skyCyanLight.cgColor
        view.layer.addSublayer(trackShape)
    }
    
    private func circular() {
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
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = UIColor.blueBlackSea.cgColor
        view.layer.addSublayer(shapeLayer)
    }
    
    private func animationCircular() {
        let timer = oneQuestionSeconds()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 0
        animation.duration = CFTimeInterval(timer)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
    
    private func setupMoveSubviews() {
        let pointX: CGFloat = currentQuestion > 0 ? 2 : 1
        imageFlagSpring.constant += view.bounds.width * pointX
        stackViewSpring.constant += view.bounds.width * pointX
    }
    
    private func startHideSubviews() {
        setupOpacityLabels(labels: labelQuiz, opacity: 0)
    }
    
    private func setupOpacityLabels(labels: UILabel..., opacity: Float) {
        labels.forEach { label in
            label.layer.opacity = opacity
        }
    }
    
    private func setupHiddenSubviews(views: UIView..., isHidden: Bool) {
        views.forEach { view in
            view.isHidden = isHidden
        }
    }
    
    private func setupEnabledSubviews(controls: UIControl..., isEnabled: Bool) {
        controls.forEach { control in
            control.isEnabled = isEnabled
        }
    }
    
    private func startGame() {
        timerFirst = Timer.scheduledTimer(
            timeInterval: 1, target: self, selector: #selector(showSubviews),
            userInfo: nil, repeats: false)
        timerSecond = Timer.scheduledTimer(
            timeInterval: 2, target: self, selector: #selector(isEnabledButton),
            userInfo: nil, repeats: false)
    }
    
    @objc private func showSubviews() {
        timerFirst.invalidate()
        
        setupHiddenSubviews(views: imageFlag, buttonAnswerFirst,
                            buttonAnswerSecond, buttonAnswerThird,
                            buttonAnswerFourth, isHidden: false)
        
        if currentQuestion < 1 {
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) { [self] in
                setupOpacityLabels(labels: labelQuiz, opacity: 1)
            }
        }
        
        animationSubviews()
    }
    
    private func animationSubviews() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
            self.imageFlagSpring.constant -= self.view.bounds.width
            self.stackViewSpring.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func isEnabledButton() {
        timerSecond.invalidate()
        setupEnabledSubviews(controls: buttonAnswerFirst, buttonAnswerSecond,
                             buttonAnswerThird, buttonAnswerFourth,
                             isEnabled: true)
        
        if mode.timeElapsed.timeElapsed {
            animationCircular()
            checkSeconds()
            runTimer()
        }
    }
    
    private func checkSeconds() {
        if !oneQuestionCheck(), currentQuestion < 1 {
            seconds = oneQuestionSeconds() * 10
        } else if oneQuestionCheck() {
            seconds = oneQuestionSeconds() * 10
        }
    }
    
    private func runTimer() {
//        timerFirst = Timer.scheduledTimer(
//            timeInterval: 0.1, target: self, selector: #selector(timeElapsed),
//            userInfo: nil, repeats: true)
        timerSecond = Timer.scheduledTimer(
            timeInterval: 0.1, target: self, selector: #selector(timeElapsedText),
            userInfo: nil, repeats: true)
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
    
    @objc private func timeElapsed() {
        let timeQuestion = TimeInterval(oneQuestionSeconds())
        let interval = (1 / timeQuestion) * 0.1
        let progress = progressView.progress - Float(interval)
        
        UIView.animate(withDuration: 0.3) {
            self.progressView.setProgress(progress, animated: true)
        }
        
        if progressView.progress <= 0 {
            timerFirst.invalidate()
            answerSelect.toggle()
            
            setupResults(numberQuestion: currentQuestion + 1, tag: 0,
                         question: questions.questions[currentQuestion],
                         buttonFirst: questions.buttonFirst[currentQuestion],
                         buttonSecond: questions.buttonSecond[currentQuestion],
                         buttonThird: questions.buttonThird[currentQuestion],
                         buttonFourth: questions.buttonFourth[currentQuestion],
                         timeUp: true)
            
            if !oneQuestionCheck() {
                currentQuestion = questions.questions.count - 1
            }
            
            endQuestion()
            disableButton(buttons: buttonAnswerFirst, buttonAnswerSecond,
                          buttonAnswerThird, buttonAnswerFourth, tag: 0)
        }
    }
    
    @objc private func timeElapsedText() {
        seconds -= 1
        if seconds.isMultiple(of: 10) {
            let text = seconds / 10
            labelTimer.text = "\(text)"
        }
        
        if seconds == 0 {
            timerSecond.invalidate()
        }
    }
    
    @objc private func backToGameType() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func backToMenu() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func buttonPress(button: UIButton) {
        let green = UIColor.greenEmerald
        let red = UIColor.bismarkFuriozo
        let tag = button.tag
        
        timerFirst.invalidate()
        timerSecond.invalidate()
        answerSelect.toggle()
        
        
        if checkAnswer(tag: tag) {
            setButtonColor(button: button, color: green)
        } else {
            setButtonColor(button: button, color: red)
            
            setupResults(numberQuestion: currentQuestion + 1, tag: tag,
                         question: questions.questions[currentQuestion],
                         buttonFirst: questions.buttonFirst[currentQuestion],
                         buttonSecond: questions.buttonSecond[currentQuestion],
                         buttonThird: questions.buttonThird[currentQuestion],
                         buttonFourth: questions.buttonFourth[currentQuestion],
                         timeUp: false)
        }
        
        endQuestion()
        disableButton(buttons: buttonAnswerFirst, buttonAnswerSecond,
                      buttonAnswerThird, buttonAnswerFourth, tag: tag)
        
        if oneQuestionCheck() {
            setAverageTime()
        } else if !oneQuestionCheck(), currentQuestion + 1 == questions.questions.count {
            setTimeSpent()
        }
    }
    
    private func setButtonColor(button: UIButton, color: UIColor) {
        button.backgroundColor = color
        button.layer.shadowColor = color.cgColor
    }
    
    private func checkAnswer(tag: Int) -> Bool {
        switch tag {
        case 1:
            return questions.questions[currentQuestion] == questions.buttonFirst[currentQuestion] ? true : false
        case 2:
            return questions.questions[currentQuestion] == questions.buttonSecond[currentQuestion] ? true : false
        case 3:
            return questions.questions[currentQuestion] == questions.buttonThird[currentQuestion] ? true : false
        default:
            return questions.questions[currentQuestion] == questions.buttonFourth[currentQuestion] ? true : false
        }
    }
    
    private func disableButton(buttons: UIButton..., tag: Int) {
        let gray = UIColor.grayLight
        
        buttons.forEach { button in
            if !(button.tag == tag) {
                setButtonColor(button: button, color: gray)
            }
            button.isEnabled = false
        }
        
        if currentQuestion + 1 < questions.questions.count {
            timerFirst = Timer.scheduledTimer(
                timeInterval: 5, target: self, selector: #selector(hideSubviews),
                userInfo: nil, repeats: false)
        }
    }
    
    private func setAverageTime() {
        let progressViewSpent = 1 - progressView.progress
        let seconds = mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
        let timeSpent = progressViewSpent * Float(seconds)
        spendTime.append(timeSpent)
    }
    
    private func setTimeSpent() {
        let progressViewSpent = 1 - progressView.progress
        let seconds = mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
        let timeSpent = progressViewSpent * Float(seconds)
        spendTime.append(timeSpent)
    }
    
    private func showNewDataForNextQuestion() {
        if mode.timeElapsed.timeElapsed {
            restorationLabelTimer()
        }
        
        imageFlag.image = UIImage(named: questions.questions[currentQuestion].flag)
        
        labelNumberQuiz.text = "\(currentQuestion + 1) / \(mode.countQuestions)"
        
        buttonAnswerFirst.setTitle(questions.buttonFirst[currentQuestion].name, for: .normal)
        buttonAnswerSecond.setTitle(questions.buttonSecond[currentQuestion].name, for: .normal)
        buttonAnswerThird.setTitle(questions.buttonThird[currentQuestion].name, for: .normal)
        buttonAnswerFourth.setTitle(questions.buttonFourth[currentQuestion].name, for: .normal)
    }
    
    private func restorationLabelTimer() {
        if oneQuestionCheck() {
            let seconds = mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
            labelTimer.text = "\(seconds)"
        }
    }
    
    private func showSubviewsWithAnimation() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) {
            self.labelNumberQuiz.layer.opacity = 1
        }
        
//        labelDescription.layer.opacity = 0
        
        if mode.timeElapsed.timeElapsed {
            restorationProgressView()
        }
    }
    
    private func restorationProgressView() {
        if oneQuestionCheck() {
            UIView.animate(withDuration: 0.5) {
                self.progressView.setProgress(1, animated: true)
            }
        }
    }
    
    private func resetColorButton(buttons: UIButton...) {
        let darkBlue = UIColor.shadowBlueLight
        let blue = UIColor.blueLight
        let lightBlue = UIColor.cyanLight
        
        buttons.forEach { button in
            button.setTitleColor(blue, for: .normal)
            button.backgroundColor = lightBlue
            button.layer.shadowColor = darkBlue.cgColor
        }
    }
    
    @objc private func hideSubviews() {
        timerFirst.invalidate()
        answerSelect.toggle()
        
        animationSubviews()
        timerFirst = Timer.scheduledTimer(
            timeInterval: 1, target: self, selector: #selector(nextQuestion),
            userInfo: nil, repeats: false)
    }
    
    private func setupResults(numberQuestion: Int, tag: Int, question: Countries,
                              buttonFirst: Countries, buttonSecond: Countries,
                              buttonThird: Countries, buttonFourth: Countries,
                              timeUp: Bool) {
        let result = Results(currentQuestion: numberQuestion, tag: tag,
                             question: question, buttonFirst: buttonFirst,
                             buttonSecond: buttonSecond, buttonThird: buttonThird,
                             buttonFourth: buttonFourth, timeUp: timeUp)
        results.append(result)
    }
    
    private func endQuestion() {
        if currentQuestion == questions.questions.count - 1 {
//            let darkRed = UIColor.darkRed
//            let lightRed = UIColor.lightRed
//            labelDescription.text = "Коснитесь экрана, чтобы завершить"
//            labelDescription.textColor = lightRed
//            labelDescription.layer.shadowColor = darkRed.cgColor
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.labelNumberQuiz.layer.opacity = 0
        })
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
//            self.labelDescription.layer.opacity = 1
        })
    }
    
    @objc private func nextQuestion() {
        timerFirst.invalidate()
        
        currentQuestion += 1
        setupMoveSubviews()
        showNewDataForNextQuestion()
        showSubviewsWithAnimation()
        resetColorButton(buttons: buttonAnswerFirst, buttonAnswerSecond,
                         buttonAnswerThird, buttonAnswerFourth)
        startGame()
    }
}

extension QuizOfFlagsViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if answerSelect {
            if currentQuestion + 1 < questions.questions.count {
                hideSubviews()
            } else {
                let resultsVC = ResultsViewController()
                resultsVC.results = results
                resultsVC.countries = questions.questions
                resultsVC.mode = mode
                resultsVC.spendTime = spendTime
                navigationController?.pushViewController(resultsVC, animated: true)
            }
        }
    }
}
// MARK: - Setup view
extension QuizOfFlagsViewController {
    private func setView(color: UIColor? = nil, cornerRadius: CGFloat? = nil,
                         borderWidth: CGFloat? = nil, borderColor: UIColor? = nil,
                         shadowColor: UIColor? = nil, shadowRadius: CGFloat? = nil,
                         shadowOffsetWidth: CGFloat? = nil,
                         shadowOffsetHeight: CGFloat? = nil) -> UIView {
        let view = UIView()
        view.layer.cornerRadius = cornerRadius ?? 0
        view.layer.borderWidth = borderWidth ?? 0
        view.layer.borderColor = borderColor?.cgColor
        view.layer.shadowColor = shadowColor?.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = shadowRadius ?? 0
        view.layer.shadowOffset = CGSize(width: shadowOffsetWidth ?? 0,
                                         height: shadowOffsetHeight ?? 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        if let color = color {
            view.backgroundColor = color
        } else {
            setGradient(content: view)
        }
        return view
    }
    
    private func setGradient(content: UIView) {
        let gradientLayer = CAGradientLayer()
        let colorBlue = UIColor.blueFirst
        let colorLightBlue = UIColor.blueSecond
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [colorLightBlue.cgColor, colorBlue.cgColor]
        content.layer.addSublayer(gradientLayer)
    }
}
// MARK: - Setup button
extension QuizOfFlagsViewController {
    private func setButton(title: String, color: UIColor, isEnabled: Bool,
                           tag: Int, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "mr_fontick", size: 23)
        button.backgroundColor = color
        button.layer.cornerRadius = 12
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.isEnabled = isEnabled
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setButton(image: String, action: Selector) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .blueBlackSea
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.blueBlackSea.cgColor
        button.layer.borderWidth = 1.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
}
// MARK: - Setup label
extension QuizOfFlagsViewController {
    private func setLabel(title: String, size: CGFloat, style: String, color: UIColor,
                          colorOfShadow: CGColor? = nil, radiusOfShadow: CGFloat? = nil,
                          shadowOffsetWidth: CGFloat? = nil, shadowOffsetHeight: CGFloat? = nil,
                          numberOfLines: Int? = nil, textAlignment: NSTextAlignment? = nil,
                          opacity: Float? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: style, size: size)
        label.textColor = color
        label.layer.shadowColor = colorOfShadow
        label.layer.shadowRadius = radiusOfShadow ?? 0
        label.layer.shadowOpacity = 1
        label.layer.shadowOffset = CGSize(width: shadowOffsetWidth ?? 0,
                                          height: shadowOffsetHeight ?? 0)
        label.numberOfLines = numberOfLines ?? 0
        label.textAlignment = textAlignment ?? .natural
        label.layer.opacity = opacity ?? 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup progress view
extension QuizOfFlagsViewController {
    private func setProgressView(radius: CGFloat, progressColor: UIColor,
                                 trackColor: UIColor, progress: Float) -> UIProgressView {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = radius
        progressView.clipsToBounds = true
        progressView.progressTintColor = progressColor
        progressView.trackTintColor = trackColor
        progressView.progress = progress
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }
}
// MARK: - Setup stack views
extension QuizOfFlagsViewController {
    private func setStackView(progressView: UIProgressView, label: UILabel) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [progressView, label])
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackViewButtons(buttonFirst: UIButton,
                                     buttonSecond: UIButton,
                                     buttonThird: UIButton,
                                     buttonFourth: UIButton) -> UIStackView {
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
extension QuizOfFlagsViewController {
    private func setConstraints() {
        if mode.timeElapsed.timeElapsed {
            constraintsTimer()
        }
        
        setupSquare(subview: buttonGameType, sizes: 40)
        setupSquare(subview: buttonBackMenu, sizes: 40)

        imageFlagSpring = NSLayoutConstraint(
            item: imageFlag, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(imageFlagSpring)
        NSLayoutConstraint.activate([
            imageFlag.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            imageFlag.widthAnchor.constraint(equalToConstant: 300),
            imageFlag.heightAnchor.constraint(equalToConstant: 180)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: imageFlag.bottomAnchor, constant: 30),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            progressView.heightAnchor.constraint(equalToConstant: radius() * 2)
        ])
        
        NSLayoutConstraint.activate([
            labelNumberQuiz.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            labelNumberQuiz.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 20),
            labelNumberQuiz.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            labelQuiz.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 25),
            labelQuiz.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelQuiz.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        stackViewSpring = NSLayoutConstraint(
            item: stackViewButtons, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(stackViewSpring)
        NSLayoutConstraint.activate([
            stackViewButtons.topAnchor.constraint(equalTo: labelQuiz.bottomAnchor, constant: 25),
            stackViewButtons.widthAnchor.constraint(equalToConstant: setupWidthConstraint()),
            stackViewButtons.heightAnchor.constraint(equalToConstant: 200)
        ])
        /*
        NSLayoutConstraint.activate([
            labelDescription.topAnchor.constraint(equalTo: imageFlag.bottomAnchor, constant: 34),
            labelDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelDescription.widthAnchor.constraint(equalToConstant: setupWidthConstraint())
        ])
        
        buttonFirstSpring = NSLayoutConstraint(
            item: buttonAnswerFirst, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(buttonFirstSpring)
        NSLayoutConstraint.activate([
            buttonAnswerFirst.topAnchor.constraint(equalTo: labelNumberQuiz.bottomAnchor, constant: 30),
            buttonAnswerFirst.widthAnchor.constraint(equalToConstant: setupWidthConstraint())
        ])
        
        buttonSecondSpring = NSLayoutConstraint(
            item: buttonAnswerSecond, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(buttonSecondSpring)
        NSLayoutConstraint.activate([
            buttonAnswerSecond.topAnchor.constraint(equalTo: buttonAnswerFirst.bottomAnchor, constant: 8),
            buttonAnswerSecond.widthAnchor.constraint(equalToConstant: setupWidthConstraint())
        ])
        
        buttonThirdSpring = NSLayoutConstraint(
            item: buttonAnswerThird, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(buttonThirdSpring)
        NSLayoutConstraint.activate([
            buttonAnswerThird.topAnchor.constraint(equalTo: buttonAnswerSecond.bottomAnchor, constant: 8),
            buttonAnswerThird.widthAnchor.constraint(equalToConstant: setupWidthConstraint())
        ])
        
        buttonFourthSpring = NSLayoutConstraint(
            item: buttonAnswerFourth, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(buttonFourthSpring)
        NSLayoutConstraint.activate([
            buttonAnswerFourth.topAnchor.constraint(equalTo: buttonAnswerThird.bottomAnchor, constant: 8),
            buttonAnswerFourth.widthAnchor.constraint(equalToConstant: setupWidthConstraint())
        ])
         */
    }
    
    private func constraintsTimer() {
        NSLayoutConstraint.activate([
            labelTimer.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            labelTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func constraintsProgressView() {
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26),
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.widthAnchor.constraint(equalToConstant: setupWidthConstraint()),
            progressView.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        NSLayoutConstraint.activate([
            labelTimer.topAnchor.constraint(equalTo: progressView.topAnchor, constant: 4),
            labelTimer.trailingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: -30)
        ])
    }
    
    private func constraintsLabelQuiz() -> NSLayoutConstraint {
        var constraint = NSLayoutConstraint()
        if mode.timeElapsed.timeElapsed {
            constraint = labelQuiz.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 30)
        } else {
            constraint = labelQuiz.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
        }
        return constraint
    }
    
    private func setupSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    private func radius() -> CGFloat {
        6
    }
    
    private func setupWidthConstraint() -> CGFloat {
        view.bounds.width - 40
    }
    
    private func fixConstraintsForViewPanelBySizeIphone() -> CGFloat {
        view.frame.height > 736 ? 110 : 70
    }
    
    private func fixConstraintsForButtonBySizeIphone() -> CGFloat {
        view.frame.height > 736 ? 60 : 30
    }
    
    private func size() -> CGFloat {
        view.frame.width > 375 ? 20 : 19
    }
}
