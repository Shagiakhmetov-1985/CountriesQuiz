//
//  DetailsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 04.10.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    private lazy var buttonBack: UIButton = {
        let button = setupButton(
            image: "arrow.left",
            action: #selector(backToIncorrectAnswers))
        return button
    }()
    
    private lazy var imageFlag: UIImageView = {
        let imageView = setupImage(image: result.question.flag)
        return imageView
    }()
    
    private lazy var labelCountry: UILabel = {
        let labelCountry = setupLabel(
            title: result.question.name,
            size: 32,
            color: .white)
        return labelCountry
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = setupProgressView(progress: setProgress())
        return progressView
    }()
    
    private lazy var labelNumberQuiz: UILabel = {
        let label = setupLabel(
            title: setNumberQuestion(),
            size: 23,
            color: .white)
        return label
    }()
    
    private lazy var viewFirst: UIView = {
        switch game.gameType {
        case .quizOfFlag: checkFlag() ? setupView(
            color: setBackgroundColor(
                question: result.question,
                answer: result.buttonFirst,
                tag: 1,
                select: result.tag),
            label: labelFirst) : setupView(
                color: setBackgroundColor(
                    question: result.question,
                    answer: result.buttonFirst,
                    tag: 1,
                    select: result.tag),
                image: imageFirst)
        default: checkFlag() ? setupView(
            checkmark: checkmarkFirst,
            color: setButtonColor(
                question: result.question,
                answer: result.buttonFirst,
                tag: 1,
                select: result.tag),
            label: labelFirst) : setupView(
                checkmark: checkmarkFirst,
                color: setButtonColor(
                    question: result.question,
                    answer: result.buttonFirst,
                    tag: 1,
                    select: result.tag),
                flag: imageFirst)
        }
    }()
    
    private lazy var labelFirst: UILabel = {
        let label = setupLabel(
            title: result.buttonFirst.name,
            size: 23,
            color: checkGameType(
                question: result.question,
                answer: result.buttonFirst,
                tag: 1,
                select: result.tag))
        return label
    }()
    
    private lazy var imageFirst: UIImageView = {
        let imageView = setupImage(
            image: result.buttonFirst.flag,
            radius: 8)
        return imageView
    }()
    
    private lazy var checkmarkFirst: UIImageView = {
        let checkmark = setupCheckmark(
            image: setCheckmark(
                question: result.question,
                answer: result.buttonFirst,
                tag: 1,
                select: result.tag),
            color: setColor(
                question: result.question,
                answer: result.buttonFirst,
                tag: 1,
                select: result.tag))
        return checkmark
    }()
    
    private lazy var viewSecond: UIView = {
        switch game.gameType {
        case .quizOfFlag: checkFlag() ? setupView(
            color: setBackgroundColor(
                question: result.question,
                answer: result.buttonSecond,
                tag: 2,
                select: result.tag),
            label: labelSecond) : setupView(
                color: setBackgroundColor(
                    question: result.question,
                    answer: result.buttonSecond,
                    tag: 2,
                    select: result.tag),
                image: imageSecond)
        default: checkFlag() ? setupView(
            checkmark: checkmarkSecond,
            color: setButtonColor(
                question: result.question,
                answer: result.buttonSecond,
                tag: 2,
                select: result.tag),
            label: labelSecond) : setupView(
                checkmark: checkmarkSecond,
                color: setButtonColor(
                    question: result.question,
                    answer: result.buttonSecond,
                    tag: 2,
                    select: result.tag),
                flag: imageSecond)
        }
    }()
    
    private lazy var labelSecond: UILabel = {
        let label = setupLabel(
            title: result.buttonSecond.name,
            size: 23,
            color: checkGameType(
                question: result.question,
                answer: result.buttonSecond,
                tag: 2,
                select: result.tag))
        return label
    }()
    
    private lazy var checkmarkSecond: UIImageView = {
        let checkmark = setupCheckmark(
            image: setCheckmark(
                question: result.question,
                answer: result.buttonSecond,
                tag: 2,
                select: result.tag),
            color: setColor(
                question: result.question,
                answer: result.buttonSecond,
                tag: 2,
                select: result.tag))
        return checkmark
    }()
    
    private lazy var imageSecond: UIImageView = {
        let imageView = setupImage(
            image: result.buttonSecond.flag,
            radius: 8)
        return imageView
    }()
    
    private lazy var viewThird: UIView = {
        switch game.gameType {
        case .quizOfFlag: checkFlag() ? setupView(
            color: setBackgroundColor(
                question: result.question,
                answer: result.buttonThird,
                tag: 3,
                select: result.tag),
            label: labelThird) : setupView(
                color: setBackgroundColor(
                    question: result.question,
                    answer: result.buttonThird,
                    tag: 3,
                    select: result.tag),
                image: imageThird)
        default: checkFlag() ? setupView(
            checkmark: checkmarkThird,
            color: setButtonColor(
                question: result.question,
                answer: result.buttonThird,
                tag: 3,
                select: result.tag),
            label: labelThird) : setupView(
                checkmark: checkmarkThird,
                color: setButtonColor(
                    question: result.question,
                    answer: result.buttonThird,
                    tag: 3,
                    select: result.tag),
                flag: imageThird)
        }
    }()
    
    private lazy var labelThird: UILabel = {
        let label = setupLabel(
            title: result.buttonThird.name,
            size: 23,
            color: checkGameType(
                question: result.question,
                answer: result.buttonThird,
                tag: 3,
                select: result.tag))
        return label
    }()
    
    private lazy var imageThird: UIImageView = {
        let imageView = setupImage(
            image: result.buttonThird.flag,
            radius: 8)
        return imageView
    }()
    
    private lazy var checkmarkThird: UIImageView = {
        let checkmark = setupCheckmark(
            image: setCheckmark(
                question: result.question,
                answer: result.buttonThird,
                tag: 3,
                select: result.tag),
            color: setColor(
                question: result.question,
                answer: result.buttonThird,
                tag: 3,
                select: result.tag))
        return checkmark
    }()
    
    private lazy var viewFourth: UIView = {
        switch game.gameType {
        case .quizOfFlag: checkFlag() ? setupView(
            color: setBackgroundColor(
                question: result.question,
                answer: result.buttonFourth,
                tag: 4,
                select: result.tag),
            label: labelFourth) : setupView(
                color: setBackgroundColor(
                    question: result.question,
                    answer: result.buttonFourth,
                    tag: 4,
                    select: result.tag),
                image: imageFourth)
        default: checkFlag() ? setupView(
            checkmark: checkmarkFourth,
            color: setButtonColor(
                question: result.question,
                answer: result.buttonFourth,
                tag: 4,
                select: result.tag),
            label: labelFourth) : setupView(
                checkmark: checkmarkFourth,
                color: setButtonColor(
                    question: result.question,
                    answer: result.buttonFourth,
                    tag: 4,
                    select: result.tag),
                flag: imageFourth)
        }
    }()
    
    private lazy var labelFourth: UILabel = {
        let label = setupLabel(
            title: result.buttonFourth.name,
            size: 23,
            color: checkGameType(
                question: result.question,
                answer: result.buttonFourth,
                tag: 4,
                select: result.tag))
        return label
    }()
    
    private lazy var imageFourth: UIImageView = {
        let imageView = setupImage(
            image: result.buttonFourth.flag,
            radius: 8)
        return imageView
    }()
    
    private lazy var checkmarkFourth: UIImageView = {
        let checkmark = setupCheckmark(
            image: setCheckmark(
                question: result.question,
                answer: result.buttonFourth,
                tag: 4,
                select: result.tag),
            color: setColor(
                question: result.question,
                answer: result.buttonFourth,
                tag: 4,
                select: result.tag))
        return checkmark
    }()
    
    private lazy var stackViewFlag: UIStackView = {
        let stackView = setupStackView(
            viewFirst: viewFirst,
            viewSecond: viewSecond,
            viewThird: viewThird,
            viewFourth: viewFourth)
        return stackView
    }()
    
    private lazy var stackViewFirst: UIStackView = {
        let stackView = setupStackView(
            viewFirst: viewFirst,
            viewSecond: viewSecond)
        return stackView
    }()
    
    private lazy var stackViewSecond: UIStackView = {
        let stackView = setupStackView(
            viewFirst: viewThird,
            viewSecond: viewFourth)
        return stackView
    }()
    
    private lazy var stackViewLabel: UIStackView = {
        let stackView = setupStackView(
            stackViewFirst: stackViewFirst,
            stackViewSecond: stackViewSecond)
        return stackView
    }()
    
    var mode: Setting!
    var game: Games!
    var result: Results!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupBarButton()
        setupSubviews()
        setupConstraints()
    }
    
    private func setupDesign() {
        view.backgroundColor = game.background
        navigationItem.hidesBackButton = true
    }
    
    private func setupBarButton() {
        let barButton = UIBarButtonItem(customView: buttonBack)
        navigationItem.leftBarButtonItem = barButton
    }
    
    private func setupSubviews() {
        checkFlag() ? setupSubviewsFlag() : setupSubviewsLabel()
    }
    
    private func setupSubviewsFlag() {
        setupSubviews(subviews: imageFlag, progressView, labelNumberQuiz,
                      stackViewFlag, on: view)
    }
    
    private func setupSubviewsLabel() {
        setupSubviews(subviews: labelCountry, progressView, labelNumberQuiz,
                      stackViewLabel, on: view)
    }
    
    private func setupSubviews(subviews: UIView..., on otherSubview: UIView) {
        subviews.forEach { subview in
            otherSubview.addSubview(subview)
        }
    }
    
    private func checkFlag() -> Bool {
        mode.flag ? true : false
    }
    
    private func checkGameType(question: Countries, answer: Countries,
                               tag: Int, select: Int) -> UIColor {
        switch game.gameType {
        case .quizOfFlag:
            setTitleColor(question: question, answer: answer, tag: tag, select: select)
        default:
            setColor(question: question, answer: answer, tag: tag, select: select)
        }
    }
    // MARK: - Set progress view and number of question
    private func setProgress() -> Float {
        Float(result.currentQuestion) / Float(mode.countQuestions)
    }
    
    private func setNumberQuestion() -> String {
        "\(result.currentQuestion) / \(mode.countQuestions)"
    }
    // MARK: - Set colors for buttons and titles, game type quiz of flags
    private func setBackgroundColor(question: Countries, answer: Countries,
                                    tag: Int, select: Int) -> UIColor {
        switch true {
        case question == answer && (tag == select || !(tag == select)):
            return .greenYellowBrilliant
        case !(question == answer) && tag == select:
            return .redTangerineTango
        default:
            return mode.flag ? .white.withAlphaComponent(0.9) : .skyGrayLight
        }
    }
    
    private func setTitleColor(question: Countries, answer: Countries,
                               tag: Int, select: Int) -> UIColor {
        switch true {
        case question == answer || tag == select:
            return .white
        default:
            return .grayLight
        }
    }
    // MARK: - Set colors for buttons, titles and checkmarks, game type questionnaire
    private func setButtonColor(question: Countries, answer: Countries,
                                tag: Int, select: Int) -> UIColor {
        switch true {
        case question == answer || tag == select:
            return .white
        default:
            return .clear
        }
    }
    
    private func setColor(question: Countries, answer: Countries,
                          tag: Int, select: Int) -> UIColor {
        switch true {
        case question == answer && (tag == select || !(tag == select)):
            return .greenHarlequin
        case !(question == answer) && tag == select:
            return .redTangerineTango
        default:
            return .white
        }
    }
    // MARK: - Set checkmarks
    private func setCheckmark(question: Countries, answer: Countries,
                              tag: Int, select: Int) -> String {
        switch true {
        case question == answer && (tag == select || !(tag == select)):
            return "checkmark.circle.fill"
        case !(question == answer) && tag == select:
            return "xmark.circle.fill"
        default:
            return "circle"
        }
    }
    
    @objc private func backToIncorrectAnswers() {
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - Setup button
extension DetailsViewController {
    private func setupButton(image: String, action: Selector) -> UIButton {
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
}
// MARK: - Setup image
extension DetailsViewController {
    private func setupImage(image: String, radius: CGFloat? = nil) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: image)
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = radius ?? 0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func setupCheckmark(image: String, color: UIColor) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
// MARK: - Setup label
extension DetailsViewController {
    private func setupLabel(title: String, size: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = color
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup progress view
extension DetailsViewController {
    private func setupProgressView(progress: Float) -> UIProgressView {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = radius()
        progressView.clipsToBounds = true
        progressView.progressTintColor = .white
        progressView.trackTintColor = .white.withAlphaComponent(0.3)
        progressView.progress = progress
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }
}
// MARK: - Setup view
extension DetailsViewController {
    private func setupView(color: UIColor, label: UILabel) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 12
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.translatesAutoresizingMaskIntoConstraints = false
        setupSubviews(subviews: label, on: view)
        return view
    }
    
    private func setupView(color: UIColor, image: UIImageView) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 12
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.translatesAutoresizingMaskIntoConstraints = false
        setupSubviews(subviews: image, on: view)
        return view
    }
    
    private func setupView(checkmark: UIImageView, color: UIColor,
                           label: UILabel) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        setupSubviews(subviews: checkmark, label, on: view)
        return view
    }
    
    private func setupView(checkmark: UIImageView, color: UIColor, 
                           flag: UIImageView) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        setupSubviews(subviews: checkmark, flag, on: view)
        return view
    }
}
// MARK: - Setup stack views
extension DetailsViewController {
    private func setupStackView(viewFirst: UIView, viewSecond: UIView,
                                viewThird: UIView, viewFourth: UIView) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [viewFirst, viewSecond, viewThird, viewFourth])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setupStackView(viewFirst: UIView, viewSecond: UIView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [viewFirst, viewSecond])
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setupStackView(stackViewFirst: UIStackView,
                                stackViewSecond: UIStackView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [stackViewFirst, stackViewSecond])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Setup constraints
