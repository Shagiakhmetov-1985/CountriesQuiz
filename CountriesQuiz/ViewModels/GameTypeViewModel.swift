//
//  GameTypeViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 07.03.2024.
//

import UIKit

protocol GameTypeViewModelProtocol {
    var setting: Setting { get }
    var setTag: Int { get }
    var countQuestions: Int { get }
    var countRows: Int { get }
    var countRowsDefault: Int { get }
    var countContinents: Int { get }
    
    var allCountries: Bool { get }
    var americaContinent: Bool { get }
    var europeContinent: Bool { get }
    var africaContinent: Bool { get }
    var asiaContinent: Bool { get }
    var oceaniaContinent: Bool { get }
    
    var background: UIColor { get }
    var colorPlay: UIColor { get }
    var colorFavourite: UIColor { get }
    var colorSwap: UIColor { get }
    var colorDone: UIColor { get }
    var image: String { get }
    var name: String { get }
    var gameType: TypeOfGame { get }
    
    var diameter: CGFloat { get }
    
    var countAllCountries: Int { get }
    var countCountriesOfAmerica: Int { get }
    var countCountriesOfEurope: Int { get }
    var countCountriesOfAfrica: Int { get }
    var countCountriesOfAsia: Int { get }
    var countCountriesOfOceania: Int { get }
    
    init(mode: Setting, game: Games, tag: Int)
    
    func numberOfComponents() -> Int
    func numberOfRows(_ pickerView: UIPickerView) -> Int
    
    func titles(_ pickerView: UIPickerView,_ row: Int, and segmented: UISegmentedControl) -> UIView
    func swap(_ button: UIButton)
    
    func titleSetting(tag: Int) -> String
    func isCountdown() -> Bool
    func isOneQuestion() -> Bool
    func oneQuestionTime() -> Int
    func allQuestionsTime() -> Int
    func isQuestionnaire() -> Bool
    
    func isCheckmark(isOn: Bool) -> String
    func imageMode() -> String
    func isEnabled() -> Bool
    
    func barButtonsOnOff(_ buttonBack: UIButton,_ buttonHelp: UIButton, bool: Bool)
    
    func width(_ view: UIView) -> CGFloat
    func size() -> CGFloat
    
    func comma() -> String
    func countdownOnOff() -> String
    func checkTimeDescription() -> String
    
    func isSelect(isOn: Bool) -> UIColor
    func setCountContinents(_ count: Int)
    
    func setupSubviews(subviews: UIView..., on subviewOther: UIView)
    func removeSubviews(subviews: UIView...)
    func setupBarButtons(_ buttonBack: UIButton,_ buttonHelp: UIButton,_ navigationItem: UINavigationItem)
    func setPickerViewCountQuestions(_ pickerView: UIPickerView,_ view: UIView)
    func setColors(buttons: UIButton..., completion: @escaping ([UIColor]) -> Void)
    func setLabels(_ labels: UILabel..., and countLabels: UILabel..., colors: [UIColor])
    func setButtonCheckmarkCountdown(_ stackView: UIStackView,_ view: UIView,_ button: UIButton)
    func setPickerViewsTime(_ stackView: UIStackView,_ view: UIView,_ segmentedControl: UISegmentedControl)
    func setPickerViewsTime(_ pickerViewOneTime: UIPickerView,_ pickerViewAllTime: UIPickerView)
    func segmentSelect(_ segment: UISegmentedControl,_ pickerViewOne: UIPickerView,_ pickerViewAll: UIPickerView,_ label: UILabel)
    func counterContinents()
    func setSubviewsTag(subviews: UIView..., tag: Int)
    func viewHelp(_ view: UIView) -> UIView
    func viewSetting() -> UIView
    func addSubviewsForViewSetting(_ tag: Int)
    
    func buttonAllCountries(_ buttonAllCountries: UIButton,_ labelAllCountries: UILabel,
                            _ labelCountCountries: UILabel,_ colorButton: UIColor,_ colorLabel: UIColor)
    func buttonContinents(_ buttons: UIButton...,and labels: UILabel...,and colorButton: UIColor,_ colorLabel: UIColor)
    func colorButtonContinent(_ sender: UIButton)
    func labelOnOff(_ labels: UILabel...,and color: UIColor)
    func checkmarkOnOff(_ button: UIButton)
    
    func setQuestions(_ pickerView: UIPickerView,_ labelQuestions: UILabel,_ labelTime: UILabel, completion: @escaping () -> Void)
    func setContinents(_ labelContinents: UILabel,_ labelQuestions: UILabel,_ pickerView: UIPickerView,
                   _ buttons: UIButton..., completion: @escaping () -> Void)
    func setCountdown(_ buttonCheckmark: UIButton,_ labelCountdown: UILabel,_ imageInfinity: UIImageView,
                      _ labelTime: UILabel,_ buttonTime: UIButton, completion: @escaping () -> Void)
    func setTime(_ segment: UISegmentedControl,_ labelTime: UILabel,_ labelDescription: UILabel,
                 _ pickerViewOne: UIPickerView,_ pickerViewAll: UIPickerView, completion: @escaping () -> Void)
    
