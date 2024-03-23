//
//  GameTypeViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 07.03.2024.
//

import UIKit

protocol GameTypeViewModelProtocol {
    var setting: Setting { get }
    var games: Games { get }
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
    var description: String { get }
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
    func numberOfQuestions() -> Int
    func countdownOneQuestion() -> Int
    func countdownAllQuestions() -> Int
    
    func titles(_ pickerView: UIPickerView,_ row: Int, and segmented: UISegmentedControl) -> UIView
    func swap(_ button: UIButton)
    
    func isCountdown() -> Bool
    func isOneQuestion() -> Bool
    func oneQuestionTime() -> Int
    func allQuestionsTime() -> Int
    func isQuestionnaire() -> Bool
    
    func isCheckmark(isOn: Bool) -> String
    func imageMode() -> String
    func isEnabled() -> Bool
    
    func countdownOnOff(isOn: Bool)
    func oneQuestionOnOff(isOn: Bool)
    func setTimeOneQuestion(time: Int)
    func setTimeAllQuestions(time: Int)
    func barButtonsOnOff(_ buttonBack: UIButton,_ buttonHelp: UIButton, bool: Bool)
    
    func setCountQuestions(_ countQuestions: Int)
    func setCountRows(_ countRows: Int)
    
    func setAllCountries(_ bool: Bool)
    func setAmericaContinent(_ bool: Bool)
    func setEuropeContinent(_ bool: Bool)
    func setAfricaContinent(_ bool: Bool)
    func setAsiaContinent(_ bool: Bool)
    func setOceaniaContinent(_ bool: Bool)
    
    func width(_ view: UIView) -> CGFloat
    func size() -> CGFloat
    
    func bulletsList(list: [String]) -> UILabel
    func bulletsListGameType() -> [String]
    
    func imageFirstTitle() -> String
    func colorTitle() -> UIColor
    func labelFirstTitle() -> String
    func labelTitleFirstDescription() -> String
    func imageSecondTitle() -> String
    func labelSecondTitle() -> String
    func labelTitleSecondDescription() -> String
    
    func comma() -> String
    func countdownOnOff() -> String
    func checkTimeDescription() -> String
    
    func isSelect(isOn: Bool) -> UIColor
    func setCountContinents(_ count: Int)
    
    func setupSubviews(subviews: UIView..., on subviewOther: UIView)
    func removeSubviews(subviews: UIView...)
    func setPickerViewCountQuestions(_ pickerView: UIPickerView,_ view: UIView)
    func counterContinents()
    func setSubviewsTag(subviews: UIView..., tag: Int)
}

class GameTypeViewModel: GameTypeViewModelProtocol {
    typealias ParagraphData = (bullet: String, paragraph: String)
    var setting: Setting {
        mode
    }
    
