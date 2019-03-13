//
//  UIImageVIew+Extension.swift
//  emo-gyazo
//
//  Created by 築山朋紀 on 2019/03/13.
//  Copyright © 2019 tomoki. All rights reserved.
//

import UIKit
import Nuke

extension UIImageView {
    func setImage(with urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        Nuke.loadImage(with: url, into: self)
    }
}