    func setSquare(subviews: UIView..., sizes: CGFloat)
    func setCenterSubview(subview: UIView, on subviewOther: UIView)
    func setSize(subview: UIView, width: CGFloat, height: CGFloat)
    func setConstraints(_ button: UIButton, layout: NSLayoutYAxisAnchor, leading: CGFloat,
                        trailing: CGFloat, height: CGFloat,_ view: UIView)
    func setConstraints(_ label: UILabel, on button: UIButton, constant: CGFloat)
    func setConstraints(_ button: UIButton,_ view: UIView)
    func setConstraints(_ viewHelp: UIView,_ view: UIView)
    
    func quizOfFlagsViewModel() -> QuizOfFlagsViewModelProtocol
    func questionnaireViewModel() -> QuestionnaireViewModelProtocol
    func quizOfCapitalsViewModel() -> QuizOfCapitalsViewModelProtocol
}

class GameTypeViewModel: GameTypeViewModelProtocol {
    typealias ParagraphData = (bullet: String, paragraph: String)
    
    var setting: Setting {
        mode
    }
    var setTag: Int {
        tag
    }
    var countQuestions: Int {
        mode.countQuestions
    }
    var countRows: Int {
        mode.countRows
    }
    var countRowsDefault = DefaultSetting.countRows.rawValue
    var countContinents = 0
    var allCountries: Bool {
        mode.allCountries
    }
    var americaContinent: Bool {
        mode.americaContinent
    }
    var europeContinent: Bool {
        mode.europeContinent
    }
    var africaContinent: Bool {
        mode.africaContinent
    }
    var asiaContinent: Bool {
        mode.asiaContinent
    }
    var oceaniaContinent: Bool {
        mode.oceaniaContinent
    }
    var background: UIColor {
        game.background
    }
    var colorPlay: UIColor {
        game.play
    }
    var colorFavourite: UIColor {
        game.favourite
    }
    var colorSwap: UIColor {
        game.swap
    }
    var colorDone: UIColor {
        game.done
    }
    var diameter: CGFloat = 100
    var image: String {
        game.image
    }
    var name: String {
        game.name
    }
    var gameType: TypeOfGame {
        game.gameType
    }
    
    var countAllCountries = FlagsOfCountries.shared.countries.count
    var countCountriesOfAmerica = FlagsOfCountries.shared.countriesOfAmericanContinent.count
    var countCountriesOfEurope = FlagsOfCountries.shared.countriesOfEuropeanContinent.count
    var countCountriesOfAfrica = FlagsOfCountries.shared.countriesOfAfricanContinent.count
    var countCountriesOfAsia = FlagsOfCountries.shared.countriesOfAsianContinent.count
    var countCountriesOfOceania = FlagsOfCountries.shared.countriesOfOceanContinent.count
    
    private var mode: Setting
    private let game: Games
    private let tag: Int
    
    private var title: UILabel!
    private var description: UILabel!
    private var list: UILabel!
    private var contentView: UIView!
    private var scrollView: UIScrollView!
    
    required init(mode: Setting, game: Games, tag: Int) {
        self.mode = mode
        self.game = game
        self.tag = tag
    }
    // MARK: - Set subviews
    func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    func removeSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
    
    func setupBarButtons(_ buttonBack: UIButton, _ buttonHelp: UIButton, _ navigationItem: UINavigationItem) {
        let leftBarButton = UIBarButtonItem(customView: buttonBack)
        let rightBarButton = UIBarButtonItem(customView: buttonHelp)
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func viewHelp(_ view: UIView) -> UIView {
        let popUpView = setView()
        addSubviewsForPopUpView()
        setupSubviews(subviews: title, scrollView, on: popUpView)
        setConstraints(popUpView, and: view)
        return popUpView
    }
    
    func viewSetting() -> UIView {
        setView()
    }
    
    func addSubviewsForViewSetting(_ tag: Int) {
        <#code#>
    }
    // MARK: - PickerView
    func numberOfComponents() -> Int {
        1
    }
    
    func numberOfRows(_ pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 1: countRows
        case 2: 10
        default: 6 * mode.countQuestions - 4 * mode.countQuestions + 1
        }
    }
    
    func titles(_ pickerView: UIPickerView, _ row: Int, and segmented: UISegmentedControl) -> UIView {
        let label = UILabel()
        let tag = pickerView.tag
        var title = String()
        var attributed = NSAttributedString()
        
        switch tag {
        case 1:
            title = "\(row + 10)"
            attributed = setAttributed(title: title, tag: tag, segmented: segmented)
        case 2:
            title = "\(row + 6)"
            attributed = setAttributed(title: title, tag: tag, segmented: segmented)
        default:
            title = "\(row + 4 * mode.countQuestions)"
            attributed = setAttributed(title: title, tag: tag, segmented: segmented)
        }
        
        label.textAlignment = .center
        label.attributedText = attributed
        return label
    }
    // MARK: - Constants
    func imageMode() -> String {
        switch tag {
        case 0, 1, 4: return mode.flag ? "flag" : "building"
        case 2: return "globe.europe.africa"
        default: return scrabbleType()
        }
    }
    
    func isEnabled() -> Bool {
        tag == 2 ? false : true
    }
    
    func isCountdown() -> Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    
    func isOneQuestion() -> Bool {
        mode.timeElapsed.questionSelect.oneQuestion
    }
    
    func oneQuestionTime() -> Int {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
    }
    
