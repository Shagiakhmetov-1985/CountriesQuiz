//
//  ResultsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 25.01.2023.
//

import UIKit

class ResultsViewController: UIViewController {
    private lazy var labelResults: UILabel = {
        let label = setLabel(
            title: "Результаты",
            size: 35,
            color: .blueBlackSea)
        return label
    }()
    
    private lazy var viewCurrentQuestions: UIView = {
        let view = setView(
            color: .greenHarlequin,
            image: imageCurrentQuestions,
            labelFirst: labelCurrentQuestions,
            labelSecond: labelNumberQuestions)
        return view
    }()
    
    private lazy var imageCurrentQuestions: UIImageView = {
        let image = setImage(
            image: "checkmark",
            size: 26)
        return image
    }()
    
    private lazy var labelCurrentQuestions: UILabel = {
        let label = setLabel(
            title: "Правильные ответы",
            size: 19,
            color: .white)
        return label
    }()
    
    private lazy var labelNumberQuestions: UILabel = {
        let label = setLabel(
            title: "\(countries.count - results.count)",
            size: 35,
            color: .white)
        return label
    }()
    
    private lazy var viewWrongQuestions: UIView = {
        let view = setView(
            color: .redTangerineTango,
            image: imageWrongQuestions,
            labelFirst: labelWrongQuestions,
            labelSecond: labelNumberWrongQuestions)
        return view
    }()
    
    private lazy var imageWrongQuestions: UIImageView = {
        let image = setImage(
            image: "multiply",
            size: 26)
        return image
    }()
    
    private lazy var labelWrongQuestions: UILabel = {
        let label = setLabel(
            title: "Неправильные ответы",
            size: 19,
            color: .white)
        return label
    }()
    
    private lazy var labelNumberWrongQuestions: UILabel = {
        let label = setLabel(
            title: "\(results.count)",
            size: 35,
            color: .white)
        return label
    }()
    
    private lazy var viewTimeSpend: UIView = {
        let view = setView(
            color: .blueMiddlePersian,
            image: imageTimeSpend,
            labelFirst: labelTimeSpend,
            labelSecond: labelNumberTimeSpend,
            imageInfinity: imageInfinity)
        return view
    }()
    
    private lazy var imageTimeSpend: UIImageView = {
        let image = setImage(
            image: "\(imageTimeElapsedOnOff())",
            size: 26)
        return image
    }()
    
    private lazy var labelTimeSpend: UILabel = {
        let label = setLabel(
            title: "\(labelTimeElapsedOnOff())",
            size: 19,
            color: .white)
        return label
    }()
    
    private lazy var labelNumberTimeSpend: UILabel = {
        let label = setLabel(
            title: "\(numberTimeElapsedOnOff())",
            size: 35,
            color: .white)
        return label
    }()
    
    private lazy var imageInfinity: UIImageView = {
        let imageView = setImage(
            image: "infinity",
            size: 45)
        return imageView
    }()
    
    private lazy var viewCountQuestions: UIView = {
        let view = setView(
            color: .gummigut,
            image: imageCountQuestions,
            labelFirst: labelCountQuestions,
            labelSecond: labelNumberCountQuestions)
        return view
    }()
    
    private lazy var imageCountQuestions: UIImageView = {
        let image = setImage(
            image: "questionmark.bubble",
            size: 26)
        return image
    }()
    
    private lazy var labelCountQuestions: UILabel = {
        let label = setLabel(
            title: "Количество вопросов",
            size: 19,
            color: .white)
        return label
    }()
    
    private lazy var labelNumberCountQuestions: UILabel = {
        let label = setLabel(
            title: "\(mode.countQuestions)",
            size: 35,
            color: .white)
        return label
    }()
    
    private lazy var buttonComplete: UIButton = {
        let button = setButton()
        return button
    }()
    
    var results: [Results]!
    var countries: [Countries]!
    var mode: Setting!
    var spendTime: [CGFloat]!
    
