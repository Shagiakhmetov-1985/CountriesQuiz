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
            guard !(Setting.getSettingDefault() == setting) else { return }
            print("default!")
            completion()
        }
        
        let noAction = UIAlertAction(title: "Нет", style: .destructive)
        
        addAction(yesAction)
        addAction(noAction)
    }
}
