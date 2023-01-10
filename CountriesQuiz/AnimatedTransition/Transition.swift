//
//  AnimatedTransition.swift
//  CountriesQuiz
//
//  Created by Marat Shagiakhmetov on 09.01.2023.
//

import UIKit

enum TransitionMode {
    case present, dismiss
}

class Transition: NSObject {
    private var rectangle = UIView()
    
    var duration = 0.4
    var transitionMode: TransitionMode = .present
    var startingPoint = CGPoint.zero {
        didSet {
            rectangle.center = startingPoint
        }
    }
    
    private func frameForRectangle(size: CGSize, startPoint: CGPoint) -> CGRect {
        let xLenght = fmax(startPoint.x, size.width - startPoint.x)
        let yLenght = fmax(startPoint.y, size.height - startPoint.y)
        
        let offsetVector = sqrt(xLenght * xLenght + yLenght * yLenght) * 2
        let size = CGSize(width: offsetVector, height: offsetVector)
        
        return CGRect(origin: .zero, size: size)
    }
}

extension Transition: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        if transitionMode == .present {
            if let presentedView = transitionContext.view(forKey: .to) {
                let viewCenter = presentedView.center
                let viewSize = presentedView.frame.size
                
                rectangle = UIView()
                rectangle.frame = frameForRectangle(size: viewSize, startPoint: viewCenter)
                rectangle.center = startingPoint
                rectangle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                containerView.addSubview(rectangle)
                
                presentedView.center = startingPoint
                presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                presentedView.alpha = 0
                containerView.addSubview(presentedView)
                
                UIView.animate(withDuration: duration) {
                    self.rectangle.transform = CGAffineTransform.identity
                    presentedView.transform = CGAffineTransform.identity
                    presentedView.alpha = 1
                    presentedView.center = viewCenter
                } completion: { success in
                    transitionContext.completeTransition(success)
                }
            }
        } else {
            if let returnedView = transitionContext.view(forKey: .from) {
                let viewSize = returnedView.frame.size
                
                rectangle.frame = frameForRectangle(size: viewSize, startPoint: startingPoint)
                rectangle.center = startingPoint
                
                UIView.animate(withDuration: duration) {
                    self.rectangle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returnedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returnedView.center = self.startingPoint
                    returnedView.alpha = 0
                } completion: { success in
                    returnedView.removeFromSuperview()
                    self.rectangle.removeFromSuperview()
                    
                    transitionContext.completeTransition(success)
                }
            }
        }
    }
}
