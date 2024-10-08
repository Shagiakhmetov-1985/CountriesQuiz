//
//  GameTypeViewModel.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 07.03.2024.
//

import UIKit

protocol GameTypeViewModelProtocol {
    var mode: Setting { get }
    var tag: Int { get }
    var countQuestions: Int { get }
    var countContinents: Int { get }
    var favorites: [Favorites] { get }
    
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
    var diameter: CGFloat { get }
    var radius: CGFloat { get }
    var popUpViewHelp: Bool { get }
    
    init(mode: Setting, game: Games, tag: Int, favorites: [Favorites])
    
    func numberOfComponents() -> Int
    func numberOfRows(_ pickerView: UIPickerView) -> Int
    func text(tag: Int) -> String
    
    func titles(_ pickerView: UIPickerView,_ row: Int, and segmented: UISegmentedControl) -> UIView
    func swap(_ button: UIButton)
    
    func isCountdown() -> Bool
    func isOneQuestion() -> Bool
    func oneQuestionTime() -> Int
    func allQuestionsTime() -> Int
    
    func isCheckmark(isOn: Bool) -> String
    func imageMode() -> String
    func isEnabled() -> Bool
    func haveFavourites() -> Bool
    
    func barButtonsOnOff(_ buttonBack: UIButton,_ buttonHelp: UIButton, bool: Bool)
    func buttonOnOff(button: UIButton, isOn: Bool)
    func showAnimationView(_ viewDetails: UIView, and visualEffect: UIVisualEffectView)
    func hideAnimationView(_ viewDetails: UIView, and visualEffect: UIVisualEffectView)
    func showViewSetting(_ viewSetting: UIView, and visualEffect: UIVisualEffectView, _ view: UIView)
    func hideViewSetting(_ viewSetting: UIView, and visualEffect: UIVisualEffectView, _ view: UIView)
    
    func width(_ view: UIView) -> CGFloat
    func size() -> CGFloat
    
    func comma() -> String
    func countdownOnOff() -> String
    func checkTimeDescription() -> String
    
    func isSelect(isOn: Bool) -> UIColor
    func setCountContinents(_ count: Int)
    
    func setSubviews(subviews: UIView..., on subviewOther: UIView)
    func removeSubviews(subviews: UIView...)
    func setupBarButtons(_ buttonBack: UIButton,_ buttonHelp: UIButton,_ navigationItem: UINavigationItem)
    func setRowPickerView(tag: Int) -> Int
    func setButtonsContinent(button: UIButton)
    func setButtonCheckmark(button: UIButton)
    func setPickerView(pickerView: UIPickerView)
    func setSegmentedControl(segment: UISegmentedControl)
    func setStackView(stackView: UIStackView)
    func setHeightSegment(segment: UISegmentedControl)
    func setDataSubviews(tag: Int)
    func segmentSelect()
    func setSubviewsTag(subviews: UIView..., tag: Int)
    func viewHelp() -> UIView
    func viewSetting() -> UIView
    func setSubview(_ subview: UIView, on viewSetting: UIView, and view: UIView)
    func setFavorites(newFavorites: [Favorites])
    
    func buttonAllCountries(_ button: UIButton, isOn: Bool)
    func setAllCountries(_ sender: UIButton)
    func condition(_ sender: UIButton)
    func checkmarkOnOff(_ button: UIButton)
    func attributedText(text: String, tag: Int) -> NSMutableAttributedString
    func popUpViewHelpToggle()
    
    func setQuestions(_ labelQuestions: UILabel, and labelTime: UILabel)
    func setContinents(_ labelContinents: UILabel,_ labelQuestions: UILabel, and pickerView: UIPickerView)
    func setCountdown(_ labelCountdown: UILabel,_ imageInfinity: UIImageView,
                      _ labelTime: UILabel, and buttonTime: UIButton)
    func setTime(_ labelTime: UILabel, and labelDescription: UILabel)
    
