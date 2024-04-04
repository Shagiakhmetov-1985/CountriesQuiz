//
//  QuizOfFlagsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 09.01.2023.
//

import UIKit

protocol QuizOfFlagsViewControllerInput: AnyObject {
    func dataToQuizOfFlag(setting: Setting)
}

class QuizOfFlagsViewController: UIViewController {
    // MARK: - Setup subviews
    private lazy var buttonback: UIButton = {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "multiply", withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        button.translatesAutoresizingMaskIntoConstraints = true
        button.addTarget(self, action: #selector(backToGameType), for: .touchUpInside)
        return button
    }()
    
    private lazy var labelTimer: UILabel = {
        setLabel(title: "\(viewModel.time())", size: 35)
    }()
    
    private lazy var imageFlag: UIImageView = {
        setImage(image: viewModel.data.questions[viewModel.currentQuestion].flag)
    }()
    
    private lazy var labelCountry: UILabel = {
        setLabel(title: "\(viewModel.data.questions[viewModel.currentQuestion].name)", size: 32)
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = viewModel.radius
        progressView.clipsToBounds = true
        progressView.progressTintColor = .white
        progressView.trackTintColor = .white.withAlphaComponent(0.3)
        progressView.progress = 0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private lazy var labelNumberQuiz: UILabel = {
        setLabel(title: "0 / \(viewModel.countQuestions)", size: 23)
    }()
    
    private lazy var labelQuiz: UILabel = {
        setLabel(title: "Выберите правильный ответ", size: 23, opacity: 0)
    }()
    
    private lazy var labelDescription: UILabel = {
        setLabel(title: "Коснитесь экрана, чтобы продолжить", size: 19, opacity: 0)
    }()
    
    private lazy var buttonFirst: UIButton = {
        viewModel.isFlag() ? setButton(title: viewModel.buttonFirst, tag: 1) : setButton(addImage: imageFirst, tag: 1)
    }()
    
    private lazy var imageFirst: UIImageView = {
        setImage(image: viewModel.data.buttonFirst[viewModel.currentQuestion].flag, radius: 8)
    }()
    
    private lazy var buttonSecond: UIButton = {
        viewModel.isFlag() ? setButton(title: viewModel.buttonSecond, tag: 2) : setButton(addImage: imageSecond, tag: 2)
    }()
    
    private lazy var imageSecond: UIImageView = {
        setImage(image: viewModel.data.buttonSecond[viewModel.currentQuestion].flag, radius: 8)
    }()
    
    private lazy var buttonThird: UIButton = {
        viewModel.isFlag() ? setButton(title: viewModel.buttonThird, tag: 3) : setButton(addImage: imageThird, tag: 3)
    }()
    
    private lazy var imageThird: UIImageView = {
        setImage(image: viewModel.data.buttonThird[viewModel.currentQuestion].flag, radius: 8)
    }()
    
    private lazy var buttonFourth: UIButton = {
        viewModel.isFlag() ? setButton(title: viewModel.buttonFourth, tag: 4) : setButton(addImage: imageFourth, tag: 4)
    }()
    
    private lazy var imageFourth: UIImageView = {
        setImage(image: viewModel.data.buttonFourth[viewModel.currentQuestion].flag, radius: 8)
    }()
    
    private lazy var stackViewFlag: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [buttonFirst, buttonSecond, buttonThird, buttonFourth])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var stackViewTop: UIStackView = {
        setStackView(buttonFirst: buttonFirst, buttonSecond: buttonSecond)
    }()
    
    private lazy var stackViewBottom: UIStackView = {
        setStackView(buttonFirst: buttonThird, buttonSecond: buttonFourth)
    }()
    
    private lazy var stackViewLabel: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackViewTop, stackViewBottom])
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var viewModel: QuizOfFlagsViewModelProtocol!
    weak var delegateInput: GameTypeViewControllerInput!
    
    private var imageFlagSpring: NSLayoutConstraint!
    private var labelNameSpring: NSLayoutConstraint!
    private var stackViewSpring: NSLayoutConstraint!
    
    private var widthOfFlagFirst: NSLayoutConstraint!
    private var widthOfFlagSecond: NSLayoutConstraint!
    private var widthOfFlagThird: NSLayoutConstraint!
    private var widthOfFlagFourth: NSLayoutConstraint!
    
    private let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupDesign()
        setupSubviews()
        setupConstraints()
        setupBarButton()
        runMoveSubviews()
        startGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard viewModel.isCountdown() else { return }
        circularShadow()
        circular(strokeEnd: 0)
        animationCircleTimeReset()
    }
    // MARK: - General methods
    private func setupData() {
        viewModel.getQuestions()
    }
    
    private func setupDesign() {
        view.backgroundColor = viewModel.background
        navigationItem.hidesBackButton = true
    }
    
    private func setupSubviews() {
        if viewModel.isCountdown() {
            viewModel.isFlag() ? subviewsWithTimerFlag() : subviewsWithTimerLabel()
        } else {
            viewModel.isFlag() ? subviewsWithoutTimerFlag() : subviewsWithoutTimerLabel()
        }
    }
    
    private func subviewsWithTimerFlag() {
        viewModel.setSubviews(subviews: labelTimer, imageFlag, progressView,
                              labelNumberQuiz, labelQuiz, labelDescription,
                              stackViewFlag, on: view)
    }
    
    private func subviewsWithTimerLabel() {
        viewModel.setSubviews(subviews: labelTimer, labelCountry, progressView,
                              labelNumberQuiz, labelQuiz, labelDescription,
                              stackViewLabel, on: view)
    }
    
    private func subviewsWithoutTimerFlag() {
        viewModel.setSubviews(subviews: imageFlag, progressView, labelNumberQuiz,
                              labelQuiz, labelDescription, stackViewFlag, on: view)
    }
    
    private func subviewsWithoutTimerLabel() {
        viewModel.setSubviews(subviews: labelCountry, progressView, labelNumberQuiz,
                              labelQuiz, labelDescription, stackViewLabel, on: view)
    }
    
    private func setupBarButton() {
        viewModel.setBarButton(buttonback, navigationItem)
    }
    // MARK: - Timer
    func runTimer(time: CGFloat, action: Selector, repeats: Bool) -> Timer {
        Timer.scheduledTimer(timeInterval: time, target: self, selector: action,
                             userInfo: nil, repeats: repeats)
    }
    // MARK: - Time for label, seconds and circle timer
    private func checkCircleCountdown() -> Int {
        viewModel.isOneQuestion() ? viewModel.oneQuestionTime() : viewModel.seconds / 10
    }
    // MARK: - Move flag and buttons
    private func runMoveSubviews() {
        viewModel.runMoveSubviews(viewModel.isFlag() ? imageFlagSpring : labelNameSpring, stackViewSpring, view)
    }
    // MARK: - Animation move subviews
    private func animationSubviews(duration: CGFloat) {
        viewModel.animationSubviews(viewModel.isFlag() ? imageFlagSpring : labelNameSpring, stackViewSpring, duration, view)
    }
    // MARK: - Animation label description and label number
    private func showDescription() {
        viewModel.showDescription(labelDescription)
        viewModel.animationHideQuizShowDescription(labelQuiz, labelDescription)
    }
    // MARK: - Start game
    private func startGame() {
        let time: CGFloat = viewModel.currentQuestion == 0 ? 1 : 0.25
        viewModel.timer = runTimer(time: time, action: #selector(showSubviews), repeats: false)
    }
    
    @objc private func showSubviews() {
        viewModel.timer.invalidate()
        let time: CGFloat = viewModel.currentQuestion == 0 ? 0.5 : 0.25
        viewModel.animationShowQuizHideDescription(labelQuiz, labelDescription)
        animationSubviews(duration: time)
        checkSetCircularStrokeEnd()
        viewModel.timer = runTimer(time: time, action: #selector(isEnabledButton), repeats: false)
    }
    // MARK: - Enable subviews
    @objc private func isEnabledButton() {
        viewModel.timer.invalidate()
        viewModel.setEnabled(controls: buttonFirst, buttonSecond, buttonThird, buttonFourth, isEnabled: true)
        viewModel.updateProgressView(progressView)
        labelNumberQuiz.text = viewModel.labelNumberQuiz
        
        guard viewModel.isCountdown() else { return }
        viewModel.setTitleTime()
        animationCircleCountdown()
        runTimer()
    }
    // MARK: - Run timer
    private func runTimer() {
        viewModel.timer = runTimer(time: 0.1, action: #selector(timerTitle), repeats: true)
    }
    
    @objc private func timerTitle() {
        viewModel.setTitleTimer(labelTimer) {
            self.timeUp()
        }
    }
    
    private func timeUp() {
        viewModel.answerSelect.toggle()
        viewModel.addIncorrectAnswer(0)
        
        if !viewModel.isOneQuestion() {
            viewModel.setNextCurrentQuestion(viewModel.countQuestions - 1)
        }
        showDescription()
        animationColorDisableButton()
    }
    // MARK: - Buttons back
    @objc private func backToGameType() {
        viewModel.timer.invalidate()
        viewModel.setSeconds(0)
        viewModel.setNextCurrentQuestion(0)
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Button action when user select answer
    @objc private func buttonPress(button: UIButton) {
        viewModel.timer.invalidate()
        viewModel.answerSelect.toggle()
        
        animationColorButtons(button: button)
        showDescription()
        
        guard viewModel.isCountdown() else { return }
        stopAnimationCircleTimer()
        viewModel.checkTimeSpent(shapeLayer)
    }
    
    private func animationColorDisableButton() {
        if viewModel.isFlag() {
            viewModel.disableButtonFlag(0, buttonFirst, buttonSecond, buttonThird, buttonFourth) {
                self.delay()
            }
        } else {
            viewModel.disableButtonLabel(0, buttonFirst, buttonSecond, buttonThird, buttonFourth) {
                self.delay()
            }
        }
    }
    
    private func animationColorButtons(button: UIButton) {
        if viewModel.isFlag() {
            viewModel.checkAnswerFlag(button.tag, button)
            viewModel.disableButtonFlag(button.tag, buttonFirst, buttonSecond, buttonThird, buttonFourth) {
                self.delay()
            }
        } else {
            viewModel.checkAnswerLabel(button.tag, button)
            viewModel.disableButtonFlag(button.tag, buttonFirst, buttonSecond, buttonThird, buttonFourth) {
                self.delay()
            }
        }
    }
    
    private func delay() {
        guard viewModel.currentQuestion + 1 < viewModel.countQuestions else { return }
        viewModel.timer = runTimer(time: 3, action: #selector(hideSubviews), repeats: false)
    }
    // MARK: - Refresh data for next question
    private func updateData() {
        viewModel.isFlag() ? updateDataFlag() : updateDataLabel()
        guard viewModel.isCountdown() else { return }
        resetTimer()
    }
    
    private func updateDataFlag() {
        let flag = viewModel.data.questions[viewModel.currentQuestion].flag
        imageFlag.image = UIImage(named: flag)
        updateButtonsFlag()
        widthOfFlagFirst.constant = viewModel.checkWidthFlag(flag)
    }
    
    private func updateDataLabel() {
        labelCountry.text = viewModel.data.questions[viewModel.currentQuestion].name
        updateButtonsLabel()
        updateWidthFlags()
    }
    
    private func updateButtonsFlag() {
        buttonFirst.setTitle(viewModel.data.buttonFirst[viewModel.currentQuestion].name, for: .normal)
        buttonSecond.setTitle(viewModel.data.buttonSecond[viewModel.currentQuestion].name, for: .normal)
        buttonThird.setTitle(viewModel.data.buttonThird[viewModel.currentQuestion].name, for: .normal)
        buttonFourth.setTitle(viewModel.data.buttonFourth[viewModel.currentQuestion].name, for: .normal)
    }
    
    private func updateButtonsLabel() {
        imageFirst.image = UIImage(named: viewModel.data.buttonFirst[viewModel.currentQuestion].flag)
        imageSecond.image = UIImage(named: viewModel.data.buttonSecond[viewModel.currentQuestion].flag)
        imageThird.image = UIImage(named: viewModel.data.buttonThird[viewModel.currentQuestion].flag)
        imageFourth.image = UIImage(named: viewModel.data.buttonFourth[viewModel.currentQuestion].flag)
    }
    
    private func updateWidthFlags() {
        widthOfFlagFirst.constant = viewModel.widthFlag(viewModel.data.buttonFirst[viewModel.currentQuestion].flag, view)
        widthOfFlagSecond.constant = viewModel.widthFlag(viewModel.data.buttonSecond[viewModel.currentQuestion].flag, view)
        widthOfFlagThird.constant = viewModel.widthFlag(viewModel.data.buttonThird[viewModel.currentQuestion].flag, view)
        widthOfFlagFourth.constant = viewModel.widthFlag(viewModel.data.buttonFourth[viewModel.currentQuestion].flag, view)
    }
    
    private func resetTimer() {
        if viewModel.isOneQuestion() && viewModel.seconds > 0 {
            labelTimer.text = "\(viewModel.oneQuestionTime())"
            animationCircleTimeReset()
        } else if viewModel.isOneQuestion() && viewModel.seconds == 0 {
            labelTimer.text = "\(viewModel.oneQuestionTime())"
            circular(strokeEnd: 0)
            animationCircleTimeReset()
        }
    }
    
    private func resetColorButton(buttons: UIButton...) {
        let white = UIColor.white
        let blue = UIColor.blueBlackSea
        buttons.forEach { button in
            viewModel.setButtonColor(button, white, blue)
        }
    }
    // MARK: - Run next question
    @objc private func hideSubviews() {
        viewModel.timer.invalidate()
        viewModel.answerSelect.toggle()
        animationSubviews(duration: 0.25)
        viewModel.timer = runTimer(time: 0.25, action: #selector(nextQuestion), repeats: false)
    }
    
    @objc private func nextQuestion() {
        viewModel.timer.invalidate()
        viewModel.setNextCurrentQuestion(1)
        
        runMoveSubviews()
        updateData()
        viewModel.animationShowQuizHideDescription(labelQuiz, labelDescription)
        resetColorButton(buttons: buttonFirst, buttonSecond, buttonThird, buttonFourth)
        startGame()
    }
}
// MARK: - Touch on the screen
extension QuizOfFlagsViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if viewModel.answerSelect {
            if viewModel.currentQuestion + 1 < viewModel.countQuestions {
                hideSubviews()
            } else {
                let resultsVC = ResultsViewController()
                resultsVC.correctAnswers = viewModel.correctAnswers
                resultsVC.incorrectAnswers = viewModel.incorrectAnswers
                resultsVC.mode = viewModel.setting
                resultsVC.game = viewModel.games
                resultsVC.spendTime = viewModel.spendTime
                resultsVC.delegateQuizOfFlag = self
                navigationController?.pushViewController(resultsVC, animated: true)
            }
        }
    }
}
// MARK: - Setup button
extension QuizOfFlagsViewController {
    private func setButton(title: String, tag: Int) -> UIButton {
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
        button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        return button
    }
    
    private func setButton(addImage: UIView, tag: Int) -> UIButton {
        let button = Button(type: .custom)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.isEnabled = false
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        viewModel.setSubviews(subviews: addImage, on: button)
        return button
    }
}
// MARK: - Setup label
extension QuizOfFlagsViewController {
    private func setLabel(title: String, size: CGFloat, opacity: Float? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.layer.opacity = opacity ?? 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup stack views
extension QuizOfFlagsViewController {
    private func setStackView(buttonFirst: UIButton, buttonSecond: UIButton) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [buttonFirst, buttonSecond])
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Setup circle timer
extension QuizOfFlagsViewController {
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
    
    private func checkSetCircularStrokeEnd() {
        if viewModel.isOneQuestion() && viewModel.isCountdown() {
            shapeLayer.strokeEnd = 1
        } else if !viewModel.isOneQuestion() && viewModel.isCountdown() && viewModel.currentQuestion < 1 {
            shapeLayer.strokeEnd = 1
        }
    }
    
    private func animationCircleCountdown() {
        let timer = checkCircleCountdown()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 0
        animation.duration = CFTimeInterval(timer)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
    
    private func animationCircleTimeReset() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = CFTimeInterval(0.4)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
    
    private func stopAnimationCircleTimer() {
        let oneQuestionTime = viewModel.time() * 10
        let time = CGFloat(viewModel.seconds) / CGFloat(oneQuestionTime)
        let result = round(100 * time) / 100
        shapeLayer.removeAnimation(forKey: "animation")
        shapeLayer.strokeEnd = result
    }
}
// MARK: - Setup images
extension QuizOfFlagsViewController {
    private func setImage(image: String, radius: CGFloat? = nil) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: image)
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = radius ?? 0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
// MARK: - Setup constraints
extension QuizOfFlagsViewController {
    private func setupConstraints() {
        if viewModel.isCountdown() {
            constraintsTimer()
        }
        setupSquare(subview: buttonback, sizes: 40)
        
        if viewModel.isFlag() {
            constraintsFlag()
            progressView(layout: imageFlag.bottomAnchor, constant: 30)
        } else {
            constraintsLabel()
            progressView(layout: view.safeAreaLayoutGuide.topAnchor, constant: 140)
        }
        
        NSLayoutConstraint.activate([
            labelNumberQuiz.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            labelNumberQuiz.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 20),
            labelNumberQuiz.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelNumberQuiz.widthAnchor.constraint(equalToConstant: 85)
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
        
        viewModel.isFlag() ?
        buttons(subview: stackViewFlag, width: viewModel.widthButtons(view), height: 215) :
        buttons(subview: stackViewLabel, width: viewModel.widthButtons(view), height: viewModel.heightStackView)
    }
    
    private func constraintsTimer() {
        NSLayoutConstraint.activate([
            labelTimer.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            labelTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func constraintsFlag() {
        let flag = viewModel.data.questions[viewModel.currentQuestion].flag
        widthOfFlagFirst = imageFlag.widthAnchor.constraint(equalToConstant: viewModel.checkWidthFlag(flag))
        
        imageFlagSpring = NSLayoutConstraint(
            item: imageFlag, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(imageFlagSpring)
        NSLayoutConstraint.activate([
            imageFlag.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            widthOfFlagFirst,
            imageFlag.heightAnchor.constraint(equalToConstant: 168)
        ])
    }
    
    private func constraintsLabel() {
        labelNameSpring = NSLayoutConstraint(
            item: labelCountry, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(labelNameSpring)
        NSLayoutConstraint.activate([
            labelCountry.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            labelCountry.widthAnchor.constraint(equalToConstant: viewModel.widthButtons(view))
        ])
    }
    
    private func progressView(layout: NSLayoutYAxisAnchor, constant: CGFloat) {
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: layout, constant: constant),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.heightAnchor.constraint(equalToConstant: viewModel.radius * 2)
        ])
    }
    
    private func setupSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    private func buttons(subview: UIView, width: CGFloat, height: CGFloat) {
        stackViewSpring = NSLayoutConstraint(
            item: subview, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(stackViewSpring)
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: labelQuiz.bottomAnchor, constant: 25),
            subview.widthAnchor.constraint(equalToConstant: width),
            subview.heightAnchor.constraint(equalToConstant: height)
        ])
        guard !viewModel.isFlag() else { return }
        setupImagesButtons()
    }
    
    private func setupImagesButtons() {
        setupImageButtonFirst(image: imageFirst, on: buttonFirst,
                              flag: viewModel.data.buttonFirst[viewModel.currentQuestion].flag)
        setupImageButtonSecond(image: imageSecond, on: buttonSecond,
                               flag: viewModel.data.buttonSecond[viewModel.currentQuestion].flag)
        setupImageButtonThird(image: imageThird, on: buttonThird,
                              flag: viewModel.data.buttonThird[viewModel.currentQuestion].flag)
        setupImageButtonFourth(image: imageFourth, on: buttonFourth,
                               flag: viewModel.data.buttonFourth[viewModel.currentQuestion].flag)
    }
    
    private func setupImageButtonFirst(image: UIImageView, on button: UIButton, flag: String) {
        widthOfFlagFirst = image.widthAnchor.constraint(
            equalToConstant: viewModel.widthFlag(flag, view))
        setImageOnButton(layout: widthOfFlagFirst, image: image, button: button)
    }
    
    private func setupImageButtonSecond(image: UIImageView, on button: UIView, flag: String) {
        widthOfFlagSecond = image.widthAnchor.constraint(
            equalToConstant: viewModel.widthFlag(flag, view))
        setImageOnButton(layout: widthOfFlagSecond, image: image, button: button)
    }
    
    private func setupImageButtonThird(image: UIImageView, on button: UIView, flag: String) {
        widthOfFlagThird = image.widthAnchor.constraint(
            equalToConstant: viewModel.widthFlag(flag, view))
        setImageOnButton(layout: widthOfFlagThird, image: image, button: button)
    }
    
    private func setupImageButtonFourth(image: UIImageView, on button: UIView, flag: String) {
        widthOfFlagFourth = image.widthAnchor.constraint(
            equalToConstant: viewModel.widthFlag(flag, view))
        setImageOnButton(layout: widthOfFlagFourth, image: image, button: button)
    }
    
    private func setImageOnButton(layout: NSLayoutConstraint, image: UIImageView, button: UIView) {
        NSLayoutConstraint.activate([
            layout,
            image.heightAnchor.constraint(equalToConstant: viewModel.setHeight()),
            image.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
    }
}
// MARK: - QuizOfFlagsViewControllerInput
extension QuizOfFlagsViewController: QuizOfFlagsViewControllerInput {
    func dataToQuizOfFlag(setting: Setting) {
        delegateInput.dataToGameType(setting: setting)
    }
}