    func allQuestionsTime() -> Int {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
    }
    
    func isCheckmark(isOn: Bool) -> String {
        isOn ? "checkmark.circle.fill" : "circle"
    }
    
    func isSelect(isOn: Bool) -> UIColor {
        isOn ? background : .white
    }
    
    func isQuestionnaire() -> Bool {
        gameType == .questionnaire ? false : true
    }
    
    func titleSetting(tag: Int) -> String {
        switch tag {
        case 1: return "Количество вопросов"
        case 2: return "Континенты"
        case 3: return "Обратный отсчет"
        default: return checkTimeDescription()
        }
    }
    
    func comma() -> String {
        comma(continents: allCountries, americaContinent, europeContinent,
              africaContinent, asiaContinent, oceaniaContinent)
    }
    
    func countdownOnOff() -> String {
        isCountdown() ? "\(checkCountdownType())" : ""
    }
    
    func checkTimeDescription() -> String {
        isOneQuestion() ? "\(checkTitleGameType())" : "Время всех вопросов"
    }
    
    func width(_ view: UIView) -> CGFloat {
        view.frame.width / 2 + 10
    }
    
    func size() -> CGFloat {
        switch tag {
        case 0, 4: 1.4
        case 1: 1.55
        case 2: 1.15
        default: 1.65
        }
    }
    // MARK: - Show / hide bar buttons
    func barButtonsOnOff(_ buttonBack: UIButton,_ buttonHelp: UIButton, bool: Bool) {
        let opacity: Float = bool ? 1 : 0
        isEnabled(buttons: buttonBack, buttonHelp, bool: bool)
        setupOpacityButtons(buttons: buttonBack, buttonHelp, opacity: opacity)
    }
    // MARK: - Press swap button of setting
    func swap(_ button: UIButton) {
        switch tag {
        case 0, 1, 4: GameTypeFirst(button: button)
        default: GameTypeSecond(button: button)
        }
    }
    // MARK: - Set change setting
    func setCountContinents(_ count: Int) {
        if count == 0 {
            countContinents = 0
        } else {
            countContinents += count
        }
    }
    // MARK: - Set popup view controller
    func setPickerViewCountQuestions(_ pickerView: UIPickerView,_ view: UIView) {
        let row = countQuestions - 10
        setupSubviews(subviews: pickerView, on: view)
        pickerView.selectRow(row, inComponent: 0, animated: false)
    }
    
    func counterContinents() {
        counterContinents(continents: americaContinent, europeContinent,
                          africaContinent, asiaContinent, oceaniaContinent)
    }
    
    func setSubviewsTag(subviews: UIView..., tag: Int) {
        subviews.forEach { subview in
            subview.tag = tag
        }
    }
    
    func setColors(buttons: UIButton..., completion: @escaping ([UIColor]) -> Void) {
        var colors: [UIColor] = []
        buttons.forEach { button in
            let color = checkBool(tag: button.tag, button: button)
            buttonOnOff(buttons: button, color: color.0)
            colors.append(color.1)
        }
        completion(colors)
    }
    
    func setLabels(_ labels: UILabel..., and countLabels: UILabel..., colors: [UIColor]) {
        let iterration = min(labels.count, countLabels.count, colors.count)
        for index in 0..<iterration {
            labelOnOff(labels[index], countLabels[index], and: colors[index])
        }
    }
    
    func setButtonCheckmarkCountdown(_ stackView: UIStackView, _ view: UIView, _ button: UIButton) {
        setupSubviews(subviews: stackView, on: view)
        checkButtonCheckmark(button: button)
    }
    
    func setPickerViewsTime(_ stackView: UIStackView, _ view: UIView, _ segmentedControl: UISegmentedControl) {
        setupSubviews(subviews: stackView, on: view)
        setSegmentIndex(segmentedControl: segmentedControl)
    }
    
    func setPickerViewsTime(_ pickerViewOneTime: UIPickerView, _ pickerViewAllTime: UIPickerView) {
        isOneQuestion() ? checkQuestionnaire(pickerViewOneTime, pickerViewAllTime) :
        pickerViewThirdOn(pickerViewOneTime, pickerViewAllTime)
        setPickerViewsRows(pickerViewOneTime, pickerViewAllTime)
        reloadPickerViews(pickerViews: pickerViewOneTime, pickerViewAllTime)
    }
    
    func segmentSelect(_ segment: UISegmentedControl, _ pickerViewOne: UIPickerView, 
                       _ pickerViewAll: UIPickerView, _ label: UILabel) {
        let index = segment.selectedSegmentIndex
        index == 0 ? pickerViewSecondOn(pickerViewOne, pickerViewAll) : pickerViewThirdOn(pickerViewOne, pickerViewAll)
        label.text = index == 1 ? "Время всех вопросов" : "Время одного вопроса"
        reloadPickerViews(pickerViews: pickerViewOne, pickerViewAll)
    }
    // MARK: - Button press continents
    func buttonAllCountries(_ buttonAllCountries: UIButton, _ labelAllCountries: UILabel, 
                            _ labelCountCountries: UILabel, _ colorButton: UIColor, _ colorLabel: UIColor) {
        buttonOnOff(buttons: buttonAllCountries, color: colorButton)
        labelOnOff(labelAllCountries, labelCountCountries, and: colorLabel)
    }
    
