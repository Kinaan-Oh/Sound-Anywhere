//
//  ObservableConvertibleType+Extension.swift
//  Common
//
//  Created by 오현식 on 2022/04/25.
//

import RxCocoa
import RxSwift

extension ObservableConvertibleType {
    public func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }
}
