//
//  IncorrectViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 04.10.2023.
//

import UIKit

class IncorrectViewController: UIViewController {
    private lazy var buttonBack: UIButton = {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "arrow.left", withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backToList), for: .touchUpInside)
        return button
    }()
    
    private lazy var question: UIView = {
        viewModel.question()
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = viewModel.radius
        progressView.clipsToBounds = true
        progressView.progressTintColor = .white
        progressView.trackTintColor = .white.withAlphaComponent(0.3)
        progressView.progress = viewModel.progress
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private lazy var labelNumber: UILabel = {
        let label = UILabel()
        label.text = viewModel.numberQuestion
        label.font = UIFont(name: "mr_fontick", size: 23)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var viewFirst: UIView = {
        viewModel.view(viewModel.buttonFirst, addSubview: subviewFirst, and: 1)
        /*
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
         */
    }()
    
    private lazy var subviewFirst: UIView = {
        viewModel.subview(button: viewModel.buttonFirst, and: 1)
    }()
    
    private lazy var viewSecond: UIView = {
        viewModel.view(viewModel.buttonSecond, addSubview: subviewSecond, and: 2)
    }()
    
    private lazy var subviewSecond: UIView = {
        viewModel.subview(button: viewModel.buttonSecond, and: 2)
    }()
    
    private lazy var viewThird: UIView = {
        viewModel.view(viewModel.buttonThird, addSubview: subviewThird, and: 3)
    }()
    
    private lazy var subviewThird: UIView = {
        viewModel.subview(button: viewModel.buttonThird, and: 3)
    }()
    
    private lazy var viewFourth: UIView = {
        viewModel.view(viewModel.buttonFourth, addSubview: subviewFourth, and: 4)
    }()
    
    private lazy var subviewFourth: UIView = {
        viewModel.subview(button: viewModel.buttonFourth, and: 4)
    }()
    
    private lazy var stackView: UIStackView = {
        viewModel.stackView(viewFirst, viewSecond, viewThird, viewFourth)
    }()
    
    var viewModel: IncorrectViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
        setBarButton()
        setSubviews()
        setConstraints()
    }
    // MARK: - General methods
    private func setDesign() {
        view.backgroundColor = viewModel.background
        navigationItem.hidesBackButton = true
    }
    
    private func setBarButton() {
        viewModel.setBarButton(buttonBack, navigationItem)
    }
    
    private func setSubviews() {
        viewModel.setSubviews(subviews: question, progressView, labelNumber, stackView, on: view)
    }
    
    @objc private func backToList() {
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - Setup constraints
extension IncorrectViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            buttonBack.widthAnchor.constraint(equalToConstant: 40),
            buttonBack.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        viewModel.constraintsQuestion(question, view)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: question.bottomAnchor, constant: 30),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.heightAnchor.constraint(equalToConstant: viewModel.radius * 2)
        ])
        
        NSLayoutConstraint.activate([
            labelNumber.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            labelNumber.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 20),
            labelNumber.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelNumber.widthAnchor.constraint(equalToConstant: 85)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: labelNumber.bottomAnchor, constant: 25),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: viewModel.widthStackView(view)),
            stackView.heightAnchor.constraint(equalToConstant: viewModel.heightStackView)
        ])
        viewModel.setConstraints(subviewFirst, on: viewFirst, view)
        viewModel.setConstraints(subviewSecond, on: viewSecond, view)
        viewModel.setConstraints(subviewThird, on: viewThird, view)
        viewModel.setConstraints(subviewFourth, on: viewFourth, view)
    }
    /*
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
     */
}
