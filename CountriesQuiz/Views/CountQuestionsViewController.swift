//
//  CountQuestionsViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 09.10.2024.
//

import UIKit

class CountQuestionsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    private lazy var buttonBack: UIButton = {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "arrow.left", withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(backToSetting), for: .touchUpInside)
        return button
    }()
    
    private lazy var image: UIImageView = {
        let size = UIImage.SymbolConfiguration(pointSize: 55)
        let image = UIImage(systemName: "questionmark.bubble", withConfiguration: size)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var labelTitle: UILabel = {
        viewModel.setLabel(text: viewModel.title, font: "GillSans-Bold", size: 21)
    }()
    
    private lazy var labelDescription: UILabel = {
        viewModel.setLabel(text: viewModel.description, font: "GillSans", size: 20)
    }()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.layer.cornerRadius = 13
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    var viewModel: CountQuestionsViewModelProtocol!
    var delegate: SettingViewControllerInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
        setBarButton()
        setSubviews()
        setConstraints()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        viewModel.numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        viewModel.setTitles(pickerView: pickerView, and: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        viewModel.heightOfRows
    }
    
    private func setDesign() {
        view.backgroundColor = .blueMiddlePersian
        navigationItem.hidesBackButton = true
    }
    
    private func setBarButton() {
        viewModel.setBarButton(button: buttonBack, navigationItem: navigationItem)
    }
    
    private func setSubviews() {
        viewModel.setSubviews(subviews: image, labelTitle, labelDescription,
                              pickerView, on: view)
    }
    
    @objc private func backToSetting() {
        delegate.dataToSetting(mode: viewModel.mode)
        navigationController?.popViewController(animated: true)
    }
}

extension CountQuestionsViewController {
    private func setConstraints() {
        viewModel.setSquare(subview: buttonBack, sizes: 40)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8),
            labelTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            labelDescription.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 8),
            labelDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            labelDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(equalTo: labelDescription.bottomAnchor, constant: 20),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            pickerView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
