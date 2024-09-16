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
    
    private lazy var viewTopPanel: UIView = {
        viewModel.setView()
    }()
    
    private lazy var iconFlag: UIImageView = {
        viewModel.setImage(image: "flag", color: .white, size: 33)
    }()
    
    private lazy var viewFlag: UIView = {
        viewModel.setView(addSubview: iconFlag)
    }()
    
    private lazy var imageFlag: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: viewModel.flag)
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var viewFlagDetails: UIView = {
        viewModel.setView(viewFlag, and: imageFlag)
    }()
    
    private lazy var iconCountry: UIImageView = {
        viewModel.setImage(image: "building", color: .white, size: 33)
    }()
    
    private lazy var viewCountry: UIView = {
        viewModel.setView(addSubview: iconCountry)
    }()
    
    private lazy var titleCountry: UILabel = {
        viewModel.setLabel(text: viewModel.name, color: .white, font: "GillSans", size: 24)
    }()
    
    private lazy var viewCountryDetails: UIView = {
        viewModel.setView(viewCountry, titleCountry)
    }()
    
    private lazy var iconCapital: UIImageView = {
        viewModel.setImage(image: "house.and.flag", color: .white, size: 28)
    }()
    
    private lazy var viewCapital: UIView = {
        viewModel.setView(addSubview: iconCapital)
    }()
    
    private lazy var titleCapital: UILabel = {
        viewModel.setLabel(text: viewModel.capital, color: .white, font: "GillSans", size: 24)
    }()
    
    private lazy var viewCapitalDetails: UIView = {
        viewModel.setView(viewCapital, titleCapital)
    }()
    
    private lazy var iconContinent: UIImageView = {
        viewModel.setImage(image: "globe.desk", color: .white, size: 33)
    }()
    
    private lazy var viewContinent: UIView = {
        viewModel.setView(addSubview: iconContinent)
    }()
    
    private lazy var titleContinent: UILabel = {
        viewModel.setLabel(text: viewModel.continent, color: .white, font: "GillSans", size: 24)
    }()
    
    private lazy var viewContinentDetails: UIView = {
        viewModel.setView(viewContinent, titleContinent)
    }()
    
    private lazy var iconNumber: UIImageView = {
        viewModel.setImage(image: "numbersign", color: .white, size: 33)
    }()
    
    private lazy var viewNumber: UIView = {
        viewModel.setView(addSubview: iconNumber)
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
        viewModel.setLabel(text: viewModel.numberQuestion, color: .white, font: "mr_fontick", size: 23)
    }()
    
    private lazy var viewNumberDetails: UIView = {
        viewModel.setView(viewNumber, progressView, and: labelNumber)
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
    
    private lazy var contentView: UIView = {
        viewModel.setView(subviews: viewFlagDetails,
                          viewCountryDetails,
                          viewCapitalDetails,
                          viewContinentDetails,
                          viewNumberDetails)
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        return scrollView
    }()
    
    private lazy var buttonAdd: UIButton = {
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "star", withConfiguration: size)
        let button = Button(type: .system)
        button.setTitle(viewModel.title, for: .normal)
        button.titleLabel?.font = UIFont(name: "mr_fontick", size: 25)
        button.setImage(image, for: .normal)
        button.tintColor = viewModel.background
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.cornerRadius = 12
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
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
        viewModel.setSubviews(subviews: viewTopPanel, scrollView, buttonAdd,
                              on: view)
    }
    
    @objc private func backToList() {
        delegate.dataToIncorrectAnswers(favourites: viewModel.favorites)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func favorites(sender: UIButton) {
//        viewModel.addOrDeleteFavorite(sender)
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
        
        NSLayoutConstraint.activate([
            viewTopPanel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewTopPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewTopPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewTopPanel.heightAnchor.constraint(equalToConstant: 10)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: viewTopPanel.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -115)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1.1)
        ])
        
        NSLayoutConstraint.activate([
            viewFlagDetails.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            viewFlagDetails.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            viewFlagDetails.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            viewFlagDetails.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            viewCountryDetails.topAnchor.constraint(equalTo: viewFlagDetails.bottomAnchor, constant: 8),
            viewCountryDetails.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            viewCountryDetails.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            viewCountryDetails.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            viewCapitalDetails.topAnchor.constraint(equalTo: viewCountryDetails.bottomAnchor, constant: 5),
            viewCapitalDetails.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            viewCapitalDetails.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            viewCapitalDetails.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            viewContinentDetails.topAnchor.constraint(equalTo: viewCapitalDetails.bottomAnchor, constant: 5),
            viewContinentDetails.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            viewContinentDetails.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            viewContinentDetails.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            viewNumberDetails.topAnchor.constraint(equalTo: viewContinentDetails.bottomAnchor, constant: 8),
            viewNumberDetails.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            viewNumberDetails.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            viewNumberDetails.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            buttonAdd.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            buttonAdd.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            buttonAdd.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            buttonAdd.heightAnchor.constraint(equalToConstant: 55)
        ])
        /*
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
         */
    }
}
