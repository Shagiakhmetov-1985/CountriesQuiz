//
//  GameTypeViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 07.03.2024.
//

import UIKit

protocol GameTypeViewModelProtocol {
    var setTag: Int { get }
    var countQuestions: Int { get }
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
    var diameter: CGFloat { get }
    var image: String { get }
    var name: String { get }
    var description: String { get }
    var gameType: TypeOfGame { get }
    init(mode: Setting, game: Games, tag: Int)
    func numberOfComponents() -> Int
    func numberOfQuestions() -> Int
    func countdownOneQuestion() -> Int
    func countdownAllQuestions() -> Int
    func titles(_ pickerView: UIPickerView, _ row: Int, and segmented: UISegmentedControl) -> UIView
    func swap(_ tag: Int, _ button: UIButton)
    func isCountdown() -> Bool
    func isOneQuestion() -> Bool
    func oneQuestionTime() -> Int
    func allQuestionsTime() -> Int
    func isCheckmark(isOn: Bool) -> String
    func image(_ tag: Int) -> String
    func isEnabled(_ tag: Int) -> Bool
    func countdownOnOff(isOn: Bool)
    func oneQuestionOnOff(isOn: Bool)
    func setTimeOneQuestion(time: Int)
    func setTimeAllQuestions(time: Int)
    func width(_ view: UIView) -> CGFloat
    func bulletsList(list: [String]) -> UILabel
    func bulletsListGameType(_ tag: Int) -> [String]
    func imageFirstTitle(_ tag: Int) -> String
    func colorTitle(_ tag: Int) -> UIColor
    func labelFirstTitle(_ tag: Int) -> String
    func labelTitleFirstDescription(_ tag: Int) -> String
    func imageSecondTitle(_ tag: Int) -> String
    func labelSecondTitle(_ tag: Int) -> String
    func labelTitleSecondDescription(_ tag: Int) -> String
    func comma() -> String
    func countdownOnOff() -> String
    func checkTimeDescription() -> String
    func isSelect(isOn: Bool) -> UIColor
}

class GameTypeViewModel: GameTypeViewModelProtocol {
    typealias ParagraphData = (bullet: String, paragraph: String)
    
    var setTag: Int {
        tag
    }
    
    var countQuestions: Int {
        mode.countQuestions
    }
    
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
    
    private var mode: Setting
    private let game: Games
    private let tag: Int
    
    required init(mode: Setting, game: Games, tag: Int) {
        self.mode = mode
        self.game = game
        self.tag = tag
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
    func image(_ tag: Int) -> String {
        switch tag {
        case 0, 1, 4: return mode.flag ? "flag" : "building"
        case 2: return "globe.europe.africa"
        default: return scrabbleType()
        }
    }
    // MARK: - Enable or disable button of setting
    func isEnabled(_ tag: Int) -> Bool {
        tag == 2 ? false : true
    }
    // MARK: - Press swap button of setting
    func swap(_ tag: Int, _ button: UIButton) {
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
    
    func imageFirstTitle(_ tag: Int) -> String {
        tag == 2 ? "globe.europe.africa" : "flag"
    }
    
    func colorTitle(_ tag: Int) -> UIColor {
        tag == 2 ? .white.withAlphaComponent(0.4) : .white
    }
    
    func labelFirstTitle(_ tag: Int) -> String {
        tag == 2 ? "Режим карты" : "Режим флага"
    }
    
    func labelTitleFirstDescription(_ tag: Int) -> String {
        switch tag {
        case 0, 1: "В качестве вопроса задается флаг страны и пользователь должен выбрать ответ наименования страны."
        case 2: "В качестве вопроса задается географическая карта страны и пользователь должен выбрать ответ наименования страны. (Кнопка неактивна)"
        case 3: "В качестве вопроса задается флаг страны и пользователь должен составить слово из букв наименования страны."
        default: "В качестве вопроса задается флаг страны и пользователь должен выбрать ответ наименования столицы."
        }
    }
    
    func imageSecondTitle(_ tag: Int) -> String {
        tag == 3 ? "globe.europe.africa" : "building"
    }
    
    func labelSecondTitle(_ tag: Int) -> String {
        switch tag {
        case 0, 1: "Режим наименования"
        case 4: "Режим столицы"
        default: "Режим карты"
        }
    }
    
    func labelTitleSecondDescription(_ tag: Int) -> String {
        switch tag {
        case 0, 1: "В качестве вопроса задается наименование страны и пользователь должен выбрать ответ флага страны."
        case 4: "В качестве вопроса задается наименование страны и пользователь должен выбрать ответ наименования столицы."
        default: "В качестве вопроса задается географическая карта страны и пользователь должен составить слово из букв наименования страны."
        }
    }
    
    func isSelect(isOn: Bool) -> UIColor {
        isOn ? background : .white
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
    
    func bulletsListGameType(_ tag: Int) -> [String] {
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
}