extension DetailsViewController {
    private func setupConstraints() {
        setupSquare(subview: buttonBack, sizes: 40)
        
        checkFlag() ? constraintsFlag() : constraintsLabel()
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: layoutYAxisAnchor(), constant: 30),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.heightAnchor.constraint(equalToConstant: radius() * 2)
        ])
        
        NSLayoutConstraint.activate([
            labelNumberQuiz.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            labelNumberQuiz.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 20),
            labelNumberQuiz.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelNumberQuiz.widthAnchor.constraint(equalToConstant: 85)
        ])
        
        checkFlag() ? constraintsStackViewFlag() : constraintsStackViewLabel()
    }
    
    private func constraintsFlag() {
        let flag = result.question.flag
        NSLayoutConstraint.activate([
            imageFlag.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            imageFlag.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageFlag.widthAnchor.constraint(equalToConstant: checkWidthFlag(flag: flag)),
            imageFlag.heightAnchor.constraint(equalToConstant: 168)
        ])
    }
    
    private func constraintsLabel() {
        NSLayoutConstraint.activate([
            labelCountry.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            labelCountry.widthAnchor.constraint(equalToConstant: setupConstraintWidth())
        ])
    }
    
    private func layoutYAxisAnchor() -> NSLayoutYAxisAnchor {
        checkFlag() ? imageFlag.bottomAnchor : labelCountry.bottomAnchor
    }
    
    private func constraintsStackViewFlag() {
        NSLayoutConstraint.activate([
            stackViewFlag.topAnchor.constraint(equalTo: labelNumberQuiz.bottomAnchor, constant: 25),
            stackViewFlag.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackViewFlag.widthAnchor.constraint(equalToConstant: setupConstraintFlag()),
            stackViewFlag.heightAnchor.constraint(equalToConstant: 215)
        ])
        constraintsOnViewFlag()
    }
    
    private func constraintsOnViewFlag() {
        switch game.gameType {
        case .quizOfFlag:
            setupLabel(label: labelFirst, on: viewFirst)
            setupLabel(label: labelSecond, on: viewSecond)
            setupLabel(label: labelThird, on: viewThird)
            setupLabel(label: labelFourth, on: viewFourth)
        default:
            constraintsOnView(checkmark: checkmarkFirst, title: labelFirst, on: viewFirst)
            constraintsOnView(checkmark: checkmarkSecond, title: labelSecond, on: viewSecond)
            constraintsOnView(checkmark: checkmarkThird, title: labelThird, on: viewThird)
            constraintsOnView(checkmark: checkmarkFourth, title: labelFourth, on: viewFourth)
        }
    }
    
    private func constraintsStackViewLabel() {
        NSLayoutConstraint.activate([
            stackViewLabel.topAnchor.constraint(equalTo: labelNumberQuiz.bottomAnchor, constant: 25),
            stackViewLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackViewLabel.widthAnchor.constraint(equalToConstant: setupConstraintWidth()),
            stackViewLabel.heightAnchor.constraint(equalToConstant: heightStackView())
        ])
        constraintsOnViewLabel()
    }
    
    private func constraintsOnViewLabel() {
        switch game.gameType {
        case .quizOfFlag:
            setImageOnButton(image: imageFirst, button: viewFirst, flag: result.buttonFirst.flag)
            setImageOnButton(image: imageSecond, button: viewSecond, flag: result.buttonSecond.flag)
            setImageOnButton(image: imageThird, button: viewThird, flag: result.buttonThird.flag)
            setImageOnButton(image: imageFourth, button: viewFourth, flag: result.buttonFourth.flag)
        default:
            setImageOnButton(checkmark: checkmarkFirst, image: imageFirst,
                             button: viewFirst, flag: result.buttonFirst.flag)
            setImageOnButton(checkmark: checkmarkSecond, image: imageSecond,
                             button: viewSecond, flag: result.buttonSecond.flag)
            setImageOnButton(checkmark: checkmarkThird, image: imageThird,
                             button: viewThird, flag: result.buttonThird.flag)
            setImageOnButton(checkmark: checkmarkFourth, image: imageFourth,
                             button: viewFourth, flag: result.buttonFourth.flag)
        }
    }
    
    private func setImageOnButton(checkmark: UIImageView? = nil, image: UIImageView,
                                  button: UIView, flag: String) {
        let layout = image.widthAnchor.constraint(equalToConstant: widthFlag(flag: flag))
        if let checkmark = checkmark {
            setImageOnButton(layout: layout, checkmark: checkmark, image: image, button: button)
        } else {
            setImageOnButton(layout: layout, image: image, button: button)
        }
    }
    
    private func setupSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    private func setupLabel(label: UILabel, on button: UIView) {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
    }
    
    private func constraintsOnView(checkmark: UIImageView, title: UILabel,
                                   on view: UIView) {
        NSLayoutConstraint.activate([
            checkmark.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            checkmark.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: checkmark.trailingAnchor, constant: 10),
            title.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            title.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        setupSquare(subview: checkmark, sizes: 30)
    }
    
    private func setImageOnButton(layout: NSLayoutConstraint, image: UIImageView,
                                  button: UIView) {
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            layout,
            image.heightAnchor.constraint(equalToConstant: setHeight())
        ])
    }
    
    private func setImageOnButton(layout: NSLayoutConstraint, checkmark: UIImageView, 
                                  image: UIImageView, button: UIView) {
        NSLayoutConstraint.activate([
            checkmark.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            checkmark.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 5),
            layout,
            image.heightAnchor.constraint(equalToConstant: setHeight()),
            image.centerXAnchor.constraint(equalTo: button.centerXAnchor, constant: setWidthAndCenterFlag().1),
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        setupSquare(subview: checkmark, sizes: 30)
    }
    
    private func checkWidthFlag(flag: String) -> CGFloat {
        switch flag {
        case "nepal", "vatican city", "switzerland": return 168
        default: return 280
        }
    }
    
    private func radius() -> CGFloat {
        6
    }
    
    private func setupConstraintFlag() -> CGFloat {
        view.bounds.width - 40
    }
    
    private func setupConstraintWidth() -> CGFloat {
        view.bounds.width - 20
    }
    
    private func heightStackView() -> CGFloat {
        235
    }
    
    private func setHeight() -> CGFloat {
        let buttonHeight = heightStackView() / 2 - 4
        return buttonHeight - 10
    }
    
    private func widthFlag(flag: String) -> CGFloat {
        switch flag {
        case "nepal", "vatican city", "switzerland": return setHeight()
        default: return setWidthAndCenterFlag().0
        }
    }
    
    private func setWidthAndCenterFlag() -> (CGFloat, CGFloat) {
        let buttonWidth = ((view.frame.width - 20) / 2) - 4
        let flagWidth = buttonWidth - 45
        let centerFlag = flagWidth / 2 + 5
        let constant = buttonWidth / 2 - centerFlag
        return (flagWidth, constant)
    }
}
