//
//  FavouritesViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 15.08.2024.
//

import UIKit

protocol FavouritesViewControllerDelegate {
    func dataToFavourites(favourites: [Favourites])
}

class FavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FavouritesViewControllerDelegate {
    private lazy var buttonClose: UIButton = {
        setButton(image: "multiply", action: #selector(extiToGameType), isBarButton: true)
    }()
    
    private lazy var visualEffectBlur: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var labelTitle: UILabel = {
        viewModel.setLabel(title: viewModel.title, font: "mr_fontick", size: 28, color: .white)
    }()
    
    private lazy var imageTitle: UIImageView = {
        let size = UIImage.SymbolConfiguration(pointSize: 28)
        let image = UIImage(systemName: "star.fill", withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelTitle, imageTitle])
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(viewModel.cell, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = viewModel.background
        tableView.separatorColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var viewDetails: UIView = {
        let view = viewModel.setView(color: viewModel.backgroundDetails, radius: 15)
        let close = setButton(image: "multiply", action: #selector(closeDetails))
        let label = viewModel.setLabel(title: viewModel.details, font: "GillSans", size: 22, color: .white)
        let moreInfo = setButton()
        let delete = setButton(image: "trash", action: #selector(deleteFavourite))
        viewModel.setSubviews(subviews: close, label, moreInfo, delete, on: view)
        viewModel.setConstraints(close, label, moreInfo, and: delete, on: view)
        return view
    }()
    
    var viewModel: FavouritesViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
        setBarButton()
        setSubviews()
        setConstraints()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        viewModel.customCell(cell: cell as! FavouritesCell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.heightOfRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setDetails(viewDetails, view, and: indexPath)
        viewModel.setSubviews(subviews: viewDetails, on: view)
        viewModel.setConstraints(viewDetails, on: view)
        viewModel.barButtonOnOff(button: buttonClose, isOn: false)
        viewModel.showAnimationView(viewDetails, visualEffectBlur)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func dataToFavourites(favourites: [Favourites]) {
        viewModel.setFavourites(newFavourites: favourites)
        tableView.reloadData()
    }
    
    private func setDesign() {
        view.backgroundColor = viewModel.background
        navigationItem.hidesBackButton = true
    }
    
    private func setBarButton() {
        viewModel.setBarButton(buttonClose, navigationItem)
    }
    
    private func setSubviews() {
        viewModel.setSubviews(subviews: stackView, tableView, visualEffectBlur,
                              on: view)
    }
    
    @objc private func extiToGameType() {
        dismiss(animated: true)
    }
    
    @objc private func closeDetails() {
        viewModel.barButtonOnOff(button: buttonClose, isOn: true)
        viewModel.hideAnimationView(viewDetails, visualEffectBlur)
    }
    
    @objc private func deleteFavourite() {
        
    }
    
    @objc private func moreInfo() {
        let detailsViewModel = viewModel.detailsViewController()
        let detailsVC = DetailsViewController()
        detailsVC.viewModel = detailsViewModel
        detailsVC.delegate = self
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension FavouritesViewController {
    private func setConstraints() {
        viewModel.setSquare(button: buttonClose, sizes: 40)
        
        NSLayoutConstraint.activate([
            visualEffectBlur.topAnchor.constraint(equalTo: view.topAnchor),
            visualEffectBlur.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualEffectBlur.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visualEffectBlur.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension FavouritesViewController {
    private func setButton(image: String, action: Selector,
                           isBarButton: Bool? = nil) -> UIButton {
        let pointSize: CGFloat = isBarButton ?? false ? 20 : 26
        let size = UIImage.SymbolConfiguration(pointSize: pointSize)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.borderWidth = isBarButton ?? false ? 1.5 : 0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setButton() -> UIButton {
        let label = viewModel.setLabel(title: "Подробнее", font: "mr_fontick", size: 26, color: .white)
        let image = viewModel.setImage(image: "chevron.right", color: .white, size: 21)
        let button = Button(type: .custom)
        button.backgroundColor = viewModel.colorButton
        button.layer.cornerRadius = 15
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moreInfo), for: .touchUpInside)
        viewModel.setSubviews(subviews: label, image, on: button)
        viewModel.setConstraints(label, and: image, on: button)
        return button
    }
}
