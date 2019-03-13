//
//  CreateImageViewController.swift
//  emo-gyazo
//
//  Created by 築山朋紀 on 2019/03/13.
//  Copyright © 2019 tomoki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateImageViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBarButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        textField.rx.text.subscribe(onNext: { [weak self] text in
            guard let body = text else { return }
            self?.imageView.image = self?.emojiToImage(text: body)
        }).disposed(by: disposeBag)
    }
    
    private func emojiToImage(text: String, size: CGFloat = 500) -> UIImage {
        let outputImageSize = CGSize.init(width: size, height: size)
        let baseSize = text.boundingRect(with: CGSize(width: 2048, height: 2048),
                                         options: .usesLineFragmentOrigin,
                                         attributes: [.font: UIFont.systemFont(ofSize: size / 2)], context: nil).size
        let fontSize = outputImageSize.width / max(baseSize.width, baseSize.height) * (outputImageSize.width / 2)
        let font = UIFont.systemFont(ofSize: fontSize)
        let textSize = text.boundingRect(with: CGSize(width: outputImageSize.width, height: outputImageSize.height),
                                         options: .usesLineFragmentOrigin,
                                         attributes: [.font: font], context: nil).size
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        style.lineBreakMode = NSLineBreakMode.byClipping
        
        let attr : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : font,
                                                     NSAttributedString.Key.paragraphStyle: style,
                                                     NSAttributedString.Key.backgroundColor: UIColor.clear ]
        
        UIGraphicsBeginImageContextWithOptions(outputImageSize, false, 0)
        text.draw(in: CGRect(x: (size - textSize.width) / 2,
                             y: (size - textSize.height) / 2,
                             width: textSize.width,
                             height: textSize.height),
                  withAttributes: attr)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

}
