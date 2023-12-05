//
//  GameTypeViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 03.08.2023.
//

import UIKit

protocol PopUpViewDelegate {
    func closeView()
}

protocol PopUpViewSettingDelegate {
    func closeViewSetting()
}

protocol GameTypeViewControllerInput: AnyObject {
    func dataOfSettingToGameType(setting: Setting)
}

class GameTypeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    private lazy var viewGameType: UIView = {
        setupView(color: .white.withAlphaComponent(0.8), radius: diameter() / 2)
    }()
    
    private lazy var imageGameType: UIImageView = {
        setupImage(image: "\(game.image)", color: game.background, size: 60)
    }()
    
    private lazy var labelGameName: UILabel = {
        setupLabel(color: .white, title: "\(game.name)", size: 30, style: "Gill Sans")
    }()
    
    private lazy var buttonBack: UIButton = {
        setupButton(image: "multiply", action: #selector(backToMenu))
    }()
    
    private lazy var buttonHelp: UIButton = {
        setupButton(image: "questionmark", action: #selector(showDescription))
    }()
    
    private lazy var labelDescription: UILabel = {
        setupLabel(
            color: .white,
            title: "\(game.description)",
            size: 19,
            style: "Gill Sans",
            alignment: .left)
    }()
    
    private lazy var labelBulletsList: UILabel = {
        bulletsList(list: bulletsListGameType())
    }()
    
    private lazy var imageFirstSwap: UIImageView = {
        setupImage(image: imageFirstTitle(), color: colorTitle(), size: 25)
    }()
    
    private lazy var viewFirstSwap: UIView = {
        setupView(color: game.swap, radius: 12, addSubview: imageFirstSwap)
    }()
    
    private lazy var labelFirstSwap: UILabel = {
        setupLabel(
            color: .white,
            title: labelFirstTitle(),
            size: 24,
            style: "Gill Sans",
            alignment: .left)
    }()
    
    private lazy var labelFirstDescriptionSwap: UILabel = {
        setupLabel(
            color: .white,
            title: labelTitleFirstDescription(),
            size: 19,
            style: "Gill Sans",
            alignment: .left)
    }()
    
    private lazy var stackViewFirst: UIStackView = {
        setupStackView(labelTop: labelFirstSwap, labelBottom: labelFirstDescriptionSwap)
    }()
    
    private lazy var stackViewFirstSwap: UIStackView = {
        setupStackView(view: viewFirstSwap, stackView: stackViewFirst)
    }()
    
    private lazy var imageSecondSwap: UIImageView = {
        setupImage(image: imageSecondTitle(), color: .white, size: 25)
    }()
    
    private lazy var viewSecondSwap: UIView = {
        setupView(color: game.swap, radius: 12, addSubview: imageSecondSwap)
    }()
    
    private lazy var labelSecondSwap: UILabel = {
        setupLabel(
            color: .white,
            title: labelSecondTitle(),
            size: 24,
            style: "Gill Sans",
            alignment: .left)
    }()
    
    private lazy var labelSecondDescriptionSwap: UILabel = {
        setupLabel(
            color: .white,
            title: labelTitleSecondDescription(),
            size: 19,
            style: "Gill Sans",
            alignment: .left)
    }()
    
    private lazy var stackViewSecond: UIStackView = {
        setupStackView(labelTop: labelSecondSwap, labelBottom: labelSecondDescriptionSwap)
    }()
    
    private lazy var stackViewSecondSwap: UIStackView = {
        setupStackView(view: viewSecondSwap, stackView: stackViewSecond)
    }()
    
    private lazy var imageThirdSwap: UIImageView = {
        setupImage(image: "building.2", color: .white, size: 25)
    }()
    
    private lazy var viewThirdSwap: UIView = {
        setupView(color: game.swap, radius: 12, addSubview: imageThirdSwap)
    }()
    
    private lazy var labelThirdSwap: UILabel = {
        setupLabel(
            color: .white,
            title: "Режим столицы",
            size: 24,
            style: "Gill Sans",
            alignment: .left)
    }()
    
    private lazy var labelThirdDescriptionSwap: UILabel = {
        setupLabel(
            color: .white,
            title: "В качестве вопроса задается наименование столицы и пользователь должен составить слово из букв наименования страны.",
            size: 19,
            style: "Gill Sans",
            alignment: .left)
    }()
    
    private lazy var stackViewThird: UIStackView = {
        setupStackView(labelTop: labelThirdSwap, labelBottom: labelThirdDescriptionSwap)
    }()
    
    private lazy var stackViewThirdSwap: UIStackView = {
        setupStackView(view: viewThirdSwap, stackView: stackViewThird)
    }()
    
    private lazy var viewDescription: UIView = {
        let view = setupView(color: .clear)
        addSubviewsDescription(view: view)
        settingLabel(label: labelBulletsList, size: 19)
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = game.background
        scrollView.layer.cornerRadius = 15
        scrollView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        setupSubviews(subviews: viewDescription, on: scrollView)
        return scrollView
    }()
    
    private lazy var labelName: UILabel = {
        setupLabel(color: .white, title: "Тип игры", size: 25, style: "Gill Sans")
    }()
    
    private lazy var viewHelp: UIView = {
        let view = PopUpView()
        view.backgroundColor = game.swap
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        setupSubviews(subviews: labelName, scrollView, on: view)
        return view
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var buttonStart: UIButton = {
        setupButton(image: "play", color: game.play, action: #selector(startGame))
    }()
    
    private lazy var buttonFavoutites: UIButton = {
        setupButton(image: "star", color: game.favourite, action: #selector(favourites))
    }()
    
    private lazy var buttonSwap: UIButton = {
        setupButton(image: imageButton(), color: game.swap, action: #selector(swap), isEnabled: isEnabled())
    }()
    
    private lazy var stackViewButtons: UIStackView = {
        setupStackView(
            buttonFirst: buttonStart,
            buttonSecond: buttonFavoutites,
            buttonThird: buttonSwap)
    }()
    
    private lazy var buttonCountQuestions: UIButton = {
        setupButton(
            color: game.swap,
            labelFirst: labelCountQuestion,
            labelSecond: labelCount,
            tag: 1)
    }()
    
    private lazy var labelCountQuestion: UILabel = {
        setupLabel(color: .white, title: "\(mode.countQuestions)", size: 60, style: "Gill Sans")
    }()
    
    private lazy var labelCount: UILabel = {
        setupLabel(color: .white, title: "Количество вопросов", size: 17, style: "Gill Sans")
    }()
    
    private lazy var buttonContinents: UIButton = {
        setupButton(
            color: game.swap,
            labelFirst: labelContinents,
            labelSecond: labelContinentsDescription,
            tag: 2)
    }()
    
    private lazy var labelContinents: UILabel = {
        setupLabel(color: .white, title: "\(comma())", size: 30, style: "Gill Sans")
    }()
    
    private lazy var labelContinentsDescription: UILabel = {
        setupLabel(color: .white, title: "Континенты", size: 17, style: "Gill Sans")
    }()
    
    private lazy var buttonCountdown: UIButton = {
        setupButton(
            color: game.swap,
            labelFirst: labelCountdown,
            labelSecond: labelCountdownDesription,
            tag: 3)
    }()
    
    private lazy var labelCountdown: UILabel = {
        setupLabel(
            color: .white,
            title: isCountdown() ? "Да" : "Нет",
            size: 60,
            style: "Gill Sans")
    }()
    
    private lazy var labelCountdownDesription: UILabel = {
        setupLabel(
            color: .white,
            title: "Обратный отсчёт",
            size: 17,
            style: "Gill Sans")
    }()
    
    private lazy var buttonTime: UIButton = {
        setupButton(
            color: isCountdown() ? game.swap : .grayLight,
            labelFirst: labelTime,
            labelSecond: labelTimeDesription,
            image: imageInfinity,
            tag: 4,
            isEnabled: isCountdown())
    }()
    
    private lazy var labelTime: UILabel = {
        setupLabel(
            color: .white,
            title: "\(countdownOnOff())",
            size: 60,
            style: "Gill Sans")
    }()
    
    private lazy var labelTimeDesription: UILabel = {
        setupLabel(
            color: .white,
            title: "\(checkTimeDescription())",
            size: 17,
            style: "Gill Sans")
    }()
    
    private lazy var imageInfinity: UIImageView = {
        setupImage(image: "infinity", color: .white, size: 60)
    }()
    
    private lazy var labelSetting: UILabel = {
        setupLabel(color: .white, title: "", size: 22, style: "Gill Sans")
    }()
    
    private lazy var viewSettingDescription: UIView = {
        let view = setupView(color: game.background)
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private lazy var pickerViewQuestions: UIPickerView = {
        setupPickerView(color: .white, tag: 1)
    }()
    
    private lazy var labelAllCountries: UILabel = {
        setupLabel(
            color: isSelect(isOn: mode.allCountries), 
            title: "Все страны мира",
            size: 26,
            style: "mr_fontick")
    }()
    
    private lazy var labelCountAllCountries: UILabel = {
        setupLabel(
            color: isSelect(isOn: mode.allCountries),
            title: "Количество стран: \(FlagsOfCountries.shared.countries.count)",
            size: 20,
            style: "mr_fontick")
    }()
    
    private lazy var buttonAllCountries: UIButton = {
        setupButton(
            color: isSelect(isOn: !mode.allCountries),
            addLabelFirst: labelAllCountries,
            addLabelSecond: labelCountAllCountries)
    }()
    
    private lazy var labelAmericaContinent: UILabel = {
        setupLabel(
            color: isSelect(isOn: mode.americaContinent),
            title: "Континент Америки",
            size: 26,
            style: "mr_fontick")
    }()
    
    private lazy var labelCountAmericaContinent: UILabel = {
        setupLabel(
            color: isSelect(isOn: mode.americaContinent),
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfAmericanContinent.count)",
            size: 20,
            style: "mr_fontick")
    }()
    
    private lazy var buttonAmericaContinent: UIButton = {
        setupButton(
            color: isSelect(isOn: !mode.americaContinent),
            addLabelFirst: labelAmericaContinent,
            addLabelSecond: labelCountAmericaContinent,
            tag: 1)
    }()
    
    private lazy var labelEuropeContinent: UILabel = {
        setupLabel(
            color: isSelect(isOn: mode.europeContinent),
            title: "Континент Европы",
            size: 26,
            style: "mr_fontick")
    }()
    
    private lazy var labelCountEuropeContinent: UILabel = {
        setupLabel(
            color: isSelect(isOn: mode.europeContinent),
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfEuropeanContinent.count)",
            size: 20,
            style: "mr_fontick")
    }()
    
    private lazy var buttonEuropeContinent: UIButton = {
        setupButton(
            color: isSelect(isOn: !mode.europeContinent),
            addLabelFirst: labelEuropeContinent,
            addLabelSecond: labelCountEuropeContinent,
            tag: 2)
    }()
    
    private lazy var labelAfricaContinent: UILabel = {
        setupLabel(
            color: isSelect(isOn: mode.africaContinent),
            title: "Континент Африки",
            size: 26,
            style: "mr_fontick")
    }()
    
    private lazy var labelCountAfricaContinent: UILabel = {
        setupLabel(
            color: isSelect(isOn: mode.africaContinent),
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfAfricanContinent.count)",
            size: 20,
            style: "mr_fontick")
    }()
    
    private lazy var buttonAfricaContinent: UIButton = {
        setupButton(
            color: isSelect(isOn: !mode.africaContinent),
            addLabelFirst: labelAfricaContinent,
            addLabelSecond: labelCountAfricaContinent,
            tag: 3)
    }()
    
    private lazy var labelAsiaContinent: UILabel = {
        setupLabel(
            color: isSelect(isOn: mode.asiaContinent),
            title: "Континент Азии",
            size: 26,
            style: "mr_fontick")
    }()
    
    private lazy var labelCountAsiaContinent: UILabel = {
        setupLabel(
            color: isSelect(isOn: mode.asiaContinent),
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfAsianContinent.count)",
            size: 20,
            style: "mr_fontick")
    }()
    
    private lazy var buttonAsiaContinent: UIButton = {
        setupButton(
            color: isSelect(isOn: !mode.asiaContinent),
            addLabelFirst: labelAsiaContinent,
            addLabelSecond: labelCountAsiaContinent,
            tag: 4)
    }()
    
    private lazy var labelOceanContinent: UILabel = {
        setupLabel(
            color: isSelect(isOn: mode.oceaniaContinent),
            title: "Континент Океании",
            size: 26,
            style: "mr_fontick")
    }()
    
    private lazy var labelCountOceanContinent: UILabel = {
        setupLabel(
            color: isSelect(isOn: mode.oceaniaContinent),
            title: "Количество стран: \(FlagsOfCountries.shared.countriesOfOceanContinent.count)",
            size: 20,
            style: "mr_fontick")
    }()
    
    private lazy var buttonOceanContinent: UIButton = {
        setupButton(
            color: isSelect(isOn: !mode.oceaniaContinent),
            addLabelFirst: labelOceanContinent,
            addLabelSecond: labelCountOceanContinent,
            tag: 5)
    }()
    
    private lazy var stackViewContinents: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [buttonAllCountries, buttonAmericaContinent,
                               buttonEuropeContinent, buttonAfricaContinent,
                               buttonAsiaContinent, buttonOceanContinent])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var buttonCheckmark: UIButton = {
        setCheckmarkButton(image: isCheckmark(isOn: isCountdown()))
    }()
    
    private lazy var viewCheckmark: UIView = {
        setupView(color: .white, radius: 13, addButton: buttonCheckmark)
    }()
    
    private lazy var labelCheckmark: UILabel = {
        setupLabel(
            color: .white,
            title: "Вкл / Выкл",
            size: 26,
            style: "mr_fontick",
            alignment: .center)
    }()
    
    private lazy var stackViewCheckmark: UIStackView = {
        setupStackView(view: viewCheckmark, label: labelCheckmark)
    }()
    
    private lazy var pickerViewOneTime: UIPickerView = {
        setupPickerView(tag: 2)
    }()
    
    private lazy var pickerViewAllTime: UIPickerView = {
        setupPickerView(tag: 3)
    }()
    
    private lazy var stackViewPickerViews: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pickerViewOneTime, pickerViewAllTime])
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Один вопрос", "Все вопросы"])
        let font = UIFont(name: "mr_fontick", size: 22)
        segment.backgroundColor = .white
        segment.selectedSegmentTintColor = game.background
        segment.setTitleTextAttributes([NSAttributedString.Key
            .font: font ?? "",
            .foregroundColor: UIColor.white
        ], for: .selected)
        segment.setTitleTextAttributes([NSAttributedString.Key
            .font: font ?? "",
            .foregroundColor: game.background
        ], for: .normal)
        segment.layer.borderWidth = 5
        segment.layer.borderColor = UIColor.white.cgColor
        segment.addTarget(self, action: #selector(segmentSelect), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    private lazy var stackViewTime: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [segmentedControl, stackViewPickerViews])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var buttonDone: UIButton = {
        setupButton(title: "ОК", color: game.done, action: #selector(done))
    }()
    
    private lazy var buttonCancel: UIButton = {
        setupButton(title: "Отмена", color: .white, action: #selector(closeViewSetting))
    }()
    
    private lazy var stackView: UIStackView = {
        setupStackView(buttonFirst: buttonDone, buttonSecond: buttonCancel, spacing: 15)
    }()
    
    private lazy var viewSetting: UIView = {
        let view = PopUpViewSetting()
        view.backgroundColor = game.swap
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        setupSubviews(subviews: labelSetting, viewSettingDescription, stackView, on: view)
        return view
    }()
    
    typealias ParagraphData = (bullet: String, paragraph: String)
    
    var mode: Setting!
    var game: Games!
    var tag: Int!
    var delegate: GameTypeViewControllerDelegate!
    var numberContinent = 0
    
    weak var delegateInput: MenuViewControllerInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupSubviews()
        setupBarButton()
        setupConstraints()
    }
    // MARK: - UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1: mode.countRows
        case 2: 10
        default: 6 * mode.countQuestions - 4 * mode.countQuestions + 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        var title = String()
        var attributed = NSAttributedString()
        
        switch pickerView.tag {
        case 1: 
            title = "\(row + 10)"
            attributed = attributtedString(title: title, tag: pickerView.tag)
        case 2:
            title = "\(row + 6)"
            attributed = attributtedString(title: title, tag: pickerView.tag)
        default:
            title = "\(row + 4 * mode.countQuestions)"
            attributed = attributtedString(title: title, tag: pickerView.tag)
        }
        
        label.textAlignment = .center
        label.attributedText = attributed
        return label
    }
    
    private func attributtedString(title: String, tag: Int) -> NSAttributedString {
        let color = tag == 1 ? game.favourite : color(tag: tag)
        return NSAttributedString(string: title, attributes: [
            .font: UIFont(name: "mr_fontick", size: 26) ?? "",
            .foregroundColor: color
        ])
    }
    // MARK: - General methods
    private func setupDesign() {
        view.backgroundColor = game.background
        imageInfinity.isHidden = isCountdown()
    }
    
    private func setupSubviews() {
        setupSubviews(subviews: viewGameType, imageGameType, labelGameName,
                      stackViewButtons, buttonCountQuestions, buttonContinents,
                      buttonCountdown, buttonTime, visualEffectView,
                      on: view)
    }
    
    private func setupBarButton() {
        let leftBarButton = UIBarButtonItem(customView: buttonBack)
        let rightBarButton = UIBarButtonItem(customView: buttonHelp)
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupSubviews(subviews: UIView..., on subviewOther: UIView) {
        subviews.forEach { subview in
            subviewOther.addSubview(subview)
        }
    }
    
    private func removeSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
    
    private func barButtonsOnOff(bool: Bool) {
        let opacity: Float = bool ? 1 : 0
        isEnabled(buttons: buttonBack, buttonHelp, bool: bool)
        setupOpacityButtons(buttons: buttonBack, buttonHelp, opacity: opacity)
    }
    
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
    
    private func isCountdown() -> Bool {
        mode.timeElapsed.timeElapsed ? true : false
    }
    
    private func isOneQuestion() -> Bool {
        mode.timeElapsed.questionSelect.oneQuestion
    }
    
    private func oneQuestionTime() -> Int {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime
    }
    
    private func allQuestionTime() -> Int {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime
    }
    
    private func countdownOnOff(bool: Bool) {
        mode.timeElapsed.timeElapsed = bool
    }
    
    private func oneQuestionOnOff(bool: Bool) {
        mode.timeElapsed.questionSelect.oneQuestion = bool
    }
    
    private func setTimeOneQuestion(time: Int) {
        mode.timeElapsed.questionSelect.questionTime.oneQuestionTime = time
    }
    
    private func setTimeAllQuestions(time: Int) {
        mode.timeElapsed.questionSelect.questionTime.allQuestionsTime = time
    }
    
    private func counterContinents() {
        counterContinents(continents: mode.americaContinent, mode.europeContinent,
                          mode.africaContinent, mode.asiaContinent, mode.oceaniaContinent)
    }
    
    private func isCheckmark(isOn: Bool) -> String {
        isOn ? "checkmark.circle.fill" : "circle"
    }
    
    private func setSubviewsTag(subviews: UIView..., tag: Int) {
        subviews.forEach { subview in
            subview.tag = tag
        }
    }
    
    private func reloadPickerViews(pickerViews: UIPickerView...) {
        pickerViews.forEach { pickerView in
            pickerView.reloadAllComponents()
        }
    }
    
    private func color(tag: Int) -> UIColor {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return tag == 2 ? game.favourite : .grayLight
        default:
            return tag == 2 ? .grayLight : game.favourite
        }
    }
    // MARK: - Bar buttons activate
    @objc private func backToMenu() {
        delegate.dataOfSettingToMenuFromGameType(setting: mode)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func showDescription() {
        setupSubviews(subviews: viewHelp, on: view)
        setupConstraintsViewHelp()
        barButtonsOnOff(bool: false)
        
        viewHelp.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        viewHelp.alpha = 0
        UIView.animate(withDuration: 0.5) { [self] in
            visualEffectView.alpha = 1
            viewHelp.alpha = 1
            viewHelp.transform = .identity
        }
    }
    // MARK: - Title, color and image for button of setting,
    private func imageButton() -> String {
        switch tag {
        case 0, 1, 4: return mode.flag ? "flag" : "building"
        case 2: return "globe.europe.africa"
        default: return scrabbleType()
        }
    }
    
    private func scrabbleType() -> String {
        switch mode.scrabbleType {
        case 0: return "flag"
        case 1: return "globe.europe.africa"
        default: return "building.2"
        }
    }
    
    private func isEnabled() -> Bool {
        tag == 2 ? false : true
    }
    
    private func checkQuestionnaire() -> Bool {
        game.gameType == .questionnaire ? false : true
    }
    
    private func isSelect(isOn: Bool) -> UIColor {
        isOn ? game.background : .white
    }
    
    private func titleSetting(tag: Int) -> String {
        switch tag {
        case 1: return "Количество вопросов"
        case 2: return "Континенты"
        case 3: return "Обратный отсчет"
        default: return checkTimeDescription()
        }
    }
    
    private func imageFirstTitle() -> String {
        tag == 2 ? "globe.europe.africa" : "flag"
    }
    
    private func colorTitle() -> UIColor {
        tag == 2 ? .white.withAlphaComponent(0.4) : .white
    }
    
    private func labelFirstTitle() -> String {
        tag == 2 ? "Режим карты" : "Режим флага"
    }
    
    private func labelTitleFirstDescription() -> String {
        switch tag {
        case 0, 1: "В качестве вопроса задается флаг страны и пользователь должен выбрать ответ наименования страны."
        case 2: "В качестве вопроса задается географическая карта страны и пользователь должен выбрать ответ наименования страны. (Кнопка неактивна)"
        case 3: "В качестве вопроса задается флаг страны и пользователь должен составить слово из букв наименования страны."
        default: "В качестве вопроса задается флаг страны и пользователь должен выбрать ответ наименования столицы."
        }
    }
    
    private func imageSecondTitle() -> String {
        tag == 3 ? "globe.europe.africa" : "building"
    }
    
    private func labelSecondTitle() -> String {
        switch tag {
        case 0, 1: "Режим наименования"
        case 4: "Режим столицы"
        default: "Режим карты"
        }
    }
    
    private func labelTitleSecondDescription() -> String {
        switch tag {
        case 0, 1: "В качестве вопроса задается наименование страны и пользователь должен выбрать ответ флага страны."
        case 4: "В качестве вопроса задается наименование страны и пользователь должен выбрать ответ наименования столицы."
        default: "В качестве вопроса задается географическая карта страны и пользователь должен составить слово из букв наименования страны."
        }
    }
    
    private func addSubviewsDescription(view: UIView) {
        switch tag {
        case 0, 1, 4: addSubviewsTwo(view: view)
        case 2: addSubviewsOne(view: view)
        default: addSubviewsThree(view: view)
        }
    }
    
    private func addSubviewsOne(view: UIView) {
        setupSubviews(subviews: labelDescription, labelBulletsList, 
                      stackViewFirstSwap, on: view)
    }
    
    private func addSubviewsTwo(view: UIView) {
        setupSubviews(subviews: labelDescription, labelBulletsList, 
                      stackViewFirstSwap, stackViewSecondSwap, on: view)
    }
    
    private func addSubviewsThree(view: UIView) {
        setupSubviews(subviews: labelDescription, labelBulletsList, 
                      stackViewFirstSwap, stackViewSecondSwap,
                      stackViewThirdSwap, on: view)
    }
    // MARK: - Methods for popup view controllers
    private func addSubviews(tag: Int) {
        switch tag {
        case 1: setPickerViewCountQuestions()
        case 2: setButtonsContinents()
        case 3: setButtonCheckmarkCountdown()
        default: setPickerViewsTime()
        }
    }
    
    private func setPickerViewCountQuestions() {
        let row = mode.countQuestions - 10
        setupSubviews(subviews: pickerViewQuestions, on: viewSettingDescription)
        pickerViewQuestions.selectRow(row, inComponent: 0, animated: false)
    }
    
    private func setButtonsContinents() {
        counterContinents()
        setupSubviews(subviews: stackViewContinents, on: viewSettingDescription)
        setColorPressButtons(buttons: buttonAllCountries, buttonAmericaContinent,
                             buttonEuropeContinent, buttonAfricaContinent,
                             buttonAsiaContinent, buttonOceanContinent)
    }
    
    private func setColorPressButtons(buttons: UIButton...) {
        buttons.forEach { button in
            checkBool(tag: button.tag, button: button)
        }
    }
    
    private func checkBool(tag: Int, button: UIButton) {
        switch tag {
        case 0: checkBool(bool: mode.allCountries, button: button)
        case 1: checkBool(bool: mode.americaContinent, button: button)
        case 2: checkBool(bool: mode.europeContinent, button: button)
        case 3: checkBool(bool: mode.africaContinent, button: button)
        case 4: checkBool(bool: mode.asiaContinent, button: button)
        default: checkBool(bool: mode.oceaniaContinent, button: button)
        }
    }
    
    private func checkBool(bool: Bool, button: UIButton) {
        setColor(button: button, color: bool ? .white : game.background)
    }
    
    private func setColor(button: UIButton, color: UIColor) {
        let colorLabel = color == .white ? game.background : .white
        buttonOnOff(buttons: button, color: color)
        labelOnOff(tag: button.tag, color: colorLabel)
    }
    
    private func setButtonCheckmarkCountdown() {
        setupSubviews(subviews: stackViewCheckmark, on: viewSettingDescription)
        checkButtonCheckmark()
    }
    
    private func checkButtonCheckmark() {
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        let symbol = isCountdown() ? "checkmark.circle.fill" : "circle"
        let image = UIImage(systemName: symbol, withConfiguration: size)
        buttonCheckmark.setImage(image, for: .normal)
    }
    
    private func setPickerViewsTime() {
        setupSubviews(subviews: stackViewTime, on: viewSettingDescription)
        setSegmentIndex()
        isOneQuestion() ? checkQuestionnairePickerViews() : pickerViewThirdOn()
        setPickerViewsRows()
        reloadPickerViews(pickerViews: pickerViewOneTime, pickerViewAllTime)
    }
    
    private func setSegmentIndex() {
        let index = game.gameType == .questionnaire ? 1 : 0
        segmentedControl.selectedSegmentIndex = isOneQuestion() ? index : 1
        segmentedControl.isUserInteractionEnabled = checkQuestionnaire()
    }
    
    private func checkQuestionnairePickerViews() {
        tag == 1 ? pickerViewThirdOn() : pickerViewSecondOn()
    }
    
    private func setPickerViewsRows() {
        let rowOneQuestion = oneQuestionTime() - 6
        let rowAllQuestions = allQuestionTime() - 4 * mode.countQuestions
        pickerViewOneTime.selectRow(rowOneQuestion, inComponent: 0, animated: false)
        pickerViewAllTime.selectRow(rowAllQuestions, inComponent: 0, animated: false)
    }
    // MARK: - Constraints for popup views
    private func setConstraintsSetting(tag: Int) {
        switch tag {
        case 1: setupConstraintsSettingCountQuestions()
        case 2: setupConstraintsSettingContinents()
        case 3: setupConstraintsSettingCountdown()
        default: setupConstraintsSettingTime()
        }
    }
    // MARK: - Press done for change setting, count questions
    private func setupCountQuestions() {
        let row = pickerViewQuestions.selectedRow(inComponent: 0)
        mode.countQuestions = row + 10
        setTimeAllQuestions(time: 5 * mode.countQuestions)
        setupTitles(title: "\(row + 10)")
        closeViewSetting()
    }
    
    private func setupTitles(title: String) {
        labelCountQuestion.text = title
        labelTime.text = countdownOnOff()
    }
    // MARK: - Press done for change setting, continents
    private func setupContinents() {
        setupCurrentContinents()
        setupCountRows()
        setupCountQuestions(countRows: mode.countRows)
        setupTitlesContinents()
        closeViewSetting()
    }
    
    private func setupCurrentContinents() {
        setupContinents(buttons: buttonAllCountries, buttonAmericaContinent,
                        buttonEuropeContinent, buttonAfricaContinent,
                        buttonAsiaContinent, buttonOceanContinent)
    }
    
    private func setupCountRows() {
        setupCountRows(continents: mode.allCountries, mode.americaContinent,
                       mode.europeContinent, mode.africaContinent,
                       mode.asiaContinent, mode.oceaniaContinent)
    }
    
    private func setupContinents(buttons: UIButton...) {
        var counter = 0
        buttons.forEach { button in
            let bool = button.backgroundColor == .white ? true : false
            checkContinents(counter: counter, bool: bool)
            counter += 1
        }
    }
    
    private func checkContinents(counter: Int, bool: Bool) {
        switch counter {
        case 0: mode.allCountries = bool
        case 1: mode.americaContinent = bool
        case 2: mode.europeContinent = bool
        case 3: mode.africaContinent = bool
        case 4: mode.asiaContinent = bool
        default: mode.oceaniaContinent = bool
        }
    }
    
    private func setupCountRows(continents: Bool...) {
        var countRows = 0
        var counter = 0
        continents.forEach { continent in
            if continent {
                countRows += checkContinents(continent: counter)
            }
            counter += 1
        }
        mode.countRows = checkCountRows(count: countRows - 9)
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
        let countRows = DefaultSetting.countRows.rawValue
        return count > countRows ? countRows : count
    }
    
    private func setupCountQuestions(countRows: Int) {
        let count = mode.countQuestions
        mode.countQuestions = countRows + 9 < count ? countRows + 9 : count
    }
    
    private func setupTitlesContinents() {
        labelContinents.text = comma()
        labelCountQuestion.text = "\(mode.countQuestions)"
        reloadPickerViews(pickerViews: pickerViewQuestions)
    }
    // MARK: - Press done for change setting, countdown
    private func setupCountdown() {
        setupCheckmarkImageToggle()
        setupTitlesCountdown()
        setupButtonTime()
        closeViewSetting()
    }
    
    private func setupCheckmarkImageToggle() {
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        let currentImage = buttonCheckmark.currentImage?.withConfiguration(size)
        let imageCircle = UIImage(systemName: "circle", withConfiguration: size)
        labelCountdown.text = currentImage == imageCircle ? "Нет" : "Да"
        countdownOnOff(bool: currentImage == imageCircle ? false : true)
    }
    
    private func setupTitlesCountdown() {
        imageInfinity.isHidden = isCountdown()
        labelTime.text = countdownOnOff()
    }
    
    private func setupButtonTime() {
        buttonTime.isEnabled = isCountdown()
        buttonTime.backgroundColor = isCountdown() ? game.swap : .grayLight
    }
    // MARK: - Press done for change setting, time
    private func setupTime() {
        setupSegmentedControl()
        setupTitleTime()
        setupDataFromPickerViews()
        closeViewSetting()
    }
    
    private func setupSegmentedControl() {
        let isOn = segmentedControl.selectedSegmentIndex == 0 ? true : false
        oneQuestionOnOff(bool: isOn)
    }
    
    private func setupTitleTime() {
        labelTime.text = countdownOnOff()
        labelTimeDesription.text = checkTimeDescription()
    }
    
    private func setupDataFromPickerViews() {
        if isOneQuestion() {
            let row = pickerViewOneTime.selectedRow(inComponent: 0)
            setTimeOneQuestion(time: row + 6)
        } else {
            let row = pickerViewAllTime.selectedRow(inComponent: 0)
            setTimeAllQuestions(time: row + 4 * mode.countQuestions)
        }
    }
    // MARK: - Setup change setting, continents
    private func buttonPress(sender: UIButton) {
        guard sender.tag > 0 else { return colorAllCountries(sender: sender) }
        numberContinent += sender.backgroundColor == .white ? -1 : 1
        guard numberContinent > 4 else { return condition(sender: sender) }
        colorAllCountries(sender: buttonAllCountries)
    }
    
    private func condition(sender: UIButton) {
        numberContinent == 0 ? colorAllCountries(sender: buttonAllCountries) : 
        colorContinents(sender: sender)
    }
    
    private func colorAllCountries(sender: UIButton) {
        guard sender.backgroundColor == game.background else { return }
        numberContinent = 0
        buttonAllCountries(colorButton: .white, colorLabel: game.background)
        buttonsContinents(colorButton: game.background, colorLabel: .white)
    }
    
    private func buttonAllCountries(colorButton: UIColor, colorLabel: UIColor) {
        buttonOnOff(buttons: buttonAllCountries, color: colorButton)
        labelOnOff(labels: labelAllCountries, labelCountAllCountries, color: colorLabel)
    }
    
    private func buttonsContinents(colorButton: UIColor, colorLabel: UIColor) {
        buttonOnOff(buttons: buttonAmericaContinent, buttonEuropeContinent,
                    buttonAfricaContinent, buttonAsiaContinent,
                    buttonOceanContinent, color: colorButton)
        labelOnOff(labels: labelAmericaContinent, labelCountAmericaContinent,
                   labelEuropeContinent, labelCountEuropeContinent,
                   labelAfricaContinent, labelCountAfricaContinent, 
                   labelAsiaContinent, labelCountAsiaContinent, labelOceanContinent,
                   labelCountOceanContinent, color: colorLabel)
    }
    
    private func colorContinents(sender: UIButton) {
        let colorButton = sender.backgroundColor == game.background ? .white : game.background
        let colorLabel = sender.backgroundColor == game.background ? game.background : .white
        buttonOnOff(buttons: sender, color: colorButton)
        labelOnOff(tag: sender.tag, color: colorLabel)
        guard buttonAllCountries.backgroundColor == .white else { return }
        buttonAllCountries(colorButton: game.background, colorLabel: .white)
    }
    
    private func labelOnOff(tag: Int, color: UIColor) {
        switch tag {
        case 0: labelOnOff(labels: labelAllCountries, labelCountAllCountries, color: color)
        case 1: labelOnOff(labels: labelAmericaContinent, labelCountAmericaContinent, color: color)
        case 2: labelOnOff(labels: labelEuropeContinent, labelCountEuropeContinent, color: color)
        case 3: labelOnOff(labels: labelAfricaContinent, labelCountAfricaContinent, color: color)
        case 4: labelOnOff(labels: labelAsiaContinent, labelCountAsiaContinent, color: color)
        default: labelOnOff(labels: labelOceanContinent, labelCountOceanContinent, color: color)
        }
    }
    
    private func buttonOnOff(buttons: UIButton..., color: UIColor) {
        buttons.forEach { button in
            UIView.animate(withDuration: 0.3) {
                button.backgroundColor = color
            }
        }
    }
    
    private func labelOnOff(labels: UILabel..., color: UIColor) {
        labels.forEach { label in
            UIView.animate(withDuration: 0.3) {
                label.textColor = color
            }
        }
    }
    
    private func counterContinents(continents: Bool...) {
        numberContinent = 0
        continents.forEach { continent in
            if continent {
                numberContinent += 1
            }
        }
    }
    // MARK: - Setup change setting, countdown
    private func checkmarkOnOff() {
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        let currentImage = buttonCheckmark.currentImage?.withConfiguration(size)
        let imageCircle = UIImage(systemName: "circle", withConfiguration: size)
        let imageCheckmark = UIImage(systemName: "checkmark.circle.fill", withConfiguration: size)
        let image = currentImage == imageCircle ? imageCheckmark : imageCircle
        buttonCheckmark.setImage(image, for: .normal)
    }
    // MARK: - Setup change setting, time
    private func pickerViewSecondOn() {
        setPickerView(pickerView: pickerViewOneTime, color: .white, isOn: true)
        setPickerView(pickerView: pickerViewAllTime, color: .skyGrayLight, isOn: false)
    }
    
    private func pickerViewThirdOn() {
        setPickerView(pickerView: pickerViewOneTime, color: .skyGrayLight, isOn: false)
        setPickerView(pickerView: pickerViewAllTime, color: .white, isOn: true)
    }
    
    private func setPickerView(pickerView: UIPickerView, color: UIColor, isOn: Bool) {
        pickerView.isUserInteractionEnabled = isOn
        UIView.animate(withDuration: 0.3) {
            pickerView.backgroundColor = color
        }
    }
    // MARK: - Start game, favourites and swap
    @objc private func startGame() {
        switch tag {
        case 0: quizOfFlagsViewController()
        case 1: questionnaireViewController()
        default: quizOfCapitalsViewController()
        }
    }
    
    private func quizOfFlagsViewController() {
        let startGameVC = QuizOfFlagsViewController()
        startGameVC.mode = mode
        startGameVC.game = game
        startGameVC.delegateInput = self
        navigationController?.pushViewController(startGameVC, animated: true)
    }
    
    private func questionnaireViewController() {
        let startGameVC = QuestionnaireViewController()
        startGameVC.mode = mode
        startGameVC.game = game
        startGameVC.delegateInput = self
        navigationController?.pushViewController(startGameVC, animated: true)
    }
    
    private func quizOfCapitalsViewController() {
        let startGameVC = QuizOfCapitalsViewController()
        startGameVC.mode = mode
        startGameVC.game = game
        startGameVC.delegateInput = self
        navigationController?.pushViewController(startGameVC, animated: true)
    }
    
    @objc private func favourites() {
        
    }
    
    @objc private func swap() {
        switch tag {
        case 0, 1, 4: GameTypeFirst()
        default: GameTypeSecond()
        }
    }
    
    private func GameTypeFirst() {
        mode.flag ? imageSwap(image: "building") : imageSwap(image: "flag")
        mode.flag.toggle()
        StorageManager.shared.saveSetting(setting: mode)
    }
    
    private func imageSwap(image: String) {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        buttonSwap.setImage(image, for: .normal)
    }
    
    private func GameTypeSecond() {
        switch mode.scrabbleType {
        case 0: imageSwap(image: "globe.europe.africa", scrabbleType: mode.scrabbleType + 1)
        case 1: imageSwap(image: "building.2", scrabbleType: mode.scrabbleType + 1)
        default: imageSwap(image: "flag", scrabbleType: 0)
        }
    }
    
    private func imageSwap(image: String, scrabbleType: Int) {
        imageSwap(image: image)
        mode.scrabbleType = scrabbleType
        StorageManager.shared.saveSetting(setting: mode)
    }
    // MARK: - Button titles
    private func comma() -> String {
        let comma = comma(continents: mode.allCountries, mode.americaContinent,
                          mode.europeContinent, mode.africaContinent,
                          mode.asiaContinent, mode.oceaniaContinent)
        return comma
    }
    
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
    
    private func countdownOnOff() -> String {
        isCountdown() ? "\(checkCountdownType())" : ""
    }
    
    private func checkCountdownType() -> String {
        isOneQuestion() ? "\(checkTimeGameType())" : "\(allQuestionTime())"
    }
    
    private func checkTimeGameType() -> String {
        game.gameType == .questionnaire ? "\(allQuestionTime())" : "\(oneQuestionTime())"
    }
    
    private func checkTimeDescription() -> String {
        isOneQuestion() ? "\(checkTitleGameType())" : "Время всех вопросов"
    }
    
    private func checkTitleGameType() -> String {
        game.gameType == .questionnaire ? "Время всех вопросов" : "Время одного вопроса"
    }
    // MARK: - Press button count questions / continents / countdown / time
    @objc private func changeSetting(sender: UIButton) {
        setupSubviews(subviews: viewSetting, on: view)
        setting(tag: sender.tag)
        barButtonsOnOff(bool: false)
        
        viewSetting.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        viewSetting.alpha = 0
        UIView.animate(withDuration: 0.5) { [self] in
            visualEffectView.alpha = 1
            viewSetting.alpha = 1
            viewSetting.transform = .identity
        }
    }
    
    private func setting(tag: Int) {
        addSubviews(tag: tag)
        labelSetting.text = titleSetting(tag: tag)
        setSubviewsTag(subviews: buttonDone, viewSetting, tag: tag)
        setConstraintsSetting(tag: tag)
    }
    
    @objc private func continents(sender: UIButton) {
        buttonPress(sender: sender)
    }
    
    @objc private func countdown() {
        checkmarkOnOff()
    }
    
    @objc private func segmentSelect() {
        let index = segmentedControl.selectedSegmentIndex
        index == 0 ? pickerViewSecondOn() : pickerViewThirdOn()
        labelSetting.text = index == 1 ? "Время всех вопросов" : "Время одного вопроса"
        reloadPickerViews(pickerViews: pickerViewOneTime, pickerViewAllTime)
    }
    // MARK: - Press done button
    @objc private func done(sender: UIButton) {
        doneChangeSetting(tag: sender.tag)
    }
    
    private func doneChangeSetting(tag: Int) {
        switch tag {
        case 1: setupCountQuestions()
        case 2: setupContinents()
        case 3: setupCountdown()
        default: setupTime()
        }
    }
}
// MARK: - Setup views
extension GameTypeViewController {
    private func setupView(color: UIColor, radius: CGFloat? = nil,
                           addSubview: UIView? = nil, addButton: UIButton? = nil) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = radius ?? 0
        view.translatesAutoresizingMaskIntoConstraints = false
        if let image = addSubview {
            view.addSubview(image)
        } else if let button = addButton {
            view.addSubview(button)
            view.layer.shadowColor = color.cgColor
            view.layer.shadowOpacity = 0.4
            view.layer.shadowOffset = CGSize(width: 0, height: 6)
        }
        return view
    }
}
// MARK: - Setup images
extension GameTypeViewController {
    private func setupImage(image: String, color: UIColor, size: CGFloat) -> UIImageView {
        let size = UIImage.SymbolConfiguration(pointSize: size)
        let image = UIImage(systemName: image, withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}
// MARK: - Setup labels
extension GameTypeViewController {
    private func setupLabel(color: UIColor, title: String, size: CGFloat, style: String,
                            alignment: NSTextAlignment? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = color
        label.font = UIFont(name: style, size: size)
        label.textAlignment = alignment ?? .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func settingLabel(label: UILabel, size: CGFloat) {
        label.textColor = .white
        label.font = UIFont(name: "Gill Sans", size: size)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
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
}
// MARK: - Setup buttons
extension GameTypeViewController {
    private func setupButton(image: String, action: Selector) -> UIButton {
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
    
    private func setupButton(image: String, color: UIColor, action: Selector,
                             isEnabled: Bool? = nil) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = Button(type: .system)
        button.backgroundColor = color
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = isEnabled ?? true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setupButton(color: UIColor, labelFirst: UILabel,
                             labelSecond: UILabel, image: UIImageView? = nil,
                             tag: Int, isEnabled: Bool? = nil) -> UIButton {
        let button = Button(type: .custom)
        button.backgroundColor = color
        button.layer.cornerRadius = 20
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(changeSetting), for: .touchUpInside)
        button.tag = tag
        button.isEnabled = isEnabled ?? true
        if let image = image {
            setupSubviews(subviews: labelFirst, labelSecond, image, on: button)
        } else {
            setupSubviews(subviews: labelFirst, labelSecond, on: button)
        }
        return button
    }
    
    private func setupButton(title: String, color: UIColor, action: Selector) -> UIButton {
        let button = Button(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(game.favourite, for: .normal)
        button.titleLabel?.font = UIFont(name: "mr_fontick", size: 25)
        button.backgroundColor = color
        button.layer.cornerRadius = 12
        button.layer.shadowColor = color.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setupButton(color: UIColor, addLabelFirst: UILabel,
                             addLabelSecond: UILabel, tag: Int? = nil) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = color
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 13
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.tag = tag ?? 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(continents), for: .touchUpInside)
        setupSubviews(subviews: addLabelFirst, addLabelSecond, on: button)
        return button
    }
    
    private func setCheckmarkButton(image: String) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = game.background
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(countdown), for: .touchUpInside)
        return button
    }
}
// MARK: - Setup stack views
extension GameTypeViewController {
    private func setupStackView(buttonFirst: UIButton, buttonSecond: UIButton,
                                buttonThird: UIButton? = nil,
                                spacing: CGFloat? = nil) -> UIStackView {
        var arrangedSubviews: [UIView] = []
        if let buttonThird = buttonThird {
            arrangedSubviews = [buttonFirst, buttonSecond, buttonThird]
        } else {
            arrangedSubviews = [buttonFirst, buttonSecond]
        }
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.spacing = spacing ?? 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setupStackView(labelTop: UILabel, labelBottom: UILabel) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [labelTop, labelBottom])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setupStackView(view: UIView, stackView: UIStackView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [view, stackView])
        stackView.spacing = 10
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setupStackView(view: UIView, label: UILabel) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [view, label])
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Setup picker views
extension GameTypeViewController {
    private func setupPickerView(color: UIColor? = nil, tag: Int) -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = color
        pickerView.layer.cornerRadius = 13
        pickerView.tag = tag
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }
}
// MARK: - Setup constraints
extension GameTypeViewController {
    private func setupConstraints() {
        setupSquare(subviews: buttonBack, buttonHelp, sizes: 40)
        
        NSLayoutConstraint.activate([
            viewGameType.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30),
            viewGameType.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        setupSquare(subviews: viewGameType, sizes: diameter())
        setupCenterSubview(subview: imageGameType, on: viewGameType)
        
        NSLayoutConstraint.activate([
            labelGameName.topAnchor.constraint(equalTo: viewGameType.bottomAnchor, constant: 10),
            labelGameName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackViewButtons.topAnchor.constraint(equalTo: labelGameName.bottomAnchor, constant: 15),
            stackViewButtons.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        setupSize(subview: stackViewButtons, width: 160, height: 40)
        
        setupConstraintsButton(button: buttonCountQuestions,
                               layout: stackViewButtons.bottomAnchor,
                               leading: 20, trailing: -halfWidth(), height: 160)
        setupConstraintsLabel(label: labelCountQuestion, button: buttonCountQuestions, constant: -30)
        setupConstraintsLabel(label: labelCount, button: buttonCountQuestions, constant: 35)
        
        setupConstraintsButton(button: buttonContinents,
                               layout: stackViewButtons.bottomAnchor,
                               leading: halfWidth(), trailing: -20, height: 190)
        setupConstraintsLabel(label: labelContinents, button: buttonContinents, constant: -15)
        setupConstraintsLabel(label: labelContinentsDescription, button: buttonContinents, constant: 75)
        
        setupConstraintsButton(button: buttonCountdown,
                               layout: buttonCountQuestions.bottomAnchor,
                               leading: 20, trailing: -halfWidth(), height: 150)
        setupConstraintsLabel(label: labelCountdown, button: buttonCountdown, constant: -25)
        setupConstraintsLabel(label: labelCountdownDesription, button: buttonCountdown, constant: 35)
        
        setupConstraintsButton(button: buttonTime,
                               layout: buttonContinents.bottomAnchor,
                               leading: halfWidth(), trailing: -20, height: 120)
        setupConstraintsLabel(label: labelTime, button: buttonTime, constant: -25)
        setupConstraintsLabel(label: labelTimeDesription, button: buttonTime, constant: 30)
        NSLayoutConstraint.activate([
            imageInfinity.centerXAnchor.constraint(equalTo: buttonTime.centerXAnchor),
            imageInfinity.centerYAnchor.constraint(equalTo: buttonTime.centerYAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupConstraintsButton(button: UIButton, layout: NSLayoutYAxisAnchor,
                                        leading: CGFloat, trailing: CGFloat,
                                        height: CGFloat) {
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: layout, constant: 20),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing),
            button.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    private func setupConstraintsLabel(label: UILabel, button: UIButton, constant: CGFloat) {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: constant),
            label.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupConstraintsViewHelp() {
        NSLayoutConstraint.activate([
            viewHelp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewHelp.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewHelp.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            viewHelp.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7)
        ])
        
        NSLayoutConstraint.activate([
            labelName.centerXAnchor.constraint(equalTo: viewHelp.centerXAnchor, constant: 20),
            labelName.centerYAnchor.constraint(equalTo: viewHelp.topAnchor, constant: 31.875)
        ])
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: viewHelp.topAnchor, constant: 63.75),
            scrollView.leadingAnchor.constraint(equalTo: viewHelp.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: viewHelp.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: viewHelp.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            viewDescription.topAnchor.constraint(equalTo: scrollView.topAnchor),
            viewDescription.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            viewDescription.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            viewDescription.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            viewDescription.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            viewDescription.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: size())
        ])
        
        NSLayoutConstraint.activate([
            labelDescription.topAnchor.constraint(equalTo: viewDescription.topAnchor, constant: 15),
            labelDescription.leadingAnchor.constraint(equalTo: viewDescription.leadingAnchor, constant: 15),
            labelDescription.trailingAnchor.constraint(equalTo: viewDescription.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            labelBulletsList.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 19),
            labelBulletsList.leadingAnchor.constraint(equalTo: viewDescription.leadingAnchor, constant: 15),
            labelBulletsList.trailingAnchor.constraint(equalTo: viewDescription.trailingAnchor, constant: -15)
        ])
        
        setupGameTypeDescription()
    }
    
    private func setupGameTypeDescription() {
        switch tag {
        case 0, 1, 4: gameTypeSecond()
        case 3: gameTypeThird()
        default: gameTypeFirst()
        }
    }
    
    private func gameTypeFirst() {
        setViewsImagesSwap(image: imageFirstSwap, view: viewFirstSwap,
                           subview: stackViewFirstSwap, to: labelBulletsList)
    }
    
    private func gameTypeSecond() {
        setViewsImagesSwap(image: imageFirstSwap, view: viewFirstSwap,
                           subview: stackViewFirstSwap, to: labelBulletsList)
        setViewsImagesSwap(image: imageSecondSwap, view: viewSecondSwap,
                           subview: stackViewSecondSwap, to: stackViewFirstSwap)
    }
    
    private func gameTypeThird() {
        setViewsImagesSwap(image: imageFirstSwap, view: viewFirstSwap,
                           subview: stackViewFirstSwap, to: labelBulletsList)
        setViewsImagesSwap(image: imageSecondSwap, view: viewSecondSwap,
                           subview: stackViewSecondSwap, to: stackViewFirstSwap)
        setViewsImagesSwap(image: imageThirdSwap, view: viewThirdSwap,
                           subview: stackViewThirdSwap, to: stackViewSecondSwap)
    }
    
    private func setViewsImagesSwap(image: UIImageView, view: UIView, 
                                    subview: UIView, to otherSubview: UIView) {
        setupCenterSubview(subview: image, on: view)
        setupSquare(subviews: view, sizes: 40)
        
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: otherSubview.bottomAnchor),
            subview.leadingAnchor.constraint(equalTo: viewDescription.leadingAnchor, constant: 15),
            subview.trailingAnchor.constraint(equalTo: viewDescription.trailingAnchor, constant: -15)
        ])
    }
    
