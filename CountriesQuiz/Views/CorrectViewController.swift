//
//  CorrectViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 15.07.2024.
//

import UIKit

class CorrectViewController: UIViewController {
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
        viewModel.view(viewModel.buttonFirst, addSubview: subviewFirst)
    }()
    
    private lazy var subviewFirst: UIView = {
        viewModel.subview(button: viewModel.buttonFirst)
    }()
    
    private lazy var viewSecond: UIView = {
        viewModel.view(viewModel.buttonSecond, addSubview: subviewSecond)
    }()
    
    private lazy var subviewSecond: UIView = {
        viewModel.subview(button: viewModel.buttonSecond)
    }()
    
    private lazy var viewThird: UIView = {
        viewModel.view(viewModel.buttonThird, addSubview: subviewThird)
    }()
    
    private lazy var subviewThird: UIView = {
        viewModel.subview(button: viewModel.buttonThird)
    }()
    
    private lazy var viewFourth: UIView = {
        viewModel.view(viewModel.buttonFourth, addSubview: subviewFourth)
    }()
    
    private lazy var subviewFourth: UIView = {
        viewModel.subview(button: viewModel.buttonFourth)
    }()
    
    private lazy var stackView: UIStackView = {
        viewModel.stackView(viewFirst, viewSecond, viewThird, viewFourth)
    }()
    
    var viewModel: CorrectViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
        setBarButton()
        setSubviews()
        setConstraints()
    }
    
    private func setDesign() {
        view.backgroundColor = viewModel.background
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
// MARK: - Set constraints
extension CorrectViewController {
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
}
