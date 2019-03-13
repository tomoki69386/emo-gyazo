//
//  TimelineTableViewCell.swift
//  emo-gyazo
//
//  Created by 築山朋紀 on 2019/03/13.
//  Copyright © 2019 tomoki. All rights reserved.
//

import UIKit

class TimelineTableViewCell: UITableViewCell {
    @IBOutlet private weak var baseView: UIView! {
        didSet {
            baseView.layer.shadowOffset = CGSize(width: 0, height: 5)
            baseView.layer.shadowRadius = 8
            baseView.layer.shadowColor = UIColor.black.cgColor
        }
    }
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyImageView: UIImageView!
    @IBOutlet private weak var saveButton: UIButton!
    
    func update() {
        
    }
}
