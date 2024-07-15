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
        let image = UIImage(systemName: "multiply", withConfiguration: size)
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
    
    private lazy var image: UIImageView = {
        let imageView = UIImageView(image: viewModel.image)
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        setLabel(text: viewModel.numberQuestion, color: .white)
    }()
    
    private lazy var viewFirst: UIView = {
        setView(color: viewModel.backgroundColor(viewModel.buttonFirst), addLabel: labelFirst)
    }()
    
    private lazy var labelFirst: UILabel = {
        setLabel(text: viewModel.buttonFirst.name, color: viewModel.textColor(viewModel.buttonFirst))
    }()
    
    private lazy var viewSecond: UIView = {
        setView(color: viewModel.backgroundColor(viewModel.buttonSecond), addLabel: labelSecond)
    }()
    
    private lazy var labelSecond: UILabel = {
        setLabel(text: viewModel.buttonSecond.name, color: viewModel.textColor(viewModel.buttonSecond))
    }()
    
    private lazy var viewThird: UIView = {
        setView(color: viewModel.backgroundColor(viewModel.buttonThird), addLabel: labelThird)
    }()
    
    private lazy var labelThird: UILabel = {
        setLabel(text: viewModel.buttonThird.name, color: viewModel.textColor(viewModel.buttonThird))
    }()
    
    private lazy var viewFourth: UIView = {
        setView(color: viewModel.backgroundColor(viewModel.buttonFourth), addLabel: labelFourth)
    }()
    
    private lazy var labelFourth: UILabel = {
        setLabel(text: viewModel.buttonFourth.name, color: viewModel.textColor(viewModel.buttonFourth))
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [viewFirst, viewSecond, viewThird, viewFourth])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        viewModel.setSubviews(subviews: image, progressView, labelNumber, stackView, on: view)
    }
    
    @objc private func backToList() {
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - Set views
extension CorrectViewController {
    private func setView(color: UIColor, addLabel: UILabel) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 12
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 6)
        view.translatesAutoresizingMaskIntoConstraints = false
        viewModel.setSubviews(subviews: addLabel, on: view)
        return view
    }
}
// MARK: - Set labels
extension CorrectViewController {
    private func setLabel(text: String, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "mr_fontick", size: 23)
        label.textColor = color
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Set constraints
extension CorrectViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            buttonBack.widthAnchor.constraint(equalToConstant: 40),
            buttonBack.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: viewModel.width(viewModel.flag)),
            image.heightAnchor.constraint(equalToConstant: 168)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 30),
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
            stackView.widthAnchor.constraint(equalToConstant: viewModel.widthFlag(view)),
            stackView.heightAnchor.constraint(equalToConstant: 215)
        ])
        viewModel.setConstraints(labelFirst, on: viewFirst)
        viewModel.setConstraints(labelSecond, on: viewSecond)
        viewModel.setConstraints(labelThird, on: viewThird)
        viewModel.setConstraints(labelFourth, on: viewFourth)
    }
}
