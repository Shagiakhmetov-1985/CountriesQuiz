//
//  IncorrectViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 04.10.2023.
//

import UIKit

class IncorrectViewController: UIViewController {
    private lazy var buttonBack: UIButton = {
        setButton(image: "arrow.left", action: #selector(backToList))
    }()
    
    private lazy var buttonFavourites: UIButton = {
        setButton(image: viewModel.imageFavorites(), action: #selector(favorites))
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
    
    private lazy var buttonAdd: UIButton = {
        let size = UIImage.SymbolConfiguration(pointSize: 33)
        let image = UIImage(systemName: "star", withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.tag = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(favorites), for: .touchUpInside)
        return button
    }()
    
    var viewModel: IncorrectViewModelProtocol!
    var delegate: IncorrectAnswersViewControllerDelegate!
    
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
        viewModel.setBarButton(buttonBack, buttonFavourites, navigationItem)
    }
    
    private func setSubviews() {
        viewModel.setSubviews(subviews: question, progressView, labelNumber,
                              stackView, on: view)
    }
    
    @objc private func backToList() {
        delegate.dataToIncorrectAnswers(favourites: viewModel.favorites)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func favorites(sender: UIButton) {
        viewModel.addOrDeleteFavorite(sender)
    }
}
// MARK: - Set button
extension IncorrectViewController {
    func setButton(image: String, action: Selector) -> UIButton {
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
// MARK: - Setup constraints
extension IncorrectViewController {
    private func setConstraints() {
        viewModel.setSquare(buttonBack, buttonFavourites, sizes: 40)
        
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
        viewModel.setConstraints(subviewFirst, on: viewFirst, view, viewModel.buttonFirst.flag)
        viewModel.setConstraints(subviewSecond, on: viewSecond, view, viewModel.buttonSecond.flag)
        viewModel.setConstraints(subviewThird, on: viewThird, view, viewModel.buttonThird.flag)
        viewModel.setConstraints(subviewFourth, on: viewFourth, view, viewModel.buttonFourth.flag)
        
//        NSLayoutConstraint.activate([
//            buttonAdd.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 25),
//            buttonAdd.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
    }
}
