//
//  UIButton + Extension.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 27.07.2023.
//

import UIKit

class Button: UIButton {
    override var isHighlighted: Bool {
        didSet {
            guard let color = backgroundColor else { return }
            
            UIView.animate(
                withDuration: self.isHighlighted ? 0 : 0.25,
                delay: 0,
                options: [.beginFromCurrentState, .allowUserInteraction]) {
                    self.backgroundColor = color.withAlphaComponent(self.isHighlighted ? 0.4 : 1)
            }
        }
    }
}
