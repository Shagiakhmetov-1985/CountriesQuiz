//
//  DetailsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 22.08.2024.
//

import UIKit

class DetailsViewController: UIViewController {
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
    
    private lazy var iconFlag: UIImageView = {
        viewModel.setImage(image: "flag", color: .white, size: 33)
    }()
    
    private lazy var imageFlag: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: viewModel.flag)
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var viewFlag: UIView = {
        viewModel.setView(iconFlag, and: imageFlag)
    }()
    
    private lazy var iconCountry: UIImageView = {
        viewModel.setImage(image: "building", color: .white, size: 33)
    }()
    
    private lazy var iconCapital: UIImageView = {
        viewModel.setImage(image: "house.and.flag", color: .white, size: 33)
    }()
    
    private lazy var iconContinent: UIImageView = {
        viewModel.setImage(image: "globe.desk", color: .white, size: 33)
    }()
    
    private lazy var titleCountry: UILabel = {
        viewModel.setLabel(title: viewModel.name, size: 27, style: "GillSans-SemiBold", color: .white)
    }()
    
    private lazy var titleCapital: UILabel = {
        viewModel.setLabel(title: viewModel.capital, size: 27, style: "GillSans-SemiBold", color: .white)
    }()
    
    private lazy var titleContinent: UILabel = {
        viewModel.setLabel(title: <#T##String#>, size: <#T##CGFloat#>, style: <#T##String#>, color: <#T##UIColor#>)
    }()
    
    private lazy var viewFirst: UIView = {
        viewModel.setView(viewModel.buttonFirst, addSubview: subviewFirst, and: 1)
    }()
    
    private lazy var subviewFirst: UIView = {
        viewModel.subview(title: viewModel.buttonFirst, and: 1)
    }()
    
    private lazy var viewSecond: UIView = {
        viewModel.setView(viewModel.buttonSecond, addSubview: subviewSecond, and: 2)
    }()
    
    private lazy var subviewSecond: UIView = {
        viewModel.subview(title: viewModel.buttonSecond, and: 2)
    }()
    
    private lazy var viewThird: UIView = {
        viewModel.setView(viewModel.buttonThird, addSubview: subviewThird, and: 3)
    }()
    
    private lazy var subviewThird: UIView = {
        viewModel.subview(title: viewModel.buttonThird, and: 3)
    }()
    
    private lazy var viewFourth: UIView = {
        viewModel.setView(viewModel.buttonFour, addSubview: subviewFourth, and: 4)
    }()
    
    private lazy var subviewFourth: UIView = {
        viewModel.subview(title: viewModel.buttonFour, and: 4)
    }()
    
    private lazy var stackView: UIStackView = {
        viewModel.stackView(viewFirst, viewSecond, viewThird, viewFourth)
    }()
    
    private lazy var buttonDelete: UIButton = {
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "trash", withConfiguration: size)
        let button = Button(type: .system)
        button.setTitle(viewModel.titleButton, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: "mr_fontick", size: 25)
        button.setImage(image, for: .normal)
        button.backgroundColor = .bismarkFuriozo
        button.layer.shadowColor = UIColor.bismarkFuriozo.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteAndBackToList), for: .touchUpInside)
        return button
    }()
    
    var viewModel: DetailsViewModelProtocol!
    var delegate: FavouritesViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
        setBarButton()
        setSubviews()
        setConstraints()
    }
    
    private func setDesign() {
        view.backgroundColor = viewModel.background
        navigationItem.hidesBackButton = true
    }
    
    private func setBarButton() {
        viewModel.setBarButton(buttonBack, navigationItem)
    }
    
    private func setSubviews() {
        viewModel.setSubviews(subviews: viewFlag, stackView, buttonDelete,
                              on: view)
    }
    
    @objc private func backToList() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteAndBackToList() {
        viewModel.deleteAndBack()
        delegate.dataToFavourites(favourites: viewModel.favourites)
        navigationController?.popViewController(animated: true)
    }
}

extension DetailsViewController {
    private func setConstraints() {
        viewModel.setSquare(button: buttonBack, sizes: 40)
        
        NSLayoutConstraint.activate([
            viewFlag.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            viewFlag.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            viewFlag.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            viewFlag.heightAnchor.constraint(equalToConstant: 142)
        ])
        /*
        NSLayoutConstraint.activate([
            iconFlag.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            iconFlag.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            imageFlag.topAnchor.constraint(equalTo: iconFlag.bottomAnchor, constant: 10),
            imageFlag.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageFlag.widthAnchor.constraint(equalToConstant: viewModel.width(viewModel.flag)),
            imageFlag.heightAnchor.constraint(equalToConstant: 168)
        ])
        
        NSLayoutConstraint.activate([
            titleName.topAnchor.constraint(equalTo: imageFlag.bottomAnchor, constant: 10),
            titleName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleCountry.topAnchor.constraint(equalTo: titleName.bottomAnchor, constant: 10),
            titleCountry.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleCountry.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            titleError.topAnchor.constraint(equalTo: titleCountry.bottomAnchor, constant: 10),
            titleError.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleError.bottomAnchor, constant: 15),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: viewModel.widthStackView(view)),
            stackView.heightAnchor.constraint(equalToConstant: viewModel.heightStackView)
        ])
        viewModel.setConstraints(subviewFirst, on: viewFirst, view, viewModel.buttonFirst)
        viewModel.setConstraints(subviewSecond, on: viewSecond, view, viewModel.buttonSecond)
        viewModel.setConstraints(subviewThird, on: viewThird, view, viewModel.buttonThird)
        viewModel.setConstraints(subviewFourth, on: viewFourth, view, viewModel.buttonFour)
        
        NSLayoutConstraint.activate([
            buttonDelete.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            buttonDelete.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonDelete.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonDelete.heightAnchor.constraint(equalToConstant: 55)
        ])
         */
    }
}
