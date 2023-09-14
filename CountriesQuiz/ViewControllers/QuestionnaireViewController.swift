//
//  QuestionnaireViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 29.08.2023.
//

import UIKit

class QuestionnaireViewController: UIViewController {
    private lazy var buttonExit: UIButton = {
        let button = setButton(
            image: "multiply",
            action: #selector(exitToGameType))
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
    
    private lazy var buttonBack: UIButton = {
        let button = setButton(
            image: "chevron.left",
            action: #selector(back))
        return button
    }()
    
    private lazy var buttonForward: UIButton = {
        let button = setButton(
            image: "chevron.right",
            action: #selector(forward))
        return button
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = setupProgressView()
        return progressView
    }()
    
    private lazy var labelNumber: UILabel = {
        let label = setupLabel(
            title: "0 / \(mode.countQuestions)",
            size: 23)
        return label
    }()
    
    private lazy var labelQuiz: UILabel = {
        let label = setupLabel(
            title: "Выберите правильные ответы",
            size: 23)
        return label
    }()
    
    private lazy var labelDescription: UILabel = {
        let label = setupLabel(
            title: "Коснитесь экрана, чтобы завершить",
            size: 19,
            color: .lightPurplePink)
        return label
    }()
    
    private lazy var buttonFirst: UIButton = {
        let button = setButton(
            image: checkmarkFirst,
            label: labelFirst,
            tag: 1,
            action: #selector(buttonPress))
        return button
    }()
    
    private lazy var checkmarkFirst: UIImageView = {
        let checkmark = setupCheckmark(
            image: "circle",
            tag: 1)
        return checkmark
    }()
    
    private lazy var labelFirst: UILabel = {
        let label = setupLabel(
            title: questions.buttonFirst[currentQuestion].name,
            size: 23,
            tag: 1)
        return label
    }()
    
    private lazy var buttonSecond: UIButton = {
        let button = setButton(
            image: checkmarkSecond,
            label: labelSecond,
            tag: 2,
            action: #selector(buttonPress))
        return button
    }()
    
    private lazy var checkmarkSecond: UIImageView = {
        let checkmark = setupCheckmark(
            image: "circle",
            tag: 2)
        return checkmark
    }()
    
    private lazy var labelSecond: UILabel = {
        let label = setupLabel(
            title: questions.buttonSecond[currentQuestion].name,
            size: 23,
            tag: 2)
        return label
    }()
    
    private lazy var buttonThird: UIButton = {
        let button = setButton(
            image: checkmarkThird,
            label: labelThird,
            tag: 3,
            action: #selector(buttonPress))
        return button
    }()
    
    private lazy var checkmarkThird: UIImageView = {
        let checkmark = setupCheckmark(
            image: "circle",
            tag: 3)
        return checkmark
    }()
    
    private lazy var labelThird: UILabel = {
        let label = setupLabel(
            title: questions.buttonThird[currentQuestion].name,
            size: 23,
            tag: 3)
        return label
    }()
    
    private lazy var buttonFourth: UIButton = {
        let button = setButton(
            image: checkmarkFourth,
            label: labelFourth,
            tag: 4,
            action: #selector(buttonPress))
        return button
    }()
    
    private lazy var checkmarkFourth: UIImageView = {
        let checkmark = setupCheckmark(
            image: "circle",
            tag: 4)
        return checkmark
    }()
    
    private lazy var labelFourth: UILabel = {
        let label = setupLabel(
            title: questions.buttonFourth[currentQuestion].name,
            size: 23,
            tag: 4)
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
    
    private var imageFlagSpring: NSLayoutConstraint!
    private var stackViewSprint: NSLayoutConstraint!
    
    private var timer = Timer()
    private var questions = Countries.getQuestions()
    private var shapeLayer = CAShapeLayer()
    
    private var currentQuestion = 0
    private var numberQuestion = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupBarButton()
        setupSubviews()
        setupConstraints()
        moveSubviews()
        setupOpacitySubviews()
        setupDisabledButtons()
        startGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupCircles()
    }
    
    private func setupDesign() {
        view.backgroundColor = game.background
        navigationItem.hidesBackButton = true
    }
    
    private func setupBarButton() {
        let leftBarButton = UIBarButtonItem(customView: buttonExit)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func setupSubviews() {
        if mode.timeElapsed.timeElapsed {
            setupSubviews(subviews: labelTimer, imageFlag, buttonBack,
                          buttonForward, progressView, labelNumber, labelQuiz,
                          labelDescription, stackView, on: view)
        } else {
            setupSubviews(subviews: imageFlag, buttonBack, buttonForward,
                          progressView, labelNumber, labelQuiz, stackView,
                          labelDescription, on: view)
        }
    }
    
    private func setupOpacitySubviews() {
        setupOpacity(subviews: labelQuiz, labelDescription, buttonBack,
                     buttonForward, opacity: 0)
    }
    
    private func setupDisabledButtons() {
        buttonsIsEnabled(bool: false)
        setupIsEnabled(subviews: buttonBack, buttonForward, isEnabled: false)
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    private func setupOpacity(subviews: UIView..., opacity: Float) {
        subviews.forEach { subview in
            subview.layer.opacity = opacity
        }
    }
    
    private func setupIsEnabled(subviews: UIControl..., isEnabled: Bool) {
        subviews.forEach { subview in
            subview.isEnabled = isEnabled
        }
    }
    
    private func runTimer(duration: CGFloat, action: Selector, repeats: Bool) -> Timer {
        Timer.scheduledTimer(timeInterval: duration, target: self,
                             selector: action, userInfo: nil, repeats: repeats)
    }
    
    private func buttonsIsEnabled(bool: Bool) {
        setupIsEnabled(subviews: buttonFirst, buttonSecond,
                       buttonThird, buttonFourth, isEnabled: bool)
    }
    
    private func checkLastQuestion() {
        guard !(currentQuestion + 1 == mode.countQuestions) else { return }
        setupIsEnabled(subviews: buttonBack, buttonForward, isEnabled: false)
    }
    
    private func checkQuestion() -> Int {
        numberQuestion == currentQuestion ? currentQuestion : numberQuestion
    }
    
    private func setProgressView() {
        let interval: Float = 1 / Float(mode.countQuestions)
        let progress = progressView.progress + interval
        
        UIView.animate(withDuration: 0.5) { 
            self.progressView.setProgress(progress, animated: true)
        }
    }
    
    private func setupCircles() {
        if mode.timeElapsed.timeElapsed {
            circleShadow()
            circle(strokeEnd: 0)
            animationTimeReset()
        }
    }
    
    @objc private func exitToGameType() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func back() {
        buttonsIsEnabled(bool: false)
        setupIsEnabled(subviews: buttonBack, buttonForward, isEnabled: false)
        animationBackSubviews()
        timer = runTimer(duration: 0.25, action: #selector(refreshBackQuestion), repeats: false)
    }
    
    @objc private func forward() {
        buttonsIsEnabled(bool: false)
        setupIsEnabled(subviews: buttonBack, buttonForward, isEnabled: false)
        runAnimationSubviews()
    }
    
    private func moveSubviews() {
        let pointX: CGFloat = currentQuestion > 0 ? 2 : 1
        imageFlagSpring.constant += view.frame.width * pointX
        stackViewSprint.constant += view.frame.width * pointX
    }
    
    private func moveBackSubviews() {
        imageFlagSpring.constant -= view.frame.width * 2
        stackViewSprint.constant -= view.frame.width * 2
    }
    
    private func startGame() {
        timer = runTimer(duration: 1, action: #selector(showSubviews), repeats: false)
    }
    
    @objc private func showSubviews() {
        timer.invalidate()
        
        if currentQuestion < 1 {
            labelAnimation(label: labelQuiz, duration: 1, opacity: 1)
        }
        animationSubviews(duration: 0.5)
        
        timer = runTimer(duration: 0.5, action: #selector(isEnabledSubviews), repeats: false)
    }
    
    private func labelAnimation(label: UILabel, duration: CGFloat, opacity: Float) {
        UIView.animate(withDuration: duration) { [self] in
            setupOpacity(subviews: label, opacity: opacity)
        }
    }
    
    private func labelDescriptionAnimation() {
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.labelDescription.layer.opacity = 1
        })
    }
    
    private func animationSubviews(duration: CGFloat) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut) { [self] in
            imageFlagSpring.constant -= view.bounds.width
            stackViewSprint.constant -= view.bounds.width
            view.layoutIfNeeded()
        }
    }
    
    private func animationBackSubviews() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) { [self] in
            imageFlagSpring.constant += view.bounds.width
            stackViewSprint.constant += view.bounds.width
            view.layoutIfNeeded()
        }
    }
    
    @objc private func isEnabledSubviews() {
        timer.invalidate()
        buttonsIsEnabled(bool: true)
        labelNumber.text = "\(currentQuestion + 1) / \(mode.countQuestions)"
    }
    
    @objc private func buttonPress(button: UIButton) {
        switch button {
        case buttonFirst:
            action(button: buttonFirst, image: checkmarkFirst, label: labelFirst)
        case buttonSecond:
            action(button: buttonSecond, image: checkmarkSecond, label: labelSecond)
        case buttonThird:
            action(button: buttonThird, image: checkmarkThird, label: labelThird)
        default:
            action(button: buttonFourth, image: checkmarkFourth, label: labelFourth)
        }
        setupNextQuestion()
    }
    
    private func action(button: UIButton, image: UIImageView, label: UILabel) {
        select(button: button)
        buttonSelect(button: button)
        imageSelect(image: image)
        labelSelect(label: label)
        
        buttonsIsEnabled(bool: false)
        checkLastQuestion()
        
        guard numberQuestion == currentQuestion else { return }
        setProgressView()
    }
    
    private func select(button: UIButton) {
        let question = checkQuestion()
        let tag = button.tag
        var number = 0
        while number < 4 {
            number += 1
            if !(number == tag) {
                selectIsEnabled(tag: number, bool: false, number: question)
            }
        }
        selectIsEnabled(tag: tag, bool: true, number: question)
    }
    
    private func buttonSelect(button: UIButton) {
        let tag = button.tag
        setupButtonsDisabled(tag: tag)
        buttonIsEnabled(button: button, color: .white)
    }
    
    private func imageSelect(image: UIImageView) {
        let tag = image.tag
        setupImagesDisabled(tag: tag)
        imageIsEnabled(image: image, color: .greenHarlequin, symbol: "checkmark.circle.fill")
    }
    
    private func labelSelect(label: UILabel) {
        let tag = label.tag
        setupLabelsDisabled(tag: tag)
        labelIsEnabled(label: label, color: .greenHarlequin)
    }
    
    private func setupButtonsDisabled(tag: Int) {
        selectButtonsDisabled(buttons: buttonFirst, buttonSecond,
                              buttonThird, buttonFourth, tag: tag)
    }
    
    private func selectButtonsDisabled(buttons: UIButton..., tag: Int) {
        buttons.forEach { button in
            if !(button.tag == tag) {
                buttonIsEnabled(button: button, color: .clear)
            }
        }
    }
    
    private func setupImagesDisabled(tag: Int) {
        selectImagesDisabled(images: checkmarkFirst, checkmarkSecond,
                             checkmarkThird, checkmarkFourth, tag: tag)
    }
    
    private func selectImagesDisabled(images: UIImageView..., tag: Int) {
        images.forEach { image in
            if !(image.tag == tag) {
                imageIsEnabled(image: image, color: .white, symbol: "circle")
            }
        }
    }
    
    private func setupLabelsDisabled(tag: Int) {
        selectLabelsDisabled(labels: labelFirst, labelSecond,
                             labelThird, labelFourth, tag: tag)
    }
    
    private func selectLabelsDisabled(labels: UILabel..., tag: Int) {
        labels.forEach { label in
            if !(label.tag == tag) {
                labelIsEnabled(label: label, color: .white)
            }
        }
    }
    
    private func buttonIsEnabled(button: UIButton, color: UIColor) {
        UIView.animate(withDuration: 0.3) {
            button.backgroundColor = color
        }
    }
    
    private func imageIsEnabled(image: UIImageView, color: UIColor, symbol: String) {
        UIView.animate(withDuration: 0.3) {
            let size = UIImage.SymbolConfiguration(pointSize: 30)
            image.tintColor = color
            image.image = UIImage(systemName: symbol, withConfiguration: size)
        }
    }
    
    private func labelIsEnabled(label: UILabel, color: UIColor) {
        UIView.animate(withDuration: 0.3) {
            label.textColor = color
        }
    }
    
    private func selectIsEnabled(tag: Int, bool: Bool, number: Int) {
        switch tag {
        case 1: questions.buttonFirst[number].select = bool
//            print("tag: \(tag), bool: \(bool), number: \(number)")
        case 2: questions.buttonSecond[number].select = bool
//            print("tag: \(tag), bool: \(bool), number: \(number)")
        case 3: questions.buttonThird[number].select = bool
//            print("tag: \(tag), bool: \(bool), number: \(number)")
        default: questions.buttonFourth[number].select = bool
//            print("tag: \(tag), bool: \(bool), number: \(number)")
        }
    }
    
    private func setupNextQuestion() {
        if currentQuestion + 1 < mode.countQuestions {
            timer = runTimer(duration: 1, action: #selector(hideQuestion), repeats: false)
        } else {
            finishQuestionnaire()
        }
    }
    
    @objc private func hideQuestion() {
        timer.invalidate()
        runAnimationSubviews()
    }
    
    private func runAnimationSubviews() {
        animationSubviews(duration: 0.25)
        timer = runTimer(duration: 0.25, action: #selector(refreshQuestion), repeats: false)
    }
    
    @objc private func refreshQuestion() {
        timer.invalidate()
        if numberQuestion == currentQuestion {
            currentQuestion += 1
            numberQuestion += 1
        } else {
            numberQuestion += 1
            checkFinish()
        }
        moveSubviews()
        
        refresh()
        
        timer = runTimer(duration: 0.1, action: #selector(showQuestion), repeats: false)
    }
    
    @objc private func showQuestion() {
        timer.invalidate()
        animationSubviews(duration: 0.25)
        timer = runTimer(duration: 0.25, action: #selector(nextQuestion), repeats: false)
    }
    
    @objc private func nextQuestion() {
        timer.invalidate()
        buttonsIsEnabled(bool: true)
        buttonsOnOff()
    }
    
    private func refresh() {
        refreshFlagAndNumber()
        refreshLabels()
        
        setupImagesDisabled(tag: 0)
        setupLabelsDisabled(tag: 0)
        setupButtonsDisabled(tag: 0)
        
        guard !(numberQuestion == currentQuestion) else { return }
        checkSelect(selects: questions.buttonFirst[numberQuestion].select,
                    questions.buttonSecond[numberQuestion].select,
                    questions.buttonThird[numberQuestion].select,
                    questions.buttonFourth[numberQuestion].select)
    }
    
    @objc private func refreshBackQuestion() {
        timer.invalidate()
        if numberQuestion > currentQuestion {
            numberQuestion -= 2
            labelAnimation(label: labelDescription, duration: 0, opacity: 0)
            labelAnimation(label: labelQuiz, duration: 1, opacity: 1)
        } else {
            numberQuestion -= 1
        }
        moveBackSubviews()
        
        refresh()
        
        timer = runTimer(duration: 0.1, action: #selector(showBackQuestion), repeats: false)
    }
    
    @objc private func showBackQuestion() {
        timer.invalidate()
        animationBackSubviews()
        timer = runTimer(duration: 0.25, action: #selector(nextQuestion), repeats: false)
    }
    
    private func checkSelect(selects: Bool...) {
        var tag = 1
        selects.forEach { select in
            if select {
                tagSelect(tag: tag)
            }
            tag += 1
        }
    }
    
    private func tagSelect(tag: Int) {
        switch tag {
        case 1: setupSelect(button: buttonFirst, image: checkmarkFirst, label: labelFirst)
        case 2: setupSelect(button: buttonSecond, image: checkmarkSecond, label: labelSecond)
        case 3: setupSelect(button: buttonThird, image: checkmarkThird, label: labelThird)
        default: setupSelect(button: buttonFourth, image: checkmarkFourth, label: labelFourth)
        }
    }
    
    private func setupSelect(button: UIButton, image: UIImageView, label: UILabel) {
        buttonSelect(button: button)
        imageSelect(image: image)
        labelSelect(label: label)
    }
    
    private func buttonsOnOff() {
        if numberQuestion == currentQuestion {
            buttonsBackForward(buttonBack: buttonBack, buttonForward: buttonForward,
                               opacityBack: 1, opacityForward: 0,
                               isEnabledBack: true, isEnabledForward: false)
        } else if numberQuestion > 0, numberQuestion < currentQuestion {
            buttonsBackForward(buttonBack: buttonBack, buttonForward: buttonForward,
                               opacityBack: 1, opacityForward: 1,
                               isEnabledBack: true, isEnabledForward: true)
        } else {
            buttonsBackForward(buttonBack: buttonBack, buttonForward: buttonForward,
                               opacityBack: 0, opacityForward: 1,
                               isEnabledBack: false, isEnabledForward: true)
        }
    }
    
    private func buttonsBackForward(buttonBack: UIButton, buttonForward: UIButton,
                                    opacityBack: Float, opacityForward: Float,
                                    isEnabledBack: Bool, isEnabledForward: Bool) {
        UIView.animate(withDuration: 0.3) { [self] in
            setupOpacity(subviews: buttonBack, opacity: opacityBack)
            setupOpacity(subviews: buttonForward, opacity: opacityForward)
        }
        setupIsEnabled(subviews: buttonBack, isEnabled: isEnabledBack)
        setupIsEnabled(subviews: buttonForward, isEnabled: isEnabledForward)
    }
    
    private func refreshFlagAndNumber() {
        let number = checkQuestion()
        imageFlag.image = UIImage(named: questions.questions[number].flag)
        labelNumber.text = "\(number + 1) / \(mode.countQuestions)"
    }
    
    private func refreshLabels() {
        let number = checkQuestion()
        labelFirst.text = questions.buttonFirst[number].name
        labelSecond.text = questions.buttonSecond[number].name
        labelThird.text = questions.buttonThird[number].name
        labelFourth.text = questions.buttonFourth[number].name
    }
    
    private func checkFinish() {
        guard numberQuestion == mode.countQuestions else { return }
        finishQuestionnaire()
    }
    
    private func finishQuestionnaire() {
        numberQuestion += 1
        labelAnimation(label: labelQuiz, duration: 0.5, opacity: 0)
        labelDescriptionAnimation()
    }
}
// MARK: - Touches began
extension QuestionnaireViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard numberQuestion > currentQuestion else { return }
        exitToGameType()
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
    
    private func setButton(image: UIImageView, label: UILabel, tag: Int,
                           action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 12
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        setupSubviews(subviews: image, label, on: button)
        return button
    }
}
// MARK: - Setup label
extension QuestionnaireViewController {
    private func setupLabel(title: String, size: CGFloat, color: UIColor? = nil,
                            tag: Int? = nil, opacity: Float? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textAlignment = .center
        label.textColor = color ?? .white
        label.numberOfLines = 0
        label.tag = tag ?? 0
        label.layer.opacity = opacity ?? 1
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
    
    private func setupCheckmark(image: String, tag: Int) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.tag = tag
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
        setupSquare(subview: buttonExit, sizes: 40)
        
        if mode.timeElapsed.timeElapsed {
            constraintsTimer()
        }
        
        imageFlagSpring = NSLayoutConstraint(
            item: imageFlag, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(imageFlagSpring)
        NSLayoutConstraint.activate([
            imageFlag.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            imageFlag.widthAnchor.constraint(equalToConstant: 280),
            imageFlag.heightAnchor.constraint(equalToConstant: 168)
        ])
        
        constraintsButtons(button: buttonBack, constant: -167.5)
        constraintsButtons(button: buttonForward, constant: 167.5)
        
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
            labelDescription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelDescription.centerYAnchor.constraint(equalTo: labelQuiz.centerYAnchor),
            labelDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        stackViewSprint = NSLayoutConstraint(
            item: stackView, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(stackViewSprint)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: labelQuiz.bottomAnchor, constant: 25),
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
    
    private func constraintsButtons(button: UIButton, constant: CGFloat) {
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: imageFlag.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant)
        ])
        setupSquare(subview: button, sizes: 40)
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
