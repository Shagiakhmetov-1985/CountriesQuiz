//
//  PopupDescription.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 31.10.2023.
//

import UIKit

class PopUpView: UIView {
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
    
    var delegate: PopUpViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(buttonClose)
        layer.cornerRadius = 15
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func close() {
        delegate.closeView()
    }
}
// MARK: - Set contraints
extension PopUpView {
    private func setConstraints() {
        NSLayoutConstraint.activate([
            buttonClose.topAnchor.constraint(equalTo: topAnchor, constant: 12.5),
            buttonClose.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.5),
            buttonClose.heightAnchor.constraint(equalToConstant: 40),
            buttonClose.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
}
