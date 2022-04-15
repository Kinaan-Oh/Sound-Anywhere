//
//  MapViewController.swift
//  Time Capsule
//
//  Created by 오현식 on 2022/03/11.
//

import UIKit

import RxSwift
import RxCocoa

final class MapViewController: UIViewController {
    @IBOutlet weak var favoriteZoneButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    func bindUI() {
        favoriteZoneButton.rx
            .tap
            .asDriver()
            .drive { _ in
                print("!!!!!!!!!!")
            }
            .disposed(by: disposeBag)
    }
}

