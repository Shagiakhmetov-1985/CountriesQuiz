//
//  AlertController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 27.12.2022.
//

import UIKit

class AlertController: UIAlertController {
    func action(setting: Setting? = nil, completion: @escaping () -> Void) {
        let yesAction = UIAlertAction(title: "Да", style: .default) { _ in
            guard let setting = setting else { return }
            guard !setting.allCountries else { return }
            guard setting.countQuestions > 50 else { return }
            completion()
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .destructive)
        
        addAction(yesAction)
        addAction(noAction)
    }
}