    private var views: [UIView] = []
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupSubviews()
        setupTimer()
        setConstraints()
    }
    
    private func setupDesign() {
        view.backgroundColor = .skyCyanLight
        navigationItem.hidesBackButton = true
        imageInfinity.isHidden = timeElapsedCheck() ? true : false
    }
    
    private func setupSubviews() {
        setupSubviews(subviews: labelResults, viewCurrentQuestions,
                      viewWrongQuestions, viewTimeSpend, viewCountQuestions,
                      buttonComplete,
                      on: view)
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 0.3, target: self, selector: #selector(circleCurrentQuestions),
            userInfo: nil, repeats: false)
    }
    
    @objc private func circleCurrentQuestions() {
        timer.invalidate()
        let delay = CGFloat(countries.count - results.count) * 0.2
        let currentQuestions = CGFloat(countries.count - results.count)
        let value = currentQuestions / CGFloat(countries.count)
        setCircle(color: .greenHarlequin, radius: 90, value: value, duration: delay)
        timer = Timer.scheduledTimer(
            timeInterval: delay, target: self, selector: #selector(circleWrongQuestions),
            userInfo: nil, repeats: false)
    }
    
    @objc private func circleWrongQuestions() {
        timer.invalidate()
        let delay = CGFloat(results.count) * 0.2
        let wrongQuestions = CGFloat(results.count)
        let value = wrongQuestions / CGFloat(countries.count)
        setCircle(color: .redTangerineTango, radius: 57, value: value, duration: delay)
        timer = Timer.scheduledTimer(
            timeInterval: delay, target: self, selector: #selector(circleSpendTime),
            userInfo: nil, repeats: false)
    }
    
    @objc private func circleSpendTime() {
        timer.invalidate()
        let timeForQuestion = oneQuestionSeconds()
        let averageTime = spendTime.reduce(0.0, +) / CGFloat(spendTime.count)
        let delay = averageTime * 0.2
        let value = averageTime / CGFloat(timeForQuestion)
        setCircle(color: .blueMiddlePersian, radius: 24, value: value, duration: delay)
    }
    
    private func oneQuestionSeconds() -> Int {
        let seconds: Int
        if oneQuestionCheck() {
            seconds = mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
        } else {
            seconds = mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
        }
        return seconds
    }
    
    private func oneQuestionCheck() -> Bool {
        mode.timeElapsed.questionSelect.oneQuestion ? true : false
    }
    
    private func timeElapsedCheck() -> Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    
    private func labelTimeElapsedOnOff() -> String {
        timeElapsedCheck() ? "\(labelCheckTimeSpend())" : "Обратный отсчет выключен"
    }
    
    private func labelCheckTimeSpend() -> String {
        oneQuestionCheck() ? "Среднее время на вопрос" : labelCheckAllQuestions()
    }
    
    private func labelCheckAllQuestions() -> String {
        spendTime.isEmpty ? "Вы не успели ответить за это время" :
        "Потраченное время на все вопросы"
    }
    
    private func imageTimeElapsedOnOff() -> String {
        timeElapsedCheck() ? "\(imageCheckTimeSpend())" : "clock.badge.xmark"
    }
    
    private func imageCheckTimeSpend() -> String {
        oneQuestionCheck() ? "timer" : imageCheckAllQuestions()
    }
    
    private func imageCheckAllQuestions() -> String {
        spendTime.isEmpty ? "clock" : "timer"
    }
    
    private func numberTimeElapsedOnOff() -> String {
        timeElapsedCheck() ? "\(numberCheckTimeSpend())" : ""
    }
    
    private func numberCheckTimeSpend() -> String {
        var text: String
        if oneQuestionCheck() {
            let averageTime = spendTime.reduce(0.0, +) / CGFloat(spendTime.count)
            let roundingTime = round(100 * averageTime) / 100
            text = "\(roundingTime)"
        } else {
            text = numberCheckAllQuestions()
        }
        return text
    }
    
    private func numberCheckAllQuestions() -> String {
        var text: String
        if spendTime.isEmpty {
            text = "-"
        } else {
            let spendTime = spendTime.first ?? 0
            let roundingTime = round(100 * spendTime) / 100
            text = "\(roundingTime)"
        }
        return text
    }
    /*
    private func checkResults() {
        if !results.isEmpty {
            showWrongAnswers()
        } else {
            showCongratulation()
        }
    }
    
    private func showWrongAnswers() {
        let labelStats = setLabel(
            title: """
            Всего вопросов: \(countries.count)
            \(checkAnswers())
            \(checkSpendTime())
            """,
            size: 23,
            style: "mr_fontick",
            color: UIColor(
                red: 214/255,
                green: 245/255,
                blue: 214/255,
                alpha: 1),
            colorOfShadow: UIColor(
                red: 51/255,
                green: 83/255,
                blue: 51/255,
                alpha: 1).cgColor,
            radiusOfShadow: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2,
            textAlignment: .left)
        
        views.append(labelStats)
        
        results.forEach { result in
            let view = setViewForResults()
            
            let label = setLabelForResults(text: result.currentQuestion, tag: 1)
            
            let imageFlag = setImageFlagForResults(imageFlag: result.question.flag)
            
            let buttonFirst = setButtonForResults(
                question: result.question, answer: result.buttonFirst, tag: 1, select: result.tag)
            let buttonSecond = setButtonForResults(
                question: result.question, answer: result.buttonSecond, tag: 2, select: result.tag)
            let buttonThird = setButtonForResults(
                question: result.question, answer: result.buttonThird, tag: 3, select: result.tag)
            let buttonFourth = setButtonForResults(
                question: result.question, answer: result.buttonFourth, tag: 4, select: result.tag)
            
            if result.timeUp {
                let labelTimeUp = setLabelForResults(tag: 2)
                
                setupSubviewsOnView(view: view, subviews: label, imageFlag, buttonFirst,
                                    buttonSecond, buttonThird, buttonFourth, labelTimeUp)
                setConstraintsOnView(view: view, label: label, imageFlag: imageFlag,
                                     buttonFirst: buttonFirst, buttonSecond: buttonSecond,
                                     buttonThird: buttonThird, buttonFourth: buttonFourth,
                                     labelTimeUp: labelTimeUp)
            } else {
                setupSubviewsOnView(view: view, subviews: label, imageFlag, buttonFirst,
                                    buttonSecond, buttonThird, buttonFourth)
                setConstraintsOnView(view: view, label: label, imageFlag: imageFlag,
                                     buttonFirst: buttonFirst, buttonSecond: buttonSecond,
                                     buttonThird: buttonThird, buttonFourth: buttonFourth)
            }
            
            views.append(view)
        }
    }
    
    private func checkAnswers() -> String {
        var text = String()
        
        if oneQuestionCheck() {
            text = """
            Правильных ответов: \(countries.count - results.count)
            Неправильных ответов: \(results.count)
            """
        } else {
            text = checkAnswersTime()
        }
        
        return text
    }
    
    private func checkAnswersTime() -> String {
        var text = String()
        
        if spendTime.isEmpty {
            let wrongAnswers = countries.count - (results.last?.currentQuestion ?? 0) + 1
            let correctAnswers = countries.count - wrongAnswers
            text = """
            Правильных ответов: \(correctAnswers)
            Неправильных ответов: \(wrongAnswers)
            """
        } else {
            text = """
            Правильных ответов: \(countries.count - results.count)
            Неправильных ответов: \(results.count)
            """
        }
        
        return text
    }
    
    private func showCongratulation() {
        let labelOne = setLabel(
            title: "Поздравляем!",
            size: 24,
            style: "mr_fontick",
            color: UIColor(
                red: 214/255,
                green: 245/255,
                blue: 214/255,
                alpha: 1),
            colorOfShadow: UIColor(
                red: 51/255,
                green: 83/255,
                blue: 51/255,
                alpha: 1).cgColor,
            radiusOfShadow: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2,
            textAlignment: .center)
        
        let labelTwo = setLabel(
            title: """
            Вы ответили на все вопросы правильно!
            Всего вопросов: \(countries.count)
            \(checkSpendTime())
            """,
            size: 23,
            style: "mr_fontick",
            color: UIColor(
                red: 214/255,
                green: 245/255,
                blue: 214/255,
                alpha: 1),
            colorOfShadow: UIColor(
                red: 51/255,
                green: 83/255,
                blue: 51/255,
                alpha: 1).cgColor,
            radiusOfShadow: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2,
            textAlignment: .left)
        
        setupSubviews(subviews: labelOne, labelTwo)
        setConstraintsCongratulation(labelOne: labelOne, labelTwo: labelTwo)
    }
    
    private func checkSpendTime() -> String {
        var text = String()
        
        if oneQuestionCheck() {
            let averageTime = spendTime.reduce(0.0, +) / CGFloat(spendTime.count)
            text = "Среднее время потраченное на вопрос: \(string(seconds: averageTime)) секунд"
        } else {
            text = checkTime()
        }
        return text
    }
    
    private func checkTime() -> String {
        var text = String()
        
        if spendTime.isEmpty {
            text = "Вы не успели ответить на все вопросы за заданное время!"
        } else {
            let seconds = mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
            let spendTime = CGFloat(seconds) - (spendTime.first ?? 0)
            text = "На все вопросы вы потратили \(string(seconds: spendTime)) секунд"
        }
        
        return text
    }
    */
    private func string(seconds: CGFloat) -> String {
        String(format: "%.2f", seconds)
    }
    
    @objc private func resetGame() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func exitToMenu() {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Setup view
extension ResultsViewController {
    private func setView(color: UIColor, image: UIImageView, labelFirst: UILabel,
                         labelSecond: UILabel, imageInfinity: UIImageView? = nil) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        if let imageInfinity = imageInfinity {
            setupSubviews(subviews: image, labelFirst, labelSecond, imageInfinity, on: view)
        } else {
            setupSubviews(subviews: image, labelFirst, labelSecond, on: view)
        }
        return view
    }
    /*
    private func setView(color: UIColor? = nil, cornerRadius: CGFloat? = nil,
                         borderWidth: CGFloat? = nil, borderColor: UIColor? = nil,
                         shadowColor: UIColor? = nil, shadowRadius: CGFloat? = nil,
                         shadowOffsetWidth: CGFloat? = nil,
                         shadowOffsetHeight: CGFloat? = nil,
                         tag: Int? = nil) -> UIView {
        let view = UIView()
        view.layer.cornerRadius = cornerRadius ?? 0
        view.layer.borderWidth = borderWidth ?? 0
        view.layer.borderColor = borderColor?.cgColor
        view.layer.shadowColor = shadowColor?.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = shadowRadius ?? 0
        view.layer.shadowOffset = CGSize(width: shadowOffsetWidth ?? 0,
                                         height: shadowOffsetHeight ?? 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tag = tag ?? 0
        
        switch tag {
        case 1:
            view.backgroundColor = color
        case 2:
            setGradient(content: view)
        default:
            setGradientView(content: view)
        }
        
        return view
    }
    
    private func setGradient(content: UIView) {
        let gradientLayer = CAGradientLayer()
        let colorGreen = UIColor(red: 71/255, green: 160/255, blue: 36/255, alpha: 1)
        let colorLightGreen = UIColor(red: 103/255, green: 200/255, blue: 51/255, alpha: 1)
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [colorLightGreen.cgColor, colorGreen.cgColor]
        content.layer.addSublayer(gradientLayer)
    }
    
    private func setGradientView(content: UIView) {
        let gradientLayer = CAGradientLayer()
        let colorGreen = UIColor(red: 30/255, green: 113/255, blue: 204/255, alpha: 1)
        let colorLightGreen = UIColor(red: 102/255, green: 153/255, blue: 204/255, alpha: 1)
        gradientLayer.frame.size.width = setupWidthConstraint()
        gradientLayer.frame.size.height = heightViewConstraint()
        gradientLayer.cornerRadius = radiusView()
        gradientLayer.colors = [colorLightGreen.cgColor, colorGreen.cgColor]
        content.layer.addSublayer(gradientLayer)
    }
    
    private func setViewForResults() -> UIView {
        let view = setView(
            cornerRadius: radiusView(),
            shadowColor: UIColor(
                red: 54/255,
                green: 55/255,
                blue: 215/255,
                alpha: 1),
            shadowRadius: 3.5,
            shadowOffsetWidth: 3.5,
            shadowOffsetHeight: 3.5,
            tag: 3)
        return view
    }
    
    private func setButtonForResults(question: Countries, answer: Countries,
                                     tag: Int, select: Int) -> UIView {
        let view = setViewForLabel(question: question, answer: answer,
                                   tag: tag, select: select)
        
        let label = setLabel(
            title: answer.name,
            size: 15,
            style: "mr_fontick",
            color: textColor(question: question, answer: answer, tag: tag,
                             select: select),
            textAlignment: .center)
        
        view.addSubview(label)
        view.tag = tag
        
        setConstraintsForLabel(label: label, view: view)
        return view
    }
    
    private func setViewForLabel(question: Countries, answer: Countries,
                                 tag: Int, select: Int) -> UIView {
        let view = setView(
            color: backgroundColor(question: question, answer: answer, tag: tag,
                                   select: select),
            cornerRadius: 5,
            shadowColor: shadowColor(question: question, answer: answer, tag: tag,
                                     select: select),
            shadowRadius: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2,
            tag: 1)
        return view
    }
    */
    private func backgroundColor(question: Countries, answer: Countries,
                                 tag: Int, select: Int) -> UIColor {
        let lightGreen = UIColor(red: 152/255, green: 255/255, blue: 51/255, alpha: 1)
        let lightRed = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1)
        let lightGray = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        
        switch true {
        case question == answer && tag == select:
            return lightGreen
        case question == answer && !(tag == select):
            return lightGreen
        case !(question == answer) && tag == select:
            return lightRed
        default:
            return lightGray
        }
    }
    
    private func shadowColor(question: Countries, answer: Countries,
                             tag: Int, select: Int) -> UIColor {
        let darkGreen = UIColor(red: 51/255, green: 83/255, blue: 51/255, alpha: 1)
        let darkRed = UIColor(red: 113/255, green: 0, blue: 0, alpha: 1)
        let darkGray = UIColor(red: 72/255, green: 72/255, blue: 72/255, alpha: 1)
        
        switch true {
        case question == answer && tag == select:
            return darkGreen
        case question == answer && !(tag == select):
            return darkGreen
        case !(question == answer) && tag == select:
            return darkRed
        default:
            return darkGray
        }
    }
    
    private func textColor(question: Countries, answer: Countries,
                           tag: Int, select: Int) -> UIColor {
        let green = UIColor(red: 51/255, green: 133/255, blue: 51/255, alpha: 1)
        let red = UIColor(red: 153/255, green: 0, blue: 0, alpha: 1)
        let gray = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        
        switch true {
        case question == answer && tag == select:
            return green
        case question == answer && !(tag == select):
            return green
        case !(question == answer) && tag == select:
            return red
        default:
            return gray
        }
    }
}
// MARK: - Setup button
extension ResultsViewController {
    private func setButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Завершить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "mr_fontick", size: 25)
        button.backgroundColor = .blueBlackSea
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor.blueBlackSea.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(exitToMenu), for: .touchUpInside)
        return button
    }
}
// MARK: - Setup label
extension ResultsViewController {
    private func setLabel(title: String, size: CGFloat, color: UIColor) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "Gill Sans", size: size)
        label.textColor = color
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func setLabel(title: String, size: CGFloat, style: String,
                          color: UIColor, backgroundColor: UIColor? = nil,
                          radiusCorner: CGFloat? = nil, colorOfShadow: CGColor? = nil,
                          radiusOfShadow: CGFloat? = nil, shadowOffsetWidth: CGFloat? = nil,
                          shadowOffsetHeight: CGFloat? = nil, numberOfLines: Int? = nil,
                          textAlignment: NSTextAlignment? = nil,
                          opacity: Float? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: style, size: size)
        label.textColor = color
        label.layer.shadowColor = colorOfShadow
        label.layer.shadowRadius = radiusOfShadow ?? 0
        label.layer.shadowOpacity = 1
        label.layer.shadowOffset = CGSize(width: shadowOffsetWidth ?? 0,
                                          height: shadowOffsetHeight ?? 0)
        label.numberOfLines = numberOfLines ?? 0
        label.textAlignment = textAlignment ?? .natural
        label.layer.opacity = opacity ?? 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func setLabel(title: String, size: CGFloat, color: UIColor,
                          numberOfLines: Int? = nil,
                          textAlignment: NSTextAlignment? = nil,
                          opacity: Float? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "Gill Sans", size: size)
        label.textColor = color
        label.numberOfLines = numberOfLines ?? 0
        label.textAlignment = textAlignment ?? .natural
        label.layer.opacity = opacity ?? 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func setLabelForResults(text: Int? = nil, tag: Int) -> UILabel {
        let label = setLabel(
            title: title(text: text),
            size: size(tag: tag),
            style: "mr_fontick",
            color: titleColor(tag: tag),
            colorOfShadow: shadowColor(tag: tag),
            radiusOfShadow: 2,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2,
            textAlignment: .center)
        return label
    }
    
    private func title(text: Int? = nil) -> String {
        if let text = text {
            return "Вопрос \(text) из \(countries.count)"
        } else {
            return "Время вышло!"
        }
    }
    
    private func size(tag: Int) -> CGFloat {
        tag == 1 ? 25 : 20
    }
    
    private func titleColor(tag: Int) -> UIColor {
        tag == 1 ?
        UIColor(red: 153/255, green: 204/255, blue: 255/255, alpha: 1) :
        UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 1)
    }
    
    private func shadowColor(tag: Int) -> CGColor {
        tag == 1 ?
        UIColor(red: 54/255, green: 55/255, blue: 215/255, alpha: 1).cgColor :
        UIColor(red: 113/255, green: 0, blue: 0, alpha: 1).cgColor
    }
}
// MARK: - Setup images
extension ResultsViewController {
    private func setImageFlagForResults(imageFlag: String) -> UIImageView {
        let image = UIImageView()
        image.image = UIImage(named: imageFlag)
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor(
            red: 54/255,
            green: 55/255,
            blue: 215/255,
            alpha: 1).cgColor
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }
    