    func setSquare(subviews: UIView..., sizes: CGFloat)
    func setCenterSubview(subview: UIView, on subviewOther: UIView)
    func setSize(subview: UIView, width: CGFloat, height: CGFloat)
    func setConstraints(_ button: UIButton, layout: NSLayoutYAxisAnchor, leading: CGFloat,
                        trailing: CGFloat, height: CGFloat,_ view: UIView)
    func setConstraints(_ label: UILabel, on button: UIButton, constant: CGFloat)
    func setConstraints(_ viewHelp: UIView,_ view: UIView)
    func setConstraints(_ button: UIButton, _ view: UIView)
    func setConstraints(stackView: UIStackView)
    func setConstraints(label: UILabel, on button: UIButton)
    
    func favouritesViewModel() -> FavoritesViewModelProtocol
    func quizOfFlagsViewModel() -> QuizOfFlagsViewModelProtocol
    func questionnaireViewModel() -> QuestionnaireViewModelProtocol
    func quizOfCapitalsViewModel() -> QuizOfCapitalsViewModelProtocol
}

class GameTypeViewModel: GameTypeViewModelProtocol {
    typealias ParagraphData = (bullet: String, paragraph: String)
    
    var countQuestions: Int {
        mode.countQuestions
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
        game.favorite
    }
    var colorSwap: UIColor {
        game.swap
    }
    var colorDone: UIColor {
        game.done
    }
    var diameter: CGFloat = 100
    var radius: CGFloat {
        diameter / 2
    }
    var image: String {
        game.image
    }
    var name: String {
        game.name
    }
    var popUpViewHelp: Bool = false
    
    var mode: Setting
    let tag: Int
    var favorites: [Favorites]
    private let game: Games
    
    private var countRowsDefault = DefaultSetting.countRows.rawValue
    
    private var title: UILabel!
    private var description: UILabel!
    private var list: UILabel!
    private var contentView: UIView!
    private var scrollView: UIScrollView!
    private var viewSecondary: UIView!
    private var titleSetting: UILabel!
    
    private var buttonAllCountries: UIButton!
    private var buttonAmerica: UIButton!
    private var buttonEurope: UIButton!
    private var buttonAfrica: UIButton!
    private var buttonAsia: UIButton!
    private var buttonOcean: UIButton!
    private var buttonCheckmark: UIButton!
    
    private var pickerViewQuestions: UIPickerView!
    private var pickerViewOneTime: UIPickerView!
    private var pickerViewAllTime: UIPickerView!
    
    private var segmentedControl: UISegmentedControl!
    private var stackViewContinents: UIStackView!
    private var stackViewCheckmark: UIStackView!
    private var stackViewTime: UIStackView!
    
