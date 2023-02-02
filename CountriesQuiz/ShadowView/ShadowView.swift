//
//  ShadowView.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 02.02.2023.
//

import UIKit

class ShadowView: UIView {
    var cornerRadius: CGFloat = 5 {
        didSet {
            label.layer.cornerRadius = cornerRadius
        }
    }
    
    var shadowColor: UIColor = UIColor(red: 54/255, green: 55/255,
                                       blue: 215/255, alpha: 1) {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    var shadowOpacity: Float = 1 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    var shadowOffset = CGSize(width: 2.5, height: 2.5) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
    
    var shadowRadius: CGFloat = 2.5 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShadow()
    }
    
    private func setupShadow() {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
        
        let cgPath = UIBezierPath(roundedRect: bounds,
                                  byRoundingCorners: [.allCorners],
                                  cornerRadii: CGSize(width: cornerRadius,
                                                      height: cornerRadius)).cgPath
        layer.shadowPath = cgPath
    }
    
    private func setup() {
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
