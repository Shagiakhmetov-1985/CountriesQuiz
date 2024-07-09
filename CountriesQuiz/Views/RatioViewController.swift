//
//  RatioViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 04.07.2024.
//

import UIKit

class RatioViewController: UIViewController {
    private lazy var viewPanel: UIView = {
        setView(first: buttonClose, second: labelPanel)
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
        setLabel(text: viewModel.titlePanel, color: .black, size: 26, alignment: .center)
    }()
    
    private lazy var viewCircle: UIView = {
        setView(radius: 22)
    }()
    
    private lazy var viewCorrect: UIView = {
        setView(radius: 22,
                first: imageCircleCorrect,
                second: labelCorrect,
                third: labelCorrectCount, 
                fourth: labelCorrectPercent,
                fiveth: progressViewCorrect)
    }()
    
    private lazy var imageCircleCorrect: UIImageView = {
        setImage(image: "circle.fill", size: 60, color: .greenEmerald.withAlphaComponent(0.3), addImage: imageCorrect)
    }()
    
    private lazy var imageCorrect: UIImageView = {
        setImage(image: "checkmark", size: 30, color: .greenEmerald)
    }()
    
    private lazy var labelCorrect: UILabel = {
        setLabel(text: "Правильные ответы", color: .black, size: 21)
    }()
    
    private lazy var labelCorrectCount: UILabel = {
        setLabel(text: viewModel.countCorrect, color: .greenDartmouth, size: 17, alignment: .center)
    }()
    
    private lazy var labelCorrectPercent: UILabel = {
        setLabel(text: viewModel.percentCorrect, color: .greenDartmouth, size: 17, alignment: .right)
    }()
    
    private lazy var progressViewCorrect: UIProgressView = {
        setProgressView(color: .greenDartmouth, value: viewModel.progressCorrect)
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
        viewModel.setProgressCircles(viewCircle, view)
    }
    
    private func setDesign() {
        view.backgroundColor = .skyGrayLight
    }
    
    private func setSubviews() {
        viewModel.setupSubviews(subviews: viewPanel, viewCircle, viewCorrect, on: view)
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}
// MARK: - Set views
extension RatioViewController {
    private func setView(radius: CGFloat? = nil, first: UIView? = nil,
                         second: UIView? = nil, third: UIView? = nil,
                         fourth: UIView? = nil, fiveth: UIView? = nil) -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = radius ?? 0
        view.translatesAutoresizingMaskIntoConstraints = false
        if let first = first, let second = second, let third = third, let fourth = fourth, let fiveth = fiveth {
            viewModel.setupSubviews(subviews: first, second, third, fourth, fiveth, on: view)
        } else if let first = first, let second = second {
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
// MARK: - Set images
extension RatioViewController {
    private func setImage(image: String, size: CGFloat, color: UIColor,
                          addImage: UIImageView? = nil) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: size)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        if let addImage = addImage {
            viewModel.setupSubviews(subviews: addImage, on: imageView)
        }
        return imageView
    }
}
// MARK: - Set progress views
extension RatioViewController {
    private func setProgressView(color: UIColor, value: Float) -> UIProgressView {
        let progressView = UIProgressView()
        progressView.progressTintColor = color
        progressView.trackTintColor = color.withAlphaComponent(0.3)
        progressView.progress = value
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = viewModel.radius
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
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
        
        NSLayoutConstraint.activate([
            viewCorrect.topAnchor.constraint(equalTo: viewCircle.bottomAnchor, constant: 60),
            viewCorrect.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            viewCorrect.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            viewCorrect.heightAnchor.constraint(equalToConstant: 90)
        ])
        viewModel.setupCenterSubview(imageCorrect, on: imageCircleCorrect)
        viewModel.constraintsView(image: imageCircleCorrect, title: labelCorrect,
                                  count: labelCorrectCount, percent: labelCorrectPercent,
                                  progressView: progressViewCorrect, on: viewCorrect)
    }
}