    func buttonContinents(_ buttons: UIButton..., and labels: UILabel..., 
                          and colorButton: UIColor, _ colorLabel: UIColor) {
        setColorButton(buttons: buttons, color: colorButton)
        setColorLabel(labels: labels, color: colorLabel)
    }
    
    func colorButtonContinent(_ sender: UIButton) {
        let color = sender.backgroundColor == background ? .white : background
        buttonOnOff(buttons: sender, color: color)
    }
    
    func labelOnOff(_ labels: UILabel...,and color: UIColor) {
        labels.forEach { label in
            UIView.animate(withDuration: 0.3) {
                label.textColor = color
            }
        }
    }
    // MARK: - Button press checkmark
    func checkmarkOnOff(_ button: UIButton) {
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        let currentImage = button.currentImage?.withConfiguration(size)
        let imageCircle = UIImage(systemName: "circle", withConfiguration: size)
        let imageCheckmark = UIImage(systemName: "checkmark.circle.fill", withConfiguration: size)
        let image = currentImage == imageCircle ? imageCheckmark : imageCircle
        button.setImage(image, for: .normal)
    }
    // MARK: - Press done for change setting, count questions
    func setQuestions(_ pickerView: UIPickerView, _ labelQuestions: UILabel,
                      _ labelTime: UILabel, completion: @escaping () -> Void) {
        let row = pickerView.selectedRow(inComponent: 0)
        setCountQuestions(row + 10)
        setTimeAllQuestions(time: 5 * countQuestions)
        setTitleCountQuestions("\(row + 10)", labelQuestions)
        setTitleTime(labelTime)
        completion()
    }
    // MARK: - Press done for change setting, continents
    func setContinents(_ labelContinents: UILabel, _ labelQuestions: UILabel,
                   _ pickerView: UIPickerView, _ buttons: UIButton..., completion: @escaping () -> Void) {
        setContinents(buttons: buttons)
        setCountRows(continents: allCountries, americaContinent, europeContinent,
                     africaContinent, asiaContinent, oceaniaContinent)
        setCountQuestions(countRows: countRows)
        setTitlesContinents(labelContinents, labelQuestions, pickerView)
        completion()
    }
    // MARK: - Press done for change setting, countdown
    func setCountdown(_ buttonCheckmark: UIButton, _ labelCountdown: UILabel, _ imageInfinity: UIImageView,
                      _ labelTime: UILabel, _ buttonTime: UIButton, completion: @escaping () -> Void) {
        setCheckmark(buttonCheckmark, labelCountdown)
        setTitlesCountdown(imageInfinity, labelTime)
        setButtonTime(buttonTime)
        completion()
    }
    // MARK: - Press done for change setting, time
    func setTime(_ segment: UISegmentedControl, _ labelTime: UILabel, _ labelDescription: UILabel, 
                 _ pickerViewOne: UIPickerView, _ pickerViewAll: UIPickerView, completion: @escaping () -> Void) {
        setSegmentedControl(segment)
        setDataFromPickerViews(pickerViewOne, pickerViewAll)
        setTitlesTime(labelTime, labelDescription)
        completion()
    }
    // MARK: - Transitions to other view controller
    func quizOfFlagsViewModel() -> QuizOfFlagsViewModelProtocol {
        QuizOfFlagsViewModel(mode: mode, game: game)
    }
    
    func questionnaireViewModel() -> QuestionnaireViewModelProtocol {
        QuestionnaireViewModel(mode: mode, game: game)
    }
    
    func quizOfCapitalsViewModel() -> QuizOfCapitalsViewModelProtocol {
        QuizOfCapitalsViewModel(mode: mode, game: game)
    }
    // MARK: - Constraints
    func setSquare(subviews: UIView..., sizes: CGFloat) {
        subviews.forEach { subview in
            NSLayoutConstraint.activate([
                subview.widthAnchor.constraint(equalToConstant: sizes),
                subview.heightAnchor.constraint(equalToConstant: sizes)
            ])
        }
    }
    
    func setCenterSubview(subview: UIView, on subviewOther: UIView) {
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: subviewOther.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: subviewOther.centerYAnchor)
        ])
    }
    
    func setSize(subview: UIView, width: CGFloat, height: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: width),
            subview.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func setConstraints(_ button: UIButton, layout: NSLayoutYAxisAnchor, leading: CGFloat,
                        trailing: CGFloat, height: CGFloat, _ view: UIView) {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: layout, constant: 20),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing),
            button.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func setConstraints(_ label: UILabel, on button: UIButton, constant: CGFloat) {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: constant),
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10)
        ])
    }
    
    func setConstraints(_ button: UIButton, _ view: UIView) {
        setSquare(subviews: button, sizes: 40)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 12.5),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12.5)
        ])
    }
    
    func setConstraints(_ viewHelp: UIView, _ view: UIView) {
        NSLayoutConstraint.activate([
            viewHelp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewHelp.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewHelp.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            viewHelp.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        ])
    }
}
// MARK: - Private methods, set bullet list
extension GameTypeViewModel {
    private func bulletsList(list: [String]) -> UILabel {
        let label = UILabel()
        let paragraphDataPairs: [ParagraphData] = bullets(list: list)
        let stringAttributes: [NSAttributedString.Key: Any] = [.font: label.font!]
        let bulletedAttributedString = makeBulletedAttributedString(
            paragraphDataPairs: paragraphDataPairs,
            attributes: stringAttributes)
        label.attributedText = bulletedAttributedString
        return label
    }
    
