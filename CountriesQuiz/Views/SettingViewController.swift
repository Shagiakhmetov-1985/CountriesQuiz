//
//  SettingViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 06.12.2022.
//

import UIKit

class SettingViewController: UIViewController {
    // MARK: - Subviews
    private lazy var buttonBack: UIButton = {
        setupButton(
            image: "multiply",
            color: .white,
            action: #selector(backToMenu))
    }()
    
    private lazy var buttonDefault: UIButton = {
        setupButton(
            image: "arrow.counterclockwise",
            color: viewModel.isMoreFiftyQuestions() ? .white : .grayStone,
            isEnabled: viewModel.isMoreFiftyQuestions() ? true : false,
            action: #selector(defaultSetting))
    }()
    
    private lazy var stackViewButtons: UIStackView = {
        setStackView(buttonFirst: buttonBack, buttonSecond: buttonDefault)
    }()
    
    private lazy var scrollView: UIScrollView = {
        let currentView = view
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.contentSize = viewModel.contentSize(currentView)
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let currentView = view
        let view = setView(color: .blueMiddlePersian)
        view.frame.size = viewModel.contentSize(currentView)
        return view
    }()
    
    private lazy var labelNumberQuestions: UILabel = {
        setLabel(
            title: "Количество вопросов",
            size: 26,
            color: .white,
            textAlignment: .center,
            numberOfLines: 1)
    }()
    
    private lazy var labelNumber: UILabel = {
        setLabel(title: "\(viewModel.countQuestions)", size: 26, color: .white)
    }()
    
    private lazy var stackViewNumberQuestion: UIStackView = {
        setStackViewLabels(
            labelFirst: labelNumberQuestions,
            labelSecond: labelNumber,
            spacing: 10)
    }()
    
    private lazy var pickerViewNumberQuestion: UIPickerView = {
        setPickerView(backgroundColor: .white, tag: 1)
    }()
    
    private lazy var labelAllCountries: UILabel = {
        setLabel(
            title: "Все страны мира",
            size: 26,
            color: viewModel.select(isOn: viewModel.allCountries))
    }()
    
    private lazy var labelCountAllCountries: UILabel = {
        setLabel(
            title: "Количество стран: \(viewModel.countCountries)",
            size: 20,
            color: viewModel.select(isOn: viewModel.allCountries))
    }()
    
    private lazy var buttonAllCountries: UIButton = {
        setButtonContinents(
            color: viewModel.select(isOn: !viewModel.allCountries),
            tag: 1,
            addLabelFirst: labelAllCountries,
            addLabelSecond: labelCountAllCountries)
    }()
    
    private lazy var labelAmericaContinent: UILabel = {
        setLabel(
            title: "Континент Америки",
            size: 26,
            color: viewModel.select(isOn: viewModel.americaContinent))
    }()
    
    private lazy var labelCountAmericaContinent: UILabel = {
        setLabel(
            title: "Количество стран: \(viewModel.countCountriesOfAmerica)",
            size: 20,
            color: viewModel.select(isOn: viewModel.americaContinent))
    }()
    
    private lazy var buttonAmericaContinent: UIButton = {
        setButtonContinents(
            color: viewModel.select(isOn: !viewModel.americaContinent),
            tag: 2,
            addLabelFirst: labelAmericaContinent,
            addLabelSecond: labelCountAmericaContinent)
    }()
    
    private lazy var labelEuropeContinent: UILabel = {
        setLabel(
            title: "Континент Европы",
            size: 26,
            color: viewModel.select(isOn: viewModel.europeContinent))
    }()
    
    private lazy var labelCountEuropeContinent: UILabel = {
        setLabel(
            title: "Количество стран: \(viewModel.countCountriesOfEurope)",
            size: 20,
            color: viewModel.select(isOn: viewModel.europeContinent))
    }()
    
    private lazy var buttonEuropeContinent: UIButton = {
        setButtonContinents(
            color: viewModel.select(isOn: !viewModel.europeContinent),
            tag: 3,
            addLabelFirst: labelEuropeContinent,
            addLabelSecond: labelCountEuropeContinent)
    }()
    
    private lazy var labelAfricaContinent: UILabel = {
        setLabel(
            title: "Континент Африки",
            size: 26,
            color: viewModel.select(isOn: viewModel.africaContinent))
    }()
    
    private lazy var labelCountAfricaContinent: UILabel = {
        setLabel(
            title: "Количество стран: \(viewModel.countCountriesOfAfrica)",
            size: 20,
            color: viewModel.select(isOn: viewModel.africaContinent))
    }()
    
    private lazy var buttonAfricaContinent: UIButton = {
        setButtonContinents(
            color: viewModel.select(isOn: !viewModel.africaContinent),
            tag: 4,
            addLabelFirst: labelAfricaContinent,
            addLabelSecond: labelCountAfricaContinent)
    }()
    
    private lazy var labelAsiaContinent: UILabel = {
        setLabel(
            title: "Континент Азии",
            size: 26,
            color: viewModel.select(isOn: viewModel.asiaContinent))
    }()
    
    private lazy var labelCountAsiaContinent: UILabel = {
        setLabel(
            title: "Количество стран: \(viewModel.countCountriesOfAsia)",
            size: 20,
            color: viewModel.select(isOn: viewModel.asiaContinent))
    }()
    
    private lazy var buttonAsiaContinent: UIButton = {
        setButtonContinents(
            color: viewModel.select(isOn: !viewModel.asiaContinent),
            tag: 5,
            addLabelFirst: labelAsiaContinent,
            addLabelSecond: labelCountAsiaContinent)
    }()
    
    private lazy var labelOceaniaContinent: UILabel = {
        setLabel(
            title: "Континент Океании",
            size: 26,
            color: viewModel.select(isOn: viewModel.oceaniaContinent))
    }()
    
    private lazy var labelCountOceaniaContinent: UILabel = {
        setLabel(
            title: "Количество стран: \(viewModel.countCountriesOfOceania)",
            size: 20,
            color: viewModel.select(isOn: viewModel.oceaniaContinent))
    }()
    
    private lazy var buttonOceaniaContinent: UIButton = {
        setButtonContinents(
            color: viewModel.select(isOn: !viewModel.oceaniaContinent),
            tag: 6,
            addLabelFirst: labelOceaniaContinent,
            addLabelSecond: labelCountOceaniaContinent)
    }()
    
    private lazy var viewTimeElapsed: UIView = {
        setView(color: .white, radiusCorner: 13, addButton: buttonTimeElapsed)
    }()
    
    private lazy var buttonTimeElapsed: UIButton = {
        setButtonCheckmark(image: viewModel.checkmark(isOn: viewModel.isTime()), tag: 7)
    }()
    
    private lazy var labelTimeElapsed: UILabel = {
        setLabel(title: "Обратный отсчет", size: 26, textAlignment: .center)
    }()
    
    private lazy var stackViewTimeElapsed: UIStackView = {
        setStackViewCheckmark(view: viewTimeElapsed, label: labelTimeElapsed)
    }()
    
    private lazy var labelTimeElapsedQuestion: UILabel = {
        setLabel(
            title: viewModel.isEnabledText(segmentedControl),
            size: 26,
            color: viewModel.isTime() ? .white : .skyGrayLight,
            numberOfLines: 1)
    }()
    
    private lazy var labelTimeElapsedNumber: UILabel = {
        setLabel(
            title: viewModel.setLabelNumberQuestions(pickerViewOneQuestion),
            size: 26,
            color: viewModel.isTime() ? .white : .skyGrayLight)
    }()
    
    private lazy var stackViewLabelTimeElapsed: UIStackView = {
        setStackViewLabels(
            labelFirst: labelTimeElapsedQuestion,
            labelSecond: labelTimeElapsedNumber,
            spacing: 10)
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Один вопрос", "Все вопросы"])
        let font = UIFont(name: "mr_fontick", size: 26)
        let titleColorSelected: UIColor = viewModel.isTime() ? .white : .skyGrayLight
        let titleColorNormal: UIColor = viewModel.isTime() ? .blueMiddlePersian : .grayLight
        let borderColor: UIColor = viewModel.isTime() ? .white : .skyGrayLight
        segment.backgroundColor = viewModel.isTime() ? .white : .skyGrayLight
        segment.selectedSegmentTintColor = viewModel.isTime() ? .blueMiddlePersian : .grayLight
        segment.setTitleTextAttributes([
            NSAttributedString.Key
                .font: font ?? "",
                .foregroundColor: titleColorSelected
        ], for: .selected)
        segment.setTitleTextAttributes([
            NSAttributedString.Key
                .font: font ?? "",
                .foregroundColor: titleColorNormal
        ], for: .normal)
        segment.selectedSegmentIndex = viewModel.isOneQuestion() ? 0 : 1
        segment.isUserInteractionEnabled = viewModel.isTime() ? true : false
        segment.layer.borderWidth = 5
        segment.layer.borderColor = borderColor.cgColor
        segment.addTarget(self, action: #selector(segmentedControlAction), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    private lazy var pickerViewOneQuestion: UIPickerView = {
        setPickerView(
            backgroundColor: viewModel.isTime() ? viewModel.isEnabledColor(2, segmentedControl) : .skyGrayLight,
            tag: 2,
            isEnabled: viewModel.isTime() ? viewModel.isEnabled(2, segmentedControl) : false)
    }()
    
    private lazy var pickerViewAllQuestions: UIPickerView = {
        setPickerView(
            backgroundColor: viewModel.isTime() ? viewModel.isEnabledColor(3, segmentedControl) : .skyGrayLight,
            tag: 3,
            isEnabled: viewModel.isTime() ? viewModel.isEnabled(3, segmentedControl) : false)
    }()
    
    private lazy var stackViewPickerViews: UIStackView = {
        setStackViewPickerViews(
            pickerViewFirst: pickerViewOneQuestion,
            pickerViewSecond: pickerViewAllQuestions)
    }()
    
    var viewModel: SettingViewModelProtocol!
    var delegate: SettingViewControllerDelegate!
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDesign()
        setupButtons()
        setupLabels()
        setupSegmentedControl()
        setupPickerViews()
        setupSubviewsOnView()
        setupSubviewsOnContentView()
        setupSubviewsOnScrollView()
        setupConstraints()
    }
    // MARK: - General methods
    private func setupDesign() {
        view.backgroundColor = .blueMiddlePersian
    }
    
    private func setupButtons() {
        viewModel.setButtons(buttonAllCountries, buttonAmericaContinent, buttonEuropeContinent,
                             buttonAfricaContinent, buttonAsiaContinent, buttonOceaniaContinent)
    }
    
    private func setupLabels() {
        viewModel.setLabels(labelAllCountries, labelCountAllCountries, labelAmericaContinent,
                            labelCountAmericaContinent, labelEuropeContinent, labelCountEuropeContinent,
                            labelAfricaContinent, labelCountAfricaContinent, labelAsiaContinent,
                            labelCountAsiaContinent, labelOceaniaContinent, labelCountOceaniaContinent,
                            labelTimeElapsedQuestion, labelTimeElapsedNumber, labelNumber)
    }
    
    private func setupSegmentedControl() {
        viewModel.setSegmentedControl(segmentedControl)
    }
    
    private func setupPickerViews() {
        viewModel.setPickerViews(pickerViewOneQuestion, pickerViewAllQuestions,
                                 pickerViewNumberQuestion)
        viewModel.setPickerViewNumberQuestion()
        viewModel.setPickerViewOneQuestion()
        viewModel.setPickerViewAllQuestions()
    }
    
    private func setupSubviewsOnView() {
        viewModel.setupSubviews(subviews: stackViewButtons, contentView, on: view)
    }
    
    private func setupSubviewsOnContentView() {
        viewModel.setupSubviews(subviews: scrollView, on: contentView)
    }
    
    private func setupSubviewsOnScrollView() {
        viewModel.setupSubviews(subviews: stackViewNumberQuestion, pickerViewNumberQuestion,
                                buttonAllCountries, buttonAmericaContinent,
                                buttonEuropeContinent, buttonAfricaContinent,
                                buttonAsiaContinent, buttonOceaniaContinent,
                                stackViewTimeElapsed, stackViewLabelTimeElapsed,
                                segmentedControl, stackViewPickerViews, on: scrollView)
    }
    // MARK: - Activating buttons
    @objc private func backToMenu() {
        delegate.dataToMenuFromSetting(setting: viewModel.mode)
        StorageManager.shared.saveSetting(setting: viewModel.mode)
        dismiss(animated: true)
    }
    
    @objc private func defaultSetting() {
        let alert = viewModel.showAlert(viewModel.mode, buttonDefault)
        present(alert, animated: true)
    }
    // MARK: - Setting of checkmarks
    @objc private func buttonCheckmark(sender: UIButton) {
        viewModel.buttonCheckmark(sender: sender)
        viewModel.setCountCountries(continents: viewModel.allCountries, viewModel.americaContinent,
                                    viewModel.europeContinent, viewModel.africaContinent,
                                    viewModel.asiaContinent, viewModel.oceaniaContinent)
        viewModel.buttonIsEnabled(buttonDefault)
    }
    // MARK: - Setting of segmented control
    @objc private func segmentedControlAction() {
        viewModel.segmentAction()
    }
}
// MARK: - Setup view
extension SettingViewController {
    private func setView(color: UIColor? = nil, radiusCorner: CGFloat? = nil,
                         addButton: UIButton? = nil) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if let color = color {
            view.backgroundColor = color
            view.layer.cornerRadius = radiusCorner ?? 0
            if let button = addButton {
                view.addSubview(button)
                view.layer.shadowColor = color.cgColor
                view.layer.shadowOpacity = 0.4
                view.layer.shadowOffset = CGSize(width: 0, height: 6)
            }
        }
        return view
    }
}
// MARK: - Setup button
extension SettingViewController {
    private func setupButton(image: String, color: UIColor, isEnabled: Bool? = nil,
                             action: Selector) -> UIButton {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: image, withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = color
        button.layer.cornerRadius = 12
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 1.5
        button.isEnabled = isEnabled ?? true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func setButtonCheckmark(image: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: image, withConfiguration: configuration)
        button.configuration = UIButton.Configuration.filled()
        button.configuration?.baseBackgroundColor = .clear
        button.configuration?.baseForegroundColor = .blueMiddlePersian
        button.configuration?.image = image
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonCheckmark), for: .touchUpInside)
        return button
    }
    
    private func setButtonContinents(color: UIColor, tag: Int,
                                     addLabelFirst: UILabel,
                                     addLabelSecond: UILabel) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = color
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 13
        button.layer.shadowColor = UIColor.white.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowOffset = CGSize(width: 0, height: 6)
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonCheckmark), for: .touchUpInside)
        viewModel.setupSubviews(subviews: addLabelFirst, addLabelSecond, on: button)
        return button
    }
}
// MARK: - Setup label
extension SettingViewController {
    private func setLabel(title: String, size: CGFloat, color: UIColor? = nil,
                          textAlignment: NSTextAlignment? = nil,
                          numberOfLines: Int? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "mr_fontick", size: size)
        label.textColor = color ?? .white
        label.textAlignment = textAlignment ?? .natural
        label.numberOfLines = numberOfLines ?? 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
// MARK: - Setup picker view
extension SettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        viewModel.numberOfComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.numberOfRows(pickerView)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        viewModel.titles(pickerView, row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1: viewModel.didSelectRowCount(row, buttonDefault)
        case 2: viewModel.didSelectRowOneQuestion(row)
        default: viewModel.didSelectRowAllQuestions(row)
        }
    }
    
    private func setPickerView(backgroundColor: UIColor, tag: Int,
                               isEnabled: Bool? = nil) -> UIPickerView {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = backgroundColor
        pickerView.layer.cornerRadius = 13
        pickerView.tag = tag
        pickerView.isUserInteractionEnabled = isEnabled ?? true
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }
}
// MARK: - Setup stack view
extension SettingViewController {
    private func setStackView(buttonFirst: UIButton, buttonSecond: UIButton) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [buttonFirst, buttonSecond])
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackViewLabels(labelFirst: UILabel, labelSecond: UILabel,
                                    spacing: CGFloat? = nil,
                                    axis: NSLayoutConstraint.Axis? = nil,
                                    distribution: UIStackView.Distribution? = nil,
                                    alignment: UIStackView.Alignment? = nil) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [labelFirst, labelSecond])
        stackView.spacing = spacing ?? 0
        stackView.axis = axis ?? .horizontal
        stackView.distribution = distribution ?? .fill
        stackView.alignment = alignment ?? .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackViewCheckmark(view: UIView, label: UILabel) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [view, label])
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
    
    private func setStackViewPickerViews(pickerViewFirst: UIPickerView,
                                         pickerViewSecond: UIPickerView) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [pickerViewFirst, pickerViewSecond])
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
// MARK: - Setup constraints
extension SettingViewController {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackViewButtons.topAnchor.constraint(equalTo: view.topAnchor, constant: viewModel.topAnchorCheck(view)),
            stackViewButtons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackViewButtons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        viewModel.setSquare(subview: buttonBack, sizes: 40)
        viewModel.setSquare(subview: buttonDefault, sizes: 40)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: stackViewButtons.bottomAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackViewNumberQuestion.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5),
            stackViewNumberQuestion.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width / 8),
            stackViewNumberQuestion.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        viewModel.setConstraints(pickerViewNumberQuestion, to: stackViewNumberQuestion,
                                 leadingConstant: 20, constant: 12, view)
        viewModel.setHeightSubview(pickerViewNumberQuestion, height: 110)
        
        viewModel.setConstraints(buttonAllCountries, to: pickerViewNumberQuestion,
                                 leadingConstant: 20, constant: 15, view)
        viewModel.setConstraintsOnButton(labelAllCountries, and: labelCountAllCountries,
                                         on: buttonAllCountries)
        viewModel.setHeightSubview(buttonAllCountries, height: 60)
        
        viewModel.setConstraints(buttonAmericaContinent, to: buttonAllCountries,
                                 leadingConstant: 20, constant: 15, view)
        viewModel.setConstraintsOnButton(labelAmericaContinent, and: labelCountAmericaContinent,
                                         on: buttonAmericaContinent)
        viewModel.setHeightSubview(buttonAmericaContinent, height: 60)
        
        viewModel.setConstraints(buttonEuropeContinent, to: buttonAmericaContinent,
                                 leadingConstant: 20, constant: 15, view)
        viewModel.setConstraintsOnButton(labelEuropeContinent, and: labelCountEuropeContinent,
                                         on: buttonEuropeContinent)
        viewModel.setHeightSubview(buttonEuropeContinent, height: 60)
        
        viewModel.setConstraints(buttonAfricaContinent, to: buttonEuropeContinent,
                                 leadingConstant: 20, constant: 15, view)
        viewModel.setConstraintsOnButton(labelAfricaContinent, and: labelCountAfricaContinent,
                                         on: buttonAfricaContinent)
        viewModel.setHeightSubview(buttonAfricaContinent, height: 60)
        
        viewModel.setConstraints(buttonAsiaContinent, to: buttonAfricaContinent,
                                 leadingConstant: 20, constant: 15, view)
        viewModel.setConstraintsOnButton(labelAsiaContinent, and: labelCountAsiaContinent,
                                         on: buttonAsiaContinent)
        viewModel.setHeightSubview(buttonAsiaContinent, height: 60)
        
        viewModel.setConstraints(buttonOceaniaContinent, to: buttonAsiaContinent,
                                 leadingConstant: 20, constant: 15, view)
        viewModel.setConstraintsOnButton(labelOceaniaContinent, and: labelCountOceaniaContinent,
                                         on: buttonOceaniaContinent)
        viewModel.setHeightSubview(buttonOceaniaContinent, height: 60)
        
        viewModel.setConstraints(stackViewTimeElapsed, to: buttonOceaniaContinent,
                                 leadingConstant: 20, constant: 15, view)
        viewModel.setSquare(subview: viewTimeElapsed, sizes: 60)
        viewModel.setConstraintsCentersOnView(buttonTimeElapsed, on: viewTimeElapsed)
        viewModel.setSquare(subview: buttonTimeElapsed, sizes: 50)
        
        viewModel.setConstraints(stackViewLabelTimeElapsed, to: stackViewTimeElapsed,
                                 leadingConstant: view.frame.width / 8, constant: 15, view)
        
        viewModel.setConstraints(segmentedControl, to: stackViewLabelTimeElapsed,
                                 leadingConstant: 20, constant: 15, view)
        viewModel.setHeightSubview(segmentedControl, height: 40)
        
        viewModel.setConstraints(stackViewPickerViews, to: segmentedControl,
                                 leadingConstant: 20, constant: 15, view)
        viewModel.setHeightSubview(stackViewPickerViews, height: 110)
    }
}
