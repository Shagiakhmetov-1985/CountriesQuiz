//
//  RatioViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 04.07.2024.
//

import UIKit

class RatioViewController: UIViewController {
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
    
    private lazy var labelStatistic: UILabel = {
        setLabel(text: viewModel.title, color: .black, size: 26, font: "GillSans-SemiBold", alignment: .center)
    }()
    
    private lazy var imageCircleCorrect: UIImageView = {
        setImage(image: "seal.fill", size: 50, color: .greenEmerald.withAlphaComponent(0.3), addImage: imageCorrect)
    }()
    
    private lazy var imageCorrect: UIImageView = {
        setImage(image: "checkmark", size: 25, color: .greenEmerald)
    }()
    
    private lazy var labelCorrect: UILabel = {
        setLabel(text: viewModel.titleCorrect, color: .black, size: 19.5, font: "GillSans")
    }()
    
    private lazy var labelCorrectCount: UILabel = {
        setLabel(text: viewModel.dataCorrect, color: .greenDartmouth, size: 20, font: "GillSans-SemiBold", alignment: .right)
    }()
    
    private lazy var progressViewCorrect: UIProgressView = {
        setProgressView(color: .greenDartmouth, value: viewModel.progressCorrect)
    }()
    
    private lazy var imageCircleIncorrect: UIImageView = {
        setImage(image: "seal.fill", size: 50, color: .bismarkFuriozo.withAlphaComponent(0.3), addImage: imageIncorrect)
    }()
    
    private lazy var imageIncorrect: UIImageView = {
        setImage(image: "multiply", size: 25, color: .bismarkFuriozo)
    }()
    
    private lazy var labelIncorrect: UILabel = {
        setLabel(text: viewModel.titleIncorrect, color: .black, size: 19.5, font: "GillSans")
    }()
    
    private lazy var labelIncorrectCount: UILabel = {
        setLabel(text: viewModel.dataIncorrect, color: .bismarkFuriozo, size: 20, font: "GillSans-SemiBold", alignment: .right)
    }()
    
    private lazy var progressViewIncorrect: UIProgressView = {
        setProgressView(color: .bismarkFuriozo, value: viewModel.progressIncorrect)
    }()
    
    private lazy var imageCircleTimeSpend: UIImageView = {
        setImage(image: "seal.fill", size: 50, color: .blueMiddlePersian.withAlphaComponent(0.3), addImage: imageTimeSpend)
    }()
    
    private lazy var imageTimeSpend: UIImageView = {
        setImage(image: viewModel.imageTimeSpend, size: 25, color: .blueMiddlePersian)
    }()
    
    private lazy var labelTimeSpend: UILabel = {
        setLabel(text: viewModel.titleTimeSpend, color: .black, size: 19.5, font: "GillSans")
    }()
    
    private lazy var labelTimeSpendCount: UILabel = {
        setLabel(text: viewModel.dataTimeSpend, color: .blueMiddlePersian, size: 20, font: "GillSans-SemiBold", alignment: .right)
    }()
    
    private lazy var progressViewTimeSpend: UIProgressView = {
        setProgressView(color: .blueMiddlePersian, value: viewModel.progressTimeSpend)
    }()
    
    private lazy var imageCircleAnswered: UIImageView = {
        setImage(image: "seal.fill", size: 50, color: .gummigut.withAlphaComponent(0.3), addImage: imageAnswered)
    }()
    
    private lazy var imageAnswered: UIImageView = {
        setImage(image: "questionmark.bubble", size: 25, color: .gummigut)
    }()
    
    private lazy var labelAnswered: UILabel = {
        setLabel(text: viewModel.titleAnswered, color: .black, size: 19.5, font: "GillSans")
    }()
    
    private lazy var labelAnsweredCount: UILabel = {
        setLabel(text: viewModel.dataAnswered, color: .gummigut, size: 20, font: "GillSans-SemiBold", alignment: .right)
    }()
    
    private lazy var progressViewAnswered: UIProgressView = {
        setProgressView(color: .gummigut, value: viewModel.progressAnswered)
    }()
    
    private lazy var imageInfinity: UIImageView = {
        setImage(image: "infinity", size: 20, color: .blueMiddlePersian)
    }()
    