    private func bulletsListGameType() -> [String] {
        switch tag {
        case 0: return GameType.shared.bulletsQuizOfFlags
        case 1: return GameType.shared.bulletsQuestionnaire
        case 2: return GameType.shared.bulletsQuizOfMaps
        case 3: return GameType.shared.bulletsScrabble
        default: return GameType.shared.bulletsQuizOfCapitals
        }
    }
    
    private func bullets(list: [String]) -> [ParagraphData] {
        var paragraphData: [ParagraphData] = []
        list.forEach { text in
            let pair = ("➤ ", "\(text)")
            paragraphData.append(pair)
        }
        return paragraphData
    }
    
    private func makeBulletedAttributedString(
        paragraphDataPairs: [ParagraphData],
        attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let fullAttributedString = NSMutableAttributedString()
            paragraphDataPairs.forEach { paragraphData in
                let attributedString = makeBulletString(
                    bullet: paragraphData.bullet,
                    content: paragraphData.paragraph,
                    attributes: attributes)
                fullAttributedString.append(attributedString)
            }
        return fullAttributedString
    }
    
    private func makeBulletString(bullet: String, content: String,
                                  attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let formattedString: String = "\(bullet)\(content)\n"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(
            string: formattedString,
            attributes: attributes)
        
        let headerIndent = (bullet as NSString).size(withAttributes: attributes).width + 6
        attributedString.addAttributes([.paragraphStyle: makeParagraphStyle(headIndent: headerIndent)],
                                       range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    private func makeParagraphStyle(headIndent: CGFloat) -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = headIndent
        return paragraphStyle
    }
    // MARK: - Set subviews for view help
    private func addSubviewsForPopUpView() {
        title = setLabel(title: "Тип игры", size: 25)
        description = setLabel(title: game.description, size: 19, alignment: .left)
        list = setting(bulletsList(list: bulletsListGameType()), size: 19)
        contentView = setContentView(description, list)
        scrollView = setScrollView(contentView)
    }
    
    private func setContentView(_ description: UILabel, _ list: UILabel) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        setupSubviews(subviews: description, list, on: view)
        switch tag {
        case 0, 1, 4:
            let stackViews = gameTypeFirst()
            setupSubviews(subviews: stackViews.0, stackViews.1, on: view)
            setConstraintsFirst(stackViews.0, stackViews.1, view)
        case 2:
            let stackView = gameTypeSecond()
            setupSubviews(subviews: stackView, on: view)
            setConstraintSecond(stackView, view)
        default:
            let stackViews = gameTypeThird()
            setupSubviews(subviews: stackViews.0, stackViews.1, stackViews.2, on: view)
            setConstraintsThird(stackViews.0, stackViews.1, stackViews.2, view)
        }
        return view
    }
    
    private func topic(image: String, color: UIColor, title: String, 
                       description: String) -> UIStackView {
        let image = setImage(image: image, color: color)
        let view = setView(color: game.swap, addImage: image)
        let title = setLabel(title: title, size: 24, alignment: .left)
        let description = setLabel(title: description, size: 19, alignment: .left)
        let stackViewOne = setStackView(title, description)
        let stackViewTwo = setStackView(view, stackViewOne)
        setCenterSubview(subview: image, on: view)
        setSquare(subviews: view, sizes: 40)
        return stackViewTwo
    }
    
    private func gameTypeFirst() -> (UIStackView, UIStackView) {
        let stackViewOne = topic(image: imageFirst(), color: .white,
                                 title: titleFirst(), description: descriptionFirst())
        let stackViewTwo = topic(image: imageSecond(), color: .white,
                                 title: titleSecond(), description: descriptionSecond())
        return (stackViewOne, stackViewTwo)
    }
    
    private func gameTypeSecond() -> UIStackView {
        topic(image: imageFirst(), color: .white.withAlphaComponent(0.4),
              title: titleFirst(), description: descriptionFirst())
    }
    
    private func gameTypeThird() -> (UIStackView, UIStackView, UIStackView) {
        let stackViewOne = topic(image: imageFirst(), color: .white,
                                 title: titleFirst(), description: descriptionFirst())
        let stackViewTwo = topic(image: imageSecond(), color: .white,
                                 title: titleSecond(), description: descriptionSecond())
        let stackViewThree = topic(image: "building.2", color: .white,
                                   title: "Режим столицы", description: descriptionThird())
        return (stackViewOne, stackViewTwo, stackViewThree)
    }
    
    private func setConstraintsFirst(_ first: UIView, _ second: UIView, _ view: UIView) {
        setConstraints(subview: first, to: list, view)
        setConstraints(subview: second, to: first, view)
    }
    
    private func setConstraintSecond(_ first: UIView, _ view: UIView) {
        setConstraints(subview: first, to: list, view)
    }
    
    private func setConstraintsThird(_ first: UIView, _ second: UIView, 
                                     _ third: UIView, _ view: UIView) {
        setConstraints(subview: first, to: list, view)
        setConstraints(subview: second, to: first, view)
        setConstraints(subview: third, to: second, view)
    }
    
