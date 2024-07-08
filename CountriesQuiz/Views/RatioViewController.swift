//
//  RatioViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 04.07.2024.
//

import UIKit

class RatioViewController: UIViewController {
    private lazy var viewPanel: UIView = {
        setView(color: .white, first: buttonClose, second: labelPanel)
    }()
    
    private lazy var buttonClose: UIButton = {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "multiply", withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1.5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    
    private lazy var labelPanel: UILabel = {
        setLabel(text: viewModel.titlePanel, color: .black, size: 25, alignment: .center)
    }()
    
    private lazy var viewCircle: UIView = {
        setView(color: .white, radius: 22)
    }()
    
    var viewModel: RatioViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
        setSubviews()
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        viewModel.setCircles(viewCircle, view)
    }
    
    private func setDesign() {
        view.backgroundColor = .skyGrayLight
    }
    
    private func setSubviews() {
        viewModel.setupSubviews(subviews: viewPanel, viewCircle, on: view)
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}
// MARK: - Set views
extension RatioViewController {
    private func setView(color: UIColor, radius: CGFloat? = nil, first: UIView? = nil,
                         second: UIView? = nil) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = radius ?? 0
        view.translatesAutoresizingMaskIntoConstraints = false
        if let first = first, let second = second {
            viewModel.setupSubviews(subviews: first, second, on: view)
        }
        return view
    }
}
// MARK: - Set labels
extension RatioViewController {
    private func setLabel(text: String, color: UIColor, size: CGFloat,
                          alignment: NSTextAlignment? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "GillSans", size: size)
        label.textColor = color
        label.textAlignment = alignment ?? .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Set constraints
extension RatioViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            viewPanel.topAnchor.constraint(equalTo: view.topAnchor),
            viewPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewPanel.heightAnchor.constraint(equalToConstant: 63.75)
        ])
        viewModel.setSquare(subview: buttonClose, sizes: 40)
        viewModel.constraintsPanel(button: buttonClose, label: labelPanel, on: viewPanel)
        
        NSLayoutConstraint.activate([
            viewCircle.topAnchor.constraint(equalTo: viewPanel.bottomAnchor, constant: 30),
            viewCircle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            viewCircle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            viewCircle.heightAnchor.constraint(equalToConstant: 240)
        ])
    }
}
