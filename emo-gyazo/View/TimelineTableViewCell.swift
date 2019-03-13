//
//  TimelineTableViewCell.swift
//  emo-gyazo
//
//  Created by 築山朋紀 on 2019/03/13.
//  Copyright © 2019 tomoki. All rights reserved.
//

import UIKit
import PKHUD
import RxSwift
import RxCocoa

class TimelineTableViewCell: UITableViewCell {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var baseView: UIView! {
        didSet {
            baseView.layer.shadowOffset = CGSize(width: 0, height: 5)
            baseView.layer.shadowRadius = 8
            baseView.layer.shadowColor = UIColor.black.cgColor
        }
    }
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyImageView: UIImageView!
    @IBOutlet private weak var saveButton: UIButton! {
        didSet {
            saveButton.rx.tap.subscribe(onNext: { [weak self] _ in
                guard let image = self?.bodyImageView.image else { return }
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                HUD.flash(.success, delay: 1.0)
            }).disposed(by: disposeBag)
        }
    }
    
    func update() {
        bodyImageView.setImage(with: "https://pbs.twimg.com/media/D1db59zU4AAnXTH.jpg")
        titleLabel.text = "😇"
    }
}