    private func setScrollView(_ contentView: UIView) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = game.background
        scrollView.layer.cornerRadius = 15
        scrollView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        return scrollView
    }
    // MARK: - Button change type game mode
    private func GameTypeFirst(button: UIButton) {
        mode.flag ? imageSwap("building", button) : imageSwap("flag", button)
        mode.flag.toggle()
        StorageManager.shared.saveSetting(setting: mode)
    }
    private func imageSwap(_ image: String, _ button: UIButton) {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        button.setImage(image, for: .normal)
    }
    
    private func GameTypeSecond(button: UIButton) {
        switch mode.scrabbleType {
        case 0: imageSwap("globe.europe.africa", mode.scrabbleType + 1, button)
        case 1: imageSwap("building.2", mode.scrabbleType + 1, button)
        default: imageSwap("flag", 0, button)
        }
    }
    
    private func imageSwap(_ image: String, _ scrabbleType: Int, _ button: UIButton) {
        imageSwap(image, button)
        mode.scrabbleType = scrabbleType
        StorageManager.shared.saveSetting(setting: mode)
    }
    // MARK: - Attributted for picker view
    private func setAttributed(title: String, tag: Int, segmented: UISegmentedControl) -> NSAttributedString {
        let color = tag == 1 ? game.favourite : color(tag: tag, segmented: segmented)
        return NSAttributedString(string: title, attributes: [
            .font: UIFont(name: "mr_fontick", size: 26) ?? "",
            .foregroundColor: color
        ])
    }
    
    private func color(tag: Int, segmented: UISegmentedControl) -> UIColor {
        switch segmented.selectedSegmentIndex {
        case 0:
            return tag == 2 ? game.favourite : .grayLight
        default:
            return tag == 2 ? .grayLight : game.favourite
        }
    }
    // MARK: - Show / hide bar buttons
    private func isEnabled(buttons: UIButton..., bool: Bool) {
        buttons.forEach { button in
            button.isEnabled = bool
        }
    }
    
    private func setupOpacityButtons(buttons: UIButton..., opacity: Float) {
        buttons.forEach { button in
            UIView.animate(withDuration: 0.5) {
                button.layer.opacity = opacity
            }
        }
    }
    // MARK: - Methods for popup view controller
    private func counterContinents(continents: Bool...) {
        setCountContinents(0)
        continents.forEach { continent in
            if continent {
                setCountContinents(1)
            }
        }
    }
    
    private func checkBool(tag: Int, button: UIButton) -> (UIColor, UIColor) {
        switch tag {
        case 0: checkBool(bool: allCountries, button: button)
        case 1: checkBool(bool: americaContinent, button: button)
        case 2: checkBool(bool: europeContinent, button: button)
        case 3: checkBool(bool: africaContinent, button: button)
        case 4: checkBool(bool: asiaContinent, button: button)
        default: checkBool(bool: oceaniaContinent, button: button)
        }
    }
    
    private func checkBool(bool: Bool, button: UIButton) -> (UIColor, UIColor) {
        bool ? (.white, background) : (background, .white)
    }
    
    private func buttonOnOff(buttons: UIButton..., color: UIColor) {
        buttons.forEach { button in
            UIView.animate(withDuration: 0.3) {
                button.backgroundColor = color
            }
        }
    }
    
    private func checkButtonCheckmark(button: UIButton) {
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        let symbol = isCountdown() ? "checkmark.circle.fill" : "circle"
        let image = UIImage(systemName: symbol, withConfiguration: size)
        button.setImage(image, for: .normal)
    }
    
    private func setSegmentIndex(segmentedControl: UISegmentedControl) {
        let index = gameType == .questionnaire ? 1 : 0
        segmentedControl.selectedSegmentIndex = isOneQuestion() ? index : 1
        segmentedControl.isUserInteractionEnabled = isQuestionnaire()
    }
    
    private func checkQuestionnaire(_ pickerViewOneTime: UIPickerView,_ pickerViewAllTime: UIPickerView) {
        tag == 1 ? pickerViewThirdOn(pickerViewOneTime, pickerViewAllTime) :
        pickerViewSecondOn(pickerViewOneTime, pickerViewAllTime)
    }
    
    private func pickerViewSecondOn(_ pickerViewOneTime: UIPickerView,_ pickerViewAllTime: UIPickerView) {
        setPickerView(pickerView: pickerViewOneTime, color: .white, isOn: true)
        setPickerView(pickerView: pickerViewAllTime, color: .skyGrayLight, isOn: false)
    }
    
    private func pickerViewThirdOn(_ pickerViewOneTime: UIPickerView,_ pickerViewAllTime: UIPickerView) {
        setPickerView(pickerView: pickerViewOneTime, color: .skyGrayLight, isOn: false)
        setPickerView(pickerView: pickerViewAllTime, color: .white, isOn: true)
    }
    
    private func setPickerView(pickerView: UIPickerView, color: UIColor, isOn: Bool) {
        pickerView.isUserInteractionEnabled = isOn
        UIView.animate(withDuration: 0.3) {
            pickerView.backgroundColor = color
        }
    }
    
    private func setPickerViewsRows(_ pickerViewOneTime: UIPickerView,_ pickerViewAllTime: UIPickerView) {
        let rowOneQuestion = oneQuestionTime() - 6
        let rowAllQuestions = allQuestionsTime() - 4 * countQuestions
        pickerViewOneTime.selectRow(rowOneQuestion, inComponent: 0, animated: false)
        pickerViewAllTime.selectRow(rowAllQuestions, inComponent: 0, animated: false)
    }
    
    private func reloadPickerViews(pickerViews: UIPickerView...) {
        pickerViews.forEach { pickerView in
            pickerView.reloadAllComponents()
        }
    }
    // MARK: - Button press continents
    private func setColorButton(buttons: [UIButton], color: UIColor) {
        buttons.forEach { button in
            buttonOnOff(buttons: button, color: color)
        }
    }
    
    private func setColorLabel(labels: [UILabel], color: UIColor) {
        labels.forEach { label in
            labelOnOff(label, and: color)
        }
    }
    // MARK: - Press done for change setting, count questions
    private func setTitleCountQuestions(_ title: String, _ labelQuestions: UILabel) {
        labelQuestions.text = title
    }
    
    private func setTitleTime(_ labelTime: UILabel) {
        labelTime.text = countdownOnOff()
    }
    // MARK: - Press done for change setting, continents
    private func setContinents(buttons: [UIButton]) {
        var counter = 0
        buttons.forEach { button in
            let bool = button.backgroundColor == .white ? true : false
            checkContinents(counter: counter, bool: bool)
            counter += 1
        }
    }
    
    private func checkContinents(counter: Int, bool: Bool) {
        switch counter {
        case 0: setAllCountries(bool)
        case 1: setAmericaContinent(bool)
        case 2: setEuropeContinent(bool)
        case 3: setAfricaContinent(bool)
        case 4: setAsiaContinent(bool)
        default: setOceaniaContinent(bool)
        }
    }
    
    private func setCountRows(continents: Bool...) {
        var countRows = 0
        var counter = 0
        continents.forEach { continent in
            if continent {
                countRows += checkContinents(continent: counter)
            }
            counter += 1
        }
        setCountRows(checkCountRows(count: countRows - 9))
    }
    
    private func checkContinents(continent: Int) -> Int {
        switch continent {
        case 0: countAllCountries
        case 1: countCountriesOfAmerica
        case 2: countCountriesOfEurope
        case 3: countCountriesOfAfrica
        case 4: countCountriesOfAsia
        default: countCountriesOfOceania
        }
    }
    
    private func checkCountRows(count: Int) -> Int {
        let countRows = countRowsDefault
        return count > countRows ? countRows : count
    }
    
    private func setCountQuestions(countRows: Int) {
        let count = countQuestions
        setCountQuestions(countRows + 9 < count ? countRows + 9 : count)
    }
    
    private func setTitlesContinents(_ labelContinents: UILabel,_ labelQuestions: UILabel,_ pickerView: UIPickerView) {
        labelContinents.text = comma()
        labelQuestions.text = "\(countQuestions)"
        reloadPickerViews(pickerViews: pickerView)
    }
    // MARK: - Press done for change setting, countdown
    private func setCheckmark(_ button: UIButton,_ label: UILabel) {
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        let currentImage = button.currentImage?.withConfiguration(size)
        let imageCircle = UIImage(systemName: "circle", withConfiguration: size)
        label.text = currentImage == imageCircle ? "Нет" : "Да"
        countdownOnOff(isOn: currentImage == imageCircle ? false : true)
    }
    
    private func setTitlesCountdown(_ image: UIImageView,_ label: UILabel) {
        image.isHidden = isCountdown()
        label.text = countdownOnOff()
    }
    
    private func setButtonTime(_ button: UIButton) {
        button.isEnabled = isCountdown()
        button.backgroundColor = isCountdown() ? colorSwap : .grayLight
    }
    // MARK: - Press done for change setting, time
    private func setSegmentedControl(_ segment: UISegmentedControl) {
        let isOn = segment.selectedSegmentIndex == 0 ? true : false
        oneQuestionOnOff(isOn: isOn)
    }
    
    private func setTitlesTime(_ labelTime: UILabel,_ labelDescription: UILabel) {
        labelTime.text = countdownOnOff()
        labelDescription.text = checkTimeDescription()
    }
    
    private func setDataFromPickerViews(_ pickerViewOne: UIPickerView,_ pickerViewAll: UIPickerView) {
        if isOneQuestion() {
            let row = pickerViewOne.selectedRow(inComponent: 0)
            setTimeOneQuestion(time: row + 6)
        } else {
            let row = pickerViewAll.selectedRow(inComponent: 0)
            setTimeAllQuestions(time: row + 4 * countQuestions)
        }
    }
}
// MARK: - Set change data
extension GameTypeViewModel {
    private func setCountQuestions(_ countQuestions: Int) {
        mode.countQuestions = countQuestions
    }
    