    var games: Games {
        game
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
    
    var countRowsDefault: Int {
        DefaultSetting.countRows.rawValue
    }
    
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
    
    var diameter: CGFloat {
        100
    }
    
    var image: String {
        game.image
    }
    
    var name: String {
        game.name
    }
    
    var description: String {
        game.description
    }
    
    var gameType: TypeOfGame {
        game.gameType
    }
    
    var countAllCountries: Int {
        FlagsOfCountries.shared.countries.count
    }
    
    var countCountriesOfAmerica: Int {
        FlagsOfCountries.shared.countriesOfAmericanContinent.count
    }
    
    var countCountriesOfEurope: Int {
        FlagsOfCountries.shared.countriesOfEuropeanContinent.count
    }
    
    var countCountriesOfAfrica: Int {
        FlagsOfCountries.shared.countriesOfAfricanContinent.count
    }
    
    var countCountriesOfAsia: Int {
        FlagsOfCountries.shared.countriesOfAsianContinent.count
    }
    
    var countCountriesOfOceania: Int {
        FlagsOfCountries.shared.countriesOfOceanContinent.count
    }
    
    private var mode: Setting
    private let game: Games
    private let tag: Int
    
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
    // MARK: - PickerView
    func numberOfComponents() -> Int {
        1
    }
    
    func numberOfQuestions() -> Int {
        mode.countRows
    }
    
    func countdownOneQuestion() -> Int {
        10
    }
    
    func countdownAllQuestions() -> Int {
        6 * mode.countQuestions - 4 * mode.countQuestions + 1
    }
    
    func titles(_ pickerView: UIPickerView, _ row: Int, and segmented: UISegmentedControl) -> UIView {
        let label = UILabel()
        let tag = pickerView.tag
        var title = String()
        var attributed = NSAttributedString()
        
        switch tag {
        case 1:
            title = "\(row + 10)"
            attributed = attributted(title: title, tag: tag, segmented: segmented)
        case 2:
            title = "\(row + 6)"
            attributed = attributted(title: title, tag: tag, segmented: segmented)
        default:
            title = "\(row + 4 * mode.countQuestions)"
            attributed = attributted(title: title, tag: tag, segmented: segmented)
        }
        
        label.textAlignment = .center
        label.attributedText = attributed
        return label
    }
    // MARK: - Image for button of setting
    func imageMode() -> String {
        switch tag {
        case 0, 1, 4: return mode.flag ? "flag" : "building"
        case 2: return "globe.europe.africa"
        default: return scrabbleType()
        }
    }
    // MARK: - Enable or disable button of setting
    func isEnabled() -> Bool {
        tag == 2 ? false : true
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
    // MARK: - Setup design
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
    
    func imageFirstTitle() -> String {
        tag == 2 ? "globe.europe.africa" : "flag"
    }
    
    func colorTitle() -> UIColor {
        tag == 2 ? .white.withAlphaComponent(0.4) : .white
    }
    
    func labelFirstTitle() -> String {
        tag == 2 ? "Режим карты" : "Режим флага"
    }
    
    func labelTitleFirstDescription() -> String {
        switch tag {
        case 0, 1: "В качестве вопроса задается флаг страны и пользователь должен выбрать ответ наименования страны."
        case 2: "В качестве вопроса задается географическая карта страны и пользователь должен выбрать ответ наименования страны. (Кнопка неактивна)"
        case 3: "В качестве вопроса задается флаг страны и пользователь должен составить слово из букв наименования страны."
        default: "В качестве вопроса задается флаг страны и пользователь должен выбрать ответ наименования столицы."
        }
    }
    
    func imageSecondTitle() -> String {
        tag == 3 ? "globe.europe.africa" : "building"
    }
    
    func labelSecondTitle() -> String {
        switch tag {
        case 0, 1: "Режим наименования"
        case 4: "Режим столицы"
        default: "Режим карты"
        }
    }
    
    func labelTitleSecondDescription() -> String {
        switch tag {
        case 0, 1: "В качестве вопроса задается наименование страны и пользователь должен выбрать ответ флага страны."
        case 4: "В качестве вопроса задается наименование страны и пользователь должен выбрать ответ наименования столицы."
        default: "В качестве вопроса задается географическая карта страны и пользователь должен составить слово из букв наименования страны."
        }
    }
    
    func isSelect(isOn: Bool) -> UIColor {
        isOn ? background : .white
    }
    
    func isQuestionnaire() -> Bool {
        gameType == .questionnaire ? false : true
    }
    // MARK: - Button titles
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
    // MARK: - Bullets
    func bulletsList(list: [String]) -> UILabel {
        let label = UILabel()
        let paragraphDataPairs: [ParagraphData] = bullets(list: list)
        let stringAttributes: [NSAttributedString.Key: Any] = [.font: label.font!]
        let bulletedAttributedString = makeBulletedAttributedString(
            paragraphDataPairs: paragraphDataPairs,
            attributes: stringAttributes)
        label.attributedText = bulletedAttributedString
        return label
    }
    
    func bulletsListGameType() -> [String] {
        switch tag {
        case 0: return GameType.shared.bulletsQuizOfFlags
        case 1: return GameType.shared.bulletsQuestionnaire
        case 2: return GameType.shared.bulletsQuizOfMaps
        case 3: return GameType.shared.bulletsScrabble
        default: return GameType.shared.bulletsQuizOfCapitals
        }
    }
    // MARK: - Set change setting
    func countdownOnOff(isOn: Bool) {
        mode.timeElapsed.timeElapsed = isOn
    }
    
    func oneQuestionOnOff(isOn: Bool) {
        mode.timeElapsed.questionSelect.oneQuestion = isOn
    }
    
    func setTimeOneQuestion(time: Int) {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime = time
    }
    
    func setTimeAllQuestions(time: Int) {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime = time
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
    
    func setCountQuestions(_ countQuestions: Int) {
        mode.countQuestions = countQuestions
    }
    
    func setCountRows(_ countRows: Int) {
        mode.countRows = countRows
    }
    
    func setAllCountries(_ bool: Bool) {
        mode.allCountries = bool
    }
    
    func setAmericaContinent(_ bool: Bool) {
        mode.americaContinent = bool
    }
    
    func setEuropeContinent(_ bool: Bool) {
        mode.europeContinent = bool
    }
    
    func setAfricaContinent(_ bool: Bool) {
        mode.africaContinent = bool
    }
    
    func setAsiaContinent(_ bool: Bool) {
        mode.asiaContinent = bool
    }
    
    func setOceaniaContinent(_ bool: Bool) {
        mode.oceaniaContinent = bool
    }
    
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
    // MARK: - Set bullet list
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
    // MARK: - Button titles
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
    // MARK: - Private methods
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
    private func attributted(title: String, tag: Int, segmented: UISegmentedControl) -> NSAttributedString {
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
    // MARK: - Image
    private func scrabbleType() -> String {
        switch mode.scrabbleType {
        case 0: return "flag"
        case 1: return "globe.europe.africa"
        default: return "building.2"
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
}