    private func size() -> CGFloat {
        switch tag {
        case 0, 4: 1.4
        case 1: 1.55
        case 2: 1.15
        default: 1.65
        }
    }
    
    private func setupConstraintsSettingCountQuestions() {
        setupConstraintsViewsAndLabel(constant: 100)
        setupConstraintsSubviews(subview: pickerViewQuestions, to: viewSettingDescription, height: 110)
        setupConstraintsDoneCancel()
    }
    
    private func setupConstraintsSettingContinents() {
        setupConstraintsViewsAndLabel(constant: -220)
        setupConstraintsSubviews(subview: stackViewContinents, to: viewSettingDescription, height: 435)
        setupConstraintsOnButton()
        setupConstraintsDoneCancel()
    }
    
    private func setupConstraintsSettingCountdown() {
        setupConstraintsViewsAndLabel(constant: 165)
        setupConstraintsSubviews(subview: stackViewCheckmark, to: viewSettingDescription, height: 60)
        setupSquare(subviews: viewCheckmark, sizes: 60)
        setupCenterSubview(subview: buttonCheckmark, on: viewCheckmark)
        setupSquare(subviews: buttonCheckmark, sizes: 50)
        setupConstraintsDoneCancel()
    }
    
    private func setupConstraintsSettingTime() {
        setupConstraintsViewsAndLabel(constant: 60)
        setupConstraintsSubviews(subview: stackViewTime, to: viewSettingDescription, height: 165)
        setupConstraintsDoneCancel()
        
        NSLayoutConstraint.activate([
            segmentedControl.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupConstraintsViewsAndLabel(constant: CGFloat) {
        NSLayoutConstraint.activate([
            viewSetting.topAnchor.constraint(equalTo: view.centerYAnchor, constant: constant),
            viewSetting.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            viewSetting.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            viewSetting.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            labelSetting.centerXAnchor.constraint(equalTo: viewSetting.centerXAnchor, constant: 20),
            labelSetting.centerYAnchor.constraint(equalTo: viewSetting.topAnchor, constant: 31.875)
        ])
        
        NSLayoutConstraint.activate([
            viewSettingDescription.topAnchor.constraint(equalTo: viewSetting.topAnchor, constant: 63.75),
            viewSettingDescription.leadingAnchor.constraint(equalTo: viewSetting.leadingAnchor),
            viewSettingDescription.trailingAnchor.constraint(equalTo: viewSetting.trailingAnchor),
            viewSettingDescription.bottomAnchor.constraint(equalTo: viewSetting.bottomAnchor)
        ])
    }
    
    private func setupConstraintsSubviews(subview: UIView, to otherSubview: UIView, height: CGFloat) {
        NSLayoutConstraint.activate([
            subview.topAnchor.constraint(equalTo: otherSubview.topAnchor, constant: 20),
            subview.leadingAnchor.constraint(equalTo: otherSubview.leadingAnchor, constant: 20),
            subview.trailingAnchor.constraint(equalTo: otherSubview.trailingAnchor, constant: -20),
            subview.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    private func setupConstraintsOnButton() {
        setupOnButton(labelFirst: labelAllCountries, and: labelCountAllCountries, on: buttonAllCountries)
        setupOnButton(labelFirst: labelAmericaContinent, and: labelCountAmericaContinent, on: buttonAmericaContinent)
        setupOnButton(labelFirst: labelEuropeContinent, and: labelCountEuropeContinent, on: buttonEuropeContinent)
        setupOnButton(labelFirst: labelAfricaContinent, and: labelCountAfricaContinent, on: buttonAfricaContinent)
        setupOnButton(labelFirst: labelAsiaContinent, and: labelCountAsiaContinent, on: buttonAsiaContinent)
        setupOnButton(labelFirst: labelOceanContinent, and: labelCountOceanContinent, on: buttonOceanContinent)
    }
    
    private func setupOnButton(
        labelFirst: UILabel, and labelSecond: UILabel, on button: UIButton) {
            NSLayoutConstraint.activate([
                labelFirst.centerXAnchor.constraint(equalTo: button.centerXAnchor),
                labelFirst.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: -12.5),
                labelSecond.centerXAnchor.constraint(equalTo: button.centerXAnchor),
                labelSecond.centerYAnchor.constraint(equalTo: button.centerYAnchor, constant: 12.5)
            ])
    }
    
    private func setupConstraintsDoneCancel() {
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: viewSettingDescription.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: viewSettingDescription.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: viewSettingDescription.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupSquare(subviews: UIView..., sizes: CGFloat) {
        subviews.forEach { subview in
            NSLayoutConstraint.activate([
                subview.widthAnchor.constraint(equalToConstant: sizes),
                subview.heightAnchor.constraint(equalToConstant: sizes)
            ])
        }
    }
    
    private func setupSize(subview: UIView, width: CGFloat, height: CGFloat) {
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: width),
            subview.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    private func setupCenterSubview(subview: UIView, on subviewOther: UIView) {
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: subviewOther.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: subviewOther.centerYAnchor)
        ])
    }
    
    private func diameter() -> CGFloat {
        100
    }
    
    private func halfWidth() -> CGFloat {
        view.frame.width / 2 + 10
    }
}
// MARK: - PopUpViewDelegate
extension GameTypeViewController: PopUpViewDelegate {
    func closeView() {
        barButtonsOnOff(bool: true)
        UIView.animate(withDuration: 0.5) { [self] in
            visualEffectView.alpha = 0
            viewHelp.alpha = 0
            viewHelp.transform = CGAffineTransform.init(scaleX: 0.6, y: 0.6)
        } completion: { [self] _ in
            viewHelp.removeFromSuperview()
        }
    }
}
// MARK: - PopUpViewSettingDelegate
extension GameTypeViewController: PopUpViewSettingDelegate {
    @objc func closeViewSetting() {
        barButtonsOnOff(bool: true)
        UIView.animate(withDuration: 0.5) { [self] in
            visualEffectView.alpha = 0
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
}
// MARK: - GameTypeViewControllerInput
extension GameTypeViewController: GameTypeViewControllerInput {
    func dataOfSettingToGameType(setting: Setting) {
        delegateInput.dataOfSettingToMenu(setting: setting)
    }
}