    private func setCountRows(_ countRows: Int) {
        mode.countRows = countRows
    }
    
    private func setAllCountries(_ bool: Bool) {
        mode.allCountries = bool
    }
    
    private func setAmericaContinent(_ bool: Bool) {
        mode.americaContinent = bool
    }
    
    private func setEuropeContinent(_ bool: Bool) {
        mode.europeContinent = bool
    }
    
    private func setAfricaContinent(_ bool: Bool) {
        mode.africaContinent = bool
    }
    
    private func setAsiaContinent(_ bool: Bool) {
        mode.asiaContinent = bool
    }
    
    private func setOceaniaContinent(_ bool: Bool) {
        mode.oceaniaContinent = bool
    }
    
    private func countdownOnOff(isOn: Bool) {
        mode.timeElapsed.timeElapsed = isOn
    }
    
    private func oneQuestionOnOff(isOn: Bool) {
        mode.timeElapsed.questionSelect.oneQuestion = isOn
    }
    
    private func setTimeOneQuestion(time: Int) {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime = time
    }
    
    private func setTimeAllQuestions(time: Int) {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime = time
    }
}
// MARK: - Constants
extension GameTypeViewModel {
    private func comma(continents: Bool...) -> String {
        var text = ""
        var number = 0
        continents.forEach { continent in
            number += 1
            if continent {
                text += text == "" ? checkContinent(continent: number) : ", " + checkContinent(continent: number)
            }
        }
        return text
    }
    
