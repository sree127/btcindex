//
//  Helper.swift
//  BTCIndex
//
//  Created by Sreejith N on 13/12/17.
//  Copyright © 2017 Sreejith N. All rights reserved.
//

import Foundation
import UIKit

let kRotationAnimationKey = "com.btc.rotationanimationkey"

protocol RotationAnimation {
    func rotateView()
    func removeAllAnimations()
}

extension RotationAnimation where Self: UIView {
    func rotateView() {
        if self.layer.animation(forKey: kRotationAnimationKey) == nil {
            let transition = CATransition()
            transition.startProgress = 0
            transition.endProgress = 1
            transition.type = "flip"
            transition.subtype = "fromRight"
            transition.duration = 0.3
            transition.repeatCount = 100
            self.layer.add(transition, forKey: kRotationAnimationKey)
        }
    }
    
    func removeAllAnimations() {
        self.layer.removeAllAnimations()
    }
}

extension UIView: RotationAnimation { }
