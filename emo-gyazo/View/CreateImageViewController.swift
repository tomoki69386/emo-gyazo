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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelBarButton.rx.tap.subscribe(onNext: { [weak self] _ in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)

    }

}
