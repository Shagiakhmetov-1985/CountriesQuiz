//
//  ContinentsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 10.10.2024.
//

import UIKit

class ContinentsViewController: UIViewController {
    private lazy var buttonBack: UIButton = {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "arrow.left", withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backToSetting), for: .touchUpInside)
        return button
    }()
    
    private lazy var image: UIImageView = {
        let size = UIImage.SymbolConfiguration(pointSize: 55)
        let image = UIImage(systemName: "globe.europe.africa", withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var labelTitle: UILabel = {
        viewModel.setLabel(text: viewModel.title, font: "GillSans-Bold", size: 21)
    }()
    
    private lazy var labelDescription: UILabel = {
        viewModel.setLabel(text: viewModel.description, font: "GillSans", size: 20)
    }()
    
    private lazy var buttonAllCountries: UIButton = {
        setButton(backgroundIsOn: !viewModel.allCountries,
                  colorIsOn: viewModel.allCountries)
    }()
    
    private lazy var buttonAmericaContinent: UIButton = {
        setButton(backgroundIsOn: !viewModel.americaContinent,
                  colorIsOn: viewModel.americaContinent,
                  tag: 1)
    }()
    
    private lazy var buttonEuropeContinent: UIButton = {
        setButton(backgroundIsOn: !viewModel.europeContinent,
                  colorIsOn: viewModel.europeContinent,
                  tag: 2)
    }()
    
    private lazy var buttonAfricaContinent: UIButton = {
        setButton(backgroundIsOn: !viewModel.africaContinent,
                  colorIsOn: viewModel.africaContinent,
                  tag: 3)
    }()
    
    private lazy var buttonAsiaContinent: UIButton = {
        setButton(backgroundIsOn: !viewModel.asiaContinent,
                  colorIsOn: viewModel.asiaContinent,
                  tag: 4)
    }()
    
    private lazy var buttonOceaniaContinent: UIButton = {
        setButton(backgroundIsOn: !viewModel.oceaniaContinent,
                  colorIsOn: viewModel.oceaniaContinent,
                  tag: 5)
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [buttonAllCountries, buttonAmericaContinent,
                               buttonEuropeContinent, buttonAfricaContinent,
                               buttonAsiaContinent, buttonOceaniaContinent])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var viewModel: ContinentsViewModelProtocol!
    var delegate: SettingViewControllerInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesing()
        setBarButton()
        setSubviews()
        setConstraints()
    }
    
    private func setDesing() {
        view.backgroundColor = .blueMiddlePersian
        navigationItem.hidesBackButton = true
        viewModel.counterContinents()
    }
    
    private func setBarButton() {
        viewModel.setBarButton(button: buttonBack, navigationItem: navigationItem)
    }
    
    private func setSubviews() {
        viewModel.setSubviews(subviews: image, labelTitle, labelDescription,
                              stackView, on: view)
    }
    
    @objc private func backToSetting() {
        delegate.dataToSetting(mode: viewModel.mode)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func continents(sender: UIButton) {
        viewModel.setContinents(sender: sender)
    }
}

extension ContinentsViewController {
    private func setButton(backgroundIsOn: Bool, colorIsOn: Bool,
                           tag: Int? = nil) -> UIButton {
        let text = viewModel.text(tag: tag ?? 0)
        let attributed = viewModel.attributedText(text: text, tag: tag ?? 0)
        let button = UIButton(type: .custom)
        button.backgroundColor = viewModel.isSelect(isOn: backgroundIsOn)
        button.setTitle(text, for: .normal)
        button.setTitleColor(viewModel.isSelect(isOn: colorIsOn), for: .normal)
        button.titleLabel?.font = UIFont(name: "mr_fontick", size: 26)
        button.titleLabel?.attributedText = attributed
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 13
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.tag = tag ?? 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(continents), for: .touchUpInside)
        viewModel.setButtonsContinent(button: button)
        return button
    }
}

extension ContinentsViewController {
    private func setConstraints() {
        viewModel.setSquare(subview: buttonBack, sizes: 40)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8),
            labelTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelDescription.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 8),
            labelDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            labelDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 370)
        ])
    }
}