    private func checkContinent(continent: Int) -> String {
        var text = ""
        switch continent {
        case 1: text = "Все страны"
        case 2: text = "Америка"
        case 3: text = "Европа"
        case 4: text = "Африка"
        case 5: text = "Азия"
        default: text = "Океания"
        }
        return text
    }
    
    private func checkCountdownType() -> String {
        isOneQuestion() ? "\(checkTimeGameType())" : "\(allQuestionsTime())"
    }
    
    private func checkTimeGameType() -> String {
        gameType == .questionnaire ? "\(allQuestionsTime())" : "\(oneQuestionTime())"
    }
    
    private func checkTitleGameType() -> String {
        gameType == .questionnaire ? "Время всех вопросов" : "Время одного вопроса"
    }
    
    private func scrabbleType() -> String {
        switch mode.scrabbleType {
        case 0: return "flag"
        case 1: return "globe.europe.africa"
        default: return "building.2"
        }
    }
    
    private func imageFirst() -> String {
        tag == 2 ? "globe.europe.africa" : "flag"
    }
    
    private func titleFirst() -> String {
        tag == 2 ? "Режим карты" : "Режим флага"
    }
    
    private func descriptionFirst() -> String {
        switch tag {
        case 0, 1: "В качестве вопроса задается флаг страны и пользователь должен выбрать ответ наименования страны."
        case 2: "В качестве вопроса задается географическая карта страны и пользователь должен выбрать ответ наименования страны. (Кнопка неактивна)"
        case 3: "В качестве вопроса задается флаг страны и пользователь должен составить слово из букв наименования страны."
        default: "В качестве вопроса задается флаг страны и пользователь должен выбрать ответ наименования столицы."
        }
    }
    
    private func imageSecond() -> String {
        tag == 3 ? "globe.europe.africa" : "building"
    }
    
    private func titleSecond() -> String {
        switch tag {
        case 0, 1: "Режим наименования"
        case 4: "Режим столицы"
        default: "Режим карты"
        }
    }
    
    private func descriptionSecond() -> String {
        switch tag {
        case 0, 1: "В качестве вопроса задается наименование страны и пользователь должен выбрать ответ флага страны."
        case 4: "В качестве вопроса задается наименование страны и пользователь должен выбрать ответ наименования столицы."
        default: "В качестве вопроса задается географическая карта страны и пользователь должен составить слово из букв наименования страны."
        }
    }
    
    private func descriptionThird() -> String {
        "В качестве вопроса задается наименование столицы и пользователь должен составить слово из букв наименования страны."
    }
}
// MARK: - Set subviews for popup view help
extension GameTypeViewModel {
    private func setLabel(title: String, size: CGFloat,
                          alignment: NSTextAlignment? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = UIFont(name: "GillSans", size: size)
        label.textAlignment = alignment ?? .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func setting(_ label: UILabel, size: CGFloat) -> UILabel {
        label.textColor = .white
        label.font = UIFont(name: "Gill Sans", size: size)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func setImage(image: String, color: UIColor) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func setView() -> UIView {
        let view = UIView()
        view.backgroundColor = game.swap
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        return view
    }
    
    private func setView(color: UIColor, addImage: UIImageView) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        setupSubviews(subviews: addImage, on: view)
        return view
    }
    
    private func setStackView(_ top: UIView, _ bottom: UIView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [top, bottom])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackView(_ view: UIView, _ stackView: UIStackView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [view, stackView])
        stackView.spacing = 10
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Private methods, constraints
extension GameTypeViewModel {
    private func setConstraints(subview: UIView, to otherSubview: UIView, _ view: UIView) {
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: otherSubview.bottomAnchor),
            subview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            subview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
    }
    
    private func setConstraints(_ popUpView: UIView, and view: UIView) {
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor, constant: 20),
            title.centerYAnchor.constraint(equalTo: popUpView.topAnchor, constant: 31.875)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: popUpView.topAnchor, constant: 63.75),
            scrollView.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: size())
        ])
        
        NSLayoutConstraint.activate([
            description.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            description.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            description.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            list.topAnchor.constraint(equalTo: description.bottomAnchor, constant: 19),
            list.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            list.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
}
