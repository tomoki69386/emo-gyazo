//
//  CreateImageViewController.swift
//  emo-gyazo
//
//  Created by 築山朋紀 on 2019/03/13.
//  Copyright © 2019 tomoki. All rights reserved.
//

import UIKit
import PKHUD
import RxSwift
import RxCocoa
import Alamofire

class CreateImageViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet private weak var saveBarButton: UIBarButtonItem!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBarButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        saveBarButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let image = self?.imageView.image else { return }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self?.postImage()
            HUD.flash(.success, onView: nil, delay: 1.0, completion: { _ in
                self?.dismiss(animated: true)
            })
        }).disposed(by: disposeBag)
        
        textField.rx.text.subscribe(onNext: { [weak self] text in
            guard let body = text else { return }
            self?.imageView.image = self?.emojiToImage(text: body)
        }).disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    private func postImage() {
        let url = "\(AppUser.apiHost)/api/v1/posts"
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.5) else { return }
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
        }, to: url, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                print(encodingResult)
                upload.responseJSON { response in
                    print(response)
                }
                upload.uploadProgress { progress in
                    print(progress.fractionCompleted)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}
