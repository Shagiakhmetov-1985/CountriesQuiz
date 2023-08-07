//
//  QuizOfFlagsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 09.01.2023.
//

import UIKit

class QuizOfFlagsViewController: UIViewController {
    // MARK: - Setup subviews
    private lazy var viewPanel: UIView = {
        let view = setView(color: .white)
        return view
    }()
    
    private lazy var buttonBackMenu: UIButton = {
        let button = setButton(
            image: "multiply",
            action: #selector(exitToMenu))
        return button
    }()
    
    private lazy var contentView: UIView = {
        let view = setView()
        return view
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = setProgressView(
            radius: 7,
            progressColor: UIColor.progressColor,
            trackColor: UIColor.trackColor,
            borderWidth: 2.5,
            borderColor: UIColor.cyanLight,
            progress: 1)
        return progressView
    }()
    
    private lazy var labelTimer: UILabel = {
        let label = setLabel(
            title: "\(oneQuestionSeconds())",
            size: 35,
            style: "mr_fontick",
            color: .black)
        return label
    }()
    
    private lazy var labelQuiz: UILabel = {
        let label = setLabel(
            title: "Флаг страны?",
            size: 30,
            style: "mr_fontick",
            color: UIColor.cyanLight,
            colorOfShadow: UIColor.shadowBlueLight.cgColor,
            radiusOfShadow: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2)
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
    
    private lazy var labelNumberQuiz: UILabel = {
        let label = setLabel(
            title: "Вопрос \(currentQuestion + 1) из \(mode.countQuestions)",
            size: 30,
            style: "mr_fontick",
            color: UIColor.cyanLight,
            colorOfShadow: UIColor.shadowBlueLight.cgColor,
            radiusOfShadow: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2,
            textAlignment: .center)
        return label
    }()
    
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
    
    private lazy var buttonAnswerFirst: UIButton = {
        let button = setButton(
            title: questions.buttonFirst[currentQuestion].name,
            style: "mr_fontick",
            size: 18,
            colorTitle: UIColor.blueLight,
            colorBackgroud: UIColor.cyanLight,
            radiusCorner: 7,
            shadowColor: UIColor.shadowBlueLight.cgColor,
            radiusShadow: 2.5,
            shadowOffsetWidth: 2.5,
            shadowOffsetHeight: 2.5,
            isEnabled: false,
            tag: 1)
        button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonAnswerSecond: UIButton = {
        let button = setButton(
            title: questions.buttonSecond[currentQuestion].name,
            style: "mr_fontick",
            size: 18,
            colorTitle: UIColor.blueLight,
            colorBackgroud: UIColor.cyanLight,
            radiusCorner: 7,
            shadowColor: UIColor.shadowBlueLight.cgColor,
            radiusShadow: 2.5,
            shadowOffsetWidth: 2.5,
            shadowOffsetHeight: 2.5,
            isEnabled: false,
            tag: 2)
        button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonAnswerThird: UIButton = {
        let button = setButton(
            title: questions.buttonThird[currentQuestion].name,
            style: "mr_fontick",
            size: 18,
            colorTitle: UIColor.blueLight,
            colorBackgroud: UIColor.cyanLight,
            radiusCorner: 7,
            shadowColor: UIColor.shadowBlueLight.cgColor,
            radiusShadow: 2.5,
            shadowOffsetWidth: 2.5,
            shadowOffsetHeight: 2.5,
            isEnabled: false,
            tag: 3)
        button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonAnswerFourth: UIButton = {
        let button = setButton(
            title: questions.buttonFourth[currentQuestion].name,
            style: "mr_fontick",
            size: 18,
            colorTitle: UIColor.blueLight,
            colorBackgroud: UIColor.cyanLight,
            radiusCorner: 7,
            shadowColor: UIColor.shadowBlueLight.cgColor,
            radiusShadow: 2.5,
            shadowOffsetWidth: 2.5,
            shadowOffsetHeight: 2.5,
            isEnabled: false,
            tag: 4)
        button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        return button
    }()
    
    var mode: Setting!
    
    private var imageFlagSpring: NSLayoutConstraint!
    private var buttonFirstSpring: NSLayoutConstraint!
    private var buttonSecondSpring: NSLayoutConstraint!
    private var buttonThirdSpring: NSLayoutConstraint!
    private var buttonFourthSpring: NSLayoutConstraint!
    
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
//        circular()
//        startHideSubviews()
        startGame()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        circular()
        circularShadow()
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
        setupSubviews(subviews: labelTimer, imageFlag,
                      on: view)
    }
    
    private func setupSubviewsWithoutTimer() {
        setupSubviews(subviews: imageFlag,
                      on: view)
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setupBarButton() {
        let barButton = UIBarButtonItem(customView: buttonBackMenu)
        navigationItem.leftBarButtonItem = barButton
    }
    
    private func circular() {
        let center = CGPoint(x: labelTimer.frame.width / 2, y: labelTimer.frame.height / 2)
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
        labelTimer.layer.addSublayer(shapeLayer)
    }
    
    private func circularShadow() {
        let center = CGPoint(x: labelTimer.frame.width / 2, y: labelTimer.frame.height / 2)
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
        trackShape.strokeColor = UIColor.blueBlackSea.withAlphaComponent(0.1).cgColor
        labelTimer.layer.addSublayer(trackShape)
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
        /*
        buttonFirstSpring.constant += view.bounds.width * pointX
        buttonSecondSpring.constant += view.bounds.width * pointX
        buttonThirdSpring.constant += view.bounds.width * pointX
        buttonFourthSpring.constant += view.bounds.width * pointX
         */
    }
    
    private func startHideSubviews() {
        setupOpacityLabels(labels: labelQuiz, labelNumberQuiz, opacity: 0)
        setupHiddenSubviews(views: imageFlag, buttonAnswerFirst, buttonAnswerSecond,
                            buttonAnswerThird, buttonAnswerFourth, isHidden: true)
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
        
        setupHiddenSubviews(views: imageFlag, isHidden: false)
        /*
        if currentQuestion < 1 {
            UIView.animate(withDuration: 1, delay: 0, options: .curveLinear) { [self] in
                setupOpacityLabels(labels: labelQuiz, labelNumberQuiz, opacity: 1)
            }
        }
        */
        animationSubviews()
    }
    
    private func animationSubviews() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
            self.imageFlagSpring.constant -= self.view.bounds.width
            /*
            self.buttonFirstSpring.constant -= self.view.bounds.width
            self.buttonSecondSpring.constant -= self.view.bounds.width
            self.buttonThirdSpring.constant -= self.view.bounds.width
            self.buttonFourthSpring.constant -= self.view.bounds.width
             */
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func isEnabledButton() {
        timerSecond.invalidate()
        animationCircular()
//        setupEnabledSubviews(controls: buttonAnswerFirst, buttonAnswerSecond,
//                             buttonAnswerThird, buttonAnswerFourth,
//                             isEnabled: true)
        
//        if mode.timeElapsed.timeElapsed {
//            checkSeconds()
//            runTimer()
//        }
    }
    
    private func checkSeconds() {
        if !oneQuestionCheck(), currentQuestion < 1 {
            seconds = oneQuestionSeconds() * 10
        } else if oneQuestionCheck() {
            seconds = oneQuestionSeconds() * 10
        }
    }
    
    private func runTimer() {
        timerFirst = Timer.scheduledTimer(
            timeInterval: 0.1, target: self, selector: #selector(timeElapsed),
            userInfo: nil, repeats: true)
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
    
    @objc private func exitToMenu() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func buttonPress(button: UIButton) {
        let darkGreen = UIColor.darkGreen
        let green = UIColor.green
        let lightGreen = UIColor.lightGreen
        
        let darkRed = UIColor.darkRed
        let red = UIColor.red
        let lightRed = UIColor.lightRed
        
        let tag = button.tag
        
        timerFirst.invalidate()
        timerSecond.invalidate()
        answerSelect.toggle()
        
        if checkAnswer(tag: tag) {
            button.setTitleColor(green, for: .normal)
            button.backgroundColor = lightGreen
            button.layer.shadowColor = darkGreen.cgColor
        } else {
            button.setTitleColor(red, for: .normal)
            button.backgroundColor = lightRed
            button.layer.shadowColor = darkRed.cgColor
            
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
        let darkGray = UIColor.darkGray
        let gray = UIColor.gray
        let lightGray = UIColor.lightGray
        
        buttons.forEach { button in
            if !(button.tag == tag) {
                button.setTitleColor(gray, for: .normal)
                button.backgroundColor = lightGray
                button.layer.shadowColor = darkGray.cgColor
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
        
        labelNumberQuiz.text = "Вопрос \(currentQuestion + 1) из \(mode.countQuestions)"
        
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
        
        labelDescription.layer.opacity = 0
        
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
            let darkRed = UIColor.darkRed
            let lightRed = UIColor.lightRed
            labelDescription.text = "Коснитесь экрана, чтобы завершить"
            labelDescription.textColor = lightRed
            labelDescription.layer.shadowColor = darkRed.cgColor
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.labelNumberQuiz.layer.opacity = 0
        })
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.labelDescription.layer.opacity = 1
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
    private func setButton(title: String, style: String? = nil, size: CGFloat,
                           colorTitle: UIColor? = nil, colorBackgroud: UIColor? = nil,
                           radiusCorner: CGFloat, borderWidth: CGFloat? = nil,
                           borderColor: CGColor? = nil, shadowColor: CGColor? = nil,
                           radiusShadow: CGFloat? = nil, shadowOffsetWidth: CGFloat? = nil,
                           shadowOffsetHeight: CGFloat? = nil, isEnabled: Bool? = nil,
                           tag: Int? = nil) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(colorTitle, for: .normal)
        button.titleLabel?.font = UIFont(name: style ?? "", size: size)
        button.backgroundColor = colorBackgroud
        button.layer.cornerRadius = radiusCorner
        button.layer.borderWidth = borderWidth ?? 0
        button.layer.borderColor = borderColor
        button.layer.shadowColor = shadowColor
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = radiusShadow ?? 0
        button.layer.shadowOffset = CGSize(width: shadowOffsetWidth ?? 0,
                                           height: shadowOffsetHeight ?? 0)
        button.isEnabled = isEnabled ?? true
        button.tag = tag ?? 0
        button.translatesAutoresizingMaskIntoConstraints = false
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
                                 trackColor: UIColor, borderWidth: CGFloat,
                                 borderColor: UIColor, progress: Float) -> UIProgressView {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = radius
        progressView.clipsToBounds = true
        progressView.progressTintColor = progressColor
        progressView.trackTintColor = trackColor
        progressView.layer.borderWidth = borderWidth
        progressView.layer.borderColor = borderColor.cgColor
        progressView.progress = progress
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }
}
// MARK: - Setup constraints
extension QuizOfFlagsViewController {
    private func setConstraints() {
        /*
        NSLayoutConstraint.activate([
            viewPanel.topAnchor.constraint(equalTo: view.topAnchor),
            viewPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewPanel.heightAnchor.constraint(equalToConstant: fixConstraintsForViewPanelBySizeIphone())
        ])
        */
        if mode.timeElapsed.timeElapsed {
            constraintsTimer()
        }
        
        setupSquare(subview: buttonBackMenu, sizes: 40)
        /*
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: viewPanel.bottomAnchor, constant: 1),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if mode.timeElapsed.timeElapsed {
            constraintsProgressView()
        }
        
        NSLayoutConstraint.activate([
            constraintsLabelQuiz(),
            labelQuiz.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        */
        imageFlagSpring = NSLayoutConstraint(
            item: imageFlag, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(imageFlagSpring)
        NSLayoutConstraint.activate([
            imageFlag.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            imageFlag.widthAnchor.constraint(equalToConstant: 300),
            imageFlag.heightAnchor.constraint(equalToConstant: 180)
        ])
        /*
        NSLayoutConstraint.activate([
            labelNumberQuiz.topAnchor.constraint(equalTo: imageFlag.bottomAnchor, constant: 30),
            labelNumberQuiz.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelNumberQuiz.widthAnchor.constraint(equalToConstant: setupWidthConstraint())
        ])
        
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