    required init(mode: Setting, game: Games, tag: Int, favorites: [Favorites]) {
        self.mode = mode
        self.game = game
        self.tag = tag
        self.favorites = favorites
    }
    // MARK: - Set subviews
    func setSubviews(subviews: UIView..., on subviewOther: UIView) {
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
    
    func viewHelp() -> UIView {
        let popUpView = setView(color: game.swap)
        addSubviewsForPopUpView()
        setSubviews(subviews: title, scrollView, on: popUpView)
        setConstraints(popUpView)
        return popUpView
    }
    
    func viewSetting() -> UIView {
        let popUpView = setView(color: game.swap)
        viewSecondary = setView(color: game.background)
        titleSetting = setLabel(title: "", size: 22, font: "GillSans")
        viewSecondary.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        setSubviews(subviews: viewSecondary, titleSetting, on: popUpView)
        setConstraints(popUpView: popUpView)
        return popUpView
    }
    
    func setSubview(_ subview: UIView, on viewSetting: UIView, and view: UIView) {
        setSubviews(subviews: subview, on: viewSecondary)
        setConstraints(subview: subview, on: viewSetting, and: view, tag: viewSetting.tag)
        titleSetting.text = titleSetting(tag: viewSetting.tag)
    }
    // MARK: - PickerView
    func numberOfComponents() -> Int {
        1
    }
    
    func numberOfRows(_ pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 1: mode.countRows
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
    
    func haveFavourites() -> Bool {
        favorites.isEmpty ? false : true
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
    
    func text(tag: Int) -> String {
        """
        \(continent(tag: tag))
        \(count(tag: tag))
        """
    }
    // MARK: - Show / hide subviews
    func barButtonsOnOff(_ buttonBack: UIButton,_ buttonHelp: UIButton, bool: Bool) {
        let opacity: Float = bool ? 1 : 0
        isEnabled(buttons: buttonBack, buttonHelp, bool: bool)
        setupOpacityButtons(buttons: buttonBack, buttonHelp, opacity: opacity)
    }
    
    func buttonOnOff(button: UIButton, isOn: Bool) {
        isEnabled(buttons: button, bool: isOn)
    }
    
    func showAnimationView(_ viewDetails: UIView, and visualEffect: UIVisualEffectView) {
        viewDetails.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        viewDetails.alpha = 0
        UIView.animate(withDuration: 0.5) { [self] in
            alpha(subviews: viewDetails, visualEffect, alpha: 1)
            viewDetails.transform = .identity
        }
    }
    
    func hideAnimationView(_ viewDetails: UIView, and visualEffect: UIVisualEffectView) {
        UIView.animate(withDuration: 0.5) { [self] in
            alpha(subviews: viewDetails, visualEffect, alpha: 0)
            viewDetails.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        } completion: { [self] _ in
            removeSubviews(subviews: viewDetails)
        }
    }
    
    func showViewSetting(_ viewSetting: UIView, and visualEffect:
                         UIVisualEffectView, _ view: UIView) {
        viewSetting.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        viewSetting.alpha = 0
        UIView.animate(withDuration: 0.5) { [self] in
            alpha(subviews: visualEffect, viewSetting, alpha: 1)
            viewSetting.transform = .identity
        }
    }
    
    func hideViewSetting(_ viewSetting: UIView, and visualEffect:
                         UIVisualEffectView, _ view: UIView) {
        UIView.animate(withDuration: 0.5) {
            visualEffect.alpha = 0
            viewSetting.alpha = 0
            viewSetting.transform = CGAffineTransform.init(translationX: 0, y: view.frame.height)
        } completion: { [self] _ in
            switch viewSetting.tag {
            case 1: removeSubviews(subviews: viewSetting, pickerViewQuestions)
            case 2: removeSubviews(subviews: viewSetting, stackViewContinents)
            case 3: removeSubviews(subviews: viewSetting, stackViewCheckmark)
            default: removeSubviews(subviews: viewSetting, stackViewTime)
            }
        }
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
    
    func setFavorites(newFavorites: [Favorites]) {
        favorites = newFavorites
    }
    // MARK: - Set popup view controller
    func popUpViewHelpToggle() {
        popUpViewHelp.toggle()
    }
    
    func setRowPickerView(tag: Int) -> Int {
        switch tag {
        case 1: countQuestions - 10
        case 2: oneQuestionTime() - 6
        default: allQuestionsTime() - 4 * countQuestions
        }
    }
    
    func setButtonsContinent(button: UIButton) {
        switch button.tag {
        case 0: buttonAllCountries = button
        case 1: buttonAmerica = button
        case 2: buttonEurope = button
        case 3: buttonAfrica = button
        case 4: buttonAsia = button
        default: buttonOcean = button
        }
    }
    
    func setButtonCheckmark(button: UIButton) {
        buttonCheckmark = button
    }
    
    func setSegmentedControl(segment: UISegmentedControl) {
        segmentedControl = segment
    }
    
    func setPickerView(pickerView: UIPickerView) {
        switch pickerView.tag {
        case 1: pickerViewQuestions = pickerView
        case 2: pickerViewOneTime = pickerView
        default: pickerViewAllTime = pickerView
        }
    }
    
    func setStackView(stackView: UIStackView) {
        switch stackView.tag {
        case 1: stackViewContinents = stackView
        case 2: stackViewCheckmark = stackView
        default: stackViewTime = stackView
        }
    }
    
    func setSubviewsTag(subviews: UIView..., tag: Int) {
        subviews.forEach { subview in
            subview.tag = tag
        }
    }
    
    func setDataSubviews(tag: Int) {
        switch tag {
        case 1: setRowPickerViewCountQuestions()
        case 2:
            counterContinents()
            setColors(buttons: buttonAllCountries, buttonAmerica, buttonEurope,
                      buttonAfrica, buttonAsia, buttonOcean)
        case 3: checkButtonCheckmark()
        default:
            setSegmentIndex()
            setPickerViewsTime()
        }
    }
    
    func segmentSelect() {
        let index = segmentedControl.selectedSegmentIndex
        if index == 0 {
            colorPickerView(pickerViewOneTime, color: .white, isOn: true)
            colorPickerView(pickerViewAllTime, color: .skyGrayLight, isOn: false)
        } else {
            colorPickerView(pickerViewOneTime, color: .skyGrayLight, isOn: false)
            colorPickerView(pickerViewAllTime, color: .white, isOn: true)
        }
        titleSetting.text = index == 1 ? "Время всех вопросов" : "Время одного вопроса"
        reloadPickerViews(pickerViews: pickerViewOneTime, pickerViewAllTime)
    }
    // MARK: - Button press continents
    func setAllCountries(_ sender: UIButton) {
        guard sender.backgroundColor == background else { return }
        setCountContinents(0)
        buttonAllCountries(sender, isOn: true)
        setColorButtons(buttonAmerica, buttonEurope, buttonAfrica, buttonAsia, buttonOcean)
    }
    
    func condition(_ sender: UIButton) {
        countContinents == 0 ? setAllCountries(sender) : setContinent(sender)
    }
    
    func buttonAllCountries(_ button: UIButton, isOn: Bool) {
        let backgroundColor: UIColor = isOn ? .white : background
        let textColor: UIColor = isOn ? background : .white
        setColor(buttons: button, backgroundColor: backgroundColor, textColor: textColor)
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
    func setQuestions(_ labelQuestions: UILabel, and labelTime: UILabel) {
        let row = pickerViewQuestions.selectedRow(inComponent: 0)
        setCountQuestions(row + 10)
        setTimeAllQuestions(time: 5 * countQuestions)
        setTitleCountQuestions("\(row + 10)", labelQuestions)
        setTitleTime(labelTime)
    }
    // MARK: - Press done for change setting, continents
    func setContinents(_ labelContinents: UILabel, _ labelQuestions: UILabel,
                       and pickerView: UIPickerView) {
        setContinents(buttons: buttonAllCountries, buttonAmerica, buttonEurope,
                      buttonAfrica, buttonAsia, buttonOcean)
        setCountRows(continents: allCountries, americaContinent, europeContinent,
                     africaContinent, asiaContinent, oceaniaContinent)
        setCountQuestions(countRows: mode.countRows)
        setTitlesContinents(labelContinents, labelQuestions, pickerView)
    }
    // MARK: - Press done for change setting, countdown
    func setCountdown(_ labelCountdown: UILabel, _ imageInfinity: UIImageView,
                      _ labelTime: UILabel, and buttonTime: UIButton) {
        setCheckmark(buttonCheckmark, labelCountdown)
        setTitlesCountdown(imageInfinity, labelTime)
        setButtonTime(buttonTime)
    }
    // MARK: - Press done for change setting, time
    func setTime(_ labelTime: UILabel, and labelDescription: UILabel) {
        setSegmentedControl(segmentedControl)
        setDataFromPickerViews(pickerViewOneTime, pickerViewAllTime)
        setTitlesTime(labelTime, labelDescription)
    }
    
    func attributedText(text: String, tag: Int) -> NSMutableAttributedString {
        let attributed = NSMutableAttributedString(string: text)
        let font = NSAttributedString.Key.font
        let key = UIFont(name: "mr_fontick", size: 20)
        let range = setRange(subString: count(tag: tag), fromString: text)
        attributed.addAttributes([font: key ?? ""], range: range)
        return attributed
    }
    // MARK: - Transitions to other view controller
    func favouritesViewModel() -> FavoritesViewModelProtocol {
        FavoritesViewModel(game: game, favorites: favorites)
    }
    
    func quizOfFlagsViewModel() -> QuizOfFlagsViewModelProtocol {
        QuizOfFlagsViewModel(mode: mode, game: game, favorites: favorites)
    }
    
    func questionnaireViewModel() -> QuestionnaireViewModelProtocol {
        QuestionnaireViewModel(mode: mode, game: game, favorites: favorites)
    }
    
    func quizOfCapitalsViewModel() -> QuizOfCapitalsViewModelProtocol {
        QuizOfCapitalsViewModel(mode: mode, game: game, favorites: favorites)
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
            button.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 26),
            button.centerXAnchor.constraint(equalTo: view.leadingAnchor, constant: 26)
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
    
    func setConstraints(label: UILabel, on button: UIButton) {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
    }
    
    func setHeightSegment(segment: UISegmentedControl) {
        NSLayoutConstraint.activate([
            segment.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setConstraints(stackView: UIStackView) {
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: viewSecondary.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: viewSecondary.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: viewSecondary.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 50)
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
        title = setLabel(title: "Тип игры", size: 25, font: "GillSans")
        description = setLabel(title: game.description, size: 19, font: "GillSans", alignment: .left)
        list = setting(bulletsList(list: bulletsListGameType()), size: 19)
        contentView = setContentView(description, list)
        scrollView = setScrollView(contentView)
    }
    
    private func setContentView(_ description: UILabel, _ list: UILabel) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        setSubviews(subviews: description, list, on: view)
        switch tag {
        case 0, 1, 4:
            let stackViews = gameTypeFirst()
            setSubviews(subviews: stackViews.0, stackViews.1, on: view)
            setConstraintsFirst(stackViews.0, stackViews.1, view)
        case 2:
            let stackView = gameTypeSecond()
            setSubviews(subviews: stackView, on: view)
            setConstraintSecond(stackView, view)
        default:
            let stackViews = gameTypeThird()
            setSubviews(subviews: stackViews.0, stackViews.1, stackViews.2, on: view)
            setConstraintsThird(stackViews.0, stackViews.1, stackViews.2, view)
        }
        return view
    }
    
    private func topic(image: String, color: UIColor, title: String, 
                       description: String) -> UIStackView {
        let image = setImage(image: image, color: color)
        let view = setView(color: game.swap, addImage: image)
        let title = setLabel(title: title, size: 24, font: "GillSans", alignment: .left)
        let description = setLabel(title: description, size: 19, font: "GillSans", alignment: .left)
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
        let color = tag == 1 ? game.favorite : color(tag: tag, segmented: segmented)
        return NSAttributedString(string: title, attributes: [
            .font: UIFont(name: "mr_fontick", size: 26) ?? "",
            .foregroundColor: color
        ])
    }
    
    private func color(tag: Int, segmented: UISegmentedControl) -> UIColor {
        switch segmented.selectedSegmentIndex {
        case 0:
            return tag == 2 ? game.favorite : .grayLight
        default:
            return tag == 2 ? .grayLight : game.favorite
        }
    }
    // MARK: - Show / hide subviews
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
    
    private func alpha(subviews: UIView..., alpha: CGFloat) {
        subviews.forEach { subview in
            subview.alpha = alpha
        }
    }
    // MARK: - Methods for popup view controller
    private func setRowPickerViewCountQuestions() {
        let row = setRowPickerView(tag: pickerViewQuestions.tag)
        pickerViewQuestions.selectRow(row, inComponent: 0, animated: false)
    }
    
    private func setContinent(_ sender: UIButton) {
        setColorButton(sender)
        guard buttonAllCountries.backgroundColor == .white else { return }
        buttonAllCountries(buttonAllCountries, isOn: false)
    }
    
    private func setColorButton(_ sender: UIButton) {
        let backgroundColor = sender.backgroundColor == background ? .white : background
        let textColor = sender.backgroundColor == background ? background : .white
        setColor(buttons: sender, backgroundColor: backgroundColor, textColor: textColor)
    }
    
    private func setColorButtons(_ buttons: UIButton...) {
        setColorButton(buttons: buttons, backgroundColor: background, textColor: .white)
    }
    
    private func counterContinents() {
        counterContinents(continents: americaContinent, europeContinent,
                          africaContinent, asiaContinent, oceaniaContinent)
    }
    
    private func counterContinents(continents: Bool...) {
        setCountContinents(0)
        continents.forEach { continent in
            if continent {
                setCountContinents(1)
            }
        }
    }
    
    private func setColors(buttons: UIButton...) {
        buttons.forEach { button in
            let color = checkContinent(tag: button.tag)
            setColor(buttons: button, backgroundColor: color.0, textColor: color.1)
        }
    }
    
    private func checkContinent(tag: Int) -> (UIColor, UIColor) {
        switch tag {
        case 0: continent(isOn: allCountries)
        case 1: continent(isOn: americaContinent)
        case 2: continent(isOn: europeContinent)
        case 3: continent(isOn: africaContinent)
        case 4: continent(isOn: asiaContinent)
        default: continent(isOn: oceaniaContinent)
        }
    }
    
    private func continent(isOn: Bool) -> (UIColor, UIColor) {
        isOn ? (.white, background) : (background, .white)
    }
    
    private func setColor(buttons: UIButton..., backgroundColor: UIColor,
                          textColor: UIColor) {
        buttons.forEach { button in
            UIView.animate(withDuration: 0.3) {
                button.backgroundColor = backgroundColor
                button.setTitleColor(textColor, for: .normal)
            }
        }
    }
    
    private func checkButtonCheckmark() {
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        let symbol = isCountdown() ? "checkmark.circle.fill" : "circle"
        let image = UIImage(systemName: symbol, withConfiguration: size)
        buttonCheckmark.setImage(image, for: .normal)
    }
    
    private func setSegmentIndex() {
        let index = game.gameType == .questionnaire ? 1 : 0
        segmentedControl.selectedSegmentIndex = isOneQuestion() ? index : 1
        segmentedControl.isUserInteractionEnabled = isOnSegment()
    }
    
    private func setPickerViewsTime() {
        if isOneQuestion() {
            checkQuestionnaire()
        } else {
            colorPickerView(pickerViewOneTime, color: .skyGrayLight, isOn: false)
            colorPickerView(pickerViewAllTime, color: .white, isOn: true)
        }
        setRowsPickerViewsTime()
    }
    
    private func checkQuestionnaire() {
        if tag == 1 {
            colorPickerView(pickerViewOneTime, color: .skyGrayLight, isOn: false)
            colorPickerView(pickerViewAllTime, color: .white, isOn: true)
        } else {
            colorPickerView(pickerViewOneTime, color: .white, isOn: true)
            colorPickerView(pickerViewAllTime, color: .skyGrayLight, isOn: false)
        }
    }
    
    private func colorPickerView(_ pickerView: UIPickerView, color: UIColor, isOn: Bool) {
        pickerView.isUserInteractionEnabled = isOn
        UIView.animate(withDuration: 0.3) {
            pickerView.backgroundColor = color
        }
    }
    
    private func reloadPickerViews(pickerViews: UIPickerView...) {
        pickerViews.forEach { pickerView in
            pickerView.reloadAllComponents()
        }
    }
    
    private func setRowsPickerViewsTime() {
        let rowOneTime = setRowPickerView(tag: pickerViewOneTime.tag)
        let rowAllTime = setRowPickerView(tag: pickerViewAllTime.tag)
        pickerViewOneTime.selectRow(rowOneTime, inComponent: 0, animated: false)
        pickerViewAllTime.selectRow(rowAllTime, inComponent: 0, animated: false)
    }
    // MARK: - Button press continents
    private func setColorButton(buttons: [UIButton], backgroundColor: UIColor,
                                textColor: UIColor) {
        buttons.forEach { button in
            setColor(buttons: button, backgroundColor: backgroundColor, textColor: textColor)
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
    private func setContinents(buttons: UIButton...) {
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
        case 0: FlagsOfCountries.shared.countries.count
        case 1: FlagsOfCountries.shared.countriesOfAmericanContinent.count
        case 2: FlagsOfCountries.shared.countriesOfEuropeanContinent.count
        case 3: FlagsOfCountries.shared.countriesOfAfricanContinent.count
        case 4: FlagsOfCountries.shared.countriesOfAsianContinent.count
        default: FlagsOfCountries.shared.countriesOfOceanContinent.count
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
    
    private func setTitlesContinents(_ labelContinents: UILabel,_ labelQuestions:
                                     UILabel,_ pickerView: UIPickerView) {
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
        setCountdown(isOn: currentImage == imageCircle ? false : true)
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
        setOneQuestion(isOn: isOn)
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
    
    private func setCountdown(isOn: Bool) {
        mode.timeElapsed.timeElapsed = isOn
    }
    
    private func setOneQuestion(isOn: Bool) {
        mode.timeElapsed.questionSelect.oneQuestion = isOn
    }
    
    private func setTimeOneQuestion(time: Int) {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime = time
    }
    
    private func setTimeAllQuestions(time: Int) {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime = time
    }
    
    private func setRange(subString: String, fromString: String) -> NSRange {
        let linkRange = fromString.range(of: subString)!
        let start = fromString.distance(from: fromString.startIndex, to: linkRange.lowerBound)
        let end = fromString.distance(from: fromString.startIndex, to: linkRange.upperBound)
        let range = NSMakeRange(start, end - start)
        return range
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
        switch continent {
        case 1: "Все страны"
        case 2: "Америка"
        case 3: "Европа"
        case 4: "Африка"
        case 5: "Азия"
        default: "Океания"
        }
    }
    
    private func checkCountdownType() -> String {
        isOneQuestion() ? "\(checkTimeGameType())" : "\(allQuestionsTime())"
    }
    
    private func checkTimeGameType() -> String {
        game.gameType == .questionnaire ? "\(allQuestionsTime())" : "\(oneQuestionTime())"
    }
    
    private func titleSetting(tag: Int) -> String {
        switch tag {
        case 1: return "Количество вопросов"
        case 2: return "Континенты"
        case 3: return "Обратный отсчет"
        default: return checkTimeDescription()
        }
    }
    
    private func checkTitleGameType() -> String {
        game.gameType == .questionnaire ? "Время всех вопросов" : "Время одного вопроса"
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
    
    private func continent(tag: Int) -> String {
        switch tag {
        case 0: "Все страны мира"
        case 1: "Континент Америки"
        case 2: "Континент Европы"
        case 3: "Континент Африки"
        case 4: "Континент Азии"
        default: "Континент Океании"
        }
    }
    
    private func count(tag: Int) -> String {
        "Количество стран: \(countCountries(tag: tag))"
    }
    
    private func countCountries(tag: Int) -> Int {
        switch tag {
        case 0: FlagsOfCountries.shared.countries.count
        case 1: FlagsOfCountries.shared.countriesOfAmericanContinent.count
        case 2: FlagsOfCountries.shared.countriesOfEuropeanContinent.count
        case 3: FlagsOfCountries.shared.countriesOfAfricanContinent.count
        case 4: FlagsOfCountries.shared.countriesOfAsianContinent.count
        default: FlagsOfCountries.shared.countriesOfOceanContinent.count
        }
    }
    
    private func isOnSegment() -> Bool {
        game.gameType == .questionnaire ? false : true
    }
}
// MARK: - Set subviews for popup view help
extension GameTypeViewModel {
    private func setLabel(title: String, size: CGFloat, font: String,
                          alignment: NSTextAlignment? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = UIFont(name: font, size: size)
        label.textAlignment = alignment ?? .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func setView(color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        return view
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
    
    private func setView(color: UIColor, addImage: UIImageView) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        setSubviews(subviews: addImage, on: view)
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
    
    private func setConstraints(_ popUpView: UIView) {
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor, constant: 20),
            title.centerYAnchor.constraint(equalTo: popUpView.topAnchor, constant: 26)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: popUpView.topAnchor, constant: 52),
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
    
    private func setConstraints(popUpView: UIView) {
        NSLayoutConstraint.activate([
            viewSecondary.topAnchor.constraint(equalTo: popUpView.topAnchor, constant: 52),
            viewSecondary.leadingAnchor.constraint(equalTo: popUpView.leadingAnchor),
            viewSecondary.trailingAnchor.constraint(equalTo: popUpView.trailingAnchor),
            viewSecondary.bottomAnchor.constraint(equalTo: popUpView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleSetting.centerXAnchor.constraint(equalTo: popUpView.centerXAnchor, constant: 20),
            titleSetting.centerYAnchor.constraint(equalTo: popUpView.topAnchor, constant: 26)
        ])
    }
    
    private func setConstraints(subview: UIView, on viewSetting: UIView,
                                and view: UIView, tag: Int) {
        switch tag {
        case 1: setCountQuestions(subview, on: viewSetting, and: view)
        case 2: setContinents(subview, on: viewSetting, and: view)
        case 3: setCheckmarkTime(subview, on: viewSetting, and: view)
        default: setTime(subview, on: viewSetting, and: view)
        }
    }
    
    private func setCountQuestions(_ pickerView: UIView, on viewSetting: UIView,
                                   and view: UIView) {
        setConstraints(pickerView, on: viewSetting, and: view, constant: 100, height: 110)
    }
    
    private func setContinents(_ stackView: UIView, on viewSetting: UIView,
                               and view: UIView) {
        setConstraints(stackView, on: viewSetting, and: view, constant: -220, height: 435)
    }
    
    private func setCheckmarkTime(_ stackView: UIView, on viewSetting: UIView,
                                  and view: UIView) {
        setConstraints(stackView, on: viewSetting, and: view, constant: 165, height: 60)
    }
    
    private func setTime(_ stackView: UIView, on viewSetting: UIView,
                         and view: UIView) {
        setConstraints(stackView, on: viewSetting, and: view, constant: 60, height: 165)
    }
    
    private func setConstraints(_ subview: UIView, on viewSetting: UIView, and
                                view: UIView, constant: CGFloat, height: CGFloat) {
        NSLayoutConstraint.activate([
            viewSetting.topAnchor.constraint(equalTo: view.centerYAnchor, constant: constant),
            viewSetting.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            viewSetting.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            viewSetting.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: viewSecondary.topAnchor, constant: 20),
            subview.leadingAnchor.constraint(equalTo: viewSecondary.leadingAnchor, constant: 20),
            subview.trailingAnchor.constraint(equalTo: viewSecondary.trailingAnchor, constant: -20),
            subview.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}