    private lazy var buttonDone: UIButton = {
        let button = Button(type: .system)
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "mr_fontick", size: 25)
        button.backgroundColor = .black
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    
    var viewModel: RatioViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
        setSubviews()
        setBarButton()
        setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        viewModel.setCircles(labelStatistic, view)
        viewModel.setProgressCircles(labelStatistic, view)
    }
    
    private func setDesign() {
        view.backgroundColor = .white
        imageInfinity.isHidden = viewModel.isTime ? true : false
    }
    
    private func setSubviews() {
        viewModel.setupSubviews(subviews: labelStatistic, imageCircleCorrect,
                                labelCorrect, labelCorrectCount, progressViewCorrect,
                                imageCircleIncorrect, labelIncorrect, labelIncorrectCount,
                                progressViewIncorrect, imageCircleTimeSpend,
                                labelTimeSpend, labelTimeSpendCount,
                                progressViewTimeSpend, imageCircleAnswered, labelAnswered,
                                labelAnsweredCount, progressViewAnswered, 
                                buttonDone, imageInfinity, on: view)
    }
    
    private func setBarButton() {
        viewModel.setBarButton(buttonClose, navigationItem)
    }
    
    @objc private func close() {
        dismiss(animated: true)
    }
}
// MARK: - Set views
extension RatioViewController {
    private func setView(radius: CGFloat? = nil, first: UIView? = nil,
                         second: UIView? = nil, third: UIView? = nil,
                         fourth: UIView? = nil) -> UIView {
        let view = UIView()
        view.backgroundColor = .skyGrayLight.withAlphaComponent(0.6)
        view.layer.cornerRadius = radius ?? 0
        view.translatesAutoresizingMaskIntoConstraints = false
        if let first = first, let second = second, let third = third, let fourth = fourth {
            viewModel.setupSubviews(subviews: first, second, third, fourth, on: view)
        } else if let first = first, let second = second {
            viewModel.setupSubviews(subviews: first, second, on: view)
        } else if let first = first {
            viewModel.setupSubviews(subviews: first, on: view)
        }
        return view
    }
}
// MARK: - Set labels
extension RatioViewController {
    private func setLabel(text: String, color: UIColor, size: CGFloat, font: String,
                          alignment: NSTextAlignment? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: font, size: size)
        label.textColor = color
        label.textAlignment = alignment ?? .left
        label.numberOfLines = 0
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
        viewModel.setSquare(subview: buttonClose, sizes: 40)
        
        NSLayoutConstraint.activate([
            labelStatistic.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -5),
            labelStatistic.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelStatistic.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        viewModel.setupCenterSubview(imageCorrect, on: imageCircleCorrect)
        viewModel.constraints(image: imageCircleCorrect, layout: labelStatistic.bottomAnchor,
                              constant: 260, title: labelCorrect, count: labelCorrectCount,
                              progressView: progressViewCorrect, view: view)
        viewModel.setupCenterSubview(imageIncorrect, on: imageCircleIncorrect)
        viewModel.constraints(image: imageCircleIncorrect, layout: imageCircleCorrect.bottomAnchor,
                              constant: 12.5, title: labelIncorrect, count: labelIncorrectCount,
                              progressView: progressViewIncorrect, view: view)
        viewModel.setupCenterSubview(imageTimeSpend, on: imageCircleTimeSpend)
        viewModel.constraints(image: imageCircleTimeSpend, layout: imageCircleIncorrect.bottomAnchor,
                              constant: 12.5, title: labelTimeSpend, count: labelTimeSpendCount,
                              progressView: progressViewTimeSpend, view: view)
        viewModel.setupCenterSubview(imageAnswered, on: imageCircleAnswered)
        viewModel.constraints(image: imageCircleAnswered, layout: imageCircleTimeSpend.bottomAnchor,
                              constant: 12.5, title: labelAnswered, count: labelAnsweredCount,
                              progressView: progressViewAnswered, view: view)
        
        viewModel.setInsteadSubview(imageInfinity, on: labelTimeSpendCount)
        
        NSLayoutConstraint.activate([
            buttonDone.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonDone.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            buttonDone.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonDone.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}
