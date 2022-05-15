//
//  ObservableConvertibleType+Extension.swift
//  Common
//
//  Created by 오현식 on 2022/04/25.
//

import RxSwift
import RxCocoa

extension ObservableConvertibleType {
    public func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }
}
