//
//  CorrectAnswersViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 14.07.2024.
//

import UIKit

class CorrectAnswersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private lazy var buttonBack: UIButton = {
        setButton(action: #selector(exitToResults), isBarButton: true)
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.alpha = 0
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        return visualEffectView
    }()
    
    private lazy var labelTitle: UILabel = {
        viewModel.setLabel(title: viewModel.title, size: 28, color: .white)
    }()
    
    private lazy var imageTitle: UIImageView = {
        let size = UIImage.SymbolConfiguration(pointSize: 28)
        let image = UIImage(systemName: "checkmark", withConfiguration: size)
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
        tableView.backgroundColor = viewModel.background
        tableView.separatorColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var viewDetails: UIView = {
        let view = viewModel.setView(color: viewModel.backgroundDetails, radius: 15, tag: 0)
        let button = setButton(action: #selector(close))
        view.addSubview(button)
        viewModel.setConstraints(button: button, on: view)
        return view
    }()
    
    var viewModel: CorrectAnswersViewModelProtocol!
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.heightOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        viewModel.customCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        let correctViewModel = viewModel.correctViewModel(indexPath.row)
        let correctVC = CorrectViewController()
        correctVC.viewModel = correctViewModel
        navigationController?.pushViewController(correctVC, animated: true)
         */
        viewModel.setDetails(viewDetails, view, and: indexPath)
        viewModel.setSubviews(subviews: viewDetails, on: view)
        viewModel.setConstraints(viewDetails: viewDetails, on: view)
        viewModel.buttonOnOff(button: buttonBack, isOn: false)
        viewModel.showAnimationView(viewDetails, and: visualEffectView)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func setDesign() {
        view.backgroundColor = viewModel.background
    }
    
    private func setBarButton() {
        viewModel.setBarButton(buttonBack, navigationItem)
    }
    
    private func setSubviews() {
        viewModel.setSubviews(subviews: stackView, tableView, visualEffectView,
                              on: view)
    }
    
    @objc private func exitToResults() {
        dismiss(animated: true)
    }
    
    @objc private func close() {
        viewModel.buttonOnOff(button: buttonBack, isOn: true)
        viewModel.hideAnimationView(viewDetails, and: visualEffectView)
    }
}
// MARK: - Subviews
extension CorrectAnswersViewController {
    private func setButton(action: Selector, isBarButton: Bool? = nil) -> UIButton {
        let pointSize: CGFloat = isBarButton ?? false ? 20 : 26
        let size = UIImage.SymbolConfiguration(pointSize: pointSize)
        let image = UIImage(systemName: "multiply", withConfiguration: size)
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
}
// MARK: - Set constraints
extension CorrectAnswersViewController {
    private func setConstraints() {
        viewModel.setSquare(button: buttonBack, sizes: 40)
        
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