    private func setImage(image: String, size: CGFloat) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: size)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
// MARK: - Setup circle shapes
extension ResultsViewController {
    private func setCircle(color: UIColor, radius: CGFloat, value: CGFloat,
                           duration: CGFloat) {
        let center = CGPoint(x: view.frame.width / 2, y: 220)
        let endAngle = CGFloat.pi / 2
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -startAngle,
            endAngle: -endAngle,
            clockwise: true)
        
        let trackShape = CAShapeLayer()
        trackShape.path = circularPath.cgPath
        trackShape.lineWidth = 30
        trackShape.fillColor = UIColor.clear.cgColor
        trackShape.strokeEnd = 0
        trackShape.strokeColor = color.cgColor
        trackShape.lineCap = CAShapeLayerLineCap.round
        view.layer.addSublayer(trackShape)
        animateCircle(shape: trackShape, value: value, duration: duration)
    }
    
    private func animateCircle(shape: CAShapeLayer, value: CGFloat, duration: CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = value
        animation.duration = CFTimeInterval(duration)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        shape.add(animation, forKey: "animation")
    }
}
// MARK: - Setup constraints
extension ResultsViewController {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            labelResults.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -40),
            labelResults.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        constraintsView(subview: viewCurrentQuestions, layout: view.topAnchor,
                        leading: 20, trailing: -setConstraint(), constant: 350,
                        image: imageCurrentQuestions, labelFirst: labelCurrentQuestions,
                        labelSecond: labelNumberQuestions)
        constraintsView(subview: viewWrongQuestions, layout: view.topAnchor,
                        leading: setConstraint(), trailing: -20, constant: 350,
                        image: imageWrongQuestions, labelFirst: labelWrongQuestions,
                        labelSecond: labelNumberWrongQuestions)
        constraintsView(subview: viewTimeSpend, layout: viewCurrentQuestions.bottomAnchor,
                        leading: 20, trailing: -setConstraint(), constant: 20,
                        image: imageTimeSpend, labelFirst: labelTimeSpend,
                        labelSecond: labelNumberTimeSpend)
        NSLayoutConstraint.activate([
            imageInfinity.centerXAnchor.constraint(equalTo: labelNumberTimeSpend.centerXAnchor),
            imageInfinity.centerYAnchor.constraint(equalTo: labelNumberTimeSpend.centerYAnchor)
        ])
        constraintsView(subview: viewCountQuestions, layout: viewWrongQuestions.bottomAnchor,
                        leading: setConstraint(), trailing: -20, constant: 20,
                        image: imageCountQuestions, labelFirst: labelCountQuestions,
                        labelSecond: labelNumberCountQuestions)
        
        NSLayoutConstraint.activate([
            buttonComplete.topAnchor.constraint(equalTo: viewCountQuestions.bottomAnchor, constant: 50),
            buttonComplete.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonComplete.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonComplete.heightAnchor.constraint(equalToConstant: 55)
        ])
        /*
        NSLayoutConstraint.activate([
            viewPanel.topAnchor.constraint(equalTo: view.topAnchor),
            viewPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewPanel.heightAnchor.constraint(equalToConstant: fixConstraintsForViewPanelBySizeIphone())
        ])
        
        NSLayoutConstraint.activate([
            buttonBackMenu.widthAnchor.constraint(equalToConstant: view.frame.width - 265)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: viewPanel.bottomAnchor, constant: 1),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
         */
    }
    
    private func constraintsView(subview: UIView, layout: NSLayoutYAxisAnchor,
                                 leading: CGFloat, trailing: CGFloat,
                                 constant: CGFloat, image: UIImageView,
                                 labelFirst: UILabel, labelSecond: UILabel) {
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: layout, constant: constant),
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing),
            subview.heightAnchor.constraint(equalToConstant: 115)
        ])
        
        NSLayoutConstraint.activate([
            labelFirst.topAnchor.constraint(equalTo: subview.topAnchor, constant: 2.5),
            labelFirst.leadingAnchor.constraint(equalTo: subview.leadingAnchor, constant: 10),
            labelFirst.trailingAnchor.constraint(equalTo: subview.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: subview.centerXAnchor, constant: -45),
            image.centerYAnchor.constraint(equalTo: subview.centerYAnchor, constant: 32.5)
        ])
        
        NSLayoutConstraint.activate([
            labelSecond.centerXAnchor.constraint(equalTo: subview.centerXAnchor, constant: 30),
            labelSecond.centerYAnchor.constraint(equalTo: subview.centerYAnchor, constant: 32.5)
        ])
    }
    
    private func setConstraint() -> CGFloat {
        view.frame.width / 2 + 10
    }
    
    private func setupSquare(subview: UIView, sizes: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: sizes),
            subview.heightAnchor.constraint(equalToConstant: sizes)
        ])
    }
    
    private func setConstraintsForLabel(label: UILabel, view: UIView) {
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    /*
    private func setConstraintsOnView(
        view: UIView, label: UILabel, imageFlag: UIImageView, buttonFirst: UIView,
        buttonSecond: UIView, buttonThird: UIView, buttonFourth: UIView, labelTimeUp: UILabel? = nil) {
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.widthAnchor.constraint(equalToConstant: setupWidthConstraint())
            ])
            
            NSLayoutConstraint.activate([
                imageFlag.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 12),
                imageFlag.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageFlag.widthAnchor.constraint(equalToConstant: 180),
                imageFlag.heightAnchor.constraint(equalToConstant: 110)
            ])
            
            NSLayoutConstraint.activate([
                buttonFirst.topAnchor.constraint(equalTo: imageFlag.bottomAnchor, constant: 16),
                buttonFirst.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                buttonFirst.heightAnchor.constraint(equalToConstant: 22),
                buttonFirst.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                buttonFirst.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            ])
            
            NSLayoutConstraint.activate([
                buttonSecond.topAnchor.constraint(equalTo: buttonFirst.bottomAnchor, constant: 6),
                buttonSecond.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                buttonSecond.heightAnchor.constraint(equalToConstant: 22),
                buttonSecond.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                buttonSecond.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            ])
            
            NSLayoutConstraint.activate([
                buttonThird.topAnchor.constraint(equalTo: buttonSecond.bottomAnchor, constant: 6),
                buttonThird.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                buttonThird.heightAnchor.constraint(equalToConstant: 22),
                buttonThird.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                buttonThird.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            ])
            
            NSLayoutConstraint.activate([
                buttonFourth.topAnchor.constraint(equalTo: buttonThird.bottomAnchor, constant: 6),
                buttonFourth.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                buttonFourth.heightAnchor.constraint(equalToConstant: 22),
                buttonFourth.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                buttonFourth.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            ])
            
            if let labelTimeUp = labelTimeUp {
                NSLayoutConstraint.activate([
                    labelTimeUp.topAnchor.constraint(equalTo: buttonFourth.bottomAnchor, constant: 6),
                    labelTimeUp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    labelTimeUp.widthAnchor.constraint(equalToConstant: setupWidthConstraint())
                ])
            }
    }
    
    private func setConstraintsCongratulation(labelOne: UILabel, labelTwo: UILabel) {
        NSLayoutConstraint.activate([
            labelOne.topAnchor.constraint(equalTo: viewPanel.bottomAnchor, constant: 30),
            labelOne.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelOne.widthAnchor.constraint(equalToConstant: setupWidthConstraint())
        ])
        
        NSLayoutConstraint.activate([
            labelTwo.topAnchor.constraint(equalTo: labelOne.bottomAnchor, constant: 20),
            labelTwo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelTwo.widthAnchor.constraint(equalToConstant: setupWidthConstraint())
        ])
    }
    
    private func setConstraintsForView() {
        guard !views.isEmpty else { return }
        
        setupSubviewsOnContentView(subviews: scrollView)
        
        setConstraintsForLabelStats()
        
        var height: CGFloat = 0
        var multiplier: CGFloat = 2
        
        views.forEach { subview in
            setupSubviewsOnScrollView(subviews: subview)
            let constraint = heightLabelStatsConstraint() + 30 * multiplier + heightViewConstraint() * height
            
            constraints(subview: subview, constant: constraint)
            
            height += 1
            multiplier += 1
        }
    }
    
    private func setConstraintsForLabelStats() {
        if let labelStats = views.first {
            setupSubviewsOnScrollView(subviews: labelStats)
            
            constraints(subview: labelStats, constant: 20)
            
            views.removeFirst()
        }
    }
    
    private func constraints(subview: UIView, constant: CGFloat) {
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: constant),
            subview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subview.widthAnchor.constraint(equalToConstant: setupWidthConstraint())
        ])
    }
    
    private func fixConstraintsForViewPanelBySizeIphone() -> CGFloat {
        view.frame.height > 736 ? 110 : 70
    }
    
    private func fixConstraintsForButtonBySizeIphone() -> CGFloat {
        view.frame.height > 736 ? 60 : 30
    }
    
    private func setupWidthConstraint() -> CGFloat {
        view.frame.width - 60
    }
    
    private func heightViewConstraint() -> CGFloat {
        315
    }
    
    private func heightLabelStatsConstraint() -> CGFloat {
        115
    }
    
    private func heightConstraint() -> CGFloat {
        30 + heightLabelStatsConstraint()
    }
    
    private func radiusView() -> CGFloat {
        15
    }
    
    private func heightContentSize() -> CGFloat {
        let answers = CGFloat(views.count - 1)
        let multiplierOne: CGFloat = answers > 2 ? 1 : 0
        let multiplierTwo: CGFloat = answers > 2 ? answers - 2 : 0
        let multiplierThree: CGFloat = answers > 1 ? 1 : 0
        
        switch view.frame.height {
        case 667:
            return heightConstraint() + 30 * multiplierOne * multiplierTwo +
            315 * multiplierOne * multiplierTwo + 133 * multiplierThree
        case 736:
            return heightConstraint() + 30 * multiplierOne * multiplierTwo + 315 *
            multiplierOne * multiplierTwo + 64 * multiplierThree
        case 812:
            return heightConstraint() + 30 * multiplierOne * multiplierTwo + 315 *
            multiplierOne * multiplierTwo - 12
        case 844:
            return heightConstraint() + 30 * multiplierOne * multiplierTwo + 315 *
            multiplierOne * multiplierTwo - 44
        case 852:
            return heightConstraint() + 30 * multiplierOne * multiplierTwo + 315 *
            multiplierOne * multiplierTwo - 52
        case 896:
            return heightConstraint() + 30 * multiplierOne * multiplierTwo + 315 *
            multiplierOne * multiplierTwo - 96
        case 926:
            return heightConstraint() + 30 * multiplierOne * multiplierTwo + 315 *
            multiplierOne * multiplierTwo - 126
        case 932:
            return heightConstraint() + 30 * multiplierOne * multiplierTwo + 315 *
            multiplierOne * multiplierTwo - 132
        default:
            return heightConstraint() + 30 * multiplierOne * multiplierTwo + 315 *
            multiplierOne * multiplierTwo + 232 * multiplierThree
        }
    }
     */
}
