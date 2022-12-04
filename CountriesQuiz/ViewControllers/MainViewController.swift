//
//  ViewController.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 01.12.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var labelMainCountries: UILabel = {
        let label = setLabel(
            title: "Countries",
            size: 55,
            style: "echorevival",
            color: UIColor(
                red: 184/255,
                green: 227/255,
                blue: 252/255,
                alpha: 1
            ),
            colorOfShadow: CGColor(
                red: 10/255,
                green: 10/255,
                blue: 10/255,
                alpha: 1
            ),
            radiusOfShadow: 4,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2
        )
        return label
    }()
    
    private lazy var labelMainQuiz: UILabel = {
        let label = setLabel(
            title: "Quiz",
            size: 50,
            style: "echorevival",
            color: UIColor(
                red: 184/255,
                green: 227/255,
                blue: 252/255,
                alpha: 1
            ),
            colorOfShadow: CGColor(
                red: 10/255,
                green: 10/255,
                blue: 10/255,
                alpha: 1
            ),
            radiusOfShadow: 4,
            shadowOffsetWidth: 2,
            shadowOffsetHeight: 2
        )
        return label
    }()
    
    private var imageMain: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Worldmap")
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupMenu()
        setupSubviews(subviews: imageMain, labelMainCountries, labelMainQuiz)
        setConstraints()
    }
    
    private func setupMenu() {
        
    }
    
    private func setupSubviews(subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setConstraints() {
        imageMain.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageMain.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            imageMain.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            imageMain.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            imageMain.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
        ])
        
        labelMainCountries.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelMainCountries.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            labelMainCountries.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            labelMainCountries.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        ])
        
        labelMainQuiz.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelMainQuiz.topAnchor.constraint(equalTo: labelMainCountries.topAnchor, constant: 45),
            labelMainQuiz.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 220),
            labelMainQuiz.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 50)
        ])
    }
}

extension MainViewController {
    private func setLabel(title: String,
                          size: CGFloat,
                          style: String,
                          color: UIColor,
                          x: CGFloat? = nil,
                          y: CGFloat? = nil,
                          width: CGFloat? = nil,
                          height: CGFloat? = nil,
                          colorOfShadow: CGColor? = nil,
                          radiusOfShadow: CGFloat? = nil,
                          shadowOffsetWidth: CGFloat? = nil,
                          shadowOffsetHeight: CGFloat? = nil) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: style, size: size)
        label.textColor = color
        label.frame = CGRect(x: x ?? 0, y: y ?? 0, width: width ?? 0, height: height ?? 0)
        label.layer.shadowColor = colorOfShadow
        label.layer.shadowRadius = radiusOfShadow ?? 0
        label.layer.shadowOpacity = 1
        label.layer.shadowOffset = CGSize(width: shadowOffsetWidth ?? 0,
                                          height: shadowOffsetHeight ?? 0
        )
        return label
    }
}
