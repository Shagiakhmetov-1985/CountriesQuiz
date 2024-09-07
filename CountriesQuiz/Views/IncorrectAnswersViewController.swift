//
//  IncorrectAnswersViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 17.08.2023.
//

import UIKit

protocol IncorrectAnswersViewControllerDelegate {
    func dataToIncorrectAnswers(favourites: [Favorites])
}

class IncorrectAnswersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, IncorrectAnswersViewControllerDelegate {
    
    private lazy var buttonBack: UIButton = {
        setButton(image: "multiply", action: #selector(exitToResults), isBarButton: true)
    }()
    
    private lazy var buttonFavorite: UIButton = {
        setButton(image: "star", action: #selector(addDeleteFavorite))
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 0
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }()
    
    private lazy var labelTitle: UILabel = {
        viewModel.setLabel(title: viewModel.title, color: .white, size: 28)
    }()
    
    private lazy var imageTitle: UIImageView = {
        let size = UIImage.SymbolConfiguration(pointSize: 28)
        let image = UIImage(systemName: "multiply", withConfiguration: size)
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = viewModel.backgroundLight
        tableView.separatorColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var viewDetails: UIView = {
        let view = viewModel.setView(color: viewModel.backgroundDark, radius: 15)
        let button = setButton(image: "multiply", action: #selector(close))
        let moreInfo = setButton()
        viewModel.setupSubviews(subviews: button, moreInfo, on: view)
        viewModel.setConstraints(button, moreInfo, on: view)
        return view
    }()
    
    var viewModel: IncorrectAnswersViewModelProtocol!
    var delegate: ResultsViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupBarButton()
        setupSubviews()
        setupConstraints()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.heightForRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        viewModel.customCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        let incorrectViewModel = viewModel.detailsViewModel(indexPath.row)
        let incorrectVC = IncorrectViewController()
        incorrectVC.viewModel = incorrectViewModel
        incorrectVC.delegate = self
        navigationController?.pushViewController(incorrectVC, animated: true)
         */
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func dataToIncorrectAnswers(favourites: [Favorites]) {
        viewModel.setFavorites(newFavorites: favourites)
    }
    
    private func setupDesign() {
        view.backgroundColor = viewModel.backgroundMedium
    }
    
    private func setupSubviews() {
        viewModel.setupSubviews(subviews: stackView, tableView, visualEffectView,
                                on: view)
    }
    
    private func setupBarButton() {
        viewModel.setBarButton(buttonBack, navigationItem)
    }
    
    @objc private func exitToResults() {
        delegate.dataToResults(favourites: viewModel.favorites)
        dismiss(animated: true)
    }
    
    @objc private func close() {
        
    }
    
    @objc private func addDeleteFavorite() {
        
    }
    
    @objc private func moreInfo() {
        
    }
}

extension IncorrectAnswersViewController {
    private func setButton(image: String, action: Selector,
                           isBarButton: Bool? = nil) -> UIButton {
        let pointSize: CGFloat = isBarButton ?? false ? 20 : 26
        let size = UIImage.SymbolConfiguration(pointSize: pointSize)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = isBarButton ?? false ? 1.5 : 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setButton() -> UIButton {
        let label = viewModel.setLabel(title: "Подробнее", color: .white, size: 26)
        let image = viewModel.setImage(image: "chevron.right", color: .white, size: 21)
        let button = Button(type: .custom)
        button.backgroundColor = viewModel.backgroundLight
        button.layer.cornerRadius = 15
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moreInfo), for: .touchUpInside)
        viewModel.setupSubviews(subviews: label, image, on: button)
        viewModel.setConstraints(label, and: image, on: button)
        return button
    }
}
// MARK: - Constraints
extension IncorrectAnswersViewController {
    private func setupConstraints() {
        viewModel.setSquare(button: buttonBack, sizes: 40)
        
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
