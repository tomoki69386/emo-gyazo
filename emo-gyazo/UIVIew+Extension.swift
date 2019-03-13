//
//  UIVIew+Extension.swift
//  emo-gyazo
//
//  Created by 築山朋紀 on 2019/03/13.
//  Copyright © 2019 tomoki. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
