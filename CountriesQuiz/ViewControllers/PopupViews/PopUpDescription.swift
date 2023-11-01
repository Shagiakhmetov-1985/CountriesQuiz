//
//  PopupDescription.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 31.10.2023.
//

import UIKit

class PopUpDescription: UIView {
    private lazy var buttonClose: UIButton = {
        let size = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "multiply", withConfiguration: size)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        return button
    }()
    
    private lazy var labelName: UILabel = {
        let label = UILabel()
        label.text = "Тип игры"
        label.textColor = .white
        label.font = UIFont(name: "Gill Sans", size: 25)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var delegate: PopUpDescriptionDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews(subviews: buttonClose, labelName)
        layer.cornerRadius = 15
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            addSubview(subview)
        }
    }
    
    @objc private func close() {
        delegate.closeView()
    }
}
// MARK: - Set contraints
extension PopUpDescription {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            buttonClose.topAnchor.constraint(equalTo: topAnchor, constant: 12.5),
            buttonClose.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.5),
            buttonClose.heightAnchor.constraint(equalToConstant: 40),
            buttonClose.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            labelName.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelName.centerYAnchor.constraint(equalTo: buttonClose.centerYAnchor)
        ])
    }
}
