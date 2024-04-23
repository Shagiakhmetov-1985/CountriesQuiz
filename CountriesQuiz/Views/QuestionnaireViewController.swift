//
//  QuestionnaireViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 29.08.2023.
//

import UIKit

protocol QuestionnaireViewControllerInput: AnyObject {
    func dataToQuestionnaire(setting: Setting)
}

class QuestionnaireViewController: UIViewController {
    private lazy var buttonExit: UIButton = {
        setButton(image: "multiply", action: #selector(exitToGameType))
    }()
    
    private lazy var labelTimer: UILabel = {
        setupLabel(title: "\(viewModel.time)", size: 35)
    }()
    
    private lazy var imageFlag: UIImageView = {
        setupImage(image: viewModel.image)
    }()
    
    private lazy var labelCountry: UILabel = {
        setupLabel(title: viewModel.name, size: 32)
    }()
    
    private lazy var buttonBack: UIButton = {
        setButton(image: "chevron.left", action: #selector(back), isEnabled: false, opacity: 0)
    }()
    
    private lazy var buttonForward: UIButton = {
        setButton(image: "chevron.right", action: #selector(forward), isEnabled: false, opacity: 0)
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
    
    private lazy var labelNumber: UILabel = {
        setupLabel(title: "0 / \(viewModel.countQuestions)", size: 23)
    }()
    
    private lazy var labelQuiz: UILabel = {
        setupLabel(title: "Выберите правильные ответы", size: 23, opacity: 0)
    }()
    
    private lazy var labelDescription: UILabel = {
        setupLabel(
            title: "Коснитесь экрана, чтобы завершить",
            size: 19,
            color: .lightPurplePink,
            opacity: 0)
    }()
    
    private lazy var buttonFirst: UIButton = {
        viewModel.isFlag() ? setButton(
            checkmark: checkmarkFirst,
            label: labelFirst,
            tag: 1,
            action: #selector(buttonPress)) :
        setButton(
            checkmark: checkmarkFirst,
            flag: imageFirst,
            tag: 1,
            action: #selector(buttonPress))
    }()
    
    private lazy var checkmarkFirst: UIImageView = {
        setupCheckmark(image: "circle", tag: 1)
    }()
    
    private lazy var labelFirst: UILabel = {
        setupLabel(
            title: viewModel.buttonFirstName,
            size: 23,
            tag: 1)
    }()
    
    private lazy var imageFirst: UIImageView = {
        setupImage(image: viewModel.buttonFirstImage, radius: 8)
    }()
    
    private lazy var buttonSecond: UIButton = {
        viewModel.isFlag() ? setButton(
            checkmark: checkmarkSecond,
            label: labelSecond,
            tag: 2,
            action: #selector(buttonPress)) :
        setButton(
            checkmark: checkmarkSecond,
            flag: imageSecond,
            tag: 2,
            action: #selector(buttonPress))
    }()
    
    private lazy var checkmarkSecond: UIImageView = {
        setupCheckmark(image: "circle", tag: 2)
    }()
    
    private lazy var labelSecond: UILabel = {
        setupLabel(
            title: viewModel.buttonSecondName,
            size: 23,
            tag: 2)
    }()
    
    private lazy var imageSecond: UIImageView = {
        setupImage(image: viewModel.buttonSecondImage, radius: 8)
    }()
    
    private lazy var buttonThird: UIButton = {
        viewModel.isFlag() ? setButton(
            checkmark: checkmarkThird,
            label: labelThird,
            tag: 3,
            action: #selector(buttonPress)) :
        setButton(
            checkmark: checkmarkThird,
            flag: imageThird,
            tag: 3,
            action: #selector(buttonPress))
    }()
    
    private lazy var checkmarkThird: UIImageView = {
        setupCheckmark(image: "circle", tag: 3)
    }()
    
    private lazy var labelThird: UILabel = {
        setupLabel(
            title: viewModel.buttonThirdName,
            size: 23,
            tag: 3)
    }()
    
    private lazy var imageThird: UIImageView = {
        setupImage(image: viewModel.buttonThirdImage, radius: 8)
    }()
    
    private lazy var buttonFourth: UIButton = {
        viewModel.isFlag() ? setButton(
            checkmark: checkmarkFourth,
            label: labelFourth,
            tag: 4,
            action: #selector(buttonPress)) :
        setButton(
            checkmark: checkmarkFourth,
            flag: imageFourth,
            tag: 4,
            action: #selector(buttonPress))
    }()
    
    private lazy var checkmarkFourth: UIImageView = {
        setupCheckmark(image: "circle", tag: 4)
    }()
    
    private lazy var labelFourth: UILabel = {
        setupLabel(
            title: viewModel.buttonFourthName,
            size: 23,
            tag: 4)
    }()
    
    private lazy var imageFourth: UIImageView = {
        setupImage(image: viewModel.buttonFourthImage, radius: 8)
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
        setupStackView(buttonFirst: buttonFirst, buttonSecond: buttonSecond)
    }()
    
    private lazy var stackViewBottom: UIStackView = {
        setupStackView(buttonFirst: buttonThird, buttonSecond: buttonFourth)
    }()
    
    private lazy var stackViewLabel: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stackViewTop, stackViewBottom])
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var viewModel: QuestionnaireViewModelProtocol!
    weak var delegateInput: GameTypeViewControllerInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupDesign()
        setupBarButton()
        setupSubviews()
        setupConstraints()
        viewModel.moveSubviews(view)
        startGame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
        viewModel.setButtons(buttonFirst, buttonSecond, buttonThird, buttonFourth)
        viewModel.setCheckmarks(checkmarkFirst, checkmarkSecond, checkmarkThird, checkmarkFourth)
        viewModel.setImages(imageFirst, imageSecond, imageThird, imageFourth)
        viewModel.setLabels(labelFirst, labelSecond, labelThird, labelFourth)
    }
    
    private func setupBarButton() {
        viewModel.setBarButton(buttonExit, navigationItem)
    }
    
    private func setupSubviews() {
        if viewModel.isCountdown() {
            viewModel.isFlag() ? subviewsWithTimerFlag() : subviewsWithTimerLabel()
        } else {
            viewModel.isFlag() ? subviewsWithoutTimerFlag() : subviewsWithoutTimerLabel()
        }
    }
    
    private func subviewsWithTimerFlag() {
        viewModel.setSubviews(subviews: labelTimer, imageFlag, buttonBack,
                              buttonForward, progressView, labelNumber, labelQuiz,
                              labelDescription, stackViewFlag, on: view)
    }
    
    private func subviewsWithTimerLabel() {
        viewModel.setSubviews(subviews: labelTimer, labelCountry, buttonBack,
                              buttonForward, progressView, labelNumber, labelQuiz,
                              labelDescription, stackViewLabel, on: view)
    }
    
    private func subviewsWithoutTimerFlag() {
        viewModel.setSubviews(subviews: imageFlag, buttonBack, buttonForward,
                              progressView, labelNumber, labelQuiz, labelDescription,
                              stackViewFlag, on: view)
    }
    
    private func subviewsWithoutTimerLabel() {
        viewModel.setSubviews(subviews: labelCountry, buttonBack, buttonForward,
                              progressView, labelNumber, labelQuiz, labelDescription,
                              stackViewLabel, on: view)
    }
    
    private func runTimer(duration: CGFloat, action: Selector, repeats: Bool) -> Timer {
        Timer.scheduledTimer(timeInterval: duration, target: self,
                             selector: action, userInfo: nil, repeats: repeats)
    }
    // MARK: - Start game
    private func startGame() {
        let time = viewModel.currentQuestion > 0 ? 0.1 : 1
        viewModel.timer = runTimer(duration: time, action: #selector(showSubviews), repeats: false)
    }
    
    @objc private func showSubviews() {
        viewModel.timer.invalidate()
        viewModel.showLabelQuiz(labelQuiz, duration: 1, opacity: 1)
        let duration = viewModel.currentQuestion == 0 ? 0.5 : 0.25
        let action = viewModel.currentQuestion == 0 ? #selector(isEnabledSubviews) : #selector(nextQuestion)
        viewModel.animationSubviews(duration: duration, view)
        viewModel.timer = runTimer(duration: duration, action: action, repeats: false)
    }
    
    @objc private func isEnabledSubviews() {
        viewModel.timer.invalidate()
        viewModel.buttonsForAnswers(isOn: true)
        viewModel.updateNumberQuestion(labelNumber)
        
        viewModel.setTime()
        viewModel.runCircleTimer()
        viewModel.countdown = runTimer(duration: 0.1, action: #selector(runCountdown), repeats: true)
    }
    
    @objc private func nextQuestion() {
        viewModel.timer.invalidate()
        viewModel.buttonsBackForwardOnOff(buttonBack, buttonForward)
        viewModel.checkLastQuestionForShowTitle(labelQuiz, labelDescription)
        viewModel.checkTimeUp {
            self.timeUp()
        }
    }
    // MARK: - Run timer
    @objc private func runCountdown() {
        viewModel.setTitleTimer(labelTimer) {
            self.timeUp()
        }
    }
    
    private func timeUp() {
        viewModel.setEnabled(subviews: buttonBack, buttonForward, buttonExit, isEnabled: false)
        viewModel.buttonsForAnswers(isOn: false)
        viewModel.endGame(labelQuiz, labelDescription)
    }
    // MARK: - Business logic
    @objc private func exitToGameType() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func back() {
        viewModel.buttonsForAnswers(isOn: false)
        viewModel.setEnabled(subviews: buttonBack, buttonForward, isEnabled: false)
        viewModel.animationBackSubviews(view)
        viewModel.timer = runTimer(duration: 0.25, action: #selector(updateBackQuestion), repeats: false)
    }
    
    @objc private func forward() {
        viewModel.buttonsForAnswers(isOn: false)
        viewModel.setEnabled(subviews: buttonBack, buttonForward, isEnabled: false)
        viewModel.animationSubviews(duration: 0.25, view)
        viewModel.timer = runTimer(duration: 0.25, action: #selector(updateQuestion), repeats: false)
    }
    // MARK: - Actions for press button
    @objc private func buttonPress(button: UIButton) {
        switch button {
        case buttonFirst: action(button: buttonFirst, image: checkmarkFirst,
                                 label: viewModel.isFlag() ? labelFirst : nil)
        case buttonSecond: action(button: buttonSecond, image: checkmarkSecond,
                                  label: viewModel.isFlag() ? labelSecond : nil)
        case buttonThird: action(button: buttonThird, image: checkmarkThird,
                                 label: viewModel.isFlag() ? labelThird : nil)
        default: action(button: buttonFourth, image: checkmarkFourth,
                        label: viewModel.isFlag() ? labelFourth : nil)
        }
        setupNextQuestion()
    }
    
    private func action(button: UIButton, image: UIImageView, label: UILabel? = nil) {
        viewModel.setSelectButton(button)
        viewModel.checkCorrectAnswer(button.tag)
        viewModel.setAppearenceButtons(button, image, label)
        
        viewModel.buttonsForAnswers(isOn: false)
        viewModel.checkLastQuestion(buttonBack, buttonForward)
        
        guard viewModel.numberQuestion == viewModel.currentQuestion else { return }
        viewModel.setProgressView(progressView)
    }
    // MARK: - Run for show next question
    private func setupNextQuestion() {
        if viewModel.numberQuestion + 1 < viewModel.countQuestions {
            viewModel.timer = runTimer(duration: 0.7, action: #selector(hideQuestion), repeats: false)
        } else {
            viewModel.selectAnswerForLastQuestion(labelQuiz, labelDescription)
        }
    }
    
    @objc private func hideQuestion() {
        viewModel.timer.invalidate()
        viewModel.animationSubviews(duration: 0.25, view)
        viewModel.timer = runTimer(duration: 0.25, action: #selector(updateQuestion), repeats: false)
    }
    
    @objc private func updateQuestion() {
        viewModel.timer.invalidate()
        if viewModel.numberQuestion == viewModel.currentQuestion {
            viewModel.setCurrentQuestion(1)
            viewModel.setNumberQuestion(1)
        } else {
            viewModel.setNumberQuestion(1)
        }
        viewModel.moveSubviews(view)
        updateData()
        startGame()
    }
    // MARK: - Show prevoius question
    @objc private func updateBackQuestion() {
        viewModel.timer.invalidate()
        viewModel.setNumberQuestion(-1)
        if viewModel.lastQuestion {
            viewModel.setOpacity(subviews: labelDescription, opacity: 0, duration: 0)
            viewModel.setOpacity(subviews: labelQuiz, opacity: 1, duration: 1)
        }
        viewModel.moveBackSubviews(view)
        updateData()
        viewModel.timer = runTimer(duration: 0.1, action: #selector(showBackQuestion), repeats: false)
    }
    
    @objc private func showBackQuestion() {
        viewModel.timer.invalidate()
        viewModel.animationBackSubviews(view)
        viewModel.timer = runTimer(duration: 0.25, action: #selector(nextQuestion), repeats: false)
    }
    // MARK: - Refresh data for show next question
    private func updateData() {
        viewModel.updateDataQuestion(imageFlag, labelCountry, view)
        viewModel.updateNumberQuestion(labelNumber)
        
        viewModel.setColorButtonsDisabled(0)
        viewModel.setCheckmarksDisabled(0)
        if viewModel.isFlag() {
            viewModel.setLabelsDisabled(0)
        }
        
        viewModel.setSelectedResponse()
    }
}
// MARK: - Touches began
extension QuestionnaireViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard viewModel.lastQuestion, viewModel.numberQuestion == viewModel.currentQuestion else { return }
        viewModel.stopTimer()
        viewModel.setTimeSpent()
        resultsVC()
    }
    
    private func resultsVC() {
        let resultsViewModel = viewModel.resultsViewController()
        let resultsVC = ResultsViewController()
        resultsVC.viewModel = resultsViewModel
        resultsVC.delegateQuestionnaire = self
        navigationController?.pushViewController(resultsVC, animated: true)
    }
}
// MARK: - Setup buttons
extension QuestionnaireViewController {
    private func setButton(image: String, action: Selector, isEnabled: Bool? = nil, 
                           opacity: Float? = nil) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        button.isEnabled = isEnabled ?? true
        button.layer.opacity = opacity ?? 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setButton(checkmark: UIImageView, label: UILabel, tag: Int,
                           action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 12
        button.tag = tag
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        viewModel.setSubviews(subviews: checkmark, label, on: button)
        return button
    }
    
    private func setButton(checkmark: UIImageView, flag: UIImageView, tag: Int,
                           action: Selector) -> UIButton {
        let button = UIButton(type: .custom)
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 12
        button.tag = tag
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        viewModel.setSubviews(subviews: checkmark, flag, on: button)
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
}
// MARK: - Setup image view
extension QuestionnaireViewController {
    private func setupImage(image: String, radius: CGFloat? = nil) -> UIImageView {
        let image = UIImage(named: image)
        let imageView = UIImageView(image: image)
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = radius ?? 0
        imageView.clipsToBounds = true
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
    private func setupStackView(buttonFirst: UIButton, buttonSecond: UIButton) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [buttonFirst, buttonSecond])
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
        
        if viewModel.isCountdown() {
            constraintsTimer()
        }
        
        if viewModel.isFlag() {
            constraintsQuestionFlag()
            constraintsProgressView(layout: imageFlag.bottomAnchor, constant: 30)
        } else {
            constraintsQuestionLabel()
            constraintsProgressView(layout: view.safeAreaLayoutGuide.topAnchor,
                                    constant: 140)
        }
        
        constraintsButtons(button: buttonBack, constant: -viewModel.setConstant(view))
        constraintsButtons(button: buttonForward, constant: viewModel.setConstant(view))
        
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
        
        buttons(subview: viewModel.isFlag() ? stackViewFlag : stackViewLabel)
    }
    
    private func constraintsTimer() {
        NSLayoutConstraint.activate([
            labelTimer.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            labelTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func constraintsQuestionFlag() {
        let flag = viewModel.question.flag
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
    
    private func constraintsQuestionLabel() {
        viewModel.labelNameSpring = NSLayoutConstraint(
            item: labelCountry, attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(viewModel.labelNameSpring)
        NSLayoutConstraint.activate([
            labelCountry.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            labelCountry.widthAnchor.constraint(equalToConstant: viewModel.widthLabel(view))
        ])
    }
    
    private func constraintsProgressView(layout: NSLayoutYAxisAnchor, constant: CGFloat) {
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
    
    private func constraintsButtons(button: UIButton, constant: CGFloat) {
        let layout = layoutConstraint()
        NSLayoutConstraint.activate([
            layoutYAxisAnchor(button: button).constraint(equalTo: layout),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant)
        ])
        setupSquare(subview: button, sizes: 40)
    }
    
    private func layoutYAxisAnchor(button: UIButton) -> NSLayoutYAxisAnchor {
        viewModel.isFlag() ? button.centerYAnchor : button.topAnchor
    }
    
    private func layoutConstraint() -> NSLayoutYAxisAnchor {
        viewModel.isFlag() ? imageFlag.centerYAnchor : labelCountry.topAnchor
    }
    
    private func buttons(subview: UIStackView) {
        viewModel.stackViewSpring = NSLayoutConstraint(
            item: subview,
            attribute: .centerX, relatedBy: .equal, toItem: view,
            attribute: .centerX, multiplier: 1, constant: 0)
        view.addConstraint(viewModel.stackViewSpring)
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: labelQuiz.bottomAnchor, constant: 25),
            subview.widthAnchor.constraint(equalToConstant: view.frame.width - 20),
            subview.heightAnchor.constraint(equalToConstant: viewModel.height)
        ])
        constraintsOnButton()
    }
    
    private func constraintsOnButton() {
        if viewModel.isFlag() {
            constraintsOnButton(image: checkmarkFirst, label: labelFirst, button: buttonFirst)
            constraintsOnButton(image: checkmarkSecond, label: labelSecond, button: buttonSecond)
            constraintsOnButton(image: checkmarkThird, label: labelThird, button: buttonThird)
            constraintsOnButton(image: checkmarkFourth, label: labelFourth, button: buttonFourth)
        } else {
            imagesOnButtonFirst(checkmark: checkmarkFirst, image: imageFirst,
                                button: buttonFirst, flag: viewModel.answerFirst.flag)
            imagesOnButtonSecond(checkmark: checkmarkSecond, image: imageSecond,
                                 button: buttonSecond, flag:  viewModel.answerSecond.flag)
            imagesOnButtonThird(checkmark: checkmarkThird, image: imageThird,
                                button: buttonThird, flag: viewModel.answerThird.flag)
            imagesOnButtonFourth(checkmark: checkmarkFourth, image: imageFourth,
                                 button: buttonFourth, flag:  viewModel.answerFourth.flag)
        }
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
        setupSquare(subview: image, sizes: 30)
    }
    
    private func imagesOnButtonFirst(checkmark: UIImageView, image: UIImageView,
                                     button: UIButton, flag: String) {
        viewModel.widthOfFlagFirst = image.widthAnchor.constraint(
            equalToConstant: viewModel.widthFlag(flag, view))
        setImageOnButton(checkmark: checkmark, image: image, button: button,
                         layout: viewModel.widthOfFlagFirst)
    }
    
    private func imagesOnButtonSecond(checkmark: UIImageView, image: UIImageView,
                                      button: UIButton, flag: String) {
        viewModel.widthOfFlagSecond = image.widthAnchor.constraint(
            equalToConstant: viewModel.widthFlag(flag, view))
        setImageOnButton(checkmark: checkmark, image: image, button: button,
                         layout: viewModel.widthOfFlagSecond)
    }
    
    private func imagesOnButtonThird(checkmark: UIImageView, image: UIImageView,
                                     button: UIButton, flag: String) {
        viewModel.widthOfFlagThird = image.widthAnchor.constraint(
            equalToConstant: viewModel.widthFlag(flag, view))
        setImageOnButton(checkmark: checkmark, image: image, button: button,
                         layout: viewModel.widthOfFlagThird)
    }
    
    private func imagesOnButtonFourth(checkmark: UIImageView, image: UIImageView,
                                      button: UIButton, flag: String) {
        viewModel.widthOfFlagFourth = image.widthAnchor.constraint(
            equalToConstant: viewModel.widthFlag(flag, view))
        setImageOnButton(checkmark: checkmark, image: image, button: button,
                         layout: viewModel.widthOfFlagFourth)
    }
    
    private func setImageOnButton(checkmark: UIImageView, image: UIImageView,
                                  button: UIButton, layout: NSLayoutConstraint) {
        NSLayoutConstraint.activate([
            checkmark.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            checkmark.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 5),
            layout,
            image.heightAnchor.constraint(equalToConstant: viewModel.setHeight()),
            image.centerXAnchor.constraint(equalTo: button.centerXAnchor, constant: viewModel.setWidthAndCenterFlag(view).1),
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        setupSquare(subview: checkmark, sizes: 30)
    }
}
// MARK: - QuestionnaireViewControllerInput
extension QuestionnaireViewController: QuestionnaireViewControllerInput {
    func dataToQuestionnaire(setting: Setting) {
        delegateInput.dataToGameType(setting: setting)
    }
}
