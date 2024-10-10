//
//  GameTypeViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 03.08.2023.
//

import UIKit

protocol GameTypeViewControllerInput: AnyObject {
    func dataToMenu(setting: Setting, favourites: [Favorites])
    func favoritesToGameType(favorites: [Favorites])
    func disableFavoriteButton()
}

class GameTypeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, GameTypeViewControllerInput {
    private lazy var viewGameType: UIView = {
        setView(color: .whiteAlphaLight, radius: viewModel.radius, sizes: viewModel.diameter)
    }()
    
    private lazy var imageGameType: UIImageView = {
        setImage(image: "\(viewModel.image)", color: viewModel.background, size: 60)
    }()
    
    private lazy var labelGameName: UILabel = {
        setLabel(color: .white, title: "\(viewModel.name)", size: 30, style: "GillSans")
    }()
    
    private lazy var buttonBack: UIButton = {
        setButton(image: "multiply", action: #selector(backToMenu), isBarButton: true)
    }()
    
    private lazy var buttonHelp: UIButton = {
        setButton(image: "questionmark", action: #selector(showViewHelp), isBarButton: true)
    }()
    
    private lazy var viewHelp: UIView = {
        setView(action: #selector(closeView), view: viewModel.viewHelp())
    }()
    
    private lazy var visualEffectView: UIVisualEffectView = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(popUpViewCheck))
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var buttonStart: UIButton = {
        setButton(image: "play", color: viewModel.colorPlay, action: #selector(startGame))
    }()
    
    private lazy var buttonFavorites: UIButton = {
        setButton(
            image: "star",
            color: viewModel.colorFavourite,
            action: #selector(favorites),
            isEnabled: viewModel.haveFavourites())
    }()
    
    private lazy var buttonSwap: UIButton = {
        setButton(
            image: viewModel.imageMode(),
            color: viewModel.colorSwap,
            action: #selector(swap),
            isEnabled: viewModel.isEnabled())
    }()
    
    private lazy var stackViewButtons: UIStackView = {
        setStackView(
            buttonFirst: buttonStart,
            buttonSecond: buttonFavorites,
            buttonThird: buttonSwap)
    }()
    
    private lazy var buttonCountQuestions: UIButton = {
        setButton(
            color: viewModel.colorSwap,
            labelFirst: labelCountQuestion,
            labelSecond: labelCount,
            tag: 1)
    }()
    
    private lazy var labelCountQuestion: UILabel = {
        setLabel(color: .white, title: "\(viewModel.countQuestions)", size: 60, style: "GillSans")
    }()
    
    private lazy var labelCount: UILabel = {
        setLabel(color: .white, title: "Количество вопросов", size: 17, style: "GillSans")
    }()
    
    private lazy var buttonContinents: UIButton = {
        setButton(
            color: viewModel.colorSwap,
            labelFirst: labelContinents,
            labelSecond: labelContinentsDescription,
            tag: 2)
    }()
    
    private lazy var labelContinents: UILabel = {
        setLabel(color: .white, title: "\(viewModel.comma())", size: 30, style: "GillSans")
    }()
    
    private lazy var labelContinentsDescription: UILabel = {
        setLabel(color: .white, title: "Континенты", size: 17, style: "GillSans")
    }()
    
    private lazy var buttonCountdown: UIButton = {
        setButton(
            color: viewModel.colorSwap,
            labelFirst: labelCountdown,
            labelSecond: labelCountdownDesription,
            tag: 3)
    }()
    
    private lazy var labelCountdown: UILabel = {
        setLabel(
            color: .white,
            title: viewModel.isCountdown() ? "Да" : "Нет",
            size: 60,
            style: "GillSans")
    }()
    
    private lazy var labelCountdownDesription: UILabel = {
        setLabel(
            color: .white,
            title: "Обратный отсчёт",
            size: 17,
            style: "GillSans")
    }()
    
    private lazy var buttonTime: UIButton = {
        setButton(
            color: viewModel.isCountdown() ? viewModel.colorSwap : .grayLight,
            labelFirst: labelTime,
            labelSecond: labelTimeDesription,
            image: imageInfinity,
            tag: 4,
            isEnabled: viewModel.isCountdown())
    }()
    
    private lazy var labelTime: UILabel = {
        setLabel(
            color: .white,
            title: "\(viewModel.countdownOnOff())",
            size: 60,
            style: "GillSans")
    }()
    
    private lazy var labelTimeDesription: UILabel = {
        setLabel(
            color: .white,
            title: "\(viewModel.checkTimeDescription())",
            size: 17,
            style: "GillSans")
    }()
    
    private lazy var imageInfinity: UIImageView = {
        setImage(image: "infinity", color: .white, size: 60)
    }()
    
    private lazy var pickerViewQuestions: UIPickerView = {
        setPickerView(tag: 1)
    }()
    
    private lazy var buttonAllCountries: UIButton = {
        setButton(
            backgroundIsOn: !viewModel.allCountries,
            colorIsOn: viewModel.allCountries)
    }()
    
    private lazy var buttonAmericaContinent: UIButton = {
        setButton(
            backgroundIsOn: !viewModel.americaContinent,
            colorIsOn: viewModel.americaContinent,
            tag: 1)
    }()
    
    private lazy var buttonEuropeContinent: UIButton = {
        setButton(
            backgroundIsOn: !viewModel.europeContinent,
            colorIsOn: viewModel.europeContinent,
            tag: 2)
    }()
    
    private lazy var buttonAfricaContinent: UIButton = {
        setButton(
            backgroundIsOn: !viewModel.africaContinent,
            colorIsOn: viewModel.africaContinent,
            tag: 3)
    }()
    
    private lazy var buttonAsiaContinent: UIButton = {
        setButton(
            backgroundIsOn: !viewModel.asiaContinent,
            colorIsOn: viewModel.asiaContinent,
            tag: 4)
    }()
    
    private lazy var buttonOceanContinent: UIButton = {
        setButton(
            backgroundIsOn: !viewModel.oceaniaContinent,
            colorIsOn: viewModel.oceaniaContinent,
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
        stackView.tag = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        viewModel.setStackView(stackView: stackView)
        return stackView
    }()
    
    private lazy var buttonCheckmark: UIButton = {
        let checkmark = viewModel.isCheckmark(isOn: viewModel.isCountdown())
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: checkmark, withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = viewModel.background
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(countdown), for: .touchUpInside)
        viewModel.setSquare(subviews: button, sizes: 50)
        viewModel.setButtonCheckmark(button: button)
        return button
    }()
    
    private lazy var viewCheckmark: UIView = {
        setView(color: .white, radius: 13, addButton: buttonCheckmark, sizes: 60)
    }()
    
    private lazy var labelCheckmark: UILabel = {
        setLabel(
            color: .white,
            title: "Вкл / Выкл",
            size: 26,
            style: "mr_fontick",
            alignment: .center)
    }()
    
    private lazy var stackViewCheckmark: UIStackView = {
        setStackView(view: viewCheckmark, label: labelCheckmark)
    }()
    
    private lazy var pickerViewOneTime: UIPickerView = {
        setPickerView(tag: 2)
    }()
    
    private lazy var pickerViewAllTime: UIPickerView = {
        setPickerView(tag: 3)
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
        segment.selectedSegmentTintColor = viewModel.background
        segment.setTitleTextAttributes([NSAttributedString.Key
            .font: font ?? "", .foregroundColor: UIColor.white
        ], for: .selected)
        segment.setTitleTextAttributes([NSAttributedString.Key
            .font: font ?? "", .foregroundColor: viewModel.background
        ], for: .normal)
        segment.layer.borderWidth = 5
        segment.layer.borderColor = UIColor.white.cgColor
        segment.addTarget(self, action: #selector(segmentSelect), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        viewModel.setHeightSegment(segment: segment)
        viewModel.setSegmentedControl(segment: segment)
        return segment
    }()
    
    private lazy var stackViewTime: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [segmentedControl, stackViewPickerViews])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.tag = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        viewModel.setStackView(stackView: stackView)
        return stackView
    }()
    
    private lazy var buttonDone: UIButton = {
        setButton(title: "ОК", color: viewModel.colorDone, action: #selector(done))
    }()
    
    private lazy var buttonCancel: UIButton = {
        setButton(title: "Отмена", color: .white, action: #selector(closeViewSetting))
    }()
    
    private lazy var stackView: UIStackView = {
        setStackView(buttonFirst: buttonDone, buttonSecond: buttonCancel, spacing: 15)
    }()
    
    private lazy var viewSetting: UIView = {
        let view = setView(action: #selector(closeViewSetting), view: viewModel.viewSetting())
        viewModel.setSubviews(subviews: stackView, on: view)
        return view
    }()
    
    var viewModel: GameTypeViewModelProtocol!
    weak var delegate: MenuViewControllerInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupSubviews()
        setupBarButton()
        setupConstraints()
    }
    // MARK: - UIPickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        viewModel.numberOfComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.numberOfRows(pickerView)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        viewModel.titles(pickerView, row, and: segmentedControl)
    }
    // MARK: - Press button count questions / continents / countdown / time
    @objc func showSetting(sender: UIButton) {
        viewModel.setSubviews(subviews: viewSetting, on: view)
        viewModel.setSubviewsTag(subviews: buttonDone, viewSetting, tag: sender.tag)
        viewModel.setSubview(subview(tag: sender.tag), on: viewSetting, and: view)
        viewModel.setConstraints(stackView: stackView)
        viewModel.setDataSubviews(tag: sender.tag)
        viewModel.barButtonsOnOff(buttonBack, buttonHelp, bool: false)
        viewModel.showViewSetting(viewSetting, and: visualEffectView, view)
    }
    
    @objc func closeViewSetting() {
        viewModel.barButtonsOnOff(buttonBack, buttonHelp, bool: true)
        viewModel.hideViewSetting(viewSetting, and: visualEffectView, view)
    }
    // MARK: - Button press continents, change setting continents
    @objc func continents(sender: UIButton) {
        guard sender.tag > 0 else { return viewModel.setAllCountries(sender) }
        viewModel.setCountContinents(sender.backgroundColor == .white ? -1 : 1)
        guard viewModel.countContinents > 4 else { return viewModel.condition(sender) }
        viewModel.setAllCountries(sender)
    }
    // MARK: - Button press checkmark, change setting countdown
    @objc func countdown() {
        viewModel.checkmarkOnOff(buttonCheckmark)
    }
    // MARK: - Press done button for change setting
    @objc func done(sender: UIButton) {
        switch sender.tag {
        case 1: viewModel.setQuestions(labelCountQuestion, and: labelTime)
        case 2: viewModel.setContinents(labelContinents, labelCountQuestion, and: pickerViewQuestions)
        case 3: viewModel.setCountdown(labelCountdown, imageInfinity, labelTime, and: buttonTime)
        default: viewModel.setTime(labelTime, and: labelTimeDesription)
        }
        closeViewSetting()
    }
    // MARK: - GameTypeViewControllerInput
    func dataToMenu(setting: Setting, favourites: [Favorites]) {
        delegate.dataToMenu(setting: setting, favorites: favourites)
    }
    
    func favoritesToGameType(favorites: [Favorites]) {
        viewModel.setFavorites(newFavorites: favorites)
    }
    
    func disableFavoriteButton() {
        viewModel.buttonOnOff(button: buttonFavorites, isOn: false)
    }
    // MARK: - General methods
    private func setupDesign() {
        view.backgroundColor = viewModel.background
        imageInfinity.isHidden = viewModel.isCountdown()
    }
    
    private func setupSubviews() {
        viewModel.setSubviews(subviews: viewGameType, imageGameType, labelGameName,
                              stackViewButtons, buttonCountQuestions, buttonContinents,
                              buttonCountdown, buttonTime, visualEffectView,
                              on: view)
    }
    
    private func setupBarButton() {
        viewModel.setupBarButtons(buttonBack, buttonHelp, navigationItem)
    }
    
    private func subview(tag: Int) -> UIView {
        switch tag {
        case 1: pickerViewQuestions
        case 2: stackViewContinents
        case 3: stackViewCheckmark
        default: stackViewTime
        }
    }
    // MARK: - Bar buttons activate
    @objc private func backToMenu() {
        delegate.dataToMenu(setting: viewModel.mode, favorites: viewModel.favorites)
    }
    
    @objc private func showViewHelp(sender: UIButton) {
        viewModel.popUpViewHelpToggle()
        viewModel.setSubviews(subviews: viewHelp, on: view)
        viewModel.setConstraints(viewHelp, view)
        viewModel.barButtonsOnOff(buttonBack, buttonHelp, bool: false)
        viewModel.showAnimationView(viewHelp, and: visualEffectView)
    }
    
    @objc private func closeView() {
        viewModel.popUpViewHelpToggle()
        viewModel.barButtonsOnOff(buttonBack, buttonHelp, bool: true)
        viewModel.hideAnimationView(viewHelp, and: visualEffectView)
    }
    
    @objc private func popUpViewCheck() {
        viewModel.popUpViewHelp ? closeView() : closeViewSetting()
    }
    // MARK: - Start game, favorites and swap
    @objc private func startGame() {
        switch viewModel.tag {
        case 0: quizOfFlagsViewController()
        case 1: questionnaireViewController()
        case 3: scrabbleViewController()
        default: quizOfCapitalsViewController()
        }
    }
    
    private func quizOfFlagsViewController() {
        let quizOfFlagsViewModel = viewModel.quizOfFlagsViewModel()
        let quizOfFlagsVC = QuizOfFlagsViewController()
        quizOfFlagsVC.viewModel = quizOfFlagsViewModel
        quizOfFlagsVC.delegate = self
        navigationController?.pushViewController(quizOfFlagsVC, animated: true)
    }
    
    private func questionnaireViewController() {
        let questionnaireViewModel = viewModel.questionnaireViewModel()
        let questionnaireVC = QuestionnaireViewController()
        questionnaireVC.viewModel = questionnaireViewModel
        questionnaireVC.delegate = self
        navigationController?.pushViewController(questionnaireVC, animated: true)
    }
    
    private func scrabbleViewController() {
        print("Scrabble view controller will be create.")
        /*
        let startGameVC = ScrabbleViewController()
        startGameVC.mode = viewModel.setting
        startGameVC.game = viewModel.games
        navigationController?.pushViewController(startGameVC, animated: true)
         */
    }
    
    private func quizOfCapitalsViewController() {
        let quizOfCapitalsViewModel = viewModel.quizOfCapitalsViewModel()
        let startGameVC = QuizOfCapitalsViewController()
        startGameVC.viewModel = quizOfCapitalsViewModel
        startGameVC.delegate = self
        navigationController?.pushViewController(startGameVC, animated: true)
    }
    
    @objc private func favorites() {
        let favorites = viewModel.favouritesViewModel()
        let favoritesVC = FavoritesViewController()
        let navigationVC = UINavigationController(rootViewController: favoritesVC)
        favoritesVC.viewModel = favorites
        favoritesVC.delegate = self
        navigationVC.modalPresentationStyle = .custom
        present(navigationVC, animated: true)
    }
    
    @objc private func swap() {
        viewModel.swap(buttonSwap)
    }
    // MARK: - Segmented control press, change setting time for one question or for all questions
    @objc private func segmentSelect() {
        viewModel.segmentSelect()
    }
}
// MARK: - Setup constraints
extension GameTypeViewController {
    private func setupConstraints() {
        viewModel.setSquare(subviews: buttonBack, buttonHelp, sizes: 40)
        
        NSLayoutConstraint.activate([
            viewGameType.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30),
            viewGameType.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        viewModel.setCenterSubview(subview: imageGameType, on: viewGameType)
        
        NSLayoutConstraint.activate([
            labelGameName.topAnchor.constraint(equalTo: viewGameType.bottomAnchor, constant: 10),
            labelGameName.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackViewButtons.topAnchor.constraint(equalTo: labelGameName.bottomAnchor, constant: 15),
            stackViewButtons.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        viewModel.setSize(subview: stackViewButtons, width: 160, height: 40)
        
        viewModel.setConstraints(buttonCountQuestions, layout: stackViewButtons.bottomAnchor,
                                 leading: 20, trailing: -viewModel.width(view), height: 160, view)
        viewModel.setConstraints(labelCountQuestion, on: buttonCountQuestions, constant: -30)
        viewModel.setConstraints(labelCount, on: buttonCountQuestions, constant: 35)
        
        viewModel.setConstraints(buttonContinents, layout: stackViewButtons.bottomAnchor,
                                 leading: viewModel.width(view), trailing: -20, height: 190, view)
        viewModel.setConstraints(labelContinents, on: buttonContinents, constant: -15)
        viewModel.setConstraints(labelContinentsDescription, on: buttonContinents, constant: 75)
        
        viewModel.setConstraints(buttonCountdown, layout: buttonCountQuestions.bottomAnchor,
                                 leading: 20, trailing: -viewModel.width(view), height: 150, view)
        viewModel.setConstraints(labelCountdown, on: buttonCountdown, constant: -25)
        viewModel.setConstraints(labelCountdownDesription, on: buttonCountdown, constant: 35)
        
        viewModel.setConstraints(buttonTime, layout: buttonContinents.bottomAnchor,
                                 leading: viewModel.width(view), trailing: -20, height: 120, view)
        viewModel.setConstraints(labelTime, on: buttonTime, constant: -25)
        viewModel.setConstraints(labelTimeDesription, on: buttonTime, constant: 30)
        
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
}
