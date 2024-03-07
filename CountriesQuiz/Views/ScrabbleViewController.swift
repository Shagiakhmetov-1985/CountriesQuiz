//
//  ScrabbleViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 11.12.2023.
//

import UIKit

class ScrabbleViewController: UIViewController {
    // MARK: - Subviews
    private lazy var buttonback: UIButton = {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "multiply", withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.5
        button.translatesAutoresizingMaskIntoConstraints = true
        button.addTarget(self, action: #selector(backToGameType), for: .touchUpInside)
        return button
    }()
    
    private lazy var labelTimer: UILabel = {
        setupLabel(title: "0", size: 35)
    }()
    
    private lazy var imageFlag: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "australia")
        imageView.layer.borderWidth = 1
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var labelCapital: UILabel = {
        setupLabel(title: "Москва", size: 32)
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = radius()
        progressView.clipsToBounds = true
        progressView.progressTintColor = .white
        progressView.trackTintColor = .white.withAlphaComponent(0.3)
        progressView.progress = 0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private lazy var labelNumber: UILabel = {
        setupLabel(title: "0 / \(mode.countQuestions)", size: 23)
    }()
    
    private lazy var labelQuiz: UILabel = {
        setupLabel(title: "Составьте правильный ответ", size: 23, opacity: 1)
    }()
    
    var mode: Setting!
    var game: Games!
    
    private var timer = Timer()
    private let shapeLayer = CAShapeLayer()
    
    private var currentQuestion = 0
    private var seconds = 0
    private var spendTime: [CGFloat] = []
    private var questions: (questions: [Countries], buttonFirst: [Countries],
                            buttonSecond: [Countries], buttonThird: [Countries],
                            buttonFourth: [Countries])!
    
    private var correctAnswers: [Countries] = []
    private var incorrectAnswers: [Results] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupDesign()
        setupSubviews()
        setupBarButton()
        setupConstraints()
    }
    // MARK: - General methods
    private func setupData() {
        questions = Countries.getQuestions(mode: mode)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        circularShadow()
        circular(strokeEnd: 0)
        animationCircleTimeReset()
    }
    
    private func setupDesign() {
        view.backgroundColor = game.background
        navigationItem.hidesBackButton = true
    }
    
    private func setupSubviews() {
        setupSubviews(subviews: labelTimer, imageFlag, progressView,
                      labelNumber, labelQuiz, on: view)
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    private func setupBarButton() {
        let leftBarButton = UIBarButtonItem(customView: buttonback)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func runTimer(time: CGFloat, action: Selector, repeats: Bool) -> Timer {
        Timer.scheduledTimer(timeInterval: time, target: self, selector: action,
                             userInfo: nil, repeats: repeats)
    }
    
    private func checkCircleCountdown() -> Int {
        10
    }
    
    private func isCountdown() -> Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    
    @objc private func backToGameType() {
        navigationController?.popViewController(animated: true)
    }
}
// MARK: - Setup label
extension ScrabbleViewController {
    private func setupLabel(title: String, size: CGFloat, opacity: Float? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.layer.opacity = opacity ?? 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup circle timer
extension ScrabbleViewController {
    private func circularShadow() {
        let center = CGPoint(x: labelTimer.center.x, y: labelTimer.center.y)
        let endAngle = CGFloat.pi / 2
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: 32,
            startAngle: -startAngle,
            endAngle: -endAngle,
            clockwise: true)
        
        let trackShape = CAShapeLayer()
        trackShape.path = circularPath.cgPath
        trackShape.lineWidth = 5
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.strokeColor = UIColor.white.withAlphaComponent(0.3).cgColor
        view.layer.addSublayer(trackShape)
    }
    
    private func circular(strokeEnd: CGFloat) {
        let center = CGPoint(x: labelTimer.center.x, y: labelTimer.center.y)
        let endAngle = CGFloat.pi / 2
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: 32,
            startAngle: -startAngle,
            endAngle: -endAngle,
            clockwise: true)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = strokeEnd
        shapeLayer.lineCap = CAShapeLayerLineCap.square
        shapeLayer.strokeColor = UIColor.white.cgColor
        view.layer.addSublayer(shapeLayer)
    }
    
    private func animationCircleCountdown() {
        let timer = checkCircleCountdown()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 0
        animation.duration = CFTimeInterval(timer)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
    
    private func animationCircleTimeReset() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = CFTimeInterval(0.4)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
}
// MARK: - Constraints
extension ScrabbleViewController {
    private func setupConstraints() {
        if isCountdown() {
            constraintsTimer()
        }
        setupSquare(subview: buttonback, sizes: 40)
        
        NSLayoutConstraint.activate([
            imageFlag.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            imageFlag.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageFlag.widthAnchor.constraint(equalToConstant: 280),
            imageFlag.heightAnchor.constraint(equalToConstant: 168)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: imageFlag.bottomAnchor, constant: 30),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.heightAnchor.constraint(equalToConstant: radius() * 2)
        ])
        
        NSLayoutConstraint.activate([
            labelNumber.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            labelNumber.leadingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: 20),
            labelNumber.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            labelNumber.widthAnchor.constraint(equalToConstant: 85)
        ])
        
        NSLayoutConstraint.activate([
            labelQuiz.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 25),
            labelQuiz.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelQuiz.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func constraintsTimer() {
        NSLayoutConstraint.activate([
            labelTimer.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            labelTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    private func radius() -> CGFloat {
        6
    }
}
