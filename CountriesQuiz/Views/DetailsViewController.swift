//
//  DetailsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 04.10.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    private lazy var buttonBack: UIButton = {
        setupButton(image: "arrow.left", action: #selector(backToIncorrectAnswers))
    }()
    
    private lazy var imageFlag: UIImageView = {
        setupImage(image: viewModel.result.question.flag)
    }()
    
    private lazy var labelCountry: UILabel = {
        setupLabel(title: viewModel.result.question.name, size: 32, color: .white)
    }()
    
    private lazy var progressView: UIProgressView = {
        setupProgressView(progress: viewModel.progress)
    }()
    
    private lazy var labelNumberQuiz: UILabel = {
        setupLabel(title: viewModel.numberQuestion, size: 23, color: .white)
    }()
    
    private lazy var viewFirst: UIView = {
        switch viewModel.game.gameType {
        case .quizOfFlag, .quizOfCapitals: setupView(
            color: viewModel.setBackgroundColor(
                question: viewModel.result.question,
                answer: viewModel.result.buttonFirst,
                tag: 1,
                select: viewModel.result.tag),
            subview: viewModel.isFlag() ? labelFirst : imageFirst)
        default: setupView(
            checkmark: checkmarkFirst,
            color: viewModel.setButtonColor(
                question: viewModel.result.question,
                answer: viewModel.result.buttonFirst,
                tag: 1,
                select: viewModel.result.tag),
            subview: viewModel.isFlag() ? labelFirst : imageFirst)
        }
    }()
    
    private lazy var labelFirst: UILabel = {
        setupLabel(
            title: viewModel.setTitle(title: viewModel.result.buttonFirst),
            size: 23,
            color: checkGameType(
                question: viewModel.result.question,
                answer: viewModel.result.buttonFirst,
                tag: 1,
                select: viewModel.result.tag))
    }()
    
    private lazy var imageFirst: UIImageView = {
        setupImage(image: viewModel.result.buttonFirst.flag, radius: 8)
    }()
    
    private lazy var checkmarkFirst: UIImageView = {
        setupCheckmark(
            image: viewModel.setCheckmark(
                question: viewModel.result.question,
                answer: viewModel.result.buttonFirst,
                tag: 1,
                select: viewModel.result.tag),
            color: viewModel.setColor(
                question: viewModel.result.question,
                answer: viewModel.result.buttonFirst,
                tag: 1,
                select: viewModel.result.tag))
    }()
    
    private lazy var viewSecond: UIView = {
        switch viewModel.game.gameType {
        case .quizOfFlag, .quizOfCapitals: setupView(
            color: viewModel.setBackgroundColor(
                question: viewModel.result.question,
                answer: viewModel.result.buttonSecond,
                tag: 2,
                select: viewModel.result.tag),
            subview: viewModel.isFlag() ? labelSecond : imageSecond)
        default: setupView(
            checkmark: checkmarkSecond,
            color: viewModel.setButtonColor(
                question: viewModel.result.question,
                answer: viewModel.result.buttonSecond,
                tag: 2,
                select: viewModel.result.tag),
            subview: viewModel.isFlag() ? labelSecond : imageSecond)
        }
    }()
    
    private lazy var labelSecond: UILabel = {
        setupLabel(
            title: viewModel.setTitle(title: viewModel.result.buttonSecond),
            size: 23,
            color: checkGameType(
                question: viewModel.result.question,
                answer: viewModel.result.buttonSecond,
                tag: 2,
                select: viewModel.result.tag))
    }()
    
    private lazy var checkmarkSecond: UIImageView = {
        setupCheckmark(
            image: viewModel.setCheckmark(
                question: viewModel.result.question,
                answer: viewModel.result.buttonSecond,
                tag: 2,
                select: viewModel.result.tag),
            color: viewModel.setColor(
                question: viewModel.result.question,
                answer: viewModel.result.buttonSecond,
                tag: 2,
                select: viewModel.result.tag))
    }()
    
    private lazy var imageSecond: UIImageView = {
        setupImage(image: viewModel.result.buttonSecond.flag, radius: 8)
    }()
    
    private lazy var viewThird: UIView = {
        switch viewModel.game.gameType {
        case .quizOfFlag, .quizOfCapitals: setupView(
            color: viewModel.setBackgroundColor(
                question: viewModel.result.question,
                answer: viewModel.result.buttonThird,
                tag: 3,
                select: viewModel.result.tag),
            subview: viewModel.isFlag() ? labelThird : imageThird)
        default: setupView(
            checkmark: checkmarkThird,
            color: viewModel.setButtonColor(
                question: viewModel.result.question,
                answer: viewModel.result.buttonThird,
                tag: 3,
                select: viewModel.result.tag),
            subview: viewModel.isFlag() ? labelThird : imageThird)
        }
    }()
    
    private lazy var labelThird: UILabel = {
        setupLabel(
            title: viewModel.setTitle(title: viewModel.result.buttonThird),
            size: 23,
            color: checkGameType(
                question: viewModel.result.question,
                answer: viewModel.result.buttonThird,
                tag: 3,
                select: viewModel.result.tag))
    }()
    
    private lazy var imageThird: UIImageView = {
        setupImage(image: viewModel.result.buttonThird.flag, radius: 8)
    }()
    
    private lazy var checkmarkThird: UIImageView = {
        setupCheckmark(
            image: viewModel.setCheckmark(
                question: viewModel.result.question,
                answer: viewModel.result.buttonThird,
                tag: 3,
                select: viewModel.result.tag),
            color: viewModel.setColor(
                question: viewModel.result.question,
                answer: viewModel.result.buttonThird,
                tag: 3,
                select: viewModel.result.tag))
    }()
    
    private lazy var viewFourth: UIView = {
        switch viewModel.game.gameType {
        case .quizOfFlag, .quizOfCapitals: setupView(
            color: viewModel.setBackgroundColor(
                question: viewModel.result.question,
                answer: viewModel.result.buttonFourth,
                tag: 4,
                select: viewModel.result.tag),
            subview: viewModel.isFlag() ? labelFourth : imageFourth)
        default: setupView(
            checkmark: checkmarkFourth,
            color: viewModel.setButtonColor(
                question: viewModel.result.question,
                answer: viewModel.result.buttonFourth,
                tag: 4,
                select: viewModel.result.tag),
            subview: viewModel.isFlag() ? labelFourth : imageFourth)
        }
    }()
    
    private lazy var labelFourth: UILabel = {
        setupLabel(
            title: viewModel.setTitle(title: viewModel.result.buttonFourth),
            size: 23,
            color: checkGameType(
                question: viewModel.result.question,
                answer: viewModel.result.buttonFourth,
                tag: 4,
                select: viewModel.result.tag))
    }()
    
    private lazy var imageFourth: UIImageView = {
        setupImage(image: viewModel.result.buttonFourth.flag, radius: 8)
    }()
    
    private lazy var checkmarkFourth: UIImageView = {
        setupCheckmark(
            image: viewModel.setCheckmark(
                question: viewModel.result.question,
                answer: viewModel.result.buttonFourth,
                tag: 4,
                select: viewModel.result.tag),
            color: viewModel.setColor(
                question: viewModel.result.question,
                answer: viewModel.result.buttonFourth,
                tag: 4,
                select: viewModel.result.tag))
    }()
    
    private lazy var stackViewFlag: UIStackView = {
        setupStackView(
            viewFirst: viewFirst,
            viewSecond: viewSecond,
            viewThird: viewThird,
            viewFourth: viewFourth)
    }()
    
    private lazy var stackViewFirst: UIStackView = {
        setupStackView(viewFirst: viewFirst, viewSecond: viewSecond)
    }()
    
    private lazy var stackViewSecond: UIStackView = {
        setupStackView(viewFirst: viewThird, viewSecond: viewFourth)
    }()
    
    private lazy var stackViewLabel: UIStackView = {
        setupStackView(stackViewFirst: stackViewFirst, stackViewSecond: stackViewSecond)
    }()
    
    var viewModel: DetailsViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupBarButton()
        setupSubviews()
        setupConstraints()
    }
    // MARK: - General methods
    private func setupDesign() {
        view.backgroundColor = viewModel.game.background
        navigationItem.hidesBackButton = true
    }
    
    private func setupBarButton() {
        viewModel.setupBarButton(buttonBack, navigationItem)
    }
    
    private func setupSubviews() {
        viewModel.isFlag() ? setupSubviewsFlag() : setupSubviewsLabel()
    }
    
    private func setupSubviewsFlag() {
        viewModel.setupSubviews(subviews: imageFlag, progressView, labelNumberQuiz,
                                stackViewFlag, on: view)
    }
    
    private func setupSubviewsLabel() {
        viewModel.setupSubviews(subviews: labelCountry, progressView, labelNumberQuiz,
                                stackViewLabel, on: view)
    }
    
    private func checkGameType(question: Countries, answer: Countries,
                               tag: Int, select: Int) -> UIColor {
        switch viewModel.game.gameType {
        case .quizOfFlag, .quizOfCapitals:
            viewModel.setTitleColor(question: question, answer: answer, tag: tag, select: select)
        default:
            viewModel.setColor(question: question, answer: answer, tag: tag, select: select)
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
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup progress view
extension DetailsViewController {
    private func setupProgressView(progress: Float) -> UIProgressView {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = viewModel.radius
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
    private func setupView(color: UIColor, subview: UIView) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 12
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.translatesAutoresizingMaskIntoConstraints = false
        viewModel.setupSubviews(subviews: subview, on: view)
        return view
    }
    
    private func setupView(checkmark: UIImageView, color: UIColor,
                           subview: UIView) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1.5
        view.translatesAutoresizingMaskIntoConstraints = false
        viewModel.setupSubviews(subviews: checkmark, subview, on: view)
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
        
        viewModel.isFlag() ? constraintsFlag() : constraintsLabel()
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: layoutYAxisAnchor(), constant: 30),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.heightAnchor.constraint(equalToConstant: viewModel.radius * 2)
        ])
        
        NSLayoutConstraint.activate([
            labelNumberQuiz.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            labelNumberQuiz.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 20),
            labelNumberQuiz.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelNumberQuiz.widthAnchor.constraint(equalToConstant: 85)
        ])
        
        viewModel.isFlag() ? constraintsStackViewFlag() : constraintsStackViewLabel()
    }
    
    private func constraintsFlag() {
        let flag = viewModel.result.question.flag
        NSLayoutConstraint.activate([
            imageFlag.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            imageFlag.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageFlag.widthAnchor.constraint(equalToConstant: viewModel.width(flag)),
            imageFlag.heightAnchor.constraint(equalToConstant: 168)
        ])
    }
    
    private func constraintsLabel() {
        NSLayoutConstraint.activate([
            labelCountry.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            labelCountry.widthAnchor.constraint(equalToConstant: viewModel.widthLabel(view))
        ])
    }
    
    private func layoutYAxisAnchor() -> NSLayoutYAxisAnchor {
        viewModel.isFlag() ? imageFlag.bottomAnchor : labelCountry.bottomAnchor
    }
    
    private func constraintsStackViewFlag() {
        NSLayoutConstraint.activate([
            stackViewFlag.topAnchor.constraint(equalTo: labelNumberQuiz.bottomAnchor, constant: 25),
            stackViewFlag.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackViewFlag.widthAnchor.constraint(equalToConstant: viewModel.widthStackViewFlag(view)),
            stackViewFlag.heightAnchor.constraint(equalToConstant: 215)
        ])
        constraintsOnViewFlag()
    }
    
    private func constraintsOnViewFlag() {
        switch viewModel.game.gameType {
        case .quizOfFlag, .quizOfCapitals:
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
            stackViewLabel.widthAnchor.constraint(equalToConstant: viewModel.widthLabel(view)),
            stackViewLabel.heightAnchor.constraint(equalToConstant: viewModel.height())
        ])
        constraintsOnViewLabel()
    }
    
    private func constraintsOnViewLabel() {
        switch viewModel.game.gameType {
        case .quizOfFlag:
            setImageOnButton(image: imageFirst, button: viewFirst, flag: viewModel.result.buttonFirst.flag)
            setImageOnButton(image: imageSecond, button: viewSecond, flag: viewModel.result.buttonSecond.flag)
            setImageOnButton(image: imageThird, button: viewThird, flag: viewModel.result.buttonThird.flag)
            setImageOnButton(image: imageFourth, button: viewFourth, flag: viewModel.result.buttonFourth.flag)
        case .quizOfCapitals:
            setupLabel(label: labelFirst, on: viewFirst)
            setupLabel(label: labelSecond, on: viewSecond)
            setupLabel(label: labelThird, on: viewThird)
            setupLabel(label: labelFourth, on: viewFourth)
        default:
            setImageOnButton(checkmark: checkmarkFirst, image: imageFirst,
                             button: viewFirst, flag: viewModel.result.buttonFirst.flag)
            setImageOnButton(checkmark: checkmarkSecond, image: imageSecond,
                             button: viewSecond, flag: viewModel.result.buttonSecond.flag)
            setImageOnButton(checkmark: checkmarkThird, image: imageThird,
                             button: viewThird, flag: viewModel.result.buttonThird.flag)
            setImageOnButton(checkmark: checkmarkFourth, image: imageFourth,
                             button: viewFourth, flag: viewModel.result.buttonFourth.flag)
        }
    }
    
    private func setImageOnButton(checkmark: UIImageView? = nil, image: UIImageView,
                                  button: UIView, flag: String) {
        let layout = image.widthAnchor.constraint(equalToConstant: viewModel.widthImage(flag, view))
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
            image.heightAnchor.constraint(equalToConstant: viewModel.heightImage())
        ])
    }
    
    private func setImageOnButton(layout: NSLayoutConstraint, checkmark: UIImageView, 
                                  image: UIImageView, button: UIView) {
        NSLayoutConstraint.activate([
            checkmark.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            checkmark.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 5),
            layout,
            image.heightAnchor.constraint(equalToConstant: viewModel.heightImage()),
            image.centerXAnchor.constraint(equalTo: button.centerXAnchor, constant: viewModel.widthOrCenter(view).2),
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        setupSquare(subview: checkmark, sizes: 30)
    }
}
