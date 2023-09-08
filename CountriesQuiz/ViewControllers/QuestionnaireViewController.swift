//
//  QuestionnaireViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 29.08.2023.
//

import UIKit

class QuestionnaireViewController: UIViewController {
    private lazy var buttonBack: UIButton = {
        let button = setButton(
            image: "arrow.backward",
            action: #selector(backToGameType))
        return button
    }()
    
    private lazy var labelTimer: UILabel = {
        let label = setupLabel(
            title: "\(seconds())",
            size: 35)
        return label
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = setupProgressView()
        return progressView
    }()
    
    private lazy var contentView: UIView = {
        let view = setupView()
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = setupScrollView()
        return scrollView
    }()
    /*
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    */
    var mode: Setting!
    var game: Games!
    
    private var timer = Timer()
    private let questions = Countries.getQuestions()
    private var shapeLayer = CAShapeLayer()
    
//    private var imageView: [UIImageView] = []
//    private var button: [UIButton] = []
    
    private var contentSize: CGSize {
        CGSize(width: view.frame.width, height: view.frame.height + sizeForQuestions())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupBarButton()
        setupSubviews()
        setupSubviewsOnContentView()
        setupSubviewsOnScrollView()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupCircles()
    }
    
    override func viewDidLayoutSubviews() {
        print("scroll view height: \(contentView.frame.height)")
    }
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        questions.questions.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! CustomHeader
        view.title.text = "\(section + 1) / \(mode.countQuestions)"
        view.image.image = UIImage(named: questions.questions[section].flag)
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QuestionnaireCell
        
        switch indexPath.row {
        case 0:
            cell.title.text = questions.buttonFirst[indexPath.section].name
            cell.image.image = checkImage(questions.buttonFirst[indexPath.section].select)
            cell.image.tintColor = checkColor(questions.buttonFirst[indexPath.section].select)
        case 1:
            cell.title.text = questions.buttonSecond[indexPath.section].name
            cell.image.image = checkImage(questions.buttonSecond[indexPath.section].select)
            cell.image.tintColor = checkColor(questions.buttonSecond[indexPath.section].select)
        case 2:
            cell.title.text = questions.buttonThird[indexPath.section].name
            cell.image.image = checkImage(questions.buttonThird[indexPath.section].select)
            cell.image.tintColor = checkColor(questions.buttonThird[indexPath.section].select)
        default:
            cell.title.text = questions.buttonFourth[indexPath.section].name
            cell.image.image = checkImage(questions.buttonFourth[indexPath.section].select)
            cell.image.tintColor = checkColor(questions.buttonFourth[indexPath.section].select)
        }
        
        cell.layer.borderWidth = 1
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            guard !questions.buttonFirst[indexPath.section].select else { return }
            checkSelect(answer: questions.buttonFirst, indexPath: indexPath)
        case 1:
            guard !questions.buttonSecond[indexPath.section].select else { return }
            checkSelect(answer: questions.buttonSecond, indexPath: indexPath)
        case 2:
            guard !questions.buttonThird[indexPath.section].select else { return }
            checkSelect(answer: questions.buttonThird, indexPath: indexPath)
        default:
            guard !questions.buttonFourth[indexPath.section].select else { return }
            checkSelect(answer: questions.buttonFourth, indexPath: indexPath)
        }
        tableView.reloadData()
    }
    */
    private func setupDesign() {
        view.backgroundColor = game.background
        navigationItem.hidesBackButton = true
    }
    
    private func setupBarButton() {
        let leftBarButton = UIBarButtonItem(customView: buttonBack)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func setupSubviews() {
        if mode.timeElapsed.timeElapsed {
            setupSubviews(subviews: labelTimer, progressView, contentView,
                          on: view)
        } else {
            setupSubviews(subviews: progressView, contentView, on: view)
        }
    }
    
    private func setupSubviewsOnContentView() {
        setupSubviews(subviews: scrollView, on: contentView)
    }
    
    private func setupQuestions() -> [UIImageView] {
        var flags: [UIImageView] = []
        questions.questions.forEach { country in
            let flag = setupImageView(image: country.flag)
            flags.append(flag)
        }
        return flags
    }
    
    private func setupButtons(countries: [Countries]) -> [UIButton] {
        var buttons: [UIButton] = []
        countries.forEach { country in
            let label = setupLabel(title: country.name, size: 28)
            let image = setupImage(image: "circle")
            let button = setButton(label: label, image: image)
            constraintsOnButton(label: label, image: image, button: button)
            buttons.append(button)
        }
        return buttons
    }
    
    private func setupAnswers() -> ([UIButton], [UIButton], [UIButton], [UIButton]) {
        let buttonsFirst = setupButtons(countries: questions.buttonFirst)
        let buttonsSecond = setupButtons(countries: questions.buttonSecond)
        let buttonsThird = setupButtons(countries: questions.buttonThird)
        let buttonsFourth = setupButtons(countries: questions.buttonFourth)
        return (buttonsFirst, buttonsSecond, buttonsThird, buttonsFourth)
    }
    
    private func setupSubviewsOnScrollView() {
        var constant: CGFloat = 20
        setupQuestions().forEach { flag in
            setupSubviews(subviews: flag, on: scrollView)
            constraintsImage(image: flag, constant: constant)
            constant += 150
        }
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    private func setupCircles() {
        circleShadow()
        circle(strokeEnd: 0)
        animationTimeReset()
    }
    
    @objc private func backToGameType() {
        navigationController?.popViewController(animated: true)
    }
    /*
    private func checkImage(_ checkmark: Bool) -> UIImage? {
        checkmark ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
    }
    
    private func checkColor(_ checkmark: Bool) -> UIColor {
        checkmark ? .systemGreen : .systemRed
    }
    
    private func checkSelect(answer: [Countries], indexPath: IndexPath) {
        questions.buttonFirst[indexPath.section].select = answer == questions.buttonFirst ? true : false
        questions.buttonSecond[indexPath.section].select = answer == questions.buttonSecond ? true : false
        questions.buttonThird[indexPath.section].select = answer == questions.buttonThird ? true : false
        questions.buttonFourth[indexPath.section].select = answer == questions.buttonFourth ? true : false
    }
     */
}
// MARK: - Setup view
extension QuestionnaireViewController {
    private func setupView() -> UIView {
        let view = UIView()
        view.frame.size = contentSize
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
// MARK: - Setup scroll view
extension QuestionnaireViewController {
    private func setupScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.contentSize = contentSize
        return scrollView
    }
}
// MARK: - Setup buttons
extension QuestionnaireViewController {
    private func setButton(image: String, action: Selector) -> UIButton {
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
    
    private func setButton(label: UILabel, image: UIImageView) -> UIButton {
        let button = UIButton(type: .custom)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        setupSubviews(subviews: label, image, on: button)
        return button
    }
}
// MARK: - Setup label
extension QuestionnaireViewController {
    private func setupLabel(title: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func seconds() -> Int {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
    }
}
// MARK: - Setup circle timer
extension QuestionnaireViewController {
    private func circleShadow() {
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
    
    private func circle(strokeEnd: CGFloat) {
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
    
    private func animationTimeElapsed() {
        let timer = seconds()
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 0
        animation.duration = CFTimeInterval(timer)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
    
    private func animationTimeReset() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = CFTimeInterval(0.4)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animation")
    }
}
// MARK: - Setup progress view
extension QuestionnaireViewController {
    private func setupProgressView() -> UIProgressView {
        let progressView = UIProgressView()
        progressView.layer.cornerRadius = radius()
        progressView.clipsToBounds = true
        progressView.progressTintColor = .white
        progressView.trackTintColor = .white.withAlphaComponent(0.3)
        progressView.progress = 0
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }
}
// MARK: - Setup image view
extension QuestionnaireViewController {
    private func setupImageView(image: String) -> UIImageView {
        let image = UIImage(named: image)
        let imageView = UIImageView()
        imageView.image = image
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func setupImage(image: String) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
// MARK: - Setup stack view
extension QuestionnaireViewController {
    private func setupStackView(buttonFirst: UIButton, buttonSecond: UIButton,
                                buttonThird: UIButton, buttonFourth: UIButton) -> UIStackView {
        let stackView = UIStackView(
            arrangedSubviews: [buttonFirst, buttonSecond, buttonThird, buttonFourth])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Setup constraints
extension QuestionnaireViewController {
    private func setupConstraints() {
        setupSquare(subview: buttonBack, sizes: 40)
        
        if mode.timeElapsed.timeElapsed {
            constraintsTimer()
            constraintsProgressView(layout: labelTimer.bottomAnchor, constant: 30)
        } else {
            constraintsProgressView(layout: view.topAnchor, constant: 100)
        }
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func constraintsTimer() {
        NSLayoutConstraint.activate([
            labelTimer.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            labelTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func constraintsProgressView(layout: NSLayoutYAxisAnchor, constant: CGFloat) {
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: layout, constant: constant),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            progressView.heightAnchor.constraint(equalToConstant: radius() * 2)
        ])
    }
    
    private func setupSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    private func constraintsOnButton(label: UILabel, image: UIImageView,
                                     button: UIButton) {
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 30),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -20)
        ])
    }
    
    private func constraintsImage(image: UIImageView, constant: CGFloat) {
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: constant),
            image.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: 200),
            image.heightAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    private func sizeForQuestions() -> CGFloat {
        CGFloat(questions.questions.count * 150) - 655
    }
    
    private func radius() -> CGFloat {
        6
    }
}
