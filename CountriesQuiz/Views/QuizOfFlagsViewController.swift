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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupDesign()
        setupSubviews()
        setupConstraints()
        setupBarButton()
        viewModel.runMoveSubviews(view)
        startGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard viewModel.isCountdown() else { return }
        viewModel.setCircleTimer(labelTimer, view)
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
    // MARK: - Start game
    private func startGame() {
        let time: CGFloat = viewModel.currentQuestion == 0 ? 1 : 0.25
        viewModel.timer = runTimer(time: time, action: #selector(showSubviews), repeats: false)
    }
    
    @objc private func showSubviews() {
        viewModel.timer.invalidate()
        let time: CGFloat = viewModel.currentQuestion == 0 ? 0.5 : 0.25
        viewModel.animationShowQuizHideDescription(labelQuiz, labelDescription)
        viewModel.animationSubviews(time, view)
        viewModel.checkSetCircularStrokeEnd()
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
        viewModel.animationCircleCountdown()
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
        viewModel.showDescription(labelQuiz, labelDescription)
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
        viewModel.showDescription(labelQuiz, labelDescription)
        
        guard viewModel.isCountdown() else { return }
        viewModel.stopAnimationCircleTimer()
        viewModel.checkTimeSpent(viewModel.shapeLayer)
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
            viewModel.disableButtonLabel(button.tag, buttonFirst, buttonSecond, buttonThird, buttonFourth) {
                self.delay()
            }
        }
    }
    
    private func delay() {
        guard viewModel.currentQuestion + 1 < viewModel.countQuestions else { return }
        viewModel.timer = runTimer(time: 3, action: #selector(hideSubviews), repeats: false)
    }
    // MARK: - Run next question
    @objc private func hideSubviews() {
        viewModel.timer.invalidate()
        viewModel.answerSelect.toggle()
        viewModel.animationSubviews(0.25, view)
        viewModel.timer = runTimer(time: 0.25, action: #selector(nextQuestion), repeats: false)
    }
    
    @objc private func nextQuestion() {
        viewModel.timer.invalidate()
        viewModel.setNextCurrentQuestion(1)
        
        viewModel.runMoveSubviews(view)
        updateData()
        viewModel.animationShowQuizHideDescription(labelQuiz, labelDescription)
        viewModel.resetColorButtons(buttonFirst, buttonSecond, buttonThird, buttonFourth)
        startGame()
    }
    // MARK: - Refresh data for next question
    private func updateData() {
        if viewModel.isFlag() {
            viewModel.updateDataFlag(imageFlag, viewModel.widthOfFlagFirst, buttonFirst,
                                     buttonSecond, buttonThird, buttonFourth)
        } else {
            viewModel.updateDataLabel(labelCountry, view,
                                      imageFirst, imageSecond, imageThird, imageFourth,
                                      and: viewModel.widthOfFlagFirst, viewModel.widthOfFlagSecond,
                                      viewModel.widthOfFlagThird, viewModel.widthOfFlagFourth)
        }
        guard viewModel.isCountdown() else { return }
        viewModel.resetTimer(labelTimer, view)
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
                let resultsViewModel = viewModel.resultsViewController()
                let resultsVC = ResultsViewController()
                resultsVC.viewModel = resultsViewModel
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
        
        let stackView = viewModel.isFlag() ? stackViewFlag : stackViewLabel
        let height = viewModel.isFlag() ? 215 : viewModel.heightStackView
        buttons(subview: stackView, width: viewModel.widthButtons(view), height: height)
    }
    
    private func constraintsTimer() {
        NSLayoutConstraint.activate([
            labelTimer.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            labelTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func constraintsFlag() {
        let flag = viewModel.data.questions[viewModel.currentQuestion].flag
        viewModel.widthOfFlagFirst = imageFlag.widthAnchor.constraint(equalToConstant: viewModel.checkWidthFlag(flag))
        
        viewModel.imageFlagSpring = NSLayoutConstraint(
            item: imageFlag, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(viewModel.imageFlagSpring)
        NSLayoutConstraint.activate([
            imageFlag.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            viewModel.widthOfFlagFirst,
            imageFlag.heightAnchor.constraint(equalToConstant: 168)
        ])
    }
    
    private func constraintsLabel() {
        viewModel.labelNameSpring = NSLayoutConstraint(
            item: labelCountry, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(viewModel.labelNameSpring)
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
        viewModel.stackViewSpring = NSLayoutConstraint(
            item: subview, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(viewModel.stackViewSpring)
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
        viewModel.widthOfFlagFirst = image.widthAnchor.constraint(
            equalToConstant: viewModel.widthFlag(flag, view))
        setImageOnButton(layout: viewModel.widthOfFlagFirst, image: image, button: button)
    }
    
    private func setupImageButtonSecond(image: UIImageView, on button: UIView, flag: String) {
        viewModel.widthOfFlagSecond = image.widthAnchor.constraint(
            equalToConstant: viewModel.widthFlag(flag, view))
        setImageOnButton(layout: viewModel.widthOfFlagSecond, image: image, button: button)
    }
    
    private func setupImageButtonThird(image: UIImageView, on button: UIView, flag: String) {
        viewModel.widthOfFlagThird = image.widthAnchor.constraint(
            equalToConstant: viewModel.widthFlag(flag, view))
        setImageOnButton(layout: viewModel.widthOfFlagThird, image: image, button: button)
    }
    
    private func setupImageButtonFourth(image: UIImageView, on button: UIView, flag: String) {
        viewModel.widthOfFlagFourth = image.widthAnchor.constraint(
            equalToConstant: viewModel.widthFlag(flag, view))
        setImageOnButton(layout: viewModel.widthOfFlagFourth, image: image, button: button)
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
